#!/usr/bin/env bash
# ============================================================
#  AAxon Skill Runner (macOS / Linux)
#  Skill:  spec-api
#  Phase:  01 - Establish Strategy
#  Prompt: 6 (source: 01-establish-strategy.md)
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
SKILL_NAME="spec-api"
SKILL_TITLE="Spec Api"
SKILL_DIR="$ROOT_DIR/skills_bundles/spec-api"
PROMPT_FILE="$ROOT_DIR/prompts/01-establish-strategy/06-spec-api.txt"
REGISTRY_PATH="$ROOT_DIR/registry/aa_skill_registry.json"
SESSION_NAME="aaxon-01-establish-strategy"

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
        --description "Creates and maintains specs/api.md with complete endpoint definitions, Pydantic schemas, authentication strategy, and error contract derived from domain entities in knowledge.md and database.md."
fi

echo "=== [$SKILL_NAME] Invoking with prompt: $PROMPT_FILE ==="
aa-skills --registry "$REGISTRY_PATH" invoke \
    --skills "$SKILL_NAME" \
    --prompt-file "$PROMPT_FILE" \
    --session "$SESSION_NAME"

echo "=== [$SKILL_NAME] Done ==="
