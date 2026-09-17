"""
aa_skills.client
===================

AASkillInvoker: the single entry point that both the CLI and any Python
caller use to run one or more AA skills against a Claude API model,
with explicit file inputs and disciplined context management.
"""

from __future__ import annotations

from pathlib import Path
from typing import Optional

from .registry import SkillRegistry
from .context import SessionContext
from . import files_api
from . import credits

REQUIRED_BETAS = [
    "code-execution-2025-08-25",
    "skills-2025-10-02",
    "files-api-2025-04-14",
]


class InvocationResult:
    def __init__(
        self,
        response,
        downloaded_files: list[dict],
        warnings: list[str],
        credit_status_before: Optional["credits.CreditStatus"] = None,
        credit_status_after: Optional["credits.CreditStatus"] = None,
    ):
        self.response = response
        # each entry: {"file_id": str, "path": Path}
        self.downloaded_files = downloaded_files
        self.warnings = warnings
        self.credit_status_before = credit_status_before
        self.credit_status_after = credit_status_after

    @property
    def downloaded_paths(self) -> list[Path]:
        return [f["path"] for f in self.downloaded_files]

    @property
    def stop_reason(self):
        return getattr(self.response, "stop_reason", None)


class AASkillInvoker:
    def __init__(
        self,
        api_key: Optional[str] = None,
        registry: Optional[SkillRegistry] = None,
        model: str = "claude-opus-4-8",
        output_dir: str = "./aa_skill_outputs",
        credit_threshold_usd: float = 5.0,
    ):
        import anthropic  # imported here so the package is importable
                            # without the anthropic SDK installed, for
                            # environments that only need the registry/
                            # context modules (e.g. testing the CLI's
                            # bookkeeping logic offline).
        import os

        self.api_key = api_key or os.environ.get("ANTHROPIC_API_KEY")
        if not self.api_key:
            raise ValueError(
                "No API key provided and ANTHROPIC_API_KEY is not set. "
                "The Claude API requires a key; no claude.ai account is used or needed."
            )
        self.client = anthropic.Anthropic(api_key=self.api_key)
        self.registry = registry or SkillRegistry()
        self.model = model
        self.output_dir = output_dir
        self.credit_threshold_usd = credit_threshold_usd

    # ---- credit management ----------------------------------------------

    def check_credits(self, live_probe: bool = False) -> credits.CreditStatus:
        """Confirm the key is usable and estimate whether remaining credit
        is above the configured warning threshold. See aa_skills.credits
        for what this can and cannot guarantee."""
        return credits.verify_key_and_check_credits(
            client=self.client,
            api_key=self.api_key,
            threshold_usd=self.credit_threshold_usd,
            live_probe=live_probe,
        )

    # ---- primary entry point -------------------------------------------

    def invoke(
        self,
        prompt: str,
        skill_names: list[str],
        session: SessionContext,
        new_input_files: Optional[list[str]] = None,
        use_generated: Optional[list[str]] = None,
        max_tokens: int = 8000,
        max_context_tokens: Optional[int] = None,
        pause_turn_retries: int = 10,
        skip_credit_check: bool = False,
        live_credit_probe: bool = False,
    ) -> InvocationResult:
        """
        Run one skill-invocation step.

        - new_input_files: local filesystem paths to upload fresh
        - use_generated: aliases/filenames of files already produced
          earlier in this session (resolved via the session manifest,
          NOT re-uploaded)
        - session: the SessionContext this call belongs to; its
          container_id (if any) is reused, and any new outputs are
          registered back into it by the caller after download.
        - skip_credit_check: bypass the pre-flight credit check entirely
          (e.g. for high-frequency automated pipelines that check once
          upfront rather than per call).
        - live_credit_probe: also fire the 1-token live probe (see
          aa_skills.credits) before this call, not just the local estimate.
        """
        skills = self.registry.resolve_many(skill_names)
        warnings: list[str] = []

        # --- pre-flight credit check -------------------------------------
        credit_status_before = None
        if not skip_credit_check:
            credit_status_before = self.check_credits(live_probe=live_credit_probe)
            credits.print_credit_warning(credit_status_before)
            # Not appended to `warnings` — already printed above; kept on
            # credit_status_before for any programmatic caller that wants it.

        # Resolve file inputs: newly uploaded + previously generated.
        attached_file_ids: list[str] = []
        attached_aliases: list[str] = []

        for path in (new_input_files or []):
            uploaded = files_api.upload_file(self.client, path)
            attached_file_ids.append(uploaded["file_id"])

        if use_generated:
            resolved = session.resolve_aliases(use_generated)
            attached_file_ids.extend(gf.file_id for gf in resolved)
            attached_aliases.extend(gf.alias for gf in resolved)

        # Build the curated, metadata-only manifest block (never raw content).
        manifest_block = session.build_manifest_block(
            attached_aliases=attached_aliases,
            max_context_tokens=max_context_tokens,
        )
        prompt, budget_warnings = session.enforce_prompt_budget(prompt, manifest_block)
        warnings.extend(budget_warnings)

        full_prompt = prompt if not manifest_block else f"{prompt}\n\n{manifest_block}"

        content = [{"type": "text", "text": full_prompt}]
        for fid in attached_file_ids:
            content.append({"type": "container_upload", "file_id": fid})

        container: dict = {"skills": [s.to_container_entry() for s in skills]}
        if session.container_id:
            container["id"] = session.container_id

        response = self.client.beta.messages.create(
            model=self.model,
            max_tokens=max_tokens,
            betas=REQUIRED_BETAS,
            container=container,
            messages=[{"role": "user", "content": content}],
            tools=[{"type": "code_execution_20250825", "name": "code_execution"}],
        )

        response = self._drain_pause_turn(
            response, container, skills, pause_turn_retries
        )

        # Persist container id for future turns in this session.
        new_container_id = getattr(getattr(response, "container", None), "id", None)
        if new_container_id:
            session.container_id = new_container_id
        session.turn_count += 1

        # Download any generated files.
        output_refs = files_api.extract_output_file_ids(response)
        downloaded = [
            {
                "file_id": ref["file_id"],
                "path": files_api.download_file(self.client, ref["file_id"], self.output_dir),
            }
            for ref in output_refs
        ]

        # --- post-call credit ledger update -------------------------------
        credit_status_after = None
        usage = getattr(response, "usage", None)
        if usage is not None:
            credits.record_usage(self.api_key, self.model, usage)
        ledger = credits.CreditLedger.load(self.api_key)
        credit_status_after = credits.CreditStatus(
            key_valid=True,
            estimated_balance_usd=ledger.estimated_balance_usd,
            below_threshold=(
                ledger.estimated_balance_usd is not None
                and ledger.estimated_balance_usd < self.credit_threshold_usd
            ),
            threshold_usd=self.credit_threshold_usd,
            source="local_estimate",
        )
        credits.print_current_balance(credit_status_after)
        if credit_status_after.below_threshold:
            credits.print_credit_warning(credit_status_after)

        return InvocationResult(
            response=response,
            downloaded_files=downloaded,
            warnings=warnings,
            credit_status_before=credit_status_before,
            credit_status_after=credit_status_after,
        )

    # ---- internals -----------------------------------------------------

    def _drain_pause_turn(self, response, container, skills, max_retries: int):
        messages = []
        for _ in range(max_retries):
            if getattr(response, "stop_reason", None) != "pause_turn":
                break
            messages.append({"role": "assistant", "content": response.content})
            container_cont = dict(container)
            if getattr(getattr(response, "container", None), "id", None):
                container_cont["id"] = response.container.id
            response = self.client.beta.messages.create(
                model=self.model,
                max_tokens=8000,
                betas=REQUIRED_BETAS,
                container=container_cont,
                messages=messages,
                tools=[{"type": "code_execution_20250825", "name": "code_execution"}],
            )
        return response
