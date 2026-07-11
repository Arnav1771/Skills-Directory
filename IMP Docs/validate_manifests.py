#!/usr/bin/env python3
"""Validate every skill's manifest.yaml against the Skills-Directory catalog contract."""
import os, sys, glob
try:
    import yaml
except ImportError:
    sys.exit("PyYAML not installed")

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
REQUIRED = ["name", "description", "categories", "tags", "icon", "version", "composesWell"]
skills = sorted(d for d in os.listdir(ROOT)
                if os.path.isdir(os.path.join(ROOT, d)) and not d.startswith(".")
                and os.path.exists(os.path.join(ROOT, d, "SKILL.md")))
errors, ok = [], []
for s in skills:
    mpath = os.path.join(ROOT, s, "manifest.yaml")
    if not os.path.exists(mpath):
        errors.append(f"{s}: missing manifest.yaml"); continue
    with open(mpath) as f:
        try:
            m = yaml.safe_load(f)
        except Exception as e:
            errors.append(f"{s}: YAML parse error: {e}"); continue
    for k in REQUIRED:
        if k not in m:
            errors.append(f"{s}: missing field '{k}'")
    if m.get("name") != s:
        errors.append(f"{s}: name '{m.get('name')}' != folder")
    desc = str(m.get("description", ""))
    if "<" in desc or ">" in desc:
        errors.append(f"{s}: description contains forbidden angle bracket")
    if not isinstance(m.get("version"), str):
        errors.append(f"{s}: version must be a quoted string, got {type(m.get('version')).__name__}")
    for c in (m.get("composesWell") or []):
        if c not in skills:
            errors.append(f"{s}: composesWell -> '{c}' is not a skill in this repo")
    if not any(e.startswith(s + ":") for e in errors):
        ok.append(f"{s}: OK ({', '.join(m.get('categories', []))})")

print("Skills found:", ", ".join(skills))
print("\n".join(ok))
if errors:
    print("\nERRORS:"); print("\n".join(errors)); sys.exit(1)
print("\nAll manifests valid.")
