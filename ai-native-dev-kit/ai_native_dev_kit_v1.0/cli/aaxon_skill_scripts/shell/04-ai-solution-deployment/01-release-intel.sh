#!/usr/bin/env bash
# ============================================================
#  AAxon Skill Runner (macOS / Linux)
#  Skill:  release-intel
#  Phase:  04 - AI Solution Deployment
#  Prompt: 1 (source: 04-ai-solution-deployment.md)
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
SKILL_NAME="release-intel"
SKILL_TITLE="Release Intel"
SKILL_DIR="$ROOT_DIR/skills_bundles/release-intel"
PROMPT_FILE="$ROOT_DIR/prompts/04-ai-solution-deployment/01-release-intel.txt"
REGISTRY_PATH="$ROOT_DIR/registry/aa_skill_registry.json"
SESSION_NAME="aaxon-04-ai-solution-deployment"

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
        --description "Synthesizes sprint planning artifacts into a binary READY/NOT READY release verdict with blast-radius assessment per component and a prioritized P0–P3 open issues list."
fi

echo "=== [$SKILL_NAME] Invoking with prompt: $PROMPT_FILE ==="
aa-skills --registry "$REGISTRY_PATH" invoke \
    --skills "$SKILL_NAME" \
    --prompt-file "$PROMPT_FILE" \
    --session "$SESSION_NAME"

echo "=== [$SKILL_NAME] Done ==="
