# SKILL.md — Canonical Template (AAxon Operate Phase v2.1.0)

> Copy this template for every new Operate-phase skill.
> All sections marked [REQUIRED] must be completed. [OPTIONAL] sections are situational.

---

## [REQUIRED] Skill Identity

```yaml
skill_id:         <kebab-case-id>          # e.g. runtime-iq
display_name:     <Human Readable Name>    # e.g. RuntimeIQ
phase:            Operate                  # Always "Operate" for this package
agent_ref:        O-XX                     # Operate agent number from spec
version:          1.0.0
model:            <claude-model-string>    # See Model Guide below
token_budget:     ~XXK                     # Approximate max tokens per invocation
status:           core | proposed          # From spec
```

**Model Guide**
| Use case | Model |
|---|---|
| Real-time monitoring, fast classification, cost tracking | `claude-haiku-4-5-20251001` |
| Drift detection, incident analysis, runbook generation, experiment management | `claude-sonnet-4-20250514` |

---

## [REQUIRED] Skill Purpose

One paragraph. What does this skill do, why does it exist, and what problem does it solve for the POD Lead? No bullet points — prose only. Must be specific enough that a new AI Builder understands the scope boundary without reading the full spec.

---

## [REQUIRED] Trigger Phrases

List of natural-language phrases that should activate this skill. Used by Claude to recognise intent.

```
"run <skill-name>"
"<action verb> <domain noun>"
...
```

---

## [REQUIRED] Input Contract

### Read-Only Source Files (from manifest)

| File | Phase Origin | What the skill reads |
|---|---|---|
| `specs/...` | Phase N | Description |
| `artifacts/...` | Phase N | Description |
| `operate/...` | Operate | Description |

### Runtime Inputs (live data / user-elicited)

| Input | Source | Required? | Notes |
|---|---|---|---|
| Live telemetry | Observability stack | Yes/No | See elicitation section |
| ... | ... | ... | ... |

---

## [REQUIRED] Elicitation Protocol

> Skills MUST NOT proceed without confirmed answers to all [REQUIRED] questions.
> Questions are asked in order. Blocked questions (depends_on) are only asked if the dependency is answered affirmatively.

### Q&A Sequence

```yaml
questions:
  - id: Q1
    required: true
    prompt: "<Exact question text shown to user>"
    type: single_select | multi_select | free_text | numeric | file_path
    options: [...]          # for select types
    validation: "<rule>"    # e.g. "must be a positive integer", "must be a valid file path"
    default: "<value>"      # if applicable
    depends_on: null

  - id: Q2
    required: true
    prompt: "..."
    type: ...
    depends_on: Q1          # only asked if Q1 == "yes" (specify condition)
```

### Confirmation Gate

Before generating any output the skill MUST echo back a structured summary of all elicited values and ask:

```
> Review the configuration above. Type CONFIRM to proceed or EDIT <Q-number> to change a value.
```

---

## [REQUIRED] Processing Logic

Step-by-step description of what the skill does after elicitation is confirmed. Written as AI Builder prompt instructions — precise enough to generate correct code and configs.

1. **Step name** — what happens, which files are read, what is computed
2. ...

---

## [REQUIRED] Output Contract

| Output File | Location | Format | Written By | Description |
|---|---|---|---|---|
| `<filename>.<ext>` | `operate/<skill>/` | markdown / yaml / json / script | This skill | What it contains |

### Feedback Loop Contribution

Every Operate skill MUST contribute to `operate/feedback-loop-triggers.yaml`. Specify the key and value shape:

```yaml
# Contribution format
<skill_id>:
  generated_at: ISO-8601 timestamp
  summary: string
  triggers: []
  severity: info | warning | critical
```

---

## [OPTIONAL] Downstream Consumers

List other skills that read this skill's outputs.

| Output File | Consumed By | How |
|---|---|---|
| ... | ... | ... |

---

## [REQUIRED] Error Handling

| Condition | Skill Behaviour |
|---|---|
| Required input file missing | Ask user to confirm file path; abort with clear message if not found |
| Observability stack not detected | Run elicitation protocol Q_OBS to confirm stack type |
| `deploy.md` not present | Ask user to provide runtime environment details inline |
| Elicitation timeout / no response | Pause and re-prompt; do not assume defaults silently |

---

## [OPTIONAL] Sample Invocation

```
User: run <skill-name>
Skill: [Elicitation Q1] ...
User: ...
Skill: [Confirmation gate] Review config... Type CONFIRM to proceed.
User: CONFIRM
Skill: [Generates outputs to operate/<skill>/ ...]
```

---

## [REQUIRED] HITL Gates

| Gate | Condition | Reviewer | Blocks |
|---|---|---|---|
| Pre-run | Confirmation gate answered | POD Lead | Execution |
| Output review | Critical severity output produced | POD Lead | Feedback loop write |

---

## Metadata

```yaml
author:           AAxon Framework
framework_ref:    02e_aaxon-sprint-specs-operate.html
manifest_ref:     061-generated-files-manifest.txt
created:          2025-01
last_updated:     2025-01
```
