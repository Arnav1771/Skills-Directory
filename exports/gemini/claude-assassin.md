<!-- skills-directory:claude-assassin START -->
## Skill: claude-assassin

> **Skill: `claude-assassin`.** Silent background daemon that automatically resumes Claude Code sessions after session limits reset. Use this skill immediately when you see "You've hit your session limit", "resets at", "session limit reached", or "/usage-credits" in the terminal. Also triggers on first run to install the daemon silently. Once installed, it works entirely behind the scenes — saving task state before Claude Code exits and relaunching automatically when the reset timer expires. Install once, works forever org-wide.
>
> **Activate** this skill when the user's request matches it — for example when they say: "session limit", "resets at", "/usage-credits". When active, follow the instructions below precisely; otherwise ignore them.
>
> Ported from [Arnav1771/Skills-Directory](https://github.com/Arnav1771/Skills-Directory/blob/main/claude-assassin/SKILL.md) — the full folder (references, scripts) lives there.

# Claude Assassin — Silent Session Resume Daemon

A silent background process that installs itself once and forever handles Claude Code session limits automatically. When the session limit hits, it saves your task state and relaunches Claude Code the moment the reset timer expires.

---

## On First Run — Install the Daemon

If the daemon is not yet installed, run this immediately:

```bash
bash ~/.claude/skills/claude-assassin/scripts/install_daemon.sh
```

This is a one-time setup. After this, everything is automatic.

---

## When Session Limit Is Detected

If you see "You've hit your session limit · resets X:XXpm", immediately:

### Step 1: Save current task state
```bash
bash ~/.claude/skills/claude-assassin/scripts/save_state.sh "DESCRIBE_CURRENT_TASK_HERE"
```

### Step 2: Schedule the resume
```bash
bash ~/.claude/skills/claude-assassin/scripts/schedule_resume.sh "X:XXpm"
```

Replace `X:XXpm` with the exact reset time shown in the terminal.

That's it. Claude Code will relaunch automatically at the reset time and resume from where it left off.

---

## How It Works

```
Session limit hit
      ↓
Claude saves task state → ~/.claude/assassin/session_state.md
      ↓
schedule_resume.sh parses reset time → schedules system job
      ↓
Claude Code exits
      ↓
[Background daemon waits silently]
      ↓
Reset time arrives → daemon relaunches Claude Code
      ↓
Claude reads session_state.md → resumes task automatically
```

---

## Files Created on Your System

| Path | Purpose |
|------|---------|
| `~/.claude/assassin/session_state.md` | Saved task state |
| `~/.claude/assassin/assassin.log` | Daemon activity log |
| `~/.claude/assassin/last_reset_time.txt` | Parsed reset time |
| `~/.config/systemd/user/claude-assassin.service` | Linux daemon (systemd) |
| `~/Library/LaunchAgents/com.claude.assassin.plist` | macOS daemon (launchd) |
| `%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\claude_assassin.vbs` | Windows auto-start (no admin needed) |

---

## Checking Daemon Status

```bash
# Windows (Git Bash)
bash ~/.claude/skills/claude-assassin/scripts/status.sh

# Linux
systemctl --user status claude-assassin

# macOS
launchctl list | grep claude-assassin

# View logs (all platforms)
tail -f ~/.claude/assassin/assassin.log
```

## Uninstalling

```bash
bash ~/.claude/skills/claude-assassin/scripts/uninstall_daemon.sh
```

---

## Reference Files

- `references/how_it_works.md` — Full technical architecture
- `references/troubleshooting.md` — Common issues and fixes
<!-- skills-directory:claude-assassin END -->
