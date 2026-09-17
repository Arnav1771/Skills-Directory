"""
aa_skills.credits
=====================

Credit / balance visibility for a Claude API key.

IMPORTANT CONSTRAINT — read before relying on this module:

Anthropic does not currently expose a public API endpoint that returns a
prepaid credit balance in dollars for a standard API key. The Console's
Plans & Billing page is the only authoritative source of that number, and
it requires a human, browser-based login. The Admin/Usage-Cost API
(`/v1/organizations/cost_report`) reports *spend*, not *remaining balance*,
requires a separate Admin API key with organization-level scope, and still
can't tell you the size of a prepaid pool.

Given that, this module does two complementary things, neither of which is
a substitute for checking the Console directly for anything you'd bet
money on:

1. **Local ledger (estimate)** — you tell it your known starting balance
   once (`set_initial_balance`, i.e. what you just topped up to). Every
   invocation's token usage is priced against a maintained rate table and
   subtracted from that balance locally. This drifts from reality over
   time (rate table changes, multi-workspace/multi-key usage sharing the
   same account, non-Messages-API spend like web search or code-execution
   container-hours beyond the free daily allowance) — it is a budgeting
   aid, not a ledger of record.

2. **Live key probe (ground truth, but binary)** — a minimal, cheap
   request that will surface Anthropic's own `insufficient_balance_error`
   if the account is actually blocked at call time. This confirms "the
   key can currently bill" or "it cannot" — it does not return a dollar
   figure, because the API itself doesn't return one.

The `$5 warning` behavior this module supports combines both: warn off
the local estimate before every call (cheap, no extra request), and
optionally corroborate with a live probe when the estimate is already
close to the threshold.
"""

from __future__ import annotations

import hashlib
import json
import time
from dataclasses import dataclass, field, asdict
from pathlib import Path
from typing import Optional

DEFAULT_CREDITS_DIR = Path.home() / ".aa_skills" / "credits"

# Per-million-token USD rates. Verify against
# https://platform.claude.com/docs/en/about-claude/pricing before relying
# on these for anything beyond rough budgeting — Anthropic updates this
# table independently of this package.
PRICING_USD_PER_MTOK = {
    "claude-opus-4-8":            {"input": 5.00, "output": 25.00, "cache_write": 6.25, "cache_read": 0.50},
    "claude-sonnet-5":            {"input": 2.00, "output": 10.00, "cache_write": 2.50, "cache_read": 0.20},  # introductory, through 2026-08-31
    "claude-sonnet-4-6":          {"input": 3.00, "output": 15.00, "cache_write": 3.75, "cache_read": 0.30},
    "claude-haiku-4-5-20251001":  {"input": 1.00, "output": 5.00,  "cache_write": 1.25, "cache_read": 0.10},
}
FALLBACK_PRICING = {"input": 5.00, "output": 25.00, "cache_write": 6.25, "cache_read": 0.50}  # conservative (Opus-tier)


def _fingerprint(api_key: str) -> str:
    """Non-reversible identifier for the key, used only as a filename —
    the raw key is never written to disk by this module."""
    return hashlib.sha256(api_key.encode()).hexdigest()[:16]


@dataclass
class CreditLedger:
    key_fingerprint: str
    initial_balance_usd: Optional[float] = None
    cumulative_spend_usd: float = 0.0
    total_calls: int = 0
    last_updated: float = field(default_factory=time.time)

    @property
    def estimated_balance_usd(self) -> Optional[float]:
        if self.initial_balance_usd is None:
            return None
        return round(self.initial_balance_usd - self.cumulative_spend_usd, 4)

    @classmethod
    def load(cls, api_key: str, credits_dir: Optional[str] = None) -> "CreditLedger":
        path = cls._path_for(api_key, credits_dir)
        if path.exists():
            return cls(**json.loads(path.read_text()))
        return cls(key_fingerprint=_fingerprint(api_key))

    def save(self, credits_dir: Optional[str] = None) -> None:
        path = self._path_for_fingerprint(self.key_fingerprint, credits_dir)
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(json.dumps(asdict(self), indent=2))

    @staticmethod
    def _path_for(api_key: str, credits_dir: Optional[str]) -> Path:
        return CreditLedger._path_for_fingerprint(_fingerprint(api_key), credits_dir)

    @staticmethod
    def _path_for_fingerprint(fingerprint: str, credits_dir: Optional[str]) -> Path:
        base = Path(credits_dir) if credits_dir else DEFAULT_CREDITS_DIR
        return base / f"{fingerprint}.json"


def set_initial_balance(api_key: str, amount_usd: float, credits_dir: Optional[str] = None) -> CreditLedger:
    """Call this right after topping up, so the local estimate has a real anchor."""
    ledger = CreditLedger.load(api_key, credits_dir)
    ledger.initial_balance_usd = amount_usd
    ledger.cumulative_spend_usd = 0.0
    ledger.last_updated = time.time()
    ledger.save(credits_dir)
    return ledger


def estimate_cost_usd(model: str, usage) -> float:
    """
    `usage` is the `.usage` object on a Messages API response (or any
    object/dict exposing input_tokens, output_tokens, and optionally
    cache_creation_input_tokens / cache_read_input_tokens).
    """
    def _get(name: str) -> int:
        if isinstance(usage, dict):
            return usage.get(name, 0) or 0
        return getattr(usage, name, 0) or 0

    rates = PRICING_USD_PER_MTOK.get(model, FALLBACK_PRICING)
    input_tokens = _get("input_tokens")
    output_tokens = _get("output_tokens")
    cache_write_tokens = _get("cache_creation_input_tokens")
    cache_read_tokens = _get("cache_read_input_tokens")

    cost = (
        input_tokens / 1_000_000 * rates["input"]
        + output_tokens / 1_000_000 * rates["output"]
        + cache_write_tokens / 1_000_000 * rates["cache_write"]
        + cache_read_tokens / 1_000_000 * rates["cache_read"]
    )
    return round(cost, 6)


def record_usage(api_key: str, model: str, usage, credits_dir: Optional[str] = None) -> CreditLedger:
    ledger = CreditLedger.load(api_key, credits_dir)
    ledger.cumulative_spend_usd += estimate_cost_usd(model, usage)
    ledger.total_calls += 1
    ledger.last_updated = time.time()
    ledger.save(credits_dir)
    return ledger


@dataclass
class CreditStatus:
    key_valid: bool
    estimated_balance_usd: Optional[float]
    below_threshold: bool
    threshold_usd: float
    source: str            # "local_estimate", "local_estimate+live_probe", "unseeded"
    warnings: list[str] = field(default_factory=list)


def verify_key_and_check_credits(
    client,
    api_key: str,
    threshold_usd: float = 5.0,
    live_probe: bool = False,
    probe_model: str = "claude-haiku-4-5-20251001",
    credits_dir: Optional[str] = None,
) -> CreditStatus:
    """
    The function requested: confirm the key is usable, and check whether
    estimated remaining credit is above `threshold_usd` before invoking
    a skill.

    - Always consults the local ledger (no network call, no cost).
    - If `live_probe=True`, also fires a 1-token request to Haiku (the
      cheapest model) purely to catch a real `insufficient_balance_error`
      or `authentication_error` from Anthropic. This costs a fraction of
      a cent and a network round trip — use it when the local estimate is
      unseeded or already close to the threshold, not on every call.
    """
    import anthropic

    ledger = CreditLedger.load(api_key, credits_dir)
    warnings: list[str] = []
    key_valid = True
    source = "local_estimate" if ledger.initial_balance_usd is not None else "unseeded"

    if ledger.initial_balance_usd is None:
        warnings.append(
            "No local balance has been set for this key yet. Run "
            "`aa-skills credits set-balance --amount <topped_up_usd>` after your "
            "last top-up so remaining credit can be estimated. Proceeding as if "
            "the threshold check cannot be confirmed."
        )

    if live_probe or ledger.initial_balance_usd is None:
        try:
            client.messages.create(
                model=probe_model,
                max_tokens=1,
                messages=[{"role": "user", "content": "ping"}],
            )
            source = source + "+live_probe" if source != "unseeded" else "live_probe_only"
        except anthropic.AuthenticationError as e:
            key_valid = False
            warnings.append(f"API key failed authentication: {e}")
        except anthropic.PermissionDeniedError as e:
            key_valid = False
            warnings.append(f"API key lacks permission: {e}")
        except anthropic.BadRequestError as e:
            if "credit balance" in str(e).lower() or "insufficient" in str(e).lower():
                warnings.append(
                    "Live probe confirms the account is currently blocked on "
                    "credit balance (Anthropic returned insufficient_balance_error)."
                )
                ledger.initial_balance_usd = ledger.cumulative_spend_usd  # force estimate to ~0
                ledger.save(credits_dir)
            else:
                warnings.append(f"Live probe request failed unexpectedly: {e}")

    estimated = ledger.estimated_balance_usd
    below_threshold = (estimated is not None and estimated < threshold_usd) or not key_valid

    if below_threshold and key_valid:
        warnings.append(
            f"Estimated remaining credit (${estimated:.2f}) is below the "
            f"configured ${threshold_usd:.2f} threshold. Confirm your actual "
            f"balance at console.anthropic.com/settings/billing before running "
            f"anything expensive."
        )

    return CreditStatus(
        key_valid=key_valid,
        estimated_balance_usd=estimated,
        below_threshold=below_threshold,
        threshold_usd=threshold_usd,
        source=source,
        warnings=warnings,
    )


def print_credit_warning(status: CreditStatus) -> None:
    if not status.warnings and not status.below_threshold:
        return
    print("\n" + "=" * 70)
    print("CREDIT CHECK WARNING")
    print("=" * 70)
    for w in status.warnings:
        print(f"- {w}")
    print("=" * 70 + "\n")


def print_current_balance(status_or_ledger) -> None:
    if isinstance(status_or_ledger, CreditStatus):
        bal = status_or_ledger.estimated_balance_usd
    else:
        bal = status_or_ledger.estimated_balance_usd
    if bal is None:
        print("Current estimated credit balance: unknown (no initial balance set — "
              "run `aa-skills credits set-balance --amount <usd>`).")
    else:
        print(f"Current estimated credit balance: ${bal:.2f}")
