#!/usr/bin/env bash
# ============================================================
# claude-assassin: uninstall_daemon.sh
# Cleanly removes the daemon from the system.
# ============================================================

set -euo pipefail

OS="$(uname -s)"
ASSASSIN_DIR="$HOME/.claude/assassin"

RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; NC='\033[0m'
info()    { echo -e "${CYAN}[assassin]${NC} $*"; }
success() { echo -e "${GREEN}[assassin]${NC} $*"; }
warn()    { echo -e "${RED}[assassin]${NC} $*"; }

info "Uninstalling claude-assassin daemon..."

# Windows Startup folder VBScript
if [[ "$OS" == MINGW* ]] || [[ "$OS" == CYGWIN* ]]; then
  STARTUP_WIN=$(powershell.exe -NoProfile -Command '[Environment]::GetFolderPath("Startup")' 2>/dev/null | tr -d '\r\n')
  STARTUP_DIR=$(cygpath -u "$STARTUP_WIN" 2>/dev/null)
  VBS_FILE="$STARTUP_DIR/claude_assassin.vbs"
  if [[ -f "$VBS_FILE" ]]; then
    rm -f "$VBS_FILE"
    success "Startup script removed: $VBS_FILE"
  else
    info "No startup script found."
  fi
fi

# Linux systemd
if [[ "$OS" == "Linux" ]] || grep -qi microsoft /proc/version 2>/dev/null; then
  SERVICE_FILE="$HOME/.config/systemd/user/claude-assassin.service"
  if [[ -f "$SERVICE_FILE" ]]; then
    systemctl --user stop claude-assassin.service 2>/dev/null || true
    systemctl --user disable claude-assassin.service 2>/dev/null || true
    rm -f "$SERVICE_FILE"
    systemctl --user daemon-reload
    success "Systemd service removed."
  else
    info "No systemd service found."
  fi
fi

# macOS launchd
if [[ "$OS" == "Darwin" ]]; then
  PLIST="$HOME/Library/LaunchAgents/com.claude.assassin.plist"
  if [[ -f "$PLIST" ]]; then
    launchctl unload "$PLIST" 2>/dev/null || true
    rm -f "$PLIST"
    success "LaunchAgent removed."
  else
    info "No LaunchAgent found."
  fi
fi

# Cron fallback (any OS)
if command -v crontab &>/dev/null && crontab -l 2>/dev/null | grep -q "watcher.sh"; then
  crontab -l 2>/dev/null | grep -v "watcher.sh" | crontab -
  success "Cron entry removed."
fi

# Kill any running watcher processes
pkill -f "watcher.sh" 2>/dev/null && success "Running watcher process killed." || info "No running watcher found."

# Clean up state and generated files (keep logs)
rm -f "$ASSASSIN_DIR/scheduled_resume.txt"
rm -f "$ASSASSIN_DIR/last_reset_time.txt"
rm -f "$ASSASSIN_DIR/watcher.sh"
rm -f "$ASSASSIN_DIR/launcher.sh"
rm -f "$ASSASSIN_DIR/resume_prompt.txt"
rm -f "$ASSASSIN_DIR/relaunch.bat"
rm -f "$ASSASSIN_DIR/install_task.bat"

echo ""
success "claude-assassin uninstalled cleanly."
warn "Session state and logs preserved at: $ASSASSIN_DIR"
warn "To fully remove: rm -rf $ASSASSIN_DIR"
