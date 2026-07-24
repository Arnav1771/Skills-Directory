#!/usr/bin/env python3
"""Export every skill into the native format of each major agent CLI.

A Claude `SKILL.md` is only recognized by Claude. Other CLIs read different
files: Cursor -> .cursor/rules/*.mdc, Windsurf -> .windsurf/rules/*.md,
Gemini CLI -> GEMINI.md, and a large group (Codex, Aider, opencode, Copilot,
Roo, Zed, Amp, Jules, ...) reads the open AGENTS.md standard.

This script reads each skill's SKILL.md (+ manifest.yaml for the description and
IMP Docs/skill_evals.yaml for trigger phrases) and writes ready-to-drop files
under exports/. install.sh places them; users can also copy a file by hand.

Run: python3 scripts/export_skills.py
"""
import os, re, sys
try:
    import yaml
except ImportError:
    sys.exit("PyYAML not installed")

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OWNER, REPO, REF = "Arnav1771", "Skills-Directory", "main"
BLOB = f"https://github.com/{OWNER}/{REPO}/blob/{REF}"
EXPORTS = os.path.join(ROOT, "exports")
EVALS = os.path.join(ROOT, "IMP Docs", "skill_evals.yaml")
WINDSURF_LIMIT = 12000


def skills():
    return sorted(d for d in os.listdir(ROOT)
                  if os.path.isdir(os.path.join(ROOT, d)) and not d.startswith(".")
                  and os.path.exists(os.path.join(ROOT, d, "SKILL.md")))


def parse_skill(name):
    with open(os.path.join(ROOT, name, "SKILL.md"), encoding="utf-8") as f:
        raw = f.read()
    m = re.match(r"^---\s*\n(.*?)\n---\s*\n(.*)$", raw, re.DOTALL)
    if not m:
        raise ValueError(f"{name}: no frontmatter")
    fm = yaml.safe_load(m.group(1))
    return fm, m.group(2).strip()


def rewrite_links(body, name):
    """Make relative links absolute so a ported single file stays self-contained."""
    def repl(mo):
        text, target = mo.group(1), mo.group(2)
        if re.match(r"^(https?:|#|/|mailto:)", target):
            return mo.group(0)
        return f"[{text}]({BLOB}/{name}/{target})"
    return re.sub(r"\[([^\]]+)\]\(([^)]+)\)", repl, body)


def load_triggers():
    if not os.path.exists(EVALS):
        return {}
    with open(EVALS, encoding="utf-8") as f:
        data = yaml.safe_load(f) or {}
    return {k: v.get("should_trigger", []) for k, v in data.items()}


def activation(name, desc, triggers):
    say = ""
    if triggers:
        say = " — for example when they say: " + ", ".join(f'"{t}"' for t in triggers)
    return (
        f"> **Skill: `{name}`.** {desc}\n>\n"
        f"> **Activate** this skill when the user's request matches it{say}. "
        f"When active, follow the instructions below precisely; otherwise ignore them.\n>\n"
        f"> Ported from [{OWNER}/{REPO}]({BLOB}/{name}/SKILL.md) — the full folder "
        f"(references, scripts) lives there."
    )


def write(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8", newline="\n") as f:
        f.write(content)


def main():
    triggers = load_triggers()
    combined = ["# Agent skills — AGENTS.md bundle\n",
                f"Ported from https://github.com/{OWNER}/{REPO}. Drop this whole file in "
                "your repo root (or ~/.codex/AGENTS.md), or take one section.\n"]
    warnings = []

    for name in skills():
        fm, body = parse_skill(name)
        desc = " ".join(str(fm.get("description", "")).split())
        body = rewrite_links(body, name)
        core = activation(name, desc, triggers.get(name, [])) + "\n\n" + body
        section = (f"<!-- skills-directory:{name} START -->\n"
                   f"## Skill: {name}\n\n{core}\n"
                   f"<!-- skills-directory:{name} END -->\n")

        # AGENTS.md-family (Codex, Aider, opencode, Copilot, Roo, Zed, generic)
        write(os.path.join(EXPORTS, "agents", f"{name}.md"), section)
        # Gemini CLI (GEMINI.md is plain markdown)
        write(os.path.join(EXPORTS, "gemini", f"{name}.md"), section)
        # Windsurf rule (.windsurf/rules/<name>.md); filename is the rule id
        wind = f"{core}\n"
        write(os.path.join(EXPORTS, "windsurf", f"{name}.md"), wind)
        if len(wind) > WINDSURF_LIMIT:
            warnings.append(f"{name}: windsurf export {len(wind)} chars > {WINDSURF_LIMIT} limit "
                            "(Windsurf may truncate; split into references)")
        # Cursor rule (.cursor/rules/<name>.mdc) — REQUIRES frontmatter
        cdesc = desc.replace('"', "'")
        mdc = (f"---\ndescription: \"{cdesc}\"\nglobs: \"\"\nalwaysApply: false\n---\n\n{core}\n")
        write(os.path.join(EXPORTS, "cursor", f"{name}.mdc"), mdc)

        combined.append(section)

    write(os.path.join(EXPORTS, "AGENTS.md"), "\n".join(combined))
    write(os.path.join(EXPORTS, "index.txt"), "\n".join(skills()) + "\n")

    print(f"Exported {len(skills())} skills -> exports/{{agents,gemini,windsurf,cursor}}/ + exports/AGENTS.md")
    for w in warnings:
        print("WARNING:", w)


if __name__ == "__main__":
    main()
