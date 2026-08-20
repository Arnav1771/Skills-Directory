# delivery-status

A **read-only** skill that turns a program's Epics → Stories → Tasks inventory into a single
visual weekly dashboard: what's done, who owns what, what's scheduled, and what's changed
since last week. It never edits specs, artifacts, or code — it only reads them and renders a
dashboard.

It is **project-agnostic**: it discovers whatever planning/build artifacts a project actually
has and degrades gracefully when something's missing, always naming the next skill to run to
unlock more detail.

See [`SKILL.md`](SKILL.md) for the full behavior spec (preflight ladder, RAG rules, change
detection). This README is the practical "how do I actually run this" guide.

---

## What it produces

Two files, written to `artifacts/` in your project, overwritten on every run:

| File | What it is |
|---|---|
| `artifacts/status-dashboard.html` | The dashboard. Self-contained, opens in any browser, no server needed. **This is the only human-facing output.** |
| `artifacts/status-history.json` | Internal snapshot log (not a report) so the dashboard can show week-over-week deltas. Leave it alone. |

The dashboard shows, top to bottom: an overview KPI row, **This Week** (new / completed /
updated / overdue), **Next Week** (starting / due / carrying over / at risk), a **Gantt**
schedule with effort and HITL gate markers, and the full filterable Epic → Story → Task tree
with person-level ownership.

---

## Run it on demand

From your project root, in Claude Code, type any of:

```
run delivery-status
status report
where are we
weekly status
```

Then open `artifacts/status-dashboard.html` in a browser.

### Minimum to get anything at all

The one hard requirement is `specs/tasks.md` (produced by `spec-generation`, end of Phase 1).
Without it, the skill stops and tells you to run `spec-generation` first — it never renders
an empty or fabricated dashboard.

Everything else is optional and additive — a coverage banner at the top of the dashboard
always says how complete the picture is and which skill to run next:

| You have | You get | Run next for more |
|---|---|---|
| `specs/tasks.md` only | Full backlog tree, everything ⚪ Not Started | `SpecFlow` → `Conductor` |
| + `task-breakdown.yaml` | + builder assignment + effort | `Conductor` |
| + `sprint-board.md` | + human owner, schedule, Gantt, gate markers | `DevCopilot` / `ReviewPilot` |
| + `ai-manifest.json` + `review-verdict.yaml` | Full green/amber/grey status | — nothing left to unlock |

---

## Set it up for automatic weekly runs

The skill can't wake itself up — an OS scheduler has to invoke it once a week. This is a
one-time setup per machine/project.

The command it runs is always:
```
claude -p "run delivery-status"
```
executed from your **project root** (so it can find `specs/` and `artifacts/`).

### Windows (Task Scheduler) — recommended

Open PowerShell and run once (example: every Monday at 09:00):

```powershell
$proj = "C:\path\to\your-project"
schtasks /create `
  /tn "Automation30\Delivery Status Weekly" `
  /tr "cmd /c cd /d `"$proj`" && claude -p `"run delivery-status`"" `
  /sc weekly /d MON /st 09:00 /f
```

Check it registered, and test-fire it immediately:

```powershell
schtasks /query /tn "Automation30\Delivery Status Weekly"
schtasks /run   /tn "Automation30\Delivery Status Weekly"
```

Remove it later if needed:

```powershell
schtasks /delete /tn "Automation30\Delivery Status Weekly" /f
```

**Notes**
- Replace `C:\path\to\your-project` with your real project path.
- Pick whatever day/time suits your team (`/d FRI /st 17:00` for Friday EOD, etc.).
- The task runs as your logged-in user; `claude` must be on that user's PATH.
- To run even when logged out, recreate the task with `/ru <user> /rp <password>`, or use the
  Task Scheduler GUI → "Run whether user is logged on or not".

### macOS / Linux (cron)

```bash
crontab -e
```

Add (example: every Monday at 09:00):

```cron
0 9 * * 1 cd /path/to/your-project && /usr/local/bin/claude -p "run delivery-status" >> /path/to/your-project/artifacts/status-cron.log 2>&1
```

Use the full path to `claude` (find it with `which claude`) — cron runs with a minimal PATH.

### What a scheduled run actually does

1. Runs preflight — if `specs/tasks.md` is missing, it logs the "run spec-generation first"
   message and exits without touching `artifacts/`.
2. Reads whatever sources are available and computes RAG status + week-over-week deltas
   against `artifacts/status-history.json`.
3. Overwrites `artifacts/status-dashboard.html` with the new week's dashboard.
4. Appends this week's snapshot to `artifacts/status-history.json`.

The dashboard shows a **"last run"** stamp, and flags itself as overdue if a scheduled run
was missed — so even the on-demand path tells you if the weekly pulse has lapsed.

More detail on the scheduling mechanics: [`references/schedule-setup.md`](references/schedule-setup.md).

---

## FAQ

**Does it ever modify my specs, tasks, or code?**
No. It's read-only. The only files it ever writes are the two under `artifacts/` listed above.

**A teammate added a new transcript / re-ran spec-generation a week later — does it catch the new tasks?**
Yes, automatically. Every run re-diffs the task inventory. New tasks show up as "new this
week." Tasks that are already 🟢 green (done + reviewed) are locked and skipped for change
re-checks; only unfinished (🟡/⚪) tasks are re-evaluated for spec/scope changes each run —
so completed work doesn't get silently reopened by unrelated upstream edits.

**Can I run it more than once a week?**
Yes — on-demand runs are always fine. The weekly scheduled run is the mandatory minimum
cadence, not a limit.

**No markdown report?**
Correct, by design — the HTML dashboard is the single deliverable.
