"""
aa_skills.context
===================

Context and session management for chained skill invocations.

Design principles (why this module exists):

1. NEVER re-inject file *content* into the prompt across turns. Files
   live in the code-execution container and are referenced by file_id.
   The conversation text only ever carries short metadata (filename,
   1-line description, producing skill) — this is what keeps a long
   multi-skill chain from silently ballooning the context window.

2. Each skill invocation gets an explicit, curated file manifest —
   not "everything generated so far". The caller (CLI or code) states
   which prior outputs are relevant inputs to the next step. This is
   the primary hallucination guardrail: Claude is not left to guess
   which of N generated artifacts is relevant, and stale/irrelevant
   files never get silently pulled into a later skill's reasoning.

3. Sessions are explicit and disk-persisted, not implicit. A session
   groups a single container_id + its generated-file manifest. Starting
   a *new* session is the default; continuing one requires an explicit
   flag. This prevents unrelated tasks from accumulating in the same
   conversation history, which is the most common cause of both context
   overflow and drift/hallucination in long agent sessions.

4. A rough token budget is enforced before each call. If the manifest
   summary + prompt would exceed the configured budget, the caller is
   warned and offered pruning — oldest, non-referenced manifest entries
   are dropped first; entries explicitly attached to the call are never
   dropped.
"""

from __future__ import annotations

import json
import time
from dataclasses import dataclass, field, asdict
from pathlib import Path
from typing import Optional


DEFAULT_SESSION_DIR = Path.home() / ".aa_skills" / "sessions"

# Conservative heuristic: ~4 characters per token for English/code mixed text.
CHARS_PER_TOKEN = 4


def estimate_tokens(text: str) -> int:
    return max(1, len(text) // CHARS_PER_TOKEN)


@dataclass
class GeneratedFile:
    alias: str                  # short handle the user refers to it by, e.g. "arch_deck"
    file_id: str                 # Anthropic Files API id
    filename: str
    produced_by_skill: str
    description: str             # 1-line, written at creation time, NOT the file content
    created_at: float = field(default_factory=time.time)
    size_bytes: Optional[int] = None

    def manifest_line(self) -> str:
        return f"- [{self.alias}] {self.filename} (from `{self.produced_by_skill}`): {self.description}"


@dataclass
class SessionContext:
    """
    One logical unit of work: a container_id (once established) plus the
    manifest of files generated within it. Persisted to disk so a CLI
    invocation can resume state between process runs.
    """

    session_name: str
    container_id: Optional[str] = None
    generated_files: list[GeneratedFile] = field(default_factory=list)
    turn_count: int = 0
    max_context_tokens: int = 6000  # budget for manifest+prompt text only,
                                     # NOT the model's total context window —
                                     # deliberately conservative so a single
                                     # skill's own instructions/output have
                                     # plenty of headroom left.

    # ---- persistence -----------------------------------------------

    @classmethod
    def load_or_create(
        cls, session_name: str, session_dir: Optional[str] = None
    ) -> "SessionContext":
        path = cls._path_for(session_name, session_dir)
        if path.exists():
            data = json.loads(path.read_text())
            data["generated_files"] = [
                GeneratedFile(**gf) for gf in data.get("generated_files", [])
            ]
            return cls(**data)
        return cls(session_name=session_name)

    def save(self, session_dir: Optional[str] = None) -> None:
        path = self._path_for(self.session_name, session_dir)
        path.parent.mkdir(parents=True, exist_ok=True)
        payload = asdict(self)
        path.write_text(json.dumps(payload, indent=2))

    def reset(self, session_dir: Optional[str] = None) -> None:
        self.container_id = None
        self.generated_files = []
        self.turn_count = 0
        self.save(session_dir)

    @staticmethod
    def _path_for(session_name: str, session_dir: Optional[str]) -> Path:
        base = Path(session_dir) if session_dir else DEFAULT_SESSION_DIR
        safe_name = "".join(c if c.isalnum() or c in "-_" else "_" for c in session_name)
        return base / f"{safe_name}.json"

    # ---- manifest management --------------------------------------

    def register_output(
        self,
        file_id: str,
        filename: str,
        produced_by_skill: str,
        description: str,
        alias: Optional[str] = None,
        size_bytes: Optional[int] = None,
    ) -> GeneratedFile:
        alias = alias or self._auto_alias(filename)
        gf = GeneratedFile(
            alias=alias,
            file_id=file_id,
            filename=filename,
            produced_by_skill=produced_by_skill,
            description=description,
            size_bytes=size_bytes,
        )
        self.generated_files.append(gf)
        return gf

    def _auto_alias(self, filename: str) -> str:
        stem = Path(filename).stem.lower().replace(" ", "_")
        candidate = stem
        n = 2
        existing = {gf.alias for gf in self.generated_files}
        while candidate in existing:
            candidate = f"{stem}_{n}"
            n += 1
        return candidate

    def resolve_aliases(self, aliases: list[str]) -> list[GeneratedFile]:
        by_alias = {gf.alias: gf for gf in self.generated_files}
        by_filename = {gf.filename: gf for gf in self.generated_files}
        resolved = []
        missing = []
        for a in aliases:
            if a in by_alias:
                resolved.append(by_alias[a])
            elif a in by_filename:
                resolved.append(by_filename[a])
            else:
                missing.append(a)
        if missing:
            available = ", ".join(sorted(by_alias)) or "(none yet)"
            raise KeyError(
                f"Unknown generated-file reference(s): {missing}. "
                f"Available in session '{self.session_name}': {available}"
            )
        return resolved

    # ---- context budget enforcement --------------------------------

    def build_manifest_block(
        self,
        attached_aliases: Optional[list[str]] = None,
        max_context_tokens: Optional[int] = None,
    ) -> str:
        """
        Produce the short text block listing available generated files
        (metadata only) to inject into the prompt. Prunes oldest,
        non-attached entries first if the budget would be exceeded.
        """
        budget = max_context_tokens or self.max_context_tokens
        attached = set(attached_aliases or [])

        # Always-keep entries: anything explicitly attached to this call.
        must_keep = [gf for gf in self.generated_files if gf.alias in attached]
        optional = [gf for gf in self.generated_files if gf.alias not in attached]

        lines = [gf.manifest_line() for gf in must_keep]
        header = "Reference files available from earlier steps in this session:\n"
        footer = (
            "\nOnly the files explicitly attached to this request are mounted "
            "in the execution container; others are listed for awareness only."
        )

        def current_tokens(extra_lines: list[str]) -> int:
            return estimate_tokens(header + "\n".join(lines + extra_lines) + footer)

        # Add optional (older) entries newest-first until budget is hit.
        for gf in reversed(optional):
            trial = current_tokens([gf.manifest_line()])
            if trial > budget:
                break
            lines.append(gf.manifest_line())

        if not lines:
            return ""
        return header + "\n".join(lines) + footer

    def enforce_prompt_budget(self, prompt: str, manifest_block: str) -> tuple[str, list[str]]:
        """
        Returns (prompt, warnings). Does not silently truncate the user's
        own prompt — that would risk changing task semantics. Instead it
        warns loudly if the combined size is large, since bloated context
        is a known contributor to degraded instruction-following and
        hallucination in long agent chains.
        """
        warnings = []
        total = estimate_tokens(prompt) + estimate_tokens(manifest_block)
        if total > self.max_context_tokens:
            warnings.append(
                f"Estimated context ({total} tokens) exceeds the configured "
                f"budget ({self.max_context_tokens}). Consider starting a new "
                f"session, reducing attached files, or raising --max-context-tokens "
                f"explicitly if this step genuinely needs more context."
            )
        return prompt, warnings
