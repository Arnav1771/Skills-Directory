#!/usr/bin/env bash
# ============================================================
# claude-assassin: status.sh
# Check daemon status, scheduled resume, and saved state.
# ============================================================

ASSASSIN_DIR="$HOME/.claude/assassin"
OS="$(uname -s)"

CYAN='\033[0;36m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
info()    { echo -e "${CYAN}[assassin]${NC} $*"; }
success() { echo -e "${GREEN}[assassin]${NC} $*"; }
warn()    { echo -e "${YELLOW}[assassin]${NC} $*"; }
err()     { echo -e "${RED}[assassin]${NC} $*"; }

echo ""
echo -e "${CYAN}══════════════════════════════════════${NC}"
echo -e "${CYAN}   claude-assassin status             ${NC}"
echo -e "${CYAN}══════════════════════════════════════${NC}"
echo ""

# ── Daemon status ─────────────────────────────────────────────
echo -e "${CYAN}▸ Daemon:${NC}"
if [[ "$OS" == MINGW* ]] || [[ "$OS" == CYGWIN* ]]; then
  # Windows (Git Bash)
  STARTUP_WIN=$(powershell.exe -NoProfile -Command '[Environment]::GetFolderPath("Startup")' 2>/dev/null | tr -d '\r\n')
  STARTUP_DIR=$(cygpath -u "$STARTUP_WIN" 2>/dev/null)
  VBS_FILE="$STARTUP_DIR/claude_assassin.vbs"

  if [[ -f "$VBS_FILE" ]]; then
    success "  Startup script: INSTALLED ($VBS_FILE)"
  else
    err "  Startup script not found — run install_daemon.sh"
  fi

  if ps aux 2>/dev/null | grep -q "[w]atcher.sh"; then
    WPID=$(ps aux 2>/dev/null | grep "[w]atcher.sh" | awk '{print $2}' | head -1)
    success "  Watcher process: RUNNING (PID $WPID)"
  elif [[ -f "$ASSASSIN_DIR/assassin.log" ]] && grep -q "Watcher started" "$ASSASSIN_DIR/assassin.log" 2>/dev/null; then
    LAST_START=$(grep "Watcher started" "$ASSASSIN_DIR/assassin.log" | tail -1)
    success "  Watcher was started: $LAST_START"
  else
    warn "  Watcher not running this session — will start at next login (or re-run install_daemon.sh)"
  fi
elif [[ "$OS" == "Linux" ]] || grep -qi microsoft /proc/version 2>/dev/null; then
  if systemctl --user is-active claude-assassin.service &>/dev/null 2>&1; then
    success "  systemd service: RUNNING"
  elif pgrep -f "watcher.sh" &>/dev/null; then
    success "  watcher.sh: RUNNING (cron/background)"
  else
    err "  Daemon: NOT RUNNING — run install_daemon.sh"
  fi
elif [[ "$OS" == "Darwin" ]]; then
  if launchctl list 2>/dev/null | grep -q "com.claude.assassin"; then
    success "  launchd agent: RUNNING"
  else
    err "  Daemon: NOT RUNNING — run install_daemon.sh"
  fi
fi

echo ""

# ── Scheduled resume ──────────────────────────────────────────
echo -e "${CYAN}▸ Scheduled Resume:${NC}"
SCHEDULED_FILE="$ASSASSIN_DIR/scheduled_resume.txt"
RESET_FILE="$ASSASSIN_DIR/last_reset_time.txt"

if [[ -f "$SCHEDULED_FILE" ]]; then
  TARGET_EPOCH=$(cat "$SCHEDULED_FILE")
  NOW_EPOCH=$(date +%s)
  WAIT=$((TARGET_EPOCH - NOW_EPOCH))
  RESET_TIME=$(cat "$RESET_FILE" 2>/dev/null || echo "unknown")

  if [[ "$WAIT" -gt 0 ]]; then
    warn "  Scheduled for: $RESET_TIME (in ~$((WAIT/60)) minutes)"
  else
    success "  Resume time has passed — Claude should have relaunched"
  fi
else
  info "  No resume scheduled."
fi

echo ""

# ── Saved state ───────────────────────────────────────────────
echo -e "${CYAN}▸ Saved State:${NC}"
STATE_FILE="$ASSASSIN_DIR/session_state.md"
if [[ -f "$STATE_FILE" ]]; then
  success "  State file exists: $STATE_FILE"
  TASK=$(grep "## Task Description" -A1 "$STATE_FILE" 2>/dev/null | tail -1 || echo "unknown")
  info "  Task: $TASK"
else
  info "  No saved state."
fi

echo ""

# ── Recent logs ───────────────────────────────────────────────
echo -e "${CYAN}▸ Recent Log:${NC}"
LOG="$ASSASSIN_DIR/assassin.log"
if [[ -f "$LOG" ]]; then
  tail -n 5 "$LOG" | sed 's/^/  /'
else
  info "  No log file yet."
fi

echo ""
