#!/usr/bin/env bash
# Runs all AAxon skill scripts for phase 02-data-readiness IN ORDER.
# Each individual script handles its own idempotent registration.
set -euo pipefail

if [ -z "${ANTHROPIC_API_KEY:-}" ]; then
    echo "ERROR: ANTHROPIC_API_KEY is not set."
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo
echo "##### Prompt 1: context-fabric #####"
"$SCRIPT_DIR/01-context-fabric.sh"
echo
echo "##### Prompt 2: policy-catalog #####"
"$SCRIPT_DIR/02-policy-catalog.sh"
echo
echo "##### Prompt 3: research-copilot #####"
"$SCRIPT_DIR/03-research-copilot.sh"
echo
echo "##### Prompt 4: assumption-tracker #####"
"$SCRIPT_DIR/04-assumption-tracker.sh"
echo
echo "##### Prompt 5: transform-iq #####"
"$SCRIPT_DIR/05-transform-iq.sh"
echo
echo "##### Prompt 6: spec-flow #####"
"$SCRIPT_DIR/06-spec-flow.sh"
echo
echo "##### Prompt 7: trace-graph #####"
"$SCRIPT_DIR/07-trace-graph.sh"
echo
echo "##### Prompt 8: spec-impact-analyzer #####"
"$SCRIPT_DIR/08-spec-impact-analyzer.sh"
echo
echo "##### Prompt 9: value-modeler #####"
"$SCRIPT_DIR/09-value-modeler.sh"
echo
echo "##### Prompt 10: portfolio-prioritizer #####"
"$SCRIPT_DIR/10-portfolio-prioritizer.sh"
echo
echo "##### Prompt 11: scenario-planner #####"
"$SCRIPT_DIR/11-scenario-planner.sh"
echo
echo "##### Prompt 12: decision-ledger #####"
"$SCRIPT_DIR/12-decision-ledger.sh"
echo
echo "##### Prompt 13: conductor #####"
"$SCRIPT_DIR/13-conductor.sh"

echo "Phase 02-data-readiness complete."
