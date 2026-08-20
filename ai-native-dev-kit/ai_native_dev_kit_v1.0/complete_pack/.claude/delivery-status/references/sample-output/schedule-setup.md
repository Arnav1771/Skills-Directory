# Weekly scheduling — `delivery-status`

The skill does not wake itself up. To get the mandatory **weekly** dashboard, register a
one-time OS scheduler job that invokes Claude Code headless once a week. It stays completely
hands-off after that; the skill is read-only, so a scheduled run can never damage anything.

The command the scheduler runs is always the same:

```
claude -p "run delivery-status"
```

Run it from the **project root** (the folder that contains `specs/` and `artifacts/`) so the
skill finds the sources. Replace `C:\path\to\project` / `/path/to/project` below with the
real path.

---

## Windows (Task Scheduler) — recommended for this environment

Open **PowerShell** and run once (weekly, Monday 09:00):

```powershell
$proj = "C:\path\to\project"
schtasks /create `
  /tn "Automation30\Delivery Status Weekly" `
  /tr "cmd /c cd /d `"$proj`" && claude -p `"run delivery-status`"" `
  /sc weekly /d MON /st 09:00 /f
```

Verify / run it immediately to test:

```powershell
schtasks /query /tn "Automation30\Delivery Status Weekly"
schtasks /run   /tn "Automation30\Delivery Status Weekly"
```

Remove it later with:

```powershell
schtasks /delete /tn "Automation30\Delivery Status Weekly" /f
```

> Notes
> - The task runs as the logged-in user; `claude` must be on that user's PATH.
> - To run even when not logged in, recreate the task with `/ru <user> /rp <password>` (or via
>   the Task Scheduler GUI → "Run whether user is logged on or not").
> - Pick the day/time that matches when you want the weekly pulse (e.g. Friday EOD `/d FRI /st 17:00`).

---

## macOS / Linux (cron)

```bash
crontab -e
```

Add (weekly, Monday 09:00):

```cron
0 9 * * 1 cd /path/to/project && /usr/local/bin/claude -p "run delivery-status" >> /path/to/project/artifacts/status-cron.log 2>&1
```

Use the full path to `claude` (`which claude`) — cron has a minimal PATH.

---

## What a scheduled run does

1. Runs the preflight (needs `specs/tasks.md`; otherwise logs the "run spec-generation first" message and exits without writing a dashboard).
2. Reads the available sources, computes the RAG view and the week-over-week deltas against `artifacts/status-history.json`.
3. Overwrites `artifacts/status-dashboard.html` with the new week's dashboard.
4. Appends this week's snapshot to `artifacts/status-history.json`.

Open `artifacts/status-dashboard.html` in any browser to view it. Because the run is weekly,
the dashboard also carries a **"last run"** stamp and shows an overdue nudge if a scheduled
run was missed.
