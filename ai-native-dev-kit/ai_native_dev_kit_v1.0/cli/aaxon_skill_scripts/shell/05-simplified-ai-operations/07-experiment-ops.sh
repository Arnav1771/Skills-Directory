#!/usr/bin/env bash
# ============================================================
#  AAxon Skill Runner (macOS / Linux)
#  Skill:  experiment-ops
#  Phase:  05 - Simplified AI Operations
#  Prompt: 7 (source: 05-simplified-ai-operations.md)
#  First registration point for this skill.
# ============================================================
set -euo pipefail

if [ -z "${ANTHROPIC_API_KEY:-}" ]; then
    echo "ERROR: ANTHROPIC_API_KEY is not set."
    echo '  Set it first, e.g.:  export ANTHROPIC_API_KEY=sk-ant-...'
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL_NAME="experiment-ops"
SKILL_TITLE="Experiment Ops"
SKILL_DIR="$ROOT_DIR/skills_bundles/experiment-ops"
PROMPT_FILE="$ROOT_DIR/prompts/05-simplified-ai-operations/07-experiment-ops.txt"
REGISTRY_PATH="$ROOT_DIR/registry/aa_skill_registry.json"
SESSION_NAME="aaxon-05-simplified-ai-operations"

if [ ! -f "$PROMPT_FILE" ]; then
    echo "ERROR: Prompt file not found: $PROMPT_FILE"
    exit 1
fi

echo "=== [$SKILL_NAME] Checking whether the skill is already registered ==="
if aa-skills --registry "$REGISTRY_PATH" list-skills | grep -qi "^$SKILL_NAME "; then
    echo "Skill '$SKILL_NAME' is already registered in $REGISTRY_PATH - skipping registration."
else
    echo "Registering skill '$SKILL_NAME' from $SKILL_DIR ..."
    aa-skills --registry "$REGISTRY_PATH" register-skill \
        --dir "$SKILL_DIR" \
        --name "$SKILL_NAME" \
        --title "$SKILL_TITLE" \
        --description "Generates complete A/B experiment configuration with traffic routing, guardrail monitoring, and automatic stopping, enabling statistically rigorous production experiments without dedicated data science infrastructure."
fi

echo "=== [$SKILL_NAME] Invoking with prompt: $PROMPT_FILE ==="
aa-skills --registry "$REGISTRY_PATH" invoke \
    --skills "$SKILL_NAME" \
    --prompt-file "$PROMPT_FILE" \
    --session "$SESSION_NAME"

echo "=== [$SKILL_NAME] Done ==="
