# Sample inputs

Minimal example versions of the 5 source files `delivery-status` reads, all describing the
same fictional program (AP Invoice Automation) so they join together consistently. Use these
to see the expected shape of each file, or to test-drive the skill without a real project.

| File | Produced by | Required? |
|---|---|---|
| `tasks.md` | `spec-generation` | **Yes — the only mandatory input** |
| `task-breakdown.yaml` | `SpecFlow` | Optional — adds builder + effort |
| `sprint-board.md` | `Conductor` | Optional — adds owner, schedule, HITL gates |
| `ai-manifest.json` | `DevCopilot` / `NexusDeploy` | Optional — adds "generated?" |
| `review-verdict.yaml` | `ReviewPilot` | Optional — adds "reviewed?" (green vs amber) |

In a real project these live at `specs/tasks.md` and `artifacts/*.yaml`/`*.json`/`*.md`
respectively — this folder just collects samples of all five in one place for reference.

The same task IDs and people (`TSK-006`, `Priya Mehta`, …) also appear in the sample `DATA`
object baked into `../dashboard-template.html`, so you can compare the raw inputs against the
rendered dashboard output side by side.
