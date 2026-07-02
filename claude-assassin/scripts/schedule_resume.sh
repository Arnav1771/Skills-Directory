#!/usr/bin/env bash
# ============================================================
# claude-assassin: schedule_resume.sh
# Parses the reset time from terminal and schedules the resume.
# Usage: bash schedule_resume.sh "4:50pm"
#        bash schedule_resume.sh  (auto-reads from clipboard/stdin)
# ============================================================

set -euo pipefail

ASSASSIN_DIR="$HOME/.claude/assassin"
SCHEDULED_FILE="$ASSASSIN_DIR/scheduled_resume.txt"
RESET_FILE="$ASSASSIN_DIR/last_reset_time.txt"
LOG="$ASSASSIN_DIR/assassin.log"

mkdir -p "$ASSASSIN_DIR"

CYAN='\033[0;36m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
info()    { echo -e "${CYAN}[assassin]${NC} $*"; }
success() { echo -e "${GREEN}[assassin]${NC} $*"; }
warn()    { echo -e "${YELLOW}[assassin]${NC} $*"; }
error()   { echo -e "${RED}[assassin]${NC} $*"; exit 1; }

# ── Get reset time ────────────────────────────────────────────
RESET_INPUT="${1:-}"

if [[ -z "$RESET_INPUT" ]]; then
  # Try to auto-detect from recent terminal output / claude logs
  if [[ -f "$HOME/.claude/logs/latest.log" ]]; then
    RESET_INPUT=$(grep -oP '\d{1,2}:\d{2}[ap]m' "$HOME/.claude/logs/latest.log" 2>/dev/null | tail -1 || true)
  fi

  if [[ -z "$RESET_INPUT" ]]; then
    echo -n "Enter reset time from terminal (e.g. 4:50pm): "
    read -r RESET_INPUT
  fi
fi

# Normalize input: strip spaces, lowercase
RESET_INPUT=$(echo "$RESET_INPUT" | tr '[:upper:]' '[:lower:]' | tr -d ' ')

# Extract time pattern (e.g. 4:50pm, 16:50, 4:50)
TIME_PATTERN=$(echo "$RESET_INPUT" | grep -oP '\d{1,2}:\d{2}(am|pm)?' || true)

if [[ -z "$TIME_PATTERN" ]]; then
  error "Could not parse a time from: '$RESET_INPUT'. Expected format: 4:50pm or 16:50"
fi

info "Parsed reset time: $TIME_PATTERN"

# ── Convert to epoch ──────────────────────────────────────────
OS="$(uname -s)"

# Add buffer: schedule 1 minute AFTER reset to ensure limit is cleared
parse_to_epoch() {
  local time_str="$1"
  local today
  today="$(date '+%Y-%m-%d')"

  # Handle am/pm
  if echo "$time_str" | grep -qP '(am|pm)$'; then
    if [[ "$OS" == "Darwin" ]]; then
      # macOS date
      TARGET_EPOCH=$(date -j -f "%Y-%m-%d %I:%M%p" "${today} ${time_str}" "+%s" 2>/dev/null || \
                     date -j -f "%Y-%m-%d %H:%M" "${today} ${time_str}" "+%s")
    else
      # Linux date
      TARGET_EPOCH=$(date -d "${today} ${time_str}" "+%s" 2>/dev/null || \
                     date -d "${time_str}" "+%s")
    fi
  else
    # 24hr format
    if [[ "$OS" == "Darwin" ]]; then
      TARGET_EPOCH=$(date -j -f "%Y-%m-%d %H:%M" "${today} ${time_str}" "+%s")
    else
      TARGET_EPOCH=$(date -d "${today} ${time_str}" "+%s")
    fi
  fi

  echo "$TARGET_EPOCH"
}

TARGET_EPOCH=$(parse_to_epoch "$TIME_PATTERN")

# Add 60 seconds buffer
TARGET_EPOCH=$((TARGET_EPOCH + 60))

NOW_EPOCH=$(date +%s)

if [[ "$TARGET_EPOCH" -le "$NOW_EPOCH" ]]; then
  warn "Time $TIME_PATTERN appears to be in the past. Adding 24 hours."
  TARGET_EPOCH=$((TARGET_EPOCH + 86400))
fi

WAIT_SECONDS=$((TARGET_EPOCH - NOW_EPOCH))
WAIT_MINUTES=$((WAIT_SECONDS / 60))

# ── Write schedule file (watcher.sh polls this) ───────────────
echo "$TARGET_EPOCH" > "$SCHEDULED_FILE"
echo "$TIME_PATTERN" > "$RESET_FILE"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Resume scheduled for $TIME_PATTERN (epoch: $TARGET_EPOCH, wait: ${WAIT_MINUTES}m)" >> "$LOG"

# ── Confirm ───────────────────────────────────────────────────
echo ""
success "══════════════════════════════════════════"
success "  Resume scheduled — Assassin is active   "
success "══════════════════════════════════════════"
echo ""
info "Reset time:     $TIME_PATTERN"
info "Resuming at:    $(date -d "@$TARGET_EPOCH" '+%H:%M:%S' 2>/dev/null || date -r "$TARGET_EPOCH" '+%H:%M:%S')"
info "Waiting:        ~${WAIT_MINUTES} minutes"
info "Daemon log:     tail -f $LOG"
echo ""
warn "You can now close this terminal or walk away."
warn "Claude Code will relaunch automatically."
echo ""
