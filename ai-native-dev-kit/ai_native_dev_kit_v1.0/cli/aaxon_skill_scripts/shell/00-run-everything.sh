#!/usr/bin/env bash
# Runs every AAxon phase end-to-end, in order.
# This will take a long time and consume real API credit - review
# `aa-skills credits show` between phases if you're budget-conscious.
set -euo pipefail

if [ -z "${ANTHROPIC_API_KEY:-}" ]; then
    echo "ERROR: ANTHROPIC_API_KEY is not set."
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "===== Phase: 01-establish-strategy ====="
"$SCRIPT_DIR/01-establish-strategy/00-run-phase.sh"

echo "===== Phase: 02-data-readiness ====="
"$SCRIPT_DIR/02-data-readiness/00-run-phase.sh"

echo "===== Phase: 03-platform-enablement ====="
"$SCRIPT_DIR/03-platform-enablement/00-run-phase.sh"

echo "===== Phase: 04-ai-solution-deployment ====="
"$SCRIPT_DIR/04-ai-solution-deployment/00-run-phase.sh"

echo "===== Phase: 05-simplified-ai-operations ====="
"$SCRIPT_DIR/05-simplified-ai-operations/00-run-phase.sh"

echo "All phases complete."
