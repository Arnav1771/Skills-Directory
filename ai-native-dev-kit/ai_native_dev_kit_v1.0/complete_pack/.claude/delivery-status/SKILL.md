---
name: delivery-status
description: >
  Generate a visual weekly delivery-status dashboard for a program by joining the
  Epics → Stories → Tasks inventory with assignments, schedule, generated artifacts, and
  review verdicts into a single RAG (red/amber/green) view. Read-only and project-agnostic —
  it discovers whatever planning and build artifacts a project happens to have and degrades
  gracefully when a source is missing, always naming the exact skill to run next to unlock
  more. Runs on demand ("run delivery-status", "status report", "where are we", "weekly
  status", "delivery pulse", "who is working on what") and is designed to be invoked
  automatically once a week by an OS scheduler. Produces one self-contained
  status-dashboard.html (the only human-facing output — no markdown) plus a small internal
  status-history.json snapshot so it can report week-over-week deltas: new tasks added,
  completed this week, status changes, and overdue items. Never mutates specs, artifacts,
  or source code.
---

# Delivery Status (weekly pulse dashboard)

A **read-only** reporting skill. It answers one question for a whole program at a glance:
*for every Epic → Story → Task, is it done, who owns it, and — if it isn't done — when is
it scheduled for?* It never writes to specs, artifacts, or code; it only reads them and
emits a dashboard.

It is **project-agnostic**: it discovers whatever a project has rather than assuming a fixed
schema, so the same skill runs on any AAxon program regardless of naming, cluster scheme, or
which phase the program is currently in.

---

## Activation

Trigger on any of:
- `run delivery-status` / `delivery status` / `delivery pulse`
- `status report` / `weekly status` / `where are we` / `what's the status`
- `who is working on what` / `who owns what`
- an automated weekly invocation from an OS scheduler (see **Weekly scheduling** below)

---

## Control flow

```
preflight ─▶ read the 5 sources ─▶ normalize (discover structure) ─▶
  load last week's snapshot ─▶ compute RAG + week-over-week deltas ─▶
  render status-dashboard.html ─▶ save status-history.json
```

Every step is read-only except the two files this skill writes in `artifacts/`.

---

## Inputs (the five references)

Only the first is required. Everything else is optional — a missing source greys out the
columns it feeds and adds a line to the coverage banner naming the skill that produces it.

| # | Source | Feeds | Produced by | If missing |
|---|--------|-------|-------------|------------|
| 1 | `specs/tasks.md` (+ `specs/spec.md`) | Epic → Story → Task inventory | `spec-generation` | **Hard stop** — nothing to report |
| 2 | `artifacts/task-breakdown.yaml` | builder assignment, effort, cluster mapping | `SpecFlow` | no builder / effort |
| 3 | `artifacts/sprint-board.md` | **person** owner, status, ETA / schedule, dependencies | `Conductor` | no owner, no schedule |
| 4 | `artifacts/ai-manifest.json` (+ `src/**` provenance headers) | which artifacts were generated per task | `DevCopilot` / `NexusDeploy` | generation = unknown |
| 5 | `artifacts/review-verdict.yaml` | review pass/fail (🟢 vs 🟡) | `ReviewPilot` | items capped at 🟡 |

Do not assume these exact filenames are the only possibilities. If a project uses a
differently named board or manifest, look for the closest match by content (a markdown
table with assignee/status/ETA columns; a JSON/YAML artifact manifest) before giving up.

---

## Preflight and the readiness ladder

Run one **hard gate**, then attach a **coverage banner** describing how complete the picture
is. This lets the skill run usefully at any point in the program's life instead of only at
the end.

**Hard gate (Level 0):** if no task inventory (`specs/tasks.md` / `specs/spec.md`) can be
found, do **not** render a dashboard. Stop and print:

> **Can't produce a status dashboard yet — no task inventory found.**
> Run **`spec-generation`** first (the final step of Phase 1, `01-establish-strategy.md`,
> Prompt 14). It produces `specs/spec.md` and `specs/tasks.md` (your Epics → Stories → Tasks),
> which this skill needs before it can report anything.

**Coverage ladder (Levels 1–4):** determine the highest level whose inputs are present and
surface it in the banner.

| Level | Inputs present | Dashboard shows | Banner names next skill |
|-------|----------------|-----------------|-------------------------|
| 1 | inventory only | full backlog tree, every item ⚪ Not Started, no owner/schedule/progress | *Run `SpecFlow` then `Conductor` to add assignments & schedule.* |
| 2 | + `task-breakdown.yaml` | + builder + effort | *Run `Conductor` for owners & schedule.* |
| 3 | + `sprint-board.md` | + **person** owner, status, ETA/schedule; "if not built, when scheduled" works | *Run `DevCopilot` / `ReviewPilot` to unlock build status.* |
| 4 | + `ai-manifest.json` + `review-verdict.yaml` | **full RAG** — green / amber / not-started | *Full status available.* |

The banner is always shown, e.g.:
`Level 3 of 4 — assignments & schedule loaded; build status pending (run DevCopilot). 0/42 tasks generated.`

---

## Normalizing (discover, don't assume)

Build one flat, normalized model from whatever was found. This is the only contract the
renderer depends on, so parsing stays flexible while output stays consistent.

For each task, resolve these fields (leave blank/unknown rather than inventing):

- `id`, `title`, and its parent `story` and `epic` (from the inventory headings/IDs)
- **`person`** — the human owner. Prefer a named person from the board's owner/assignee
  columns (e.g. an "Owner", "Assignee", or "Responsible" column, or an owner named in a
  human-led track row). This is required output whenever the board provides it — always
  surface the person's name, not just the bot.
- `builder` — the AI Builder assigned (e.g. from `task-breakdown.yaml` or the board's
  Builder column). Show alongside the person.
- `status` — see RAG rules below
- `generated` (bool) and `artifacts` (list of file paths) — from the manifest / provenance
- `reviewed` (pass / pending / fail) — from the review verdict
- `eta` — the scheduled date/'when' text from the board (kept **verbatim**, e.g. `Wed AM`,
  `2026-06-21`) — shown in the tree as "Scheduled for: …" on anything not yet done
- `startDate` / `endDate` — **normalized ISO dates** (`yyyy-mm-dd`) for the Gantt. Resolve
  the board's `eta` into a real `endDate`; derive `startDate` from effort/duration
  (`endDate − effort`) or the dependency wave when available. Omit both if no date can be
  resolved (that task simply won't appear on the Gantt). Never guess a date just to fill the
  chart — a blank is honest; a fabricated bar is misleading.
- `effort` — estimated hours (number) from `task-breakdown.yaml`. Shown inside the Gantt bar
  (e.g. `8h · Mon–Tue`) and in the Gantt's right-hand **Effort** column. Omit if unknown.

Also resolve a top-level **`gates`** list — the HITL gates (Gate 0 / 0.5 / 1 / 2 / 3) and their
scheduled dates from the board's gate queue (`sprint-board.md`). Each `{label, date}` renders
as an orange **flag marker** on the Gantt timeline, so the plan/build/deploy checkpoints line
up against the task bars exactly like the sprint dispatch view they come from.

Join key: map a task → its cluster/work-unit (via `task-breakdown.yaml`) → the board row
and manifest entries. When IDs don't line up cleanly, fall back to matching on the nearest
requirement/spec ID present in provenance headers and manifest entries.

---

## RAG rules

Per task:

- 🟢 **Green** — an artifact exists for it **and** its review verdict is a pass, with no
  open corrections.
- 🟡 **Amber** — an artifact exists but review is pending / failed / partial, **or** only
  some of the expected artifacts are present.
- ⚪ **Not started** — no artifact yet. Show its `person`, `builder`, and scheduled `eta`.
  If `eta` has passed and it isn't done, also flag it **overdue**.

If review data is entirely absent (Level 3), no task can be confirmed 🟢 — cap generated
items at 🟡 and say so in the banner.

**Rollup:** a Story's status is the rollup of its Tasks (`done/total`, worst-of colour); an
Epic is the rollup of its Stories. Show counts like `4/6` on every Story and Epic.

---

## Change detection & week-over-week deltas

Inputs change between runs. A new transcript added a week later — or any re-run of the
knowledge/spec phases — regenerates `specs/tasks.md`, which can **add new tasks, re-scope
existing ones, or remove some**. The skill catches all of this automatically by diffing
against the previous week's snapshot in `artifacts/status-history.json`. There is no manual
bookkeeping — the inventory itself is the signal.

**Per-task fingerprint.** For every task, the snapshot stores its `id`, `status`, `person`,
`etaDate`, and a **content fingerprint** — a hash of the task's definition (title +
description + acceptance criteria as written in `spec.md` / `tasks.md`). The fingerprint is
what makes *"the spec changed"* detectable even when the task ID stays the same. A new task
appears as a brand-new ID; a re-scoped task appears as a same-ID / changed-fingerprint.

**The green-lock rule (completed work is frozen).**
- A task that was 🟢 **green** last snapshot and is still green is **locked** — carried
  forward as done and **not** re-checked for spec/content changes. Shipped-and-reviewed work
  is not reopened by later upstream edits, so the report stays quiet about it.
- Tasks that are 🟡 **amber** or ⚪ **grey** are **live** — always re-fingerprinted and
  re-evaluated on every run for new updates: newly added tasks, re-scoped specs, changed
  owners / ETAs, new dependencies. This is exactly the "keep checking what isn't done yet"
  behaviour: only the unfinished and partially-done items are monitored for change.
- **Safety valve:** if a *green* task's underlying spec is later edited materially, do **not**
  reopen it, but surface one advisory line — *"completed task TSK-x had its spec change after
  completion — confirm it still holds"*. This honours the lock while flagging the single case
  where a silent freeze could hide a real regression.

**Each run:**
1. Load `status-history.json` (ordered list of weekly snapshots). No file → first run; deltas
   are the baseline.
2. Diff the current model against the most recent snapshot:
   - **new tasks** — IDs present now, absent before *(this is how a new transcript's tasks surface)*
   - **completed this week** — moved to 🟢 since last snapshot
   - **updated** — a **live** (non-green) task whose status, owner, ETA, or **fingerprint**
     (spec/scope) changed → flagged `changed`
   - **removed / descoped** — IDs in the snapshot but gone now (noted, never silently dropped)
   - **overdue** — past ETA and not 🟢
   - green-locked tasks are skipped in change checks (except the safety-valve advisory)
3. Append the current snapshot and save.

Snapshot shape (compact — state only, never artifact bodies):
```json
{ "week": "2026-07-08", "totals": { "done": 5, "total": 10 },
  "tasks": { "TSK-006": { "status": "green", "person": "Priya Mehta",
                          "etaDate": "2026-07-02", "fp": "a1b2c3" } } }
```

`status-history.json` is **internal machine state, not a report** — it exists only so the
deltas and the green-lock survive between weekly runs. It is the one non-HTML file this
skill maintains.

---

## Rendering the dashboard

Populate `references/dashboard-template.html` and write the result to
`artifacts/status-dashboard.html`.

The template is a self-contained mini-app. Replace the object **between the
`/*DATA-START*/` and `/*DATA-END*/` markers** with the live data object (keep the markers so
the next run can find and replace it again). The template's own JS then renders everything
from that data — the KPI row, the "This Week" panel, the **Gantt schedule**, the **"Next Week"
look-ahead**, and the collapsible Epic → Story → Task tree — and wires the status / owner /
epic filters. You only produce the data; the template guarantees a consistent, AA-styled look
every week.

The **"Next Week"** panel is derived automatically from the task schedule (no extra data
needed): tasks **starting** or **due** within the 7 days after the report date, work
**carrying over** (in-progress), and anything **at risk** (overdue). It mirrors the "This
Week" card layout but looks forward instead of back.

- Replace only the marked `DATA` object; nothing else in the template needs editing — all
  copy, colours, level tags, and the Gantt are data-driven.
- The Gantt uses each task's `startDate` / `endDate`; tasks without resolved dates are simply
  omitted from the chart (and the Gantt shows a "no scheduled dates yet" note if none have them).

---

## Outputs

Written to `artifacts/` (both overwritten each run):

- **`artifacts/status-dashboard.html`** — the single human-facing deliverable. Self-contained,
  AA-styled, works offline in any browser. No markdown report is produced by design.
- **`artifacts/status-history.json`** — internal weekly snapshot log for deltas (not a report).

---

## Weekly scheduling

This skill does not wake itself up — an OS scheduler invokes it once a week. See
`references/schedule-setup.md` for the ready-to-paste **Windows Task Scheduler** command
(and the `cron` equivalent) that runs Claude Code headless weekly:

```
claude -p "run delivery-status"
```

The dashboard shows a **"last run"** stamp and, when a run is overdue relative to the weekly
cadence, a gentle nudge — so even the on-demand path tells you if the weekly pulse has lapsed.

---

## Constraints

- **Read-only.** Never edits specs, artifacts, source, or the board. Writes only
  `status-dashboard.html` and `status-history.json` under `artifacts/`.
- **No markdown report.** The dashboard is the deliverable; markdown is intentionally omitted.
- **Never invents data.** Missing owner/schedule/review stays blank and is reflected in the
  coverage banner, not guessed.
- **Project-agnostic.** No hard-coded cluster IDs, person names, or column names — everything
  is discovered per run.
- **Accuracy over completeness.** If sources disagree (e.g. manifest says generated but no
  provenance in `src/`), show the more conservative status and note the conflict.
