#!/usr/bin/env bash
# Runs all AAxon skill scripts for phase 01-establish-strategy IN ORDER.
# Each individual script handles its own idempotent registration.
set -euo pipefail

if [ -z "${ANTHROPIC_API_KEY:-}" ]; then
    echo "ERROR: ANTHROPIC_API_KEY is not set."
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo
echo "##### Prompt 1: program-charter #####"
"$SCRIPT_DIR/01-program-charter.sh"
echo
echo "##### Prompt 2: spec-knowledge #####"
"$SCRIPT_DIR/02-spec-knowledge.sh"
echo
echo "##### Prompt 3: spec-design #####"
"$SCRIPT_DIR/03-spec-design.sh"
echo
echo "##### Prompt 4: spec-uiux #####"
"$SCRIPT_DIR/04-spec-uiux.sh"
echo
echo "##### Prompt 5: spec-database #####"
"$SCRIPT_DIR/05-spec-database.sh"
echo
echo "##### Prompt 6: spec-api #####"
"$SCRIPT_DIR/06-spec-api.sh"
echo
echo "##### Prompt 7: skill-flow #####"
"$SCRIPT_DIR/07-skill-flow.sh"
echo
echo "##### Prompt 8: skill-generator #####"
"$SCRIPT_DIR/08-skill-generator.sh"
echo
echo "##### Prompt 9: requirements-elicitation-charter #####"
"$SCRIPT_DIR/09-requirements-elicitation-charter.sh"
echo
echo "##### Prompt 10: doc-extraction #####"
"$SCRIPT_DIR/10-doc-extraction.sh"
echo
echo "##### Prompt 11: code-extraction #####"
"$SCRIPT_DIR/11-code-extraction.sh"
echo
echo "##### Prompt 12: meeting-extraction #####"
"$SCRIPT_DIR/12-meeting-extraction.sh"
echo
echo "##### Prompt 13: knowledge-review #####"
"$SCRIPT_DIR/13-knowledge-review.sh"
echo
echo "##### Prompt 14: design-setup #####"
"$SCRIPT_DIR/14-design-setup.sh"
echo
echo "##### Prompt 15: spec-generation #####"
"$SCRIPT_DIR/15-spec-generation.sh"

echo "Phase 01-establish-strategy complete."
