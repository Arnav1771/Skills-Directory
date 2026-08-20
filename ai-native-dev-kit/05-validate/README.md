# AAxon Validate Phase — Skill Package
**Version 2.1.0 | Aligned Automation | Confidential**

---

## What This Package Contains

Six AI skill definitions for the AAxon Framework **Validate Phase** (Sprint Days 2–5, Tuesday–Thursday continuous + Friday gate). These skills are consumed by the POD Lead and AI Builders to run automated, parallel validation before any artifact enters the Release phase.

| Skill | Agent ID | Purpose | Model |
|-------|----------|---------|-------|
| [Guardian](#guardian) | V-01 | Test generation, execution, failure triage | Sonnet 4 |
| [EvalHarness](#evalharness) | V-02 | Shared semantic evaluation framework | Sonnet 4 |
| [RedTeamX](#redteamx) | V-03 | Adversarial and safety testing | Sonnet 4 |
| [SimLab](#simlab) | V-04 | Load, chaos, resilience simulation | Haiku 4.5 |
| [PolicyEnforcer](#policyenforcer) | V-05 | Compliance scanning and policy gate | Haiku 4.5 |
| [InsightOps](#insightops) | V-06 | Failure pattern synthesis, spec gap ID | Sonnet 4 |

---

## Prerequisites

Before running any Validate phase skill, confirm the following Phase 3 (Planning) outputs exist and are locked:

| File | Produced By | Required By |
|------|-------------|-------------|
| `artifacts/openspec.yaml` | POD Lead (Gate 0) | All 6 skills |
| `artifacts/ai-manifest.json` | SpecFlow | Guardian, RedTeamX |
| `artifacts/traceability-report.md` | TraceGraph | Guardian, InsightOps |
| `artifacts/task-breakdown.yaml` | SpecFlow | SimLab |
| `artifacts/policy-catalogue.yaml` | PolicyCatalog | PolicyEnforcer |
| `artifacts/deploy-manifest.yaml` | Build phase | SimLab |

If `openspec.yaml` is not locked (Gate 0 not cleared), **no Validate skill will proceed**.

---

## Installation

Copy the six skill directories to your project's `.claude/` folder:

```
your-project/
└── .claude/
    ├── guardian/
    │   └── SKILL.md
    ├── eval-harness/
    │   └── SKILL.md
    ├── red-team-x/
    │   ├── SKILL.md
    │   └── references/
    │       └── adversarial-vector-library.yaml   ← copy this too
    ├── sim-lab/
    │   └── SKILL.md
    ├── policy-enforcer/
    │   └── SKILL.md
    └── insight-ops/
        └── SKILL.md
```

---

## Execution Order

The skills must be run in a specific sequence to ensure each agent has the inputs it needs. Do not run InsightOps until all five preceding agents have produced outputs.

```
TUESDAY — Gate 2 (pre-build)
─────────────────────────────────────────────────────────────────────
Step 1  EvalHarness     Define rubric + elicit golden references
        ↓ produces: artifacts/eval-rubric.yaml

Step 2  Guardian        Generation Mode — produce .feature files from openspec
        ↓ produces: tests/*.feature, artifacts/coverage-report.md

        POD Lead reviews .feature files ← GATE 2 SIGN-OFF REQUIRED

WEDNESDAY–THURSDAY — Continuous (parallel to Build)
─────────────────────────────────────────────────────────────────────
Step 3  Guardian        Execution Mode — runs continuously as code lands
        ↓ produces: artifacts/test-results.json (updated continuously)

Step 4  RedTeamX        Once AI-facing components available from Build
        ↓ produces: artifacts/adversarial-test-suite.json,
                    artifacts/vulnerability-report.md

Step 5  SimLab          Once endpoints available from Build
        ↓ produces: tests/load/*, tests/chaos/*,
                    artifacts/simlab-results.json, artifacts/nfr-verdict.md

Step 6  PolicyEnforcer  Once src/ available from Build
        ↓ produces: artifacts/policy-scan-report.md,
                    artifacts/compliance-attestation.md

THURSDAY END OF DAY — Synthesis
─────────────────────────────────────────────────────────────────────
Step 7  InsightOps      After all 5 agents have produced outputs
        ↓ produces: artifacts/validation-report.md  ← PRIMARY OUTPUT
                    artifacts/spec-amendments.md
                    artifacts/action-list.md

FRIDAY — Gate 3 (Release)
─────────────────────────────────────────────────────────────────────
        POD Lead reviews validation-report.md ← GATE 3 SIGN-OFF
        Release proceeds only if gate criteria are met
```

---

## Skill Usage Guide

---

### Guardian

**What it does:** Converts acceptance criteria from `openspec.yaml` into executable Gherkin `.feature` files and continuously executes them as code is built. Every test failure is triaged into exactly one of three categories: `SPEC_ERROR`, `CODE_ERROR`, or `ENV_ERROR`.

**When to invoke:**
```
"Generate tests for this sprint"
"Run Guardian"
"Create feature files from the spec"
"Execute the test suite and triage failures"
```

**Modes:**
- **Generation Mode** (Tuesday, pre-build): Produces `.feature` files. No source code required.
- **Execution Mode** (Wednesday–Thursday): Runs tests against available `src/` modules.

**POD Lead actions required:**
1. Clarify ambiguous acceptance criteria when Guardian asks (pre-generation)
2. Review generated `.feature` files before Gate 2 clears
3. Triage any `UNTRIAGED` failures Guardian cannot classify

**Release gate contribution:** `artifacts/coverage-report.md`
- Gate passes if: coverage ≥ 80% AND zero untriaged failures

**Key output files:**
```
tests/*.feature                      Gherkin scenarios (one file per feature)
artifacts/test-results.json          Pass/fail per scenario with triage categories
artifacts/coverage-report.md         Requirement coverage % + gate verdict
```

---

### EvalHarness

**What it does:** Defines a consistent LLM-as-judge scoring rubric for all semantic quality evaluation in the sprint. It is the shared evaluation backbone consumed by Guardian, RedTeamX, and SimLab — ensuring "quality" means the same thing regardless of which agent is scoring.

**When to invoke:**
```
"Set up the evaluation rubric for this sprint"
"EvalHarness"
"Define golden references for [feature]"
"Score these AI outputs"
"Check for evaluation drift from last sprint"
```

**Must run before Guardian execution mode** — Guardian uses `eval-rubric.yaml` to score AI outputs within test scenarios.

**POD Lead actions required:**
1. Define golden reference outputs for each feature that requires semantic evaluation (mandatory — EvalHarness cannot score without references)
2. Set minimum acceptable scores per dimension
3. Approve or recalibrate rubric if drift is detected from prior sprint

**How to provide golden references:**
> When EvalHarness asks, provide either:
> - A sample ideal response to a representative input
> - Minimum score thresholds per dimension (accuracy, completeness, tone, safety, groundedness)
> - A reference to a prior sprint's golden output

**Release gate contribution:** `artifacts/eval-summary.md`
- Gate passes if: sprint weighted score ≥ `pass_threshold` defined in rubric

**Key output files:**
```
artifacts/eval-rubric.yaml           Compiled rubric — consumed by Guardian, RedTeamX, SimLab
artifacts/eval-results.json          Per-output scores with rationale
artifacts/eval-summary.md            Sprint-level semantic quality verdict
artifacts/eval-drift-alert.md        Written only if scoring drift detected vs. prior sprint
```

---

### RedTeamX

**What it does:** Subjects every AI-facing component to systematic adversarial attack using a 24-vector library across 6 attack categories. Classifies each component as ROBUST, DEGRADED, or VULNERABLE per attack vector.

**When to invoke:**
```
"Run adversarial tests"
"RedTeamX"
"Test [component] for prompt injection"
"Safety test the extraction engine"
"Check for vulnerabilities in AI components"
```

**Requires:** `eval-rubric.yaml` from EvalHarness (for safety dimension scoring). Run EvalHarness first.

**Attack categories covered:**
1. Prompt Injection
2. Jailbreak / Role Confusion
3. PII Extraction Probes
4. Data Exfiltration
5. Boundary Manipulation
6. Semantic Manipulation

**POD Lead actions required:**
1. Confirm component list and add any domain-specific attack scenarios when prompted
2. Immediately review any **VULNERABLE** finding — these are Release gate hard blockers
3. Sign off CONDITIONAL verdict (zero VULNERABLE, some DEGRADED) to proceed

**VULNERABLE finding protocol:**
> If RedTeamX identifies a VULNERABLE component, it stops and notifies the POD Lead immediately. The builder assigned to that component must remediate before RedTeamX re-runs. No release proceeds with an unresolved VULNERABLE finding.

**Adding custom vectors:** If you have domain-specific attack patterns (e.g., financial fraud, medical data manipulation), add them to `references/adversarial-vector-library.yaml` following the existing format.

**Release gate contribution:** `artifacts/redteam-summary.md`
- SAFE (0 VULNERABLE, ≤10% DEGRADED): passes
- CONDITIONAL (0 VULNERABLE, 11-25% DEGRADED): passes with POD Lead sign-off
- BLOCKED (any VULNERABLE or >25% DEGRADED): hard block

**Key output files:**
```
artifacts/adversarial-test-suite.json   All attack vectors with per-component results
artifacts/vulnerability-report.md       Human-readable findings + remediation guidance
artifacts/redteam-summary.md            Sprint safety verdict for Release gate
```

---

### SimLab

**What it does:** Generates load test scripts and chaos scenarios from the NFR targets in `openspec.yaml`, then validates circuit-breaker and fallback behaviour. Produces p50/p95/p99 latency and error rate metrics against the staging environment.

**When to invoke:**
```
"Run load tests"
"SimLab"
"Validate NFR targets"
"Test circuit-breaker behaviour"
"What's the p95 latency under load?"
"Failure injection for [dependency]"
```

**Requires `openspec.yaml` to have an NFR block.** If missing, SimLab will prompt the POD Lead for:
- Target and peak concurrent users
- p95 latency target (ms)
- Error rate ceiling (%)
- Dependency list and circuit-breaker specifications

**Generated test frameworks:**
- Default: **k6** (JavaScript)
- Specify alternative in `openspec.yaml` under `nfr.test_framework`: `locust | jmeter | gatling`

**Environment equivalence requirement:**
> SimLab results are only valid as Release gate evidence if the POD Lead confirms the staging environment is equivalent to production. This confirmation must be documented in `artifacts/nfr-verdict.md`.

**POD Lead actions required:**
1. Provide NFR targets if not in openspec
2. Confirm staging ↔ production equivalence before accepting results
3. Sign off on any WARN results (latency > target by ≤ 20%)

**Release gate contribution:** `artifacts/nfr-verdict.md`
- PASS: all metrics meet targets
- WARN: latency >target by ≤20% — requires POD Lead sign-off
- FAIL: any metric exceeds target — blocks Release

**Key output files:**
```
tests/load/*.js                      Generated k6 load test scripts
tests/chaos/*.js                     Generated failure injection scripts
artifacts/simlab-results.json        Raw metrics — p50/p95/p99 + failure injection
artifacts/nfr-verdict.md             Human-readable NFR pass/fail with gate input
```

---

### PolicyEnforcer

**What it does:** Scans generated source code (static) and runtime logs (behavioural) against `policy-catalogue.yaml`. Enforces a hard gate: zero critical and zero high violations required for Release.

**When to invoke:**
```
"Run compliance scan"
"PolicyEnforcer"
"Scan the code for GDPR violations"
"Check for hardcoded secrets"
"Policy gate"
"Is the code compliant?"
```

**Requires `policy-catalogue.yaml` from the PolicyCatalog skill (Phase 3).** If absent, PolicyEnforcer will prompt the POD Lead to generate or provide the catalogue before scanning.

**Two scan modes (both run by default):**
- **Static:** Source code pattern matching — PII in logs, hardcoded secrets, injection risks, CVEs
- **Runtime:** Log analysis — PII in API responses, auth gaps, error message leakage

**Keeping the catalogue current:**
> PolicyEnforcer only enforces what is in the catalogue. New regulatory requirements (new GDPR guidance, new internal security policies) must be added to `policy-catalogue.yaml` by the POD Lead or compliance owner before they are enforceable.

**Severity and gate impact:**
| Severity | Gate Impact |
|----------|-------------|
| Critical | Hard blocks Release |
| High | Hard blocks Release |
| Medium | Logged — next sprint backlog |
| Informational | Advisory only |

**Release gate contribution:** `artifacts/compliance-attestation.md`
- Gate passes if: critical_violations == 0 AND high_violations == 0

**Key output files:**
```
artifacts/policy-scan-report.md      Full violation list with remediation guidance
artifacts/policy-scan-results.json   Machine-readable results for InsightOps
artifacts/compliance-attestation.md  Release gate attestation with POD Lead sign-off
```

---

### InsightOps

**What it does:** Aggregates all five validation agent outputs, identifies cross-agent failure patterns, traces patterns to root causes in `openspec.yaml`, and produces a consolidated action list for the POD Lead. Replaces 2–3 hours of manual synthesis.

**When to invoke:**
```
"Synthesise validation results"
"InsightOps"
"Generate the validation report"
"What failed this sprint and why?"
"Priority action list"
"Identify spec gaps"
```

**Must run last** — InsightOps requires all five upstream agent outputs. It performs a completeness check and will not proceed if any are missing.

**What InsightOps detects that individual agents cannot:**
- The same component failing across multiple test types (cross-agent correlation)
- Multiple SPEC_ERROR triages pointing to the same spec gap
- Semantic quality decline correlated with functional failures (combined regression)
- Environmental failures masking code defects (ENV_ERROR pattern)
- Quality drift from prior sprint on specific features

**Spec amendment recommendations:**
> InsightOps recommends specific `openspec.yaml` amendments using requirement IDs. These are starting points — the POD Lead must review, validate, and commit the amendments. Amended requirements re-enter Guardian's next-sprint Generation Mode automatically.

**POD Lead actions required:**
1. Review the priority action list (`artifacts/action-list.md`) and assign to owners
2. Decide: accept or reject each spec amendment recommendation
3. Sign off `validation-report.md` before Release gate proceeds

**Release gate contribution:** `artifacts/validation-report.md`
- This is the primary Release gate document
- Consolidates all five agent verdicts into a single sign-off document

**Key output files:**
```
artifacts/validation-report.md         Consolidated sprint quality summary ← PRIMARY
artifacts/spec-amendments.md           Specific openspec.yaml amendment recommendations
artifacts/action-list.md               POD Lead-ready action list with owners + effort
artifacts/feedback-loop-triggers.yaml  Next sprint's requirements session seed (Operate feed)
```

---

## Release Gate Checklist (Gate 3)

The POD Lead uses this checklist every Friday before authorising Release:

```
□ Guardian
  □ artifacts/coverage-report.md exists and shows coverage ≥ 80%
  □ artifacts/test-results.json shows zero UNTRIAGED failures
  □ All CODE_ERROR and SPEC_ERROR items resolved or accepted

□ EvalHarness
  □ artifacts/eval-summary.md shows sprint score ≥ pass_threshold
  □ No unresolved drift alerts in artifacts/eval-drift-alert.md

□ RedTeamX
  □ artifacts/redteam-summary.md shows SAFE or CONDITIONAL
  □ If CONDITIONAL: POD Lead signature present in redteam-summary.md
  □ Zero VULNERABLE findings

□ SimLab
  □ artifacts/nfr-verdict.md shows PASS or WARN
  □ If WARN: POD Lead signature present in nfr-verdict.md
  □ Staging equivalence confirmed and documented

□ PolicyEnforcer
  □ artifacts/compliance-attestation.md shows 0 critical, 0 high violations
  □ POD Lead signature present in compliance-attestation.md

□ InsightOps
  □ artifacts/validation-report.md exists and is current sprint
  □ All RED aggregate signals resolved or accepted with rationale
  □ Spec amendments reviewed and POD Lead decision recorded
  □ Priority action list items 1–N (blocking) completed

□ POD Lead final sign-off on artifacts/validation-report.md
```

---

## Common Errors and Resolutions

| Error | Likely Cause | Resolution |
|-------|-------------|------------|
| `openspec.yaml not found or unlocked` | Gate 0 not cleared | POD Lead locks openspec before Validate begins |
| `EvalHarness: no golden reference for FEAT-XXX` | POD Lead hasn't defined references | Follow EvalHarness HITL prompt to define golden outputs |
| `Guardian: UNTRIAGED failure` | Ambiguous failure — unclear if spec, code, or env | POD Lead classifies manually using triage decision tree |
| `RedTeamX: VULNERABLE finding` | AI component exploitable | Builder remediates; RedTeamX re-runs that vector |
| `SimLab: no NFR block in openspec` | NFRs not defined in spec | POD Lead adds NFR block to openspec or provides values via SimLab prompt |
| `PolicyEnforcer: no policy-catalogue.yaml` | Phase 3 PolicyCatalog not run | Run PolicyCatalog skill to generate catalogue from openspec |
| `InsightOps: missing upstream outputs` | One or more agents not yet run | Run all 5 agents before invoking InsightOps |

---

## Validate Phase Artefact Map

```
openspec.yaml (LOCKED)
    │
    ├──► EvalHarness ──────────────────► eval-rubric.yaml
    │                                         │
    ├──► Guardian ──────── eval-rubric.yaml ──► test-results.json
    │        │                                  coverage-report.md
    │        └── tests/*.feature
    │
    ├──► RedTeamX ──────── eval-rubric.yaml ──► adversarial-test-suite.json
    │                                           vulnerability-report.md
    │
    ├──► SimLab ────────────────────────────► simlab-results.json
    │        │                                nfr-verdict.md
    │        └── tests/load/, tests/chaos/
    │
    ├──► PolicyEnforcer ─────────────────► policy-scan-results.json
    │        │                             compliance-attestation.md
    │        └── src/ (scanned)
    │
    └──► InsightOps ◄────── all above outputs
             │
             └──► validation-report.md  ◄── RELEASE GATE PRIMARY DOCUMENT
                  spec-amendments.md
                  action-list.md
                  feedback-loop-triggers.yaml
```

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.1.0 | 2025-05-27 | Initial Validate phase skill package |

---

*AAxon Framework v2.1.0 · Aligned Automation · Validate Phase Skills · Confidential*
