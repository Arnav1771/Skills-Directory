#!/usr/bin/env bash
# Runs all AAxon skill scripts for phase 03-platform-enablement IN ORDER.
# Each individual script handles its own idempotent registration.
set -euo pipefail

if [ -z "${ANTHROPIC_API_KEY:-}" ]; then
    echo "ERROR: ANTHROPIC_API_KEY is not set."
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo
echo "##### Prompt 1: knowledge-mesh #####"
"$SCRIPT_DIR/01-knowledge-mesh.sh"
echo
echo "##### Prompt 2: secret-shield #####"
"$SCRIPT_DIR/02-secret-shield.sh"
echo
echo "##### Prompt 3: trust-fabric #####"
"$SCRIPT_DIR/03-trust-fabric.sh"
echo
echo "##### Prompt 4: performance-optimizer #####"
"$SCRIPT_DIR/04-performance-optimizer.sh"
echo
echo "##### Prompt 5: experience-studio #####"
"$SCRIPT_DIR/05-experience-studio.sh"
echo
echo "##### Prompt 6: dev-copilot #####"
"$SCRIPT_DIR/06-dev-copilot.sh"
echo
echo "##### Prompt 7: prompt-bench #####"
"$SCRIPT_DIR/07-prompt-bench.sh"
echo
echo "##### Prompt 8: review-pilot #####"
"$SCRIPT_DIR/08-review-pilot.sh"
echo
echo "##### Prompt 9: nexus-deploy #####"
"$SCRIPT_DIR/09-nexus-deploy.sh"
echo
echo "##### Prompt 10: guardian #####"
"$SCRIPT_DIR/10-guardian.sh"
echo
echo "##### Prompt 11: eval-harness #####"
"$SCRIPT_DIR/11-eval-harness.sh"
echo
echo "##### Prompt 12: red-team-x #####"
"$SCRIPT_DIR/12-red-team-x.sh"
echo
echo "##### Prompt 13: sim-lab #####"
"$SCRIPT_DIR/13-sim-lab.sh"
echo
echo "##### Prompt 14: policy-enforcer #####"
"$SCRIPT_DIR/14-policy-enforcer.sh"
echo
echo "##### Prompt 15: insight-ops #####"
"$SCRIPT_DIR/15-insight-ops.sh"

echo "Phase 03-platform-enablement complete."
