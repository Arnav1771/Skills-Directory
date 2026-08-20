# AAxon Release Skills — Phase 4

**Framework:** AAxon v2.1.0 · Aligned Automation  
**Phase:** 4 — Release  
**Sprint Day:** Friday  
**HITL Gate:** Gate 3 — QA Sign-off  
**Skills:** ReleaseIntel · ParityChecker · RolloutAdvisor

---

## Purpose

These three skills power Friday's Gate 3 review. They transform a 3–4 hour manual QA sign-off into a 30–45 minute evidence-based decision process. Each skill is designed to run in sequence: the output of each feeds the next.

```
ReleaseIntel → ParityChecker → RolloutAdvisor → POD Lead Sign-off → Gate 3 LOCKED
```

No new code is written on Friday. These skills synthesise everything built during the sprint and produce the deployment package that executes on Monday.

---

## Prerequisites

Before running any release skill, confirm the following Phase 3 planning artifacts exist in `artifacts/`:

| File | Source Skill | Required by |
|------|-------------|-------------|
| `artifacts/sprint-board.md` | Conductor | ReleaseIntel, RolloutAdvisor |
| `artifacts/task-breakdown.yaml` | SpecFlow | ReleaseIntel, RolloutAdvisor |
| `artifacts/traceability-report.md` | TraceGraph | ReleaseIntel (coverage signals) |
| `artifacts/scenario-matrix.md` | ScenarioPlanner | ReleaseIntel, RolloutAdvisor |
| `artifacts/assumption-log.md` | AssumptionTracker | ReleaseIntel |
| `artifacts/decision-ledger.md` | DecisionLedger | ReleaseIntel |

Missing files are handled gracefully — each skill will note what is absent and flag it as a P2/P1 risk rather than failing silently.

---

## Skill 1 — ReleaseIntel

**Location:** `.claude/release-intel/SKILL.md`  
**Output:** `artifacts/release/release-intel-report.md`  
**Token budget:** ~60K (claude-sonnet-4-20250514)

### What it does
Aggregates all sprint planning artifacts into a single release-readiness verdict. Quantifies deployment blast radius as a structured table — each affected component rated across 5 dimensions (User Segments, Dependent Features, Integration Points, Data Risk, Rollback Complexity) with every rating traced back to its source artifact.

### How to run

**In Claude.ai / Claude Code chat:**
> *"Run ReleaseIntel for sprint [sprint-id]"*

ReleaseIntel will:
1. Auto-detect available artifacts from `artifacts/`
2. Infer deployment scope from `sprint-board.md` + `task-breakdown.yaml` (or read `artifacts/release/deploy-manifest.yaml` if present)
3. Synthesise readiness signals against Gate 3 thresholds
4. Produce the blast-radius table with source citations
5. Issue a binary verdict: ✅ READY TO DEPLOY or ❌ NOT READY — BLOCKED
6. Write `artifacts/release/release-intel-report.md`

**Via script:**
```bash
python scripts/release_intel.py \
  --sprint-board artifacts/sprint-board.md \
  --task-breakdown artifacts/task-breakdown.yaml \
  --traceability artifacts/traceability-report.md \
  --scenario-matrix artifacts/scenario-matrix.md \
  --assumption-log artifacts/assumption-log.md \
  --decision-ledger artifacts/decision-ledger.md \
  --output artifacts/release/release-intel-report.md \
  --sprint-id YOUR-SPRINT-ID
```

### POD Lead action after ReleaseIntel
- Review the blast-radius table — focus on HIGH/CRITICAL rated components
- Accept or reject each P1 risk (document acceptance in the report)
- If NOT READY: resolve each P0 blocker and re-run ReleaseIntel
- If READY: proceed to ParityChecker

---

## Skill 2 — ParityChecker

**Location:** `.claude/parity-checker/SKILL.md`  
**Outputs:** `artifacts/release/env-config-staging.yaml` (first run only), `artifacts/release/env-config-production.yaml` (first run only), `artifacts/release/parity-check-report.md`  
**Token budget:** ~25K (claude-haiku-4-5-20251001)

### What it does
Verifies that staging and production environments are identical in every dimension that could cause a staging test to pass but a production deployment to fail. Classifies every difference as Critical Drift (deploy blocker), Notable Drift (POD Lead must acknowledge), or Expected Difference (documented by design).

**Critical drift count must be zero for Gate 3 to clear.**

### First run vs. subsequent runs

**First run** (no YAML config files exist): ParityChecker conducts a structured interactive interview — one dimension at a time — covering runtime, dependencies, database, external services, feature flags, environment variables, monitoring, and network/security. It then generates `env-config-staging.yaml` and `env-config-production.yaml` for reuse in all future sprints.

**Subsequent runs** (YAML files exist): ParityChecker diffs the two files directly. Update the YAML files before each Friday review to reflect any infrastructure changes made during the sprint.

### How to run

**In Claude.ai / Claude Code chat:**
> *"Run ParityChecker for sprint [sprint-id]"*

ParityChecker will auto-detect run mode and either begin elicitation or diff existing files.

**Via script:**
```bash
python scripts/parity_checker.py \
  --staging artifacts/release/env-config-staging.yaml \
  --production artifacts/release/env-config-production.yaml \
  --sprint-id YOUR-SPRINT-ID \
  --output artifacts/release/parity-check-report.md
```

### Updating config files between sprints
Before running ParityChecker on a new sprint's Friday:
1. Open `artifacts/release/env-config-staging.yaml` and `env-config-production.yaml`
2. Update any fields that changed during the sprint (new env vars, SDK upgrades, feature flags added/removed, migration IDs)
3. Run ParityChecker — it will diff the updated files

### POD Lead action after ParityChecker
- If critical drift > 0: resolve each item and re-run ParityChecker until count = 0
- Acknowledge each Notable Drift item with written rationale
- Only proceed to RolloutAdvisor after critical drift = 0

---

## Skill 3 — RolloutAdvisor

**Location:** `.claude/rollout-advisor/SKILL.md`  
**Outputs:** `artifacts/release/rollout-strategy.md`, `artifacts/release/rollback-plan.md`  
**Token budget:** ~35K (claude-sonnet-4-20250514)

### What it does
Synthesises the risk profile from ReleaseIntel and ParityChecker, asks 5 targeted questions about your infrastructure and deployment window, then produces a risk-calibrated rollout strategy with phase gates and a component-level rollback plan with explicit RTO targets.

### How to run

**In Claude.ai / Claude Code chat:**
> *"Run RolloutAdvisor for sprint [sprint-id]"*

RolloutAdvisor will:
1. Confirm ReleaseIntel and ParityChecker reports are present and show no blockers (marks outputs DRAFT if blockers remain)
2. Synthesise the composite risk tier (LOW / MEDIUM / HIGH / CRITICAL)
3. Ask 5 questions about your deployment window, feature flag availability, prior incidents, infrastructure capabilities, and on-call coverage
4. Recommend a rollout method (Feature-Flag Ramp, Canary, Blue-Green, or Direct Deploy)
5. Generate rollback procedures for each component with step-by-step instructions and RTO targets
6. Generate the Monday smoke test checklist
7. Write both output files to `artifacts/release/`

**Via script:**
```bash
python scripts/rollout_advisor.py \
  --release-intel artifacts/release/release-intel-report.md \
  --parity-check artifacts/release/parity-check-report.md \
  --task-breakdown artifacts/task-breakdown.yaml \
  --scenario-matrix artifacts/scenario-matrix.md \
  --sprint-board artifacts/sprint-board.md \
  --output-strategy artifacts/release/rollout-strategy.md \
  --output-rollback artifacts/release/rollback-plan.md \
  --sprint-id YOUR-SPRINT-ID
```

### POD Lead action after RolloutAdvisor
- Review rollout strategy — confirm the recommended method matches your infrastructure capability
- Review rollback plan — verify each rollback procedure is executable by your on-call engineer
- Brief the on-call engineer on smoke test checklist and rollback triggers
- Sign the Gate 3 attestation blocks in all three reports
- Set `artifacts/release/deploy-manifest.yaml` status to `LOCKED`

---

## Gate 3 Sign-off Checklist

Complete in order on Friday before EOD:

```
PHASE 3 ARTIFACTS READY
  □ sprint-board.md confirmed DONE/IN REVIEW for all in-scope tasks
  □ Artifact files accessible in artifacts/ directory

RELEASE INTEL
  □ ReleaseIntel run → release-intel-report.md produced
  □ Verdict: READY TO DEPLOY (zero P0 blockers)
  □ All P1 risks reviewed and accepted (or scope reduced)
  □ Blast-radius table reviewed — no surprises

PARITY CHECKER
  □ ParityChecker run → parity-check-report.md produced
  □ Critical drift count: 0
  □ All notable drift items acknowledged
  □ Config YAML files updated for next sprint (if applicable)

ROLLOUT ADVISOR
  □ RolloutAdvisor run → rollout-strategy.md + rollback-plan.md produced
  □ Rollout method confirmed feasible in your infrastructure
  □ Rollback script(s) staged in production environment
  □ On-call engineer briefed on smoke test checklist
  □ RTO targets reviewed and accepted

GATE 3 LOCK
  □ Signed Gate 3 attestation in release-intel-report.md
  □ Signed Gate 3 attestation in parity-check-report.md
  □ Signed Go/No-Go in rollout-strategy.md
  □ deploy-manifest.yaml status → LOCKED
  □ Deployment package immutable from this point
```

> ⚠️ The Go/No-Go deployment decision belongs to the POD Lead. No agent may be delegated this authority. Monday deployment proceeds only after a named human signs Gate 3.

---

## Directory Structure

```
.claude/
├── release-intel/
│   ├── SKILL.md                         ← Skill definition + workflow
│   ├── references/
│   │   ├── readiness-thresholds.md      ← Gate 3 pass/fail rules, blast-radius scoring
│   │   └── output-schema.md             ← Required sections in release-intel-report.md
│   ├── sample_input/
│   │   └── sprint-board.md              ← Example sprint board (S07, 10 tasks)
│   └── sample_output/
│       └── release-intel-report.md      ← Example: READY verdict, 1 P1 risk, 5 components
│
├── parity-checker/
│   ├── SKILL.md                         ← Skill definition + elicitation workflow
│   ├── references/
│   │   ├── classification-rules.md      ← CRITICAL/NOTABLE/EXPECTED rules + examples
│   │   └── output-schema.md             ← Required sections in parity-check-report.md
│   ├── sample_input/
│   │   ├── env-config-staging.yaml      ← Example staging config (S07)
│   │   └── env-config-production.yaml   ← Example production config (2 critical drifts)
│   └── sample_output/
│       └── parity-check-report.md       ← Example: 2 CRITICAL, 3 NOTABLE, 4 EXPECTED
│
└── rollout-advisor/
    ├── SKILL.md                         ← Skill definition + elicitation questions
    ├── references/
    │   └── output-schema.md             ← Required sections in both output files
    ├── sample_input/
    │   (uses release-intel + parity-checker sample outputs)
    └── sample_output/
        ├── rollout-strategy.md          ← Example: Feature-flag ramp, MEDIUM risk
        └── rollback-plan.md             ← Example: 5-component rollback, 25 min RTO

artifacts/release/
├── deploy-manifest.yaml                 ← Template (optional POD Lead input)
├── env-config-staging.yaml              ← Generated by ParityChecker (first run)
├── env-config-production.yaml           ← Generated by ParityChecker (first run)
├── release-intel-report.md             ← Generated by ReleaseIntel
├── parity-check-report.md              ← Generated by ParityChecker
├── rollout-strategy.md                 ← Generated by RolloutAdvisor
└── rollback-plan.md                    ← Generated by RolloutAdvisor

052-release-phase-manifest.txt          ← Phase 4 file manifest (extends 051)
```

---

## Installation

1. Copy the `.claude/` directory contents into your project's `.claude/` directory
2. Copy `artifacts/release/deploy-manifest.yaml` template into your project's `artifacts/release/`
3. Ensure `ANTHROPIC_API_KEY` is set in your environment (for script mode)
4. On first ParityChecker run, have staging and production environment details available

No additional dependencies are required for interactive mode (Claude.ai / Claude Code chat).  
Script mode requires: `pip install anthropic --break-system-packages`

---

## Efficiency Impact Summary

| Skill | Before | After |
|-------|--------|-------|
| **ReleaseIntel** | 3–4 hours manually cross-referencing test, coverage, scenario reports | 30–45 min reviewing a single synthesised verdict |
| **ParityChecker** | Ad-hoc config comparison; frequent "works in staging" incidents | 5 min first run; sub-minute diff on subsequent sprints |
| **RolloutAdvisor** | Improvised Friday-afternoon rollout decisions; no documented rollback | Mechanical Monday execution from a pre-approved, risk-calibrated plan |

---

*AAxon Framework v2.1.0 · Aligned Automation · Confidential*
