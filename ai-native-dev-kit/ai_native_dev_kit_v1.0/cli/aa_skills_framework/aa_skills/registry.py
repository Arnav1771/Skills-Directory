"""
aa_skills.registry
===================

Maintains the mapping between AA's internal skill catalog (the names used
by delivery teams — e.g. "aa_scaffold_pptx", "rfp_extraction") and the
identifiers the Claude API actually needs (skill_id, type, version).

This is the machine-readable counterpart to AA's HTML skills registry.
It is intentionally dumb: it does not talk to the network except when
explicitly asked to register/refresh a custom skill.
"""

from __future__ import annotations

import json
import os
from dataclasses import dataclass, field, asdict
from pathlib import Path
from typing import Optional


DEFAULT_REGISTRY_PATH = Path.home() / ".aa_skills" / "aa_skill_registry.json"


@dataclass
class RegisteredSkill:
    name: str                      # AA-internal short name, e.g. "rfp_extraction"
    anthropic_skill_id: str        # "pptx" (pre-built) or "skill_01Abc..." (custom)
    type: str                      # "anthropic" | "custom"
    version: str = "latest"        # date-based, epoch, or "latest"
    description: str = ""          # short human description (also used as
                                    # context hint injected into prompts)
    max_input_files: Optional[int] = None   # optional guardrail per skill
    typical_output_kind: Optional[str] = None  # e.g. "pptx", "xlsx", "text"

    def to_container_entry(self) -> dict:
        return {
            "type": self.type,
            "skill_id": self.anthropic_skill_id,
            "version": self.version,
        }


class SkillRegistry:
    """Loads/saves/queries the AA skill registry JSON file."""

    def __init__(self, path: Optional[str | Path] = None):
        self.path = Path(path) if path else DEFAULT_REGISTRY_PATH
        self._skills: dict[str, RegisteredSkill] = {}
        if self.path.exists():
            self.load()

    # ---- persistence -----------------------------------------------

    def load(self) -> None:
        data = json.loads(self.path.read_text())
        self._skills = {
            name: RegisteredSkill(name=name, **entry)
            for name, entry in data.items()
        }

    def save(self) -> None:
        self.path.parent.mkdir(parents=True, exist_ok=True)
        payload = {
            name: {k: v for k, v in asdict(skill).items() if k != "name"}
            for name, skill in self._skills.items()
        }
        self.path.write_text(json.dumps(payload, indent=2, sort_keys=True))

    # ---- CRUD ---------------------------------------------------------

    def add(self, skill: RegisteredSkill, save: bool = True) -> None:
        self._skills[skill.name] = skill
        if save:
            self.save()

    def remove(self, name: str, save: bool = True) -> None:
        self._skills.pop(name, None)
        if save:
            self.save()

    def get(self, name: str) -> RegisteredSkill:
        if name not in self._skills:
            raise KeyError(
                f"Skill '{name}' is not registered. "
                f"Known skills: {', '.join(sorted(self._skills)) or '(none)'}"
            )
        return self._skills[name]

    def list(self) -> list[RegisteredSkill]:
        return sorted(self._skills.values(), key=lambda s: s.name)

    def resolve_many(self, names: list[str]) -> list[RegisteredSkill]:
        if len(names) > 8:
            raise ValueError(
                f"Requested {len(names)} skills, but the Claude API allows "
                f"a maximum of 8 skills per request."
            )
        return [self.get(n) for n in names]

    # ---- bootstrap helpers ---------------------------------------------

    @classmethod
    def bootstrap_prebuilt(cls, path: Optional[str | Path] = None) -> "SkillRegistry":
        """Seed a fresh registry with Anthropic's pre-built document skills."""
        reg = cls(path=path)
        prebuilt = [
            ("pptx", "Create/edit PowerPoint presentations"),
            ("xlsx", "Create/edit Excel spreadsheets"),
            ("docx", "Create/edit Word documents"),
            ("pdf", "Create/fill/merge PDF documents"),
        ]
        for skill_id, desc in prebuilt:
            reg.add(
                RegisteredSkill(
                    name=skill_id,
                    anthropic_skill_id=skill_id,
                    type="anthropic",
                    version="latest",
                    description=desc,
                    typical_output_kind=skill_id,
                ),
                save=False,
            )
        reg.save()
        return reg


def register_custom_skill_from_dir(
    client,
    registry: SkillRegistry,
    name: str,
    display_title: str,
    skill_dir: str | Path,
    description: str = "",
    typical_output_kind: Optional[str] = None,
) -> RegisteredSkill:
    """
    Upload a local SKILL.md bundle (an AAxon skill folder) to the workspace
    via the Skills API, then register it under an AA-internal short name.

    `client` is an `anthropic.Anthropic` instance (kept as a parameter
    rather than imported at module scope so this module has no hard
    dependency on the `anthropic` package unless you actually register
    a skill).
    """
    from anthropic.lib import files_from_dir  # local import, see note above

    uploaded = client.beta.skills.create(
        display_title=display_title,
        files=files_from_dir(str(skill_dir)),
        betas=["skills-2025-10-02"],
    )
    skill = RegisteredSkill(
        name=name,
        anthropic_skill_id=uploaded.id,
        type="custom",
        version="latest",
        description=description,
        typical_output_kind=typical_output_kind,
    )
    registry.add(skill)
    return skill
