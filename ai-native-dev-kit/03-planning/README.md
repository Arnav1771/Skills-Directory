# AAxon Planning Skills — Phase 1 Sprint Accelerators

**AAxon Framework v2.1.0 · Aligned Automation · Planning Phase (Monday)**

This package contains 13 Claude Project Skills that power Monday sprint planning. Each skill is a structured prompt file that instructs a Claude session to perform a focused planning function. Skills are composable — outputs from one feed directly into the inputs of another via shared artifact files.

---

## Architecture Overview

```
openspec.yaml  ←─── POD Lead locks spec (HITL Gate 0)
     │
     ├──► ContextFabric    → context.yaml
     ├──► PolicyCatalog    → policy-catalogue.yaml
     ├──► ResearchCopilot  → evidence-map.md
     ├──► AssumptionTracker→ assumption-log.md
     ├──► TransformIQ      → opportunity-backlog-rescored.md
     │
     ▼
SpecFlow  (reads openspec.yaml + context.yaml + policy-catalogue.yaml)
     │
     ├──► task-breakdown.yaml
     ├──► ai-manifest.json
     │
     ▼
TraceGraph  (reads openspec.yaml + ai-manifest.json)
     │
     ├──► traceability-report.md
     │
     ▼
SpecImpactAnalyzer  (reads openspec.yaml diff + ai-manifest.json + traceability-report.md)
     │
     ├──► impact-analysis.md
     ├──► rework-scope-patch.yaml
     │
     ▼
ValueModeler  (reads openspec.yaml + opportunity-catalogue.yaml)
     │
     ├──► roi-brief.md
     │
     ▼
PortfolioPrioritizer  (reads roi-brief.md + task-breakdown.yaml)
     │
     ├──► sprint-scope-ranked.md
     │
     ▼
ScenarioPlanner  (reads roi-brief.md + sprint-scope-ranked.md)
     │
     ├──► scenario-matrix.md
     │
     ▼
DecisionLedger  (receives all decisions → decision-ledger.md)
     │
     ▼
Conductor  (reads task-breakdown.yaml + all above outputs → dispatches to AI Builders)
```

---

## File System Contract

All shared artifacts live in `specs/` (read-only inputs from previous phases) and `artifacts/` (written by planning skills):

### Input Files (from previous phases — read-only)
| File | Produced By | Consumed By |
|------|-------------|-------------|
| `specs/program.md` | program-charter | Conductor, ContextFabric |
| `specs/knowledge.md` | spec-knowledge | ResearchCopilot, ContextFabric |
| `specs/design.md` | spec-design | SpecFlow, ContextFabric |
| `specs/ui-ux.md` | spec-uiux | SpecFlow, PolicyCatalog |
| `specs/database.md` | spec-database | SpecFlow, PolicyCatalog, ContextFabric |
| `specs/api.md` | spec-api | SpecFlow, PolicyCatalog |
| `specs/features.md` | spec-generation | TransformIQ, PortfolioPrioritizer |
| `specs/spec.md` | spec-generation | All planning skills |
| `specs/tasks.md` | spec-generation | SpecFlow, Conductor |

### Output Files (written by planning skills)
| File | Written By | Consumed By |
|------|------------|-------------|
| `artifacts/openspec.yaml` | POD Lead (locked) | All skills |
| `artifacts/context.yaml` | ContextFabric | SpecFlow, Conductor |
| `artifacts/policy-catalogue.yaml` | PolicyCatalog | SpecFlow, Conductor |
| `artifacts/task-breakdown.yaml` | SpecFlow | Conductor, TraceGraph, PortfolioPrioritizer |
| `artifacts/ai-manifest.json` | SpecFlow | TraceGraph, SpecImpactAnalyzer |
| `artifacts/traceability-report.md` | TraceGraph | SpecImpactAnalyzer, Conductor |
| `artifacts/impact-analysis.md` | SpecImpactAnalyzer | Conductor, DecisionLedger |
| `artifacts/rework-scope-patch.yaml` | SpecImpactAnalyzer | Conductor |
| `artifacts/evidence-map.md` | ResearchCopilot | AssumptionTracker, DecisionLedger |
| `artifacts/assumption-log.md` | AssumptionTracker | DecisionLedger, Conductor |
| `artifacts/roi-brief.md` | ValueModeler | PortfolioPrioritizer, ScenarioPlanner |
| `artifacts/sprint-scope-ranked.md` | PortfolioPrioritizer | ScenarioPlanner, Conductor |
| `artifacts/scenario-matrix.md` | ScenarioPlanner | Conductor, DecisionLedger |
| `artifacts/decision-ledger.md` | DecisionLedger | Conductor (read-only reference) |
| `artifacts/opportunity-backlog-rescored.md` | TransformIQ | PortfolioPrioritizer |
| `artifacts/sprint-board.md` | Conductor | POD Lead |

---

## Skill Index

| # | Skill | Model | Tokens | Status | SKILL.md Path |
|---|-------|-------|--------|--------|---------------|
| 01 | **Conductor** | Sonnet 4 | ~60K | Core | `.claude/conductor/SKILL.md` |
| 02 | **SpecFlow** | Opus 4 | ~120K | Core | `.claude/spec-flow/SKILL.md` |
| 03 | **TraceGraph** | Haiku 4.5 | ~30K | Core | `.claude/trace-graph/SKILL.md` |
| 04 | **SpecImpactAnalyzer** | Sonnet 4 | ~50K | Core | `.claude/spec-impact-analyzer/SKILL.md` |
| 05 | **PolicyCatalog** | Haiku 4.5 | ~25K | Core | `.claude/policy-catalog/SKILL.md` |
| 06 | **TransformIQ** | Sonnet 4 | ~40K | Core | `.claude/transform-iq/SKILL.md` |
| 07 | **ResearchCopilot** | Sonnet 4 | ~80K | Core | `.claude/research-copilot/SKILL.md` |
| 08 | **DecisionLedger** | Haiku 4.5 | ~20K | Core | `.claude/decision-ledger/SKILL.md` |
| 09 | **AssumptionTracker** | Haiku 4.5 | ~20K | Proposed | `.claude/assumption-tracker/SKILL.md` |
| 10 | **ValueModeler** | Sonnet 4 | ~40K | Proposed | `.claude/value-modeler/SKILL.md` |
| 11 | **PortfolioPrioritizer** | Sonnet 4 | ~35K | Proposed | `.claude/portfolio-prioritizer/SKILL.md` |
| 12 | **ScenarioPlanner** | Sonnet 4 | ~30K | Proposed | `.claude/scenario-planner/SKILL.md` |
| 13 | **ContextFabric** | Sonnet 4 | ~80K | Proposed | `.claude/context-fabric/SKILL.md` |

---

## Monday Sprint Planning — Execution Order

Run skills in this sequence on Monday morning. Each step depends on outputs from the prior step.

### Step 0 — Pre-conditions (POD Lead)
- [ ] Lock `artifacts/openspec.yaml` — this triggers all downstream skills
- [ ] Set sprint capacity in `artifacts/sprint-capacity.yaml` (builder-hours available)
- [ ] Confirm strategic priority weights for ValueModeler and PortfolioPrioritizer

### Step 1 — Context & Compliance (Parallel, no dependencies)
Run simultaneously:
- **ContextFabric** — produces `context.yaml`
- **PolicyCatalog** — produces `policy-catalogue.yaml`
- **ResearchCopilot** — produces `evidence-map.md`
- **TransformIQ** — produces `opportunity-backlog-rescored.md`

### Step 2 — Assumption Triage (depends on Step 1)
- **AssumptionTracker** — reads `evidence-map.md` → produces `assumption-log.md`
- HITL gate: POD Lead reviews HITL blocker list before proceeding

### Step 3 — Spec Decomposition (depends on Step 1)
- **SpecFlow** — reads `openspec.yaml` + `context.yaml` + `policy-catalogue.yaml` → produces `task-breakdown.yaml` + `ai-manifest.json`

### Step 4 — Traceability & Impact (depends on Step 3)
Run simultaneously:
- **TraceGraph** — produces `traceability-report.md`
- **SpecImpactAnalyzer** — runs only if a spec change diff is present

### Step 5 — Value & Prioritisation (depends on Step 3)
Run in sequence:
1. **ValueModeler** → `roi-brief.md`
2. **PortfolioPrioritizer** → `sprint-scope-ranked.md`
3. **ScenarioPlanner** → `scenario-matrix.md`

### Step 6 — Decision Capture (ongoing)
- **DecisionLedger** — receives all HITL gate events and scope decisions throughout Monday

### Step 7 — Orchestration (depends on Steps 3–6)
- **Conductor** — reads all artifacts → produces `sprint-board.md` and dispatches to AI Builders

### HITL Gate 1 — Plan Sign-off
POD Lead reviews `sprint-board.md` and `scenario-matrix.md`. Gate clears sprint board for Build phase (Tue–Thu).

---

## Installation

1. Copy the `.claude/` directory into your Claude Project root
2. Each skill's `SKILL.md` is loaded as a Claude Project knowledge file or pasted as a custom instruction set
3. Create the `artifacts/` directory in your project root (writable)
4. Ensure all `specs/*.md` files from the previous phases are present (read-only)

### Directory Structure After Installation
```
project-root/
├── CLAUDE.md
├── README.md
├── specs/                        ← from previous phases (read-only)
│   ├── program.md
│   ├── knowledge.md
│   ├── design.md
│   ├── ui-ux.md
│   ├── database.md
│   ├── api.md
│   ├── features.md
│   ├── spec.md
│   └── tasks.md
├── artifacts/                    ← written by planning skills
│   └── openspec.yaml             ← POD Lead locks this first
├── .claude/
│   ├── conductor/SKILL.md
│   ├── spec-flow/SKILL.md
│   ├── trace-graph/SKILL.md
│   ├── spec-impact-analyzer/SKILL.md
│   ├── policy-catalog/SKILL.md
│   ├── transform-iq/SKILL.md
│   ├── research-copilot/SKILL.md
│   ├── decision-ledger/SKILL.md
│   ├── assumption-tracker/SKILL.md
│   ├── value-modeler/SKILL.md
│   ├── portfolio-prioritizer/SKILL.md
│   ├── scenario-planner/SKILL.md
│   └── context-fabric/SKILL.md
└── src/
```

---

## Model Selection Rationale

| Model | Used For | Reason |
|-------|----------|--------|
| **Opus 4** | SpecFlow | Deep multi-requirement reasoning; complex decomposition across 120K context |
| **Sonnet 4** | Conductor, SpecImpactAnalyzer, TransformIQ, ResearchCopilot, ValueModeler, PortfolioPrioritizer, ScenarioPlanner, ContextFabric | Balanced reasoning + speed; primary workhorses for Monday planning |
| **Haiku 4.5** | TraceGraph, PolicyCatalog, DecisionLedger, AssumptionTracker | High-speed, low-complexity mapping/logging tasks; cost-efficient at scale |

---

## HITL Gate Summary

| Gate | Trigger | Reviewer | Blocks |
|------|---------|----------|--------|
| Gate 0 | openspec.yaml lock | POD Lead | All planning skills |
| Gate 0.5 | AssumptionTracker HITL blocker list | POD Lead | SpecFlow dispatch |
| Gate 1 | Plan sign-off (sprint-board.md) | POD Lead + Business Lead | Build phase start |
| Mid-sprint | SpecImpactAnalyzer: scope change detected | POD Lead | Conductor re-dispatch |

---

*AAxon Framework v2.1.0 · Aligned Automation · Confidential*
