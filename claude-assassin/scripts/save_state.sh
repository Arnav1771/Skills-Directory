#!/usr/bin/env bash
# ============================================================
# claude-assassin: save_state.sh
# Saves the current task state before Claude Code session ends.
# Usage: bash save_state.sh "description of current task"
# ============================================================

set -euo pipefail

ASSASSIN_DIR="$HOME/.claude/assassin"
STATE_FILE="$ASSASSIN_DIR/session_state.md"
LOG="$ASSASSIN_DIR/assassin.log"

mkdir -p "$ASSASSIN_DIR"

CYAN='\033[0;36m'; GREEN='\033[0;32m'; NC='\033[0m'
info()    { echo -e "${CYAN}[assassin]${NC} $*"; }
success() { echo -e "${GREEN}[assassin]${NC} $*"; }

TASK_DESCRIPTION="${1:-No task description provided. Resume last known work.}"
TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"
CWD="$(pwd)"
GIT_BRANCH=""

# Try to capture git branch if in a repo
if git rev-parse --abbrev-ref HEAD &>/dev/null 2>&1; then
  GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
fi

# Try to capture last few lines of claude conversation if log exists
RECENT_LOG=""
CLAUDE_LOG_CANDIDATES=(
  "$HOME/.claude/logs/latest.log"
  "$HOME/.claude/logs/current.log"
)
# Also try the most recently modified log in the logs dir
if [[ -d "$HOME/.claude/logs" ]]; then
  LATEST_BY_TIME=$(ls -t "$HOME/.claude/logs/"*.log 2>/dev/null | head -1 || true)
  [[ -n "$LATEST_BY_TIME" ]] && CLAUDE_LOG_CANDIDATES+=("$LATEST_BY_TIME")
fi
for _log in "${CLAUDE_LOG_CANDIDATES[@]}"; do
  if [[ -f "$_log" ]]; then
    RECENT_LOG="$(tail -n 20 "$_log" 2>/dev/null || true)"
    break
  fi
done

# Write state file
cat > "$STATE_FILE" << STATE
# Claude Assassin — Saved Session State
Saved at: $TIMESTAMP

## Working Directory
$CWD

## Git Branch
${GIT_BRANCH:-Not a git repo or no branch detected}

## Task Description
$TASK_DESCRIPTION

## Instructions for Claude on Resume
- Resume this task exactly where it left off
- Re-read any relevant files in the working directory
- Do not re-explain what you are doing, just continue
- Check git status if relevant before proceeding

## Recent Activity (last log lines)
${RECENT_LOG:-Not available}
STATE

echo "[$(date '+%Y-%m-%d %H:%M:%S')] State saved: $TASK_DESCRIPTION" >> "$LOG"

success "Task state saved to $STATE_FILE"
info "Task: $TASK_DESCRIPTION"
info "Directory: $CWD"
echo ""
info "Now run: bash ~/.claude/skills/claude-assassin/scripts/schedule_resume.sh '4:50pm'"
