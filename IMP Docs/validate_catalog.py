#!/usr/bin/env python3
"""Validate marketplace.json and the compat matrix against the skill folders.

- Every skill folder (has SKILL.md) has exactly one plugin entry in
  .claude-plugin/marketplace.json, and vice-versa.
- Each plugin entry's `skills` paths exist and point at a folder with SKILL.md.
- Plugin name/description/version mirror the skill's manifest.yaml.
- Every manifest `compat` uses known agent keys and level values.
Deterministic — safe to run in CI.
"""
import os, sys, json
try:
    import yaml
except ImportError:
    sys.exit("PyYAML not installed")

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MKT = os.path.join(ROOT, ".claude-plugin", "marketplace.json")
AGENTS = {"claude-code", "claude-ai", "cursor", "codex", "copilot",
          "gemini-cli", "windsurf", "roo-code"}
LEVELS = {"full", "partial", "na"}


def skill_dirs():
    return sorted(d for d in os.listdir(ROOT)
                  if os.path.isdir(os.path.join(ROOT, d)) and not d.startswith(".")
                  and os.path.exists(os.path.join(ROOT, d, "SKILL.md")))


def main():
    errors = []
    skills = skill_dirs()

    with open(MKT, encoding="utf-8") as f:
        try:
            mkt = json.load(f)
        except json.JSONDecodeError as e:
            sys.exit(f"marketplace.json: invalid JSON: {e}")

    for field in ("name", "owner", "plugins"):
        if field not in mkt:
            errors.append(f"marketplace.json: missing top-level '{field}'")

    entries = {p.get("name"): p for p in mkt.get("plugins", [])}
    for s in skills:
        if s not in entries:
            errors.append(f"marketplace.json: no plugin entry for skill '{s}'")
    for name in entries:
        if name not in skills:
            errors.append(f"marketplace.json: plugin '{name}' has no matching skill folder")

    for name, p in entries.items():
        for rel in (p.get("skills") or []):
            target = os.path.normpath(os.path.join(ROOT, rel))
            if not os.path.exists(os.path.join(target, "SKILL.md")):
                errors.append(f"marketplace.json: {name} skills path '{rel}' has no SKILL.md")
        # Cross-check against manifest.yaml where present.
        mpath = os.path.join(ROOT, name, "manifest.yaml")
        if os.path.exists(mpath):
            with open(mpath, encoding="utf-8") as mf:
                man = yaml.safe_load(mf)
            if str(man.get("version")) != str(p.get("version")):
                errors.append(f"{name}: marketplace version '{p.get('version')}' != manifest '{man.get('version')}'")
            if man.get("description") != p.get("description"):
                errors.append(f"{name}: marketplace description differs from manifest")

    # Compat matrix checks.
    for s in skills:
        mpath = os.path.join(ROOT, s, "manifest.yaml")
        if not os.path.exists(mpath):
            continue
        with open(mpath, encoding="utf-8") as mf:
            man = yaml.safe_load(mf)
        compat = man.get("compat")
        if compat is None:
            errors.append(f"{s}: manifest missing 'compat' matrix")
            continue
        for agent, level in compat.items():
            if agent not in AGENTS:
                errors.append(f"{s}: compat unknown agent '{agent}'")
            if level not in LEVELS:
                errors.append(f"{s}: compat '{agent}' bad level '{level}' (want full|partial|na)")
        if compat.get("claude-code") != "full":
            errors.append(f"{s}: compat.claude-code should be 'full' (all skills built for Claude Code)")

    print(f"Skills: {', '.join(skills)}")
    print(f"Marketplace plugins: {', '.join(entries)}")
    if errors:
        print("\nERRORS:")
        print("\n".join(errors))
        sys.exit(1)
    print("\nMarketplace + compat valid.")


if __name__ == "__main__":
    main()
