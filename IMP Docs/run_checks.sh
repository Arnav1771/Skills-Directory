#!/usr/bin/env bash
# Run every Skills-Directory catalog check. Used locally and by CI.
set -e
cd "$(dirname "$0")/.."
if ! python3 -c "import yaml" 2>/dev/null; then
  pip install pyyaml -q 2>/dev/null || pip3 install pyyaml -q 2>/dev/null || true
fi
echo "== manifests =="   && python3 "IMP Docs/validate_manifests.py"
echo && echo "== marketplace + compat ==" && python3 "IMP Docs/validate_catalog.py"
echo && echo "== trigger evals ==" && python3 "IMP Docs/eval_skills.py"
