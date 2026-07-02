# Claude Assassin — Troubleshooting

## Daemon Not Starting

### Linux: systemd not available
**Symptom:** `systemctl: command not found` or `Failed to connect to bus`

**Fix:** The installer will auto-fallback to cron. Or manually:
```bash
nohup ~/.claude/assassin/watcher.sh >> ~/.claude/assassin/assassin.log 2>&1 &
```

### WSL: systemd not enabled
**Symptom:** Systemd errors in WSL

**Fix:** Either enable systemd in WSL2 (`/etc/wsl.conf` → `[boot] systemd=true`) or use the cron fallback which installs automatically.

### macOS: Permission denied loading plist
**Fix:**
```bash
chmod 644 ~/Library/LaunchAgents/com.claude.assassin.plist
launchctl load ~/Library/LaunchAgents/com.claude.assassin.plist
```

---

## Resume Not Triggering

### Watcher not running
**Check:**
```bash
bash ~/.claude/skills/claude-assassin/scripts/status.sh
```

**Fix:** Restart the daemon:
```bash
# Linux
systemctl --user restart claude-assassin

# macOS
launchctl unload ~/Library/LaunchAgents/com.claude.assassin.plist
launchctl load ~/Library/LaunchAgents/com.claude.assassin.plist

# Manual
nohup ~/.claude/assassin/watcher.sh &
```

### scheduled_resume.txt not found
**Cause:** `schedule_resume.sh` was not run after saving state.

**Fix:**
```bash
bash ~/.claude/skills/claude-assassin/scripts/schedule_resume.sh "4:50pm"
```

### Time parsing failed
**Symptom:** `Could not parse a time from: ...`

**Fix:** Use explicit format:
```bash
bash schedule_resume.sh "4:50pm"   # 12hr with am/pm ✅
bash schedule_resume.sh "16:50"    # 24hr ✅
bash schedule_resume.sh "4:50 PM"  # with space — strip the space ✅
```

---

## Claude Code Not Relaunching

### No terminal emulator found
**Symptom:** Claude relaunches but no window opens

**Fix:** Install tmux (works everywhere including SSH/WSL):
```bash
sudo apt install tmux   # Ubuntu/Debian/WSL
brew install tmux       # macOS
```

The watcher will use tmux automatically and create a new session named `claude-resume-<timestamp>`.

Attach to it with:
```bash
tmux attach -t $(tmux ls | grep claude-resume | tail -1 | cut -d: -f1)
```

### claude CLI not in PATH for daemon
**Symptom:** Daemon fires but `claude: command not found`

**Fix:** Add claude to a PATH the daemon can see:
```bash
# Find claude
which claude

# Add to watcher explicitly
echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >> ~/.bashrc
```

Or edit `~/.claude/assassin/watcher.sh` and hardcode the claude path.

---

## Checking Logs

```bash
# Live log
tail -f ~/.claude/assassin/assassin.log

# Last 20 lines
tail -20 ~/.claude/assassin/assassin.log

# Filter for errors
grep -i "error\|fail" ~/.claude/assassin/assassin.log
```

---

## Full Reset

```bash
# Uninstall
bash ~/.claude/skills/claude-assassin/scripts/uninstall_daemon.sh

# Reinstall clean
rm -rf ~/.claude/assassin
bash ~/.claude/skills/claude-assassin/scripts/install_daemon.sh
```
