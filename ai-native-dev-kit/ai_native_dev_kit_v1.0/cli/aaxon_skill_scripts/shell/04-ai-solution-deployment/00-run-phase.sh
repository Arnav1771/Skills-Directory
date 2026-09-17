#!/usr/bin/env bash
# Runs all AAxon skill scripts for phase 04-ai-solution-deployment IN ORDER.
# Each individual script handles its own idempotent registration.
set -euo pipefail

if [ -z "${ANTHROPIC_API_KEY:-}" ]; then
    echo "ERROR: ANTHROPIC_API_KEY is not set."
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo
echo "##### Prompt 1: release-intel #####"
"$SCRIPT_DIR/01-release-intel.sh"
echo
echo "##### Prompt 2: parity-checker #####"
"$SCRIPT_DIR/02-parity-checker.sh"
echo
echo "##### Prompt 3: rollout-advisor #####"
"$SCRIPT_DIR/03-rollout-advisor.sh"

echo "Phase 04-ai-solution-deployment complete."
