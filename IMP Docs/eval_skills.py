#!/usr/bin/env python3
"""Trigger-eval harness for Skills-Directory.

Asserts each skill's SKILL.md `description` still contains the phrases users say
to trigger it (should_trigger) and excludes phrases that belong to other skills
(should_not), and warns when one skill's trigger phrase also matches another
skill's description (ambiguous routing). Deterministic — safe to run in CI.
"""
import os, re, sys, glob
try:
    import yaml
except ImportError:
    sys.exit("PyYAML not installed")

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
EVALS = os.path.join(ROOT, "IMP Docs", "skill_evals.yaml")


def frontmatter_description(skill):
    """Extract the `description` field from a skill's SKILL.md YAML frontmatter."""
    path = os.path.join(ROOT, skill, "SKILL.md")
    with open(path, encoding="utf-8") as f:
        text = f.read()
    m = re.match(r"^---\s*\n(.*?)\n---\s*\n", text, re.DOTALL)
    if not m:
        raise ValueError(f"{skill}: no YAML frontmatter in SKILL.md")
    fm = yaml.safe_load(m.group(1))
    return str(fm.get("description", ""))


def matches(phrase, text):
    """Case-insensitive, word-boundary-aware substring match."""
    return re.search(r"(?<!\w)" + re.escape(phrase) + r"(?!\w)", text, re.IGNORECASE) is not None


def main():
    with open(EVALS, encoding="utf-8") as f:
        evals = yaml.safe_load(f)

    descriptions = {s: frontmatter_description(s) for s in evals}
    errors, warnings, passes = [], [], 0

    for skill, spec in evals.items():
        desc = descriptions[skill]
        for phrase in spec.get("should_trigger", []):
            if matches(phrase, desc):
                passes += 1
            else:
                errors.append(f"{skill}: should_trigger '{phrase}' NOT in description (drift)")
        for phrase in spec.get("should_not", []):
            if matches(phrase, desc):
                errors.append(f"{skill}: should_not '{phrase}' IS in description (over-broad)")
            else:
                passes += 1
        # Cross-skill ambiguity: this skill's trigger phrases must not match others.
        for phrase in spec.get("should_trigger", []):
            for other, odesc in descriptions.items():
                if other != skill and matches(phrase, odesc):
                    warnings.append(f"AMBIGUOUS: '{phrase}' ({skill}) also matches {other}'s description")

    print(f"Skills evaluated: {', '.join(evals)}")
    print(f"Assertions passed: {passes}")
    if warnings:
        print("\nWARNINGS:")
        print("\n".join(sorted(set(warnings))))
    if errors:
        print("\nERRORS:")
        print("\n".join(errors))
        sys.exit(1)
    print("\nAll trigger evals passed.")


if __name__ == "__main__":
    main()
