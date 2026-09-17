# Automation30 Framework — Skills Guide

**Automation30 · Aligned Automation · Confidential**

A complete AI-native software delivery framework. Five phases take a program from strategy through live production operations, each powered by Claude skills that replace hours of manual work with structured, evidence-based AI collaboration.

---

## The Five Phases

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                             │
│  Phase 1             Phase 2            Phase 3           Phase 4          Phase 5         │
│  Establish           Data               Platform          AI Solution      Simplified      │
│  Strategy            Readiness          Enablement        Deployment       AI Operations   │
│                                                                             │
│  Program charter  →  Sprint context, →  Build + test   →  Release       →  Monitor,       │
│  Specs, discovery    planning            validate          readiness         optimise       │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

| Phase | Sprint Days | Key Gate | Primary Owner |
|-------|-------------|----------|---------------|
| 1 — Establish Strategy | Pre-sprint (Discovery) | Gate 0: openspec.yaml locked | Program Lead |
| 2 — Data Readiness | Monday (Sprint Planning) | Gate 1: plan sign-off (sprint-board.md) | Pod Lead |
| 3 — Platform Enablement | Tue–Thu (Build + Validate) | Gate 2: design sign-off · Gate 3: validation sign-off | Pod Lead + AI Builders |
| 4 — AI Solution Deployment | Friday | Gate 3: QA sign-off | Pod Lead |
| 5 — Simplified AI Operations | Post-deploy (continuous) | HITL per-skill | Pod Lead |

---

## How to Use This Guide

Each phase section below covers:
- **What it does** — the purpose and output
- **Skills** — the AI skills available in that phase
- **Execution order** — the sequence to run skills
- **Artifacts** — files produced and consumed
- **HITL gates** — where human sign-off is required

All prompts for each phase are in the corresponding file in the `prompts/` folder. Execute prompts in the order they appear, reply **NEXT** to proceed with artifact generation, and **CONFIRM** before moving to the next prompt.

---

## Phase 1 — Establish Strategy

**Purpose:** Transform a raw program idea into a validated, AI-ready specification. Covers program charter creation, full spec generation, discovery (document, code, and meeting extraction), knowledge review, design setup, and work breakdown. By the end of this phase, all specs are complete and `artifacts/openspec.yaml` is locked ready for Phase 2 sprint planning.

**Prompt file:** `prompts/01-establish-strategy.md` (14 prompts)

### Skills

| Skill | Purpose |
|-------|---------|
| `program-charter` | Structured elicitation interview → `specs/program.md` + folder scaffold |
| `spec-knowledge` | Domain entities, business rules, state machines → `specs/knowledge.md` |
| `spec-design` | Tech stack, frameworks, infra, coding standards → `specs/design.md` |
| `spec-uiux` | Design tokens, components, motion system → `specs/ui-ux.md` |
| `spec-database` | Schema, tables, indexes, migrations → `specs/database.md` |
| `spec-api` | REST endpoints, request/response schemas, auth → `specs/api.md` |
| `skill-flow` | Validate Phase 1 specs and recommend Phase 2+ skills |
| `requirements-elicitation-charter` | Generate discovery question pack from charter |
| `doc-extraction` | Parse customer docs → seed knowledge, design, uiux files |
| `code-extraction` | Parse legacy code → seed api, database, design files (AS-IS) |
| `meeting-extraction` | Parse transcripts → route to knowledge, features, design files |
| `knowledge-review` | Section-by-section validation of knowledge.md and features.md |
| `design-setup` | Interactive TO-BE design session → populate all design files |
| `spec-generation` | Derive Epics → Stories → Tasks → `specs/spec.md` + `specs/tasks.md` |

### Execution Order

```
Step 1   program-charter                   →  specs/program.md + folder scaffold
Step 2   spec-knowledge                    →  specs/knowledge.md
Step 3   spec-design                       →  specs/design.md
Step 4   spec-uiux                         →  specs/ui-ux.md
Step 5   spec-database                     →  specs/database.md
Step 6   spec-api                          →  specs/api.md
Step 7   skill-flow                        →  recommendation_report.md

── Discovery (run as needed, any order) ──
Step 8   requirements-elicitation-charter  →  questions-[date].md
Step 9   doc-extraction                    →  updates knowledge.md, design.md, uiux.md
Step 10  code-extraction                   →  updates knowledge.md, api.md, database.md
Step 11  meeting-extraction                →  updates knowledge.md, features.md, design.md

        ── Repeat Steps 9–11 as new inputs arrive ──

Step 12  knowledge-review                  →  knowledge.md + features.md (REVIEWED ✓)
Step 13  design-setup                      →  all design files (TO-BE populated)
Step 14  spec-generation                   →  specs/spec.md + specs/tasks.md
```

### Key Artifacts Produced

| Artifact | Purpose |
|----------|---------|
| `specs/program.md` | Program charter — goals, stakeholders, scope, KPIs |
| `specs/knowledge.md` | Domain knowledge — entities, rules, workflows, glossary |
| `specs/design.md` | Tech stack and architecture decisions |
| `specs/ui-ux.md` | Design system — tokens, components, motion |
| `specs/database.md` | Database schema and migration strategy |
| `specs/api.md` | REST API contract — endpoints, schemas, auth |
| `specs/spec.md` | Epics and stories with acceptance criteria |
| `specs/tasks.md` | Full task inventory (≤3 business days each) |
| `artifacts/openspec.yaml` | Sprint specification — **locked by Pod Lead (Gate 0)** |

### HITL Gates

| Gate | Trigger | Reviewer | Blocks |
|------|---------|----------|--------|
| Gate 0 | openspec.yaml lock | Pod Lead | Phase 2 start |

---

## Phase 2 — Data Readiness

**Purpose:** Transform the locked spec into a sprint-ready execution plan. Runs on Monday (Sprint Planning day). Builds the sprint context index, derives compliance rules, validates evidence, scores assumptions, prioritises scope, generates the task breakdown and AI manifest, traces requirements, models ROI, and dispatches work to AI Builders via the sprint board. By the end of this phase, Gate 1 is signed and the build phase can begin.

**Prompt file:** `prompts/02-data-readiness.md` (13 prompts)

### Skills

| Skill | Purpose |
|-------|---------|
| **ContextFabric** | Build sprint context index → `artifacts/context.yaml` |
| **PolicyCatalog** | Derive compliance rules → `artifacts/policy-catalogue.yaml` |
| **ResearchCopilot** | Evidence-backed spec validation → `artifacts/evidence-map.md` |
| **AssumptionTracker** | Flag and triage spec assumptions → `artifacts/assumption-log.md` |
| **TransformIQ** | Rescore opportunity backlog against strategy → `artifacts/opportunity-backlog-rescored.md` |
| **SpecFlow** | Decompose spec into tasks + AI manifest → `artifacts/task-breakdown.yaml`, `artifacts/ai-manifest.json` |
| **TraceGraph** | Build requirement traceability map → `artifacts/traceability-report.md` |
| **SpecImpactAnalyzer** | Analyse spec change impact → `artifacts/impact-analysis.md` |
| **ValueModeler** | Forecast ROI per feature → `artifacts/roi-brief.md` |
| **PortfolioPrioritizer** | Rank sprint scope by value → `artifacts/sprint-scope-ranked.md` |
| **ScenarioPlanner** | Generate risk scenarios → `artifacts/scenario-matrix.md` |
| **DecisionLedger** | Log all HITL decisions → `artifacts/decision-ledger.md` |
| **Conductor** | Orchestrate all planning outputs → `artifacts/sprint-board.md` |

### Execution Order

```
Prompt 1   ContextFabric           →  artifacts/context.yaml
Prompt 2   PolicyCatalog           →  artifacts/policy-catalogue.yaml
Prompt 3   ResearchCopilot         →  artifacts/evidence-map.md
Prompt 4   AssumptionTracker       →  artifacts/assumption-log.md
Prompt 5   TransformIQ             →  artifacts/opportunity-backlog-rescored.md
Prompt 6   SpecFlow                →  artifacts/task-breakdown.yaml + ai-manifest.json
Prompt 7   TraceGraph              →  artifacts/traceability-report.md
Prompt 8   SpecImpactAnalyzer      →  artifacts/impact-analysis.md (if spec changed)
Prompt 9   ValueModeler            →  artifacts/roi-brief.md
Prompt 10  PortfolioPrioritizer    →  artifacts/sprint-scope-ranked.md
Prompt 11  ScenarioPlanner         →  artifacts/scenario-matrix.md
Prompt 12  DecisionLedger          →  artifacts/decision-ledger.md (ongoing)
Prompt 13  Conductor               →  artifacts/sprint-board.md
```

### Key Artifacts Produced

| Artifact | Purpose |
|----------|---------|
| `artifacts/context.yaml` | Sprint context index — capability inventory, requirement-to-capability mapping |
| `artifacts/policy-catalogue.yaml` | Compliance rail prompts per requirement |
| `artifacts/evidence-map.md` | Evidence strength per requirement + AssumptionTracker escalations |
| `artifacts/assumption-log.md` | Scored assumptions with HITL blocker classification |
| `artifacts/opportunity-backlog-rescored.md` | Rescored backlog with value density rankings |
| `artifacts/task-breakdown.yaml` | Decomposed task tree with builder assignments and wave plan |
| `artifacts/ai-manifest.json` | AI artifact provenance — task → source files |
| `artifacts/traceability-report.md` | Requirement → cluster → artifact traceability graph |
| `artifacts/impact-analysis.md` | Spec change ripple analysis (if spec changed mid-sprint) |
| `artifacts/roi-brief.md` | ROI forecast per feature with payback period |
| `artifacts/sprint-scope-ranked.md` | Prioritised, capacity-cut sprint scope |
| `artifacts/scenario-matrix.md` | 3-scenario ROI matrix + minimum viable scope |
| `artifacts/decision-ledger.md` | Append-only log of all HITL decisions |
| `artifacts/sprint-board.md` | Dispatched work board for AI Builders — **Gate 1 output** |

### HITL Gates

| Gate | Trigger | Reviewer | Blocks |
|------|---------|----------|--------|
| Gate 0.5 | AssumptionTracker HITL blocker list | Pod Lead | SpecFlow dispatch |
| Gate 1 | Plan sign-off (sprint-board.md) | Pod Lead + Business Lead | Build phase start |
| Mid-sprint | SpecImpactAnalyzer: scope change detected | Pod Lead | Conductor re-dispatch |

---

## Phase 3 — Platform Enablement

**Purpose:** Build, test, and validate all sprint deliverables. Covers design validation, AI-safe code generation, PR review, adversarial testing, load testing, compliance scanning, and deployment manifest generation. Runs Tuesday through Thursday.

**Prompt file:** `prompts/platform-enablement.md` (15 prompts)

### Skills

#### Build Skills (Tuesday — Design Validation)

| Skill | Agent | Model | Purpose |
|-------|-------|-------|---------|
| `KnowledgeMesh` | B-02 | Haiku 4.5 | Build sprint context index for all downstream agents |
| `SecretShield` | B-07 | Haiku 4.5 | Scrub credentials from all LLM context payloads |
| `TrustFabric` | B-03 | Haiku 4.5 | PII classification and data contract governance |
| `PerformanceOptimizer` | B-08 | Haiku 4.5 | Model routing and token budget enforcement |
| `ExperienceStudio` | B-01 | Sonnet 4 | UX intent validation — Gate 2 design sign-off |

#### Build Skills (Wednesday–Thursday — Build Days)

| Skill | Agent | Model | Purpose |
|-------|-------|---------|---------|
| `DevCopilot` | B-04 | Sonnet 4 | IDE-time implementation assistant |
| `PromptBench` | B-06 | Haiku 4.5 | Benchmark prompt variants for AI features |
| `ReviewPilot` | B-05 | Sonnet 4 | Automated PR review and spec conformance check |
| `NexusDeploy` | B-09 | Haiku 4.5 | Artifact registry and deploy manifest generation |

#### Validate Skills (Tuesday–Thursday continuous, Friday gate)

| Skill | Agent | Model | Purpose |
|-------|-------|-------|---------|
| `EvalHarness` | V-02 | Sonnet 4 | Define LLM-as-judge rubric for semantic evaluation |
| `Guardian` | V-01 | Sonnet 4 | Generate Gherkin tests from spec; execute and triage failures |
| `AxiomTestGen` | V-07 | Sonnet 4 | Generate traceable test suites (unit/integration/contract/acceptance) after DevCopilot; produces test-plan.yaml, traceability matrix, and coverage-gap report |
| `RedTeamX` | V-03 | Sonnet 4 | Adversarial and safety testing (24 attack vectors, 6 categories) |
| `SimLab` | V-04 | Haiku 4.5 | Load tests, chaos scenarios, NFR pass/fail verdict |
| `PolicyEnforcer` | V-05 | Haiku 4.5 | Static + runtime compliance scanning against policy catalogue |
| `InsightOps` | V-06 | Sonnet 4 | Cross-agent failure synthesis and spec gap identification |

### Execution Order

```
TUESDAY — Design Validation Day
─────────────────────────────────────────────────────────
Step 1   KnowledgeMesh         →  knowledge-mesh-index.md
Step 2   SecretShield          →  active (implicit gate on all payloads)
Step 3   EvalHarness           →  artifacts/eval-rubric.yaml
Step 4   Guardian (Generation) →  tests/*.feature, artifacts/coverage-report.md
         ↑ POD Lead reviews .feature files ← GATE 2 SIGN-OFF REQUIRED ↑
Step 5   ExperienceStudio      →  experience-conformance-report.md
Step 6   TrustFabric           →  data-contract-compliance-report.md
Step 7   PerformanceOptimizer  →  token budget dashboard, model routing decisions

WEDNESDAY–THURSDAY — Build + Validate (parallel to each other)
─────────────────────────────────────────────────────────
Per task (each AI Builder):
  PerformanceOptimizer routes → KnowledgeMesh retrieves context →
  SecretShield scans payload → DevCopilot generates code →
  TrustFabric validates → ReviewPilot reviews PR

  AxiomTestGen             →  tests/<epic-id>/, test-plan.<epic-id>.yaml,
                               test-traceability.md, coverage-gap-report.md

For AI features only:
  PromptBench benchmarks variants → POD Lead selects winner

Validation (continuous, once components are available):
  Guardian (Execution)    →  artifacts/test-results.json
  RedTeamX               →  artifacts/vulnerability-report.md
  SimLab                 →  artifacts/nfr-verdict.md
  PolicyEnforcer         →  artifacts/compliance-attestation.md

THURSDAY EOD — Sprint Close-Out
─────────────────────────────────────────────────────────
  NexusDeploy            →  deploy-manifest.yaml (if all requirements complete)
  InsightOps             →  artifacts/validation-report.md (PRIMARY GATE DOCUMENT)
                            artifacts/spec-amendments.md
                            artifacts/action-list.md
```

### Key Artifacts Produced

| Artifact | Produced By | Purpose |
|----------|------------|---------|
| `experience-conformance-report.md` | ExperienceStudio | UX Gate 2 sign-off |
| `eval-rubric.yaml` | EvalHarness | Shared scoring rubric for all validation agents |
| `test-results.json` | Guardian | Pass/fail per scenario with triage categories |
| `tests/<epic-id>/…` | AxiomTestGen | Runnable unit/integration/contract/acceptance test files |
| `test-plan.<epic-id>.yaml` | AxiomTestGen | Machine-readable case manifest — handoff to Guardian/CI |
| `test-traceability.md` | AxiomTestGen | Acceptance-criterion → test-case traceability matrix |
| `coverage-gap-report.md` | AxiomTestGen | Uncovered/ambiguous ACs with HITL flags |
| `adversarial-test-suite.json` | RedTeamX | Per-component ROBUST/DEGRADED/VULNERABLE verdict |
| `nfr-verdict.md` | SimLab | p50/p95/p99 metrics + PASS/WARN/FAIL verdict |
| `compliance-attestation.md` | PolicyEnforcer | Zero critical/high violations attestation |
| `validation-report.md` | InsightOps | **Primary Release Gate document** |
| `deploy-manifest.yaml` | NexusDeploy | Deployment package for Release phase |

### HITL Gates

| Gate | Skill | POD Lead Action |
|------|-------|----------------|
| Gate 2 — Design sign-off | ExperienceStudio | Approve conformance report or resolve revisions |
| Data contract gaps | TrustFabric | Classify unclassified PII fields before build begins |
| Spec ambiguity | DevCopilot | Resolve escalated ambiguity questions |
| Budget alert (80%) | PerformanceOptimizer | Approve model downgrades or task deferrals |
| PR review judgment | ReviewPilot | Review UNTESTABLE findings; approve advisory deferrals |
| Prompt selection | PromptBench | Confirm recommended winner |
| Coverage gap (critical AC) | AxiomTestGen | Review gap report before suite is accepted into Validate |
| VULNERABLE finding | RedTeamX | Remediate immediately — hard blocks Release |
| Sprint completeness | NexusDeploy | Resolve blockers; approve deploy manifest |
| Validation sign-off | InsightOps | Sign `validation-report.md` before Gate 3 |

### Release Gate Checklist (Gate 3 — end of Phase 3)

```
□ Guardian:        coverage-report.md ≥ 80% coverage, zero UNTRIAGED failures
□ EvalHarness:     eval-summary.md score ≥ pass_threshold, no unresolved drift
□ RedTeamX:        redteam-summary.md = SAFE or CONDITIONAL (zero VULNERABLE)
□ SimLab:          nfr-verdict.md = PASS or WARN (staging equivalence confirmed)
□ PolicyEnforcer:  compliance-attestation.md = 0 critical, 0 high violations
□ InsightOps:      validation-report.md signed by POD Lead
```

---

## Phase 4 — AI Solution Deployment

**Purpose:** Transform the validated sprint artifacts into a risk-calibrated, approved deployment package. Three skills run in sequence on Friday. No new code is written — these skills synthesise everything built during the sprint.

**Prompt file:** `prompts/ai-solution-deployment.md` (3 prompts)

### Skills

| Skill | Location | Model | Output |
|-------|----------|-------|--------|
| `ReleaseIntel` | `.claude/release-intel/` | Sonnet 4 | Binary release verdict + blast-radius table |
| `ParityChecker` | `.claude/parity-checker/` | Haiku 4.5 | Staging vs. production environment diff |
| `RolloutAdvisor` | `.claude/rollout-advisor/` | Sonnet 4 | Risk-calibrated rollout strategy + rollback plan |

### Execution Order

```
ReleaseIntel → ParityChecker → RolloutAdvisor → POD Lead Sign-off → Gate 3 LOCKED
```

**Step 1 — ReleaseIntel**
Aggregates all sprint artifacts into a single readiness verdict. Quantifies deployment blast radius per component across 5 dimensions (User Segments, Dependent Features, Integration Points, Data Risk, Rollback Complexity). Issues binary verdict: READY TO DEPLOY or NOT READY — BLOCKED.

```
"Run ReleaseIntel for sprint [sprint-id]"
```

Output: `artifacts/release/release-intel-report.md`

**Step 2 — ParityChecker**
Verifies staging and production environments are identical across 8 dimensions (runtime, dependencies, database, external services, feature flags, environment variables, monitoring, network). Classifies every difference as CRITICAL_DRIFT, NOTABLE_DRIFT, or EXPECTED_DIFF. **Critical drift must be zero for Gate 3 to clear.**

First run: conducts a structured interview and generates the environment config YAML files.
Subsequent runs: diffs the existing YAML files directly.

```
"Run ParityChecker for sprint [sprint-id]"
```

Output: `artifacts/release/parity-check-report.md`

**Step 3 — RolloutAdvisor**
Synthesises the composite risk tier and asks 5 targeted questions about deployment window, feature flag availability, prior incidents, infrastructure rollback capability, and on-call coverage. Recommends a rollout method (Feature-Flag Ramp, Canary, Blue-Green, or Direct Deploy) with phase gates and a component-level rollback plan.

```
"Run RolloutAdvisor for sprint [sprint-id]"
```

Outputs: `artifacts/release/rollout-strategy.md`, `artifacts/release/rollback-plan.md`

### Gate 3 Sign-off Checklist

```
□ ReleaseIntel:    Verdict = READY TO DEPLOY, zero P0 blockers
□ ParityChecker:   Critical drift count = 0
□ RolloutAdvisor:  Rollout strategy confirmed feasible; rollback scripts staged
□ On-call engineer briefed on smoke test checklist and rollback triggers
□ Signed Gate 3 attestation in release-intel-report.md
□ Signed Gate 3 attestation in parity-check-report.md
□ Signed Go/No-Go in rollout-strategy.md
□ deploy-manifest.yaml status → LOCKED
```

> The Go/No-Go deployment decision belongs to the POD Lead. No agent may be delegated this authority. Monday deployment proceeds only after a named human signs Gate 3.

### Efficiency Impact

| Skill | Before | After |
|-------|--------|-------|
| ReleaseIntel | 3–4 hours cross-referencing test, coverage, and scenario reports | 30–45 min reviewing a single synthesised verdict |
| ParityChecker | Ad-hoc config comparison; frequent "works in staging" incidents | 5 min first run; sub-minute on subsequent sprints |
| RolloutAdvisor | Improvised Friday-afternoon rollout decisions | Mechanical Monday execution from a pre-approved plan |

---

## Phase 5 — Simplified AI Operations

**Purpose:** Maintain, monitor, and continuously improve the deployed AI system. Covers cost governance, SLA monitoring, drift detection, incident management, runbook generation, ROI measurement, experimentation, and AI system optimisation.

**Prompt file:** `prompts/simplified-ai-operations.md` (21 prompts)

### Skills

#### Operations Skills

| Skill | Agent | Model | Purpose |
|-------|-------|-------|---------|
| `ControlPlane` | O-03 | Haiku 4.5 | Cost governance, billing enforcement, security posture |
| `RuntimeIQ` | O-01 | Haiku 4.5 | SLA monitoring and auto-scaling |
| `DriftGuard` | O-02 | Sonnet 4 | Semantic and performance drift detection |
| `IncidentLens` | O-05 | Sonnet 4 | Incident logging, pattern learning, backlog generation |
| `RunbookSynth` | O-04 | Sonnet 4 | Auto-generated operational runbooks and alert playbooks |
| `ValueTracker` | O-06 | Sonnet 4 | ROI measurement — actual vs. forecast |
| `ExperimentOps` | O-07 | Sonnet 4 | Safe A/B testing and multi-armed experimentation |

#### Optimisation Skills

| Skill | Purpose |
|-------|---------|
| `ToolSurfaceAuditor` | Score and cull unused MCP servers and tools |
| `PromptSlimmer` | Audit, compress, and diff system prompts |
| `BudgetGovernor` | Forecast task graph cost; apply spend gates |
| `SemanticCache` | Cache AI responses by semantic similarity (threshold: 0.92) |
| `ModelRouter` | Score tasks across 6 dimensions and assign Haiku/Sonnet/Opus |
| `RegexLLMRouter` | Score parsing tasks and route to regex, hybrid, or LLM |
| `ContextProfiler` | Profile 5 context segments; alert at 70/85/95% utilisation |
| `RelevancePruner` | Score and prune context chunks by relevance; respect token budget |
| `RollingSummarizer` | Fold new conversation turns into a rolling 6-section summary |
| `StrategicCompactor` | Classify and compress context by alert level (50–75% reduction) |
| `IterativeRetrieval` | Progressive RAG loop with confidence gating (threshold: 0.85) |
| `MemoryPersistence` | Extract and persist prioritised session state across context windows |
| `EvalHarness` | Run grader suite (exact_match, rubric, functional, adversarial) |
| `PatternExtractor` | Mine execution traces for reusable patterns and candidate skills |

### Recommended Activation Order (New Deployment)

```
1.  ControlPlane      ← Establish cost ceilings first (RuntimeIQ reads these)
2.  RuntimeIQ         ← Set up SLA monitoring and auto-scaling
3.  DriftGuard        ← Set up drift detection (needs observability stack)
4.  RunbookSynth      ← Generate runbooks (reads deploy manifest + design)
5.  IncidentLens      ← Set up incident intake
6.  ValueTracker      ← Capture baseline before measuring ROI
7.  ExperimentOps     ← Design experiments (requires stakeholder sign-off)

── Optimisation (run as needed) ──
    ToolSurfaceAuditor  ← Cull tool surface every 30 days
    PromptSlimmer       ← Compress system prompts when size creeps
    BudgetGovernor      ← Forecast cost before large task runs
    ModelRouter         ← Assign optimal models to task batches
    ContextProfiler     ← Monitor context utilisation each session
```

### Skill Invocation

Every skill follows the same three-stage pattern:

```
1. INVOKE   →  Use the trigger phrase with Claude
2. ELICIT   →  Answer structured Q&A (validated inputs, EDIT Q<n> to revise)
3. CONFIRM  →  Type CONFIRM at the confirmation gate to generate artifacts
```

| Skill | Trigger Phrase |
|-------|---------------|
| ControlPlane | `run ControlPlane` or `set up cost governance` |
| RuntimeIQ | `run RuntimeIQ` |
| DriftGuard | `run DriftGuard` or `check for model drift` |
| RunbookSynth | `run RunbookSynth` or `generate runbooks` |
| IncidentLens | `run IncidentLens` (then select Mode A: log incident or Mode B: analyse patterns) |
| ValueTracker | `run ValueTracker` |
| ExperimentOps | `run ExperimentOps` |

### Key Output Files

| Skill | Primary Outputs | Location |
|-------|----------------|---------|
| RuntimeIQ | `runtime-iq-monitor.py`, `thresholds.yaml`, `sla-dashboard.json` | `operate/runtime-iq/` |
| DriftGuard | `drift-scorer.py`, `drift-report.md`, `drift-config.yaml` | `operate/drift-guard/` |
| ControlPlane | `cost-config.yaml`, `control-plane-monitor.py`, `security-monitor.py` | `operate/control-plane/` |
| RunbookSynth | `runbook-[feature]-[version].md`, `runbook-index.md` | `operate/runbook-synth/` |
| IncidentLens | `incident-log.md`, `incident-pattern-report.md`, `backlog-items.yaml` | `operate/incident-lens/` |
| ValueTracker | `value-realization-report.md`, `value-modeler-calibration.yaml` | `operate/value-tracker/` |
| ExperimentOps | `experiment-[id]-manifest.yaml`, `guardrail-monitor.py` | `operate/experiment-ops/` |

### The Feedback Loop

All Operate skills write to `operate/feedback-loop-triggers.yaml`. This file is read at the start of every Monday planning session, seeding Phase 1 (Establish Strategy) with live production evidence.

```
Monday Planning (Phase 1)
        │
        ▼
  feedback-loop-triggers.yaml ◄──────────────────────────────────────┐
        │                                                              │
        ▼                                                              │
  Sprint Scope + Spec  →  Build  →  Deploy  →  Production            │
                                                    │                  │
                                        RuntimeIQ ──┤ SLA signals      │
                                        DriftGuard ─┤ Spec drift       │
                                        ControlPlane┤ Cost overruns    │
                                        IncidentLens┤ Failure patterns │
                                        ValueTracker┤ ROI actuals      │
                                        ExperimentOps┤ Test results    │
                                                    └──────────────────┘
```

### HITL Gates (Operate Phase)

| Gate | Skill | Condition | Reviewer |
|------|-------|-----------|----------|
| Pre-run confirmation | All skills | CONFIRM gate | Pod Lead |
| Scaling request | RuntimeIQ | >80% of max replica bound | Pod Lead |
| Revalidation trigger | DriftGuard | Feature drift below threshold | Pod Lead |
| Cost ceiling activation | ControlPlane | First consumption block | Pod Lead |
| Security anomaly | ControlPlane | Any access anomaly | Pod Lead |
| Rollback runbook review | RunbookSynth | New rollback runbook generated | Pod Lead |
| Systemic backlog item | IncidentLens | Systemic classification | Pod Lead |
| Baseline capture | ValueTracker | Baseline absent at deployment | Pod Lead |
| Experiment go-live | ExperimentOps | Before traffic routing activates | Pod Lead + Stakeholder |
| Winner promotion | ExperimentOps | Statistical significance reached | Pod Lead |

---

## Sprint Orchestration

**skill-orchestrator** is the dispatch-mode engine that runs the entire AAxon sprint as a single governed pipeline — planning → build → validate — across all skills and HITL gates. Use it whenever you want to run multiple skills as a coordinated workflow rather than invoking each one manually.

> The engine decides **what to run next** (order, parallelism, rework, gate routing). Claude Code **executes** each action — spawning a subagent per skill, routing each gate to its human reviewer — then feeds results back.

### When to invoke

Use trigger phrases like: *"orchestrate these skills"*, *"run the planning/build/validate phases"*, *"execute the sprint workflow"*, *"plan this run first"*, *"estimate the cost before running"*, *"dry-run the workflow"*, *"what skills do we actually need"*, or any pipeline of named skills with gates and artifacts.

### Plan mode — think first, act later

Before committing to a run, plan mode analyzes the workflow spec against a free-text requirements statement **without invoking any skill**:

```bash
python -m skill_orchestrator.cli plan \
  --spec examples/aaxon/aaxon-sprint.workflow.json \
  --requirements "CRUD expense service; 1000 concurrent users, p95 < 300ms." \
  --report plan-report.md --config run-config.json
```

It (1) explores the artifact dependency graph; (2) dry-runs the scheduler to lay out the wave-by-wave plan and estimated makespan; (3) estimates **tokens and cost** (base + worst-case-with-rework) from each task's budget; (4) raises **clarifying questions** (scope, AI features, NFR targets); and (5) **recommends skills to include or exclude** (e.g. drop `spec-impact-analyzer` with no spec diff, drop `prompt-bench` with no AI features).

Two-pass flow: first pass → `needs_input` (questions listed, run config not yet persisted); second pass with `--answers answers.json` → `ready` (finalized run config written, ready for `init`).

### Control loop

```
init ─▶ next ─▶ [skills → subagents, gates → human reviewers] ─▶ record ─▶ … ─▶ report
         ▲                                                           │
         └───────────────────────────────────────────────────────────┘  loop until complete
```

State persists as JSON after every `record` — runs survive across turns.

### AAxon phase mapping

| Phase | Skills (tasks) | Gates |
|-------|----------------|-------|
| **Planning** | ContextFabric, PolicyCatalog, ResearchCopilot, TransformIQ, AssumptionTracker, SpecFlow, TraceGraph, SpecImpactAnalyzer, ValueModeler, PortfolioPrioritizer, ScenarioPlanner, DecisionLedger, Conductor | Gate 0 (openspec lock), Gate 0.5 (assumption sign-off), Gate 1 (plan sign-off) |
| **Build** | SecretShield, PerformanceOptimizer, ExperienceStudio, TrustFabric, KnowledgeMesh, DevCopilot, ReviewPilot, PromptBench, NexusDeploy | Gate 2 (design sign-off) |
| **Validate** | EvalHarness, Guardian, RedTeamX, SimLab, PolicyEnforcer, InsightOps | Gate 2 (feature sign-off), Gate 3 (release) |

### CLI quick-start

```bash
# Plan mode (optional but recommended)
python -m skill_orchestrator.cli plan   --spec aaxon-sprint.workflow.json --requirements "..." --report plan.md --config run-config.json

# Run mode
python -m skill_orchestrator.cli init   --spec run-config.json --state state.json
python -m skill_orchestrator.cli next   --state state.json          # → wave JSON (parallel or gate)
# … run the wave, write results.json …
python -m skill_orchestrator.cli record --state state.json --results results.json --governor-db gov.db
python -m skill_orchestrator.cli status --state state.json
python -m skill_orchestrator.cli report --state state.json          # add --json for machine-readable
```

### Governance

Pass `--governor-db gov.db` to `record` to persist each skill task into the vendored `skill_governor`, yielding unified per-skill telemetry (FTR rate, reruns, token spend) alongside the per-phase orchestrator report.

Sample combined-sprint report (29 skills / 6 gates):

```
skill tasks      : 29  (done=29, failed=0, skipped=0, completion=100.0%)
first-time-right : 26/29  (rate=89.7%)
rework           : 2 cycle(s)
HITL gates       : 6/6 approved
schedule         : makespan=159.8s; waves=24; avg parallelism=1.62

BY PHASE
  planning  tasks=13  done=13  ftr=13  rework=0  gates=3/3
  build     tasks=9   done=9   ftr=8   rework=1  gates=1/1
  validate  tasks=7   done=7   ftr=5   rework=1  gates=2/2
```

### Location

`.claude/skill-orchestrator/` — install by copying the folder into your project's `.claude/` directory.

---

## Cross-Phase Artifact Flow

```
Phase 1                      Phase 2                  Phase 3               Phase 4           Phase 5
────────                     ───────                  ───────               ───────           ───────
specs/program.md  ─►         context.yaml        ─►  eval-rubric.yaml ─►  release-intel ─►  drift-report
specs/knowledge.md ─►        policy-catalogue.yaml ─► test-results.json    parity-check       sla-dashboard
specs/design.md   ─►         task-breakdown.yaml  ─►  validation-report ─► rollout-strategy   incident-log
specs/api.md      ─►         ai-manifest.json     ─►  deploy-manifest  ─►  [LOCKED]      ─►  runbooks
specs/database.md ─►         sprint-board.md
openspec.yaml     ──────────────────────────────────────────────────────────────────────────► feedback-loop
                                                                                                triggers.yaml
```

---

## Installation

### Step 1 — Copy skill files

```bash
cp -r .claude/ /path/to/your-project/.claude/
cp -r operate/ /path/to/your-project/operate/
```

### Step 2 — Create required directories

```
your-project/
├── specs/          ← specification files (Phases 1–2)
├── artifacts/      ← planning + build + release artifacts (Phases 1, 3–4)
│   └── release/    ← release artifacts (Phase 4)
├── operate/        ← operations artifacts (Phase 5)
├── tests/          ← generated test files (Phase 3)
│   ├── load/
│   └── chaos/
└── .claude/        ← all skill SKILL.md files
```

### Step 3 — Set environment variables

```bash
export ANTHROPIC_API_KEY="sk-ant-..."      # Required for DriftGuard and script mode
export ALERT_WEBHOOK_URL="https://..."     # Slack / Teams webhook
export METRICS_ENDPOINT="http://..."       # Prometheus or observability endpoint
```

### Step 4 — Install Python dependencies (script mode only)

```bash
pip install anthropic requests pyyaml

# Optional, stack-specific
pip install prometheus-client      # Prometheus integration
pip install datadog                # Datadog integration
pip install sqlalchemy psycopg2-binary  # ValueTracker database metrics
```

---

## Model Selection Reference

| Model | Used For | Reason |
|-------|----------|--------|
| **Opus 4** | SpecFlow | Deep multi-requirement reasoning across 120K context |
| **Sonnet 4** | Conductor, SpecImpactAnalyzer, TransformIQ, ResearchCopilot, ValueModeler, PortfolioPrioritizer, ScenarioPlanner, ContextFabric, ExperienceStudio, DevCopilot, ReviewPilot, Guardian, AxiomTestGen, EvalHarness (validate), RedTeamX, InsightOps, ReleaseIntel, RolloutAdvisor, DriftGuard, RunbookSynth, IncidentLens, ValueTracker, ExperimentOps | Balanced reasoning + speed; primary workhorse |
| **Haiku 4.5** | TraceGraph, PolicyCatalog, DecisionLedger, AssumptionTracker, KnowledgeMesh, TrustFabric, PromptBench, SecretShield, PerformanceOptimizer, NexusDeploy, SimLab, PolicyEnforcer, ParityChecker, RuntimeIQ, ControlPlane | High-speed, lower-complexity mapping/logging/scanning tasks |

---

*Automation30 Framework · Aligned Automation · Confidential*
