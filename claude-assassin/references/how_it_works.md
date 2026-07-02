# How Claude Assassin Works — Technical Architecture

## The Core Problem

Claude Code enforces a per-session rate limit (~5 hours). When hit:
- Claude Code exits
- All in-memory context is lost
- No built-in mechanism to resume

## The Solution: OS-Level Daemon

A skill cannot run in the background — but **a system process can**.

Claude Assassin installs a lightweight background process at the OS level (systemd / launchd / cron). This process:
1. Runs independently of Claude Code
2. Polls every 30 seconds for a scheduled resume time
3. Relaunches Claude Code when the timer fires
4. Passes the saved state as the opening prompt

## Component Map

```
claude-assassin/
│
├── SKILL.md                    ← Claude reads this, triggers the workflow
│
├── scripts/
│   ├── install_daemon.sh       ← One-time: installs OS-level watcher
│   ├── save_state.sh           ← Run before session dies: saves task to file
│   ├── schedule_resume.sh      ← Parses reset time, writes epoch to file
│   ├── status.sh               ← Check daemon + schedule status
│   └── uninstall_daemon.sh     ← Clean removal
│
└── ~/.claude/assassin/         ← Runtime directory (created on install)
    ├── watcher.sh              ← The actual daemon process
    ├── session_state.md        ← Saved task state
    ├── scheduled_resume.txt    ← Epoch timestamp for resume
    ├── last_reset_time.txt     ← Human-readable reset time
    └── assassin.log            ← Activity log
```

## Sequence Diagram

```
[Claude Code Running]
        │
        │ ← Session limit hit
        ▼
[Claude reads SKILL.md]
        │
        ├─→ save_state.sh "current task"
        │         │
        │         └─→ writes ~/.claude/assassin/session_state.md
        │
        ├─→ schedule_resume.sh "4:50pm"
        │         │
        │         └─→ converts to epoch
        │         └─→ writes ~/.claude/assassin/scheduled_resume.txt
        │
        ▼
[Claude Code exits]

[OS Daemon (watcher.sh) — always running]
        │
        │ (polls every 30s)
        │
        │ epoch reached?
        │   YES ──────────────────────────────────────────────┐
        │                                                      ▼
        │                                           [reads session_state.md]
        │                                           [launches: claude "resume..."]
        │                                                      │
        │                                                      ▼
        │                                           [Claude Code starts]
        │                                           [resumes task from state]
        │   NO → sleep 30s → poll again
```

## Daemon Installation by OS

| OS | Method | File Location |
|----|--------|--------------|
| Linux | systemd --user | `~/.config/systemd/user/claude-assassin.service` |
| macOS | launchd | `~/Library/LaunchAgents/com.claude.assassin.plist` |
| WSL | cron @reboot | crontab entry |
| WSL (systemd enabled) | systemd --user | same as Linux |

## Terminal Launch Strategy

When relaunching Claude Code, the daemon tries (in order):
1. `gnome-terminal` — standard Linux desktop
2. `wt.exe` — Windows Terminal (WSL)
3. `tmux` new session — headless/SSH environments
4. Background process — absolute fallback

## Security Notes

- No network calls — all local
- No elevated permissions required (`--user` systemd service)
- State file contains only task description + working directory
- Watcher runs as the current user only
