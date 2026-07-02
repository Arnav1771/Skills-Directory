#!/usr/bin/env bash
# ============================================================
# claude-assassin: install_daemon.sh
# One-time installer for the silent session-resume daemon.
# Supports: Windows (Task Scheduler), Linux (systemd --user),
#           macOS (launchd), WSL (cron fallback)
# ============================================================

set -euo pipefail

ASSASSIN_DIR="$HOME/.claude/assassin"
SKILL_DIR="$HOME/.claude/skills/claude-assassin/scripts"
LOG="$ASSASSIN_DIR/assassin.log"
OS="$(uname -s)"

# ── Colours ──────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; NC='\033[0m'

info()    { echo -e "${CYAN}[assassin]${NC} $*"; }
success() { echo -e "${GREEN}[assassin]${NC} $*"; }
warn()    { echo -e "${YELLOW}[assassin]${NC} $*"; }
error()   { echo -e "${RED}[assassin]${NC} $*"; exit 1; }

# ── OS helpers ───────────────────────────────────────────────
is_wsl()     { grep -qi microsoft /proc/version 2>/dev/null; }
is_windows() { [[ "$OS" == MINGW* ]] || [[ "$OS" == CYGWIN* ]]; }

# ── Pre-flight ────────────────────────────────────────────────
info "Detected OS: $OS"
mkdir -p "$ASSASSIN_DIR"
touch "$LOG"

if ! command -v claude &>/dev/null; then
  error "Claude Code CLI not found. Install it first: npm install -g @anthropic-ai/claude-code"
fi

# ── Write the watcher script ──────────────────────────────────
# This is what the daemon actually runs — it watches for a scheduled
# resume time and relaunches Claude Code when it arrives.

cat > "$ASSASSIN_DIR/watcher.sh" << 'WATCHER'
#!/usr/bin/env bash
# claude-assassin watcher — runs silently as a daemon

ASSASSIN_DIR="$HOME/.claude/assassin"
STATE_FILE="$ASSASSIN_DIR/session_state.md"
LOG="$ASSASSIN_DIR/assassin.log"
SCHEDULED_FILE="$ASSASSIN_DIR/scheduled_resume.txt"
PROMPT_FILE="$ASSASSIN_DIR/resume_prompt.txt"
LAUNCHER="$ASSASSIN_DIR/launcher.sh"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG"; }

log "Watcher started (PID $$)"

while true; do
  if [[ -f "$SCHEDULED_FILE" ]]; then
    TARGET_EPOCH=$(cat "$SCHEDULED_FILE")
    NOW_EPOCH=$(date +%s)

    if [[ "$NOW_EPOCH" -ge "$TARGET_EPOCH" ]]; then
      log "Resume time reached. Relaunching Claude Code..."
      rm -f "$SCHEDULED_FILE"

      # Build resume prompt from saved state
      if [[ -f "$STATE_FILE" ]]; then
        RESUME_PROMPT="Session resumed automatically by claude-assassin. Resume the following task exactly where it left off:"$'\n\n'"$(cat "$STATE_FILE")"
      else
        RESUME_PROMPT="Session resumed automatically by claude-assassin. No saved state found — please check what was last being worked on."
      fi

      # Write prompt to file — avoids shell quoting issues with apostrophes/special chars
      printf '%s' "$RESUME_PROMPT" > "$PROMPT_FILE"

      # Write a launcher script that reads from the prompt file at runtime
      cat > "$LAUNCHER" << 'LAUNCH_EOF'
#!/usr/bin/env bash
claude "$(cat "$HOME/.claude/assassin/resume_prompt.txt")"
exec bash
LAUNCH_EOF
      chmod +x "$LAUNCHER"

      log "Launching Claude Code in new terminal..."

      OS_TYPE="$(uname -s)"

      if [[ "$OS_TYPE" == MINGW* ]] || [[ "$OS_TYPE" == CYGWIN* ]]; then
        # Use mintty — Git Bash's own terminal emulator. This completely bypasses
        # wt.exe and its default profile selection (which defaults to WSL on many systems).
        # mintty is always available with Git for Windows and always opens Git Bash.
        if command -v mintty &>/dev/null; then
          mintty -e bash --login "$LAUNCHER" &
          log "Launched via mintty (Git Bash terminal)"
        else
          # Fallback: no mintty, try running launcher directly in background
          bash "$LAUNCHER" >> "$LOG" 2>&1 &
          log "Launched Claude Code in background (PID $!)"
        fi
      elif command -v osascript &>/dev/null; then
        # macOS
        osascript -e "tell application \"Terminal\" to do script \"bash '$LAUNCHER'\"" &
        log "Launched via macOS Terminal (osascript)"
      elif command -v gnome-terminal &>/dev/null; then
        gnome-terminal -- bash "$LAUNCHER" &
        log "Launched via gnome-terminal"
      elif command -v xterm &>/dev/null; then
        xterm -e bash "$LAUNCHER" &
        log "Launched via xterm"
      elif command -v tmux &>/dev/null; then
        tmux new-session -d -s "claude-resume" "bash '$LAUNCHER'"
        log "Launched in new tmux session: claude-resume"
      else
        bash "$LAUNCHER" >> "$LOG" 2>&1 &
        log "Launched Claude Code in background (PID $!)"
      fi

      log "Claude Code relaunch complete."
    fi
  fi

  sleep 30
done
WATCHER

chmod +x "$ASSASSIN_DIR/watcher.sh"
info "Watcher script written to $ASSASSIN_DIR/watcher.sh"

# ── Install daemon by OS ──────────────────────────────────────

install_windows_startup() {
  info "Installing via Windows Startup folder (no admin required)..."

  # Get the user Startup folder path via PowerShell
  STARTUP_WIN=$(powershell.exe -NoProfile -Command '[Environment]::GetFolderPath("Startup")' 2>/dev/null | tr -d '\r\n')
  if [[ -z "$STARTUP_WIN" ]]; then
    error "Could not determine Windows Startup folder path."
  fi

  STARTUP_DIR=$(cygpath -u "$STARTUP_WIN")
  VBS_FILE="$STARTUP_DIR/claude_assassin.vbs"

  # Resolve the ABSOLUTE path to *this* (Git) bash. A bare "bash.exe" launched by
  # Windows resolves against the system PATH, where C:\Windows\System32\bash.exe
  # (the WSL launcher) usually wins — its $HOME is the WSL home, so
  # ~/.claude/assassin/watcher.sh does not exist there and the daemon never starts.
  # Embedding the full Git Bash path guarantees the right interpreter and $HOME.
  BASH_WIN=$(cygpath -w "$(command -v bash)")

  # VBScript runs bash silently (window style 0 = hidden, no cmd window flashing).
  # Path is double-quoted inside the Run string in case it contains spaces.
  cat > "$VBS_FILE" << VBS
Dim WshShell
Set WshShell = WScript.CreateObject("WScript.Shell")
WshShell.Run """$BASH_WIN"" --login -c ""~/.claude/assassin/watcher.sh""", 0, False
Set WshShell = Nothing
VBS

  success "Startup script written: $VBS_FILE"
  info "Watcher will auto-start silently at every Windows login."

  # Start watcher NOW for this session (doesn't wait for reboot)
  nohup "$ASSASSIN_DIR/watcher.sh" >> "$LOG" 2>&1 &
  WATCHER_PID=$!
  success "Watcher started for this session (PID $WATCHER_PID)"
  success "Check status: bash ~/.claude/skills/claude-assassin/scripts/status.sh"
}

install_systemd() {
  info "Installing systemd user service..."

  SYSTEMD_DIR="$HOME/.config/systemd/user"
  mkdir -p "$SYSTEMD_DIR"

  cat > "$SYSTEMD_DIR/claude-assassin.service" << SERVICE
[Unit]
Description=Claude Assassin — Silent Session Resume Daemon
After=network.target

[Service]
Type=simple
ExecStart=$ASSASSIN_DIR/watcher.sh
Restart=always
RestartSec=10
StandardOutput=append:$LOG
StandardError=append:$LOG

[Install]
WantedBy=default.target
SERVICE

  systemctl --user daemon-reload
  systemctl --user enable claude-assassin.service
  systemctl --user start claude-assassin.service

  success "Systemd service installed and started."
  success "Check status: systemctl --user status claude-assassin"
}

install_launchd() {
  info "Installing launchd agent (macOS)..."

  PLIST_DIR="$HOME/Library/LaunchAgents"
  mkdir -p "$PLIST_DIR"

  cat > "$PLIST_DIR/com.claude.assassin.plist" << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.claude.assassin</string>
  <key>ProgramArguments</key>
  <array>
    <string>$ASSASSIN_DIR/watcher.sh</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <true/>
  <key>StandardOutPath</key>
  <string>$LOG</string>
  <key>StandardErrorPath</key>
  <string>$LOG</string>
</dict>
</plist>
PLIST

  launchctl load "$PLIST_DIR/com.claude.assassin.plist"
  success "LaunchAgent installed and loaded."
  success "Check status: launchctl list | grep claude-assassin"
}

install_cron_fallback() {
  warn "No systemd or launchd found. Installing via cron (WSL/minimal Linux)..."

  CRON_LINE="@reboot $ASSASSIN_DIR/watcher.sh >> $LOG 2>&1"

  if crontab -l 2>/dev/null | grep -q "claude-assassin\|watcher.sh"; then
    warn "Cron entry already exists. Skipping."
  else
    (crontab -l 2>/dev/null; echo "$CRON_LINE") | crontab -
    success "Cron entry added (@reboot)."
  fi

  nohup "$ASSASSIN_DIR/watcher.sh" >> "$LOG" 2>&1 &
  success "Watcher started in background (PID $!)"
  success "Check logs: tail -f $LOG"
}

# ── Route to correct installer ────────────────────────────────
if is_windows; then
  install_windows_startup
elif is_wsl; then
  warn "WSL detected"
  if systemctl --user status &>/dev/null 2>&1; then
    install_systemd
  else
    install_cron_fallback
  fi
elif [[ "$OS" == "Linux" ]]; then
  install_systemd
elif [[ "$OS" == "Darwin" ]]; then
  install_launchd
else
  warn "Unknown OS ($OS) — falling back to cron"
  install_cron_fallback
fi

# ── Final summary ─────────────────────────────────────────────
echo ""
success "══════════════════════════════════════════"
success "  claude-assassin installed successfully  "
success "══════════════════════════════════════════"
echo ""
info "The daemon is now running silently in the background."
info "When session limit hits, run:"
echo ""
echo "  bash ~/.claude/skills/claude-assassin/scripts/save_state.sh 'your task description'"
echo "  bash ~/.claude/skills/claude-assassin/scripts/schedule_resume.sh '4:50pm'"
echo ""
info "Logs: tail -f $LOG"
