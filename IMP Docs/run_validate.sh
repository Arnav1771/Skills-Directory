#!/usr/bin/env bash
set -e
cd "$(dirname "$0")/.."
if ! python3 -c "import yaml" 2>/dev/null; then
  pip install pyyaml -q 2>/dev/null || pip3 install pyyaml -q 2>/dev/null || true
fi
python3 "IMP Docs/validate_manifests.py"
