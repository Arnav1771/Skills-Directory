#!/usr/bin/env bash
# Runs all AAxon skill scripts for phase 05-simplified-ai-operations IN ORDER.
# Each individual script handles its own idempotent registration.
set -euo pipefail

if [ -z "${ANTHROPIC_API_KEY:-}" ]; then
    echo "ERROR: ANTHROPIC_API_KEY is not set."
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo
echo "##### Prompt 1: control-plane #####"
"$SCRIPT_DIR/01-control-plane.sh"
echo
echo "##### Prompt 2: runtime-iq #####"
"$SCRIPT_DIR/02-runtime-iq.sh"
echo
echo "##### Prompt 3: drift-guard #####"
"$SCRIPT_DIR/03-drift-guard.sh"
echo
echo "##### Prompt 4: incident-lens #####"
"$SCRIPT_DIR/04-incident-lens.sh"
echo
echo "##### Prompt 5: runbook-synth #####"
"$SCRIPT_DIR/05-runbook-synth.sh"
echo
echo "##### Prompt 6: value-tracker #####"
"$SCRIPT_DIR/06-value-tracker.sh"
echo
echo "##### Prompt 7: experiment-ops #####"
"$SCRIPT_DIR/07-experiment-ops.sh"
echo
echo "##### Prompt 8: tool-surface-auditor #####"
"$SCRIPT_DIR/08-tool-surface-auditor.sh"
echo
echo "##### Prompt 9: prompt-slimmer #####"
"$SCRIPT_DIR/09-prompt-slimmer.sh"
echo
echo "##### Prompt 10: budget-governor #####"
"$SCRIPT_DIR/10-budget-governor.sh"
echo
echo "##### Prompt 11: semantic-cache #####"
"$SCRIPT_DIR/11-semantic-cache.sh"
echo
echo "##### Prompt 12: model-router #####"
"$SCRIPT_DIR/12-model-router.sh"
echo
echo "##### Prompt 13: regex-llm-router #####"
"$SCRIPT_DIR/13-regex-llm-router.sh"
echo
echo "##### Prompt 14: context-profiler #####"
"$SCRIPT_DIR/14-context-profiler.sh"
echo
echo "##### Prompt 15: relevance-pruner #####"
"$SCRIPT_DIR/15-relevance-pruner.sh"
echo
echo "##### Prompt 16: rolling-summarizer #####"
"$SCRIPT_DIR/16-rolling-summarizer.sh"
echo
echo "##### Prompt 17: strategic-compactor #####"
"$SCRIPT_DIR/17-strategic-compactor.sh"
echo
echo "##### Prompt 18: iterative-retrieval #####"
"$SCRIPT_DIR/18-iterative-retrieval.sh"
echo
echo "##### Prompt 19: memory-persistence #####"
"$SCRIPT_DIR/19-memory-persistence.sh"
echo
echo "##### Prompt 20: eval-harness #####"
"$SCRIPT_DIR/20-eval-harness.sh"
echo
echo "##### Prompt 21: pattern-extractor #####"
"$SCRIPT_DIR/21-pattern-extractor.sh"

echo "Phase 05-simplified-ai-operations complete."
