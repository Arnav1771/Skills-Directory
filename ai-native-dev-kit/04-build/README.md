# AAxon Build Phase Skills
## Version 2.1.0 | Aligned Automation | Confidential

This package contains the **9 build-phase skill definitions** for the AAxon Framework. These skills power the Tuesday–Thursday build cycle of each sprint, covering every stage from design validation through deployment manifest generation.

---

## Prerequisites

Before using any build-phase skill, the following Phase 3 planning artifacts must exist in `artifacts/`:

| File | Produced by | Required by |
|------|------------|-------------|
| `artifacts/openspec.yaml` | POD Lead | ALL skills |
| `artifacts/task-breakdown.yaml` | SpecFlow | DevCopilot, PerformanceOptimizer, NexusDeploy |
| `artifacts/sprint-capacity.yaml` | POD Lead | PerformanceOptimizer |
| `artifacts/ai-manifest.json` | Prior sprint / NexusDeploy | KnowledgeMesh, DevCopilot, NexusDeploy |
| `artifacts/policy-catalogue.yaml` | PolicyCatalog | DevCopilot, TrustFabric |
| `artifacts/decision-ledger.md` | DecisionLedger | KnowledgeMesh |

And the following Phase 2 spec files in `specs/`:

| File | Required by |
|------|------------|
| `specs/ui-ux.md` | ExperienceStudio |
| `specs/design.md` | DevCopilot, KnowledgeMesh |
| `specs/api.md` | DevCopilot, KnowledgeMesh, TrustFabric |
| `specs/database.md` | DevCopilot, KnowledgeMesh, TrustFabric |
| `specs/knowledge.md` | KnowledgeMesh |
| `specs/features.md` | KnowledgeMesh, ExperienceStudio |
| `specs/impl.md` | KnowledgeMesh, DevCopilot |

---

## Skill Index

| # | Skill | Agent ID | Model | Token Budget | Primary Role |
|---|-------|----------|-------|-------------|-------------|
| 1 | [ExperienceStudio](#1-experiencestudio) | B-01 | claude-sonnet-4 | ~45K | UX intent validation, Gate 2 design sign-off |
| 2 | [KnowledgeMesh](#2-knowledgemesh) | B-02 | claude-haiku-4-5 | ~60K | RAG context backbone for all build agents |
| 3 | [TrustFabric](#3-trustfabric) | B-03 | claude-haiku-4-5 | ~30K | PII classification and data contract governance |
| 4 | [DevCopilot](#4-devcopilot) | B-04 | claude-sonnet-4 | ~50K | IDE-time implementation assistant |
| 5 | [ReviewPilot](#5-reviewpilot) | B-05 | claude-sonnet-4 | ~70K | Automated PR review and spec conformance |
| 6 | [PromptBench](#6-promptbench) | B-06 | claude-haiku-4-5 | ~40K | Prompt and model benchmarking |
| 7 | [SecretShield](#7-secretshield) | B-07 | claude-haiku-4-5 | ~15K | Credential scrubbing before LLM injection |
| 8 | [PerformanceOptimizer](#8-performanceoptimizer) | B-08 | claude-haiku-4-5 | ~20K | Model routing and token budget enforcement |
| 9 | [NexusDeploy](#9-nexusdeploy) | B-09 | claude-haiku-4-5 | ~25K | Artifact registry and deploy manifest |

---

## Sprint Day-by-Day Usage

### Tuesday — Design Validation Day

**Step 1: SecretShield** (implicit — always active)
> SecretShield runs automatically on all context payloads. No explicit invocation needed.

**Step 2: KnowledgeMesh — Build the context index**
```
Run KnowledgeMesh to build the sprint context index.
Source files: specs/design.md, specs/api.md, specs/database.md,
              specs/knowledge.md, artifacts/openspec.yaml,
              artifacts/task-breakdown.yaml, artifacts/decision-ledger.md
```
KnowledgeMesh produces `knowledge-mesh-index.md`. All downstream agents now retrieve through it.

**Step 3: ExperienceStudio — Gate 2 design sign-off**
```
Run ExperienceStudio.
Inputs: specs/ui-ux.md, artifacts/openspec.yaml
Provide: UI designs / wireframes / component code for review
```
ExperienceStudio produces `experience-conformance-report.md`. Gate 2 must pass before builders start coding UI.

**Step 4: TrustFabric — Data contract baseline**
```
Run TrustFabric on the sprint requirements.
Inputs: data-contracts/*.yaml, specs/database.md, artifacts/openspec.yaml
```
TrustFabric establishes the PII baseline. Any unclassified fields must be resolved now, not mid-sprint.

**Step 5: PerformanceOptimizer — Set sprint budget**
```
Run PerformanceOptimizer sprint setup.
Input: artifacts/sprint-capacity.yaml
```
PerformanceOptimizer loads the budget. It will now route all subsequent tasks automatically.

---

### Wednesday–Thursday — Build Days

**Per task (each AI Builder, for each task in `task-breakdown.yaml`):**

1. **PerformanceOptimizer routes the task** (automatic)
   - Input: task ID, complexity profile
   - Output: model routing decision

2. **KnowledgeMesh retrieves context** (called by DevCopilot)
   - Input: requirement ID, domain keywords
   - Output: relevant spec chunks

3. **SecretShield scans context payload** (automatic gate)
   - Input: assembled context
   - Output: sanitised context or block alert

4. **DevCopilot generates implementation**
   ```
   Implement TASK-[N] | Requirement: REQ-[ID]
   ```
   - Input: task context, KnowledgeMesh chunks, .cursorrules
   - Output: implementation code with provenance headers

5. **TrustFabric validates generated code** (called by DevCopilot)
   - Input: generated module
   - Output: compliance report or PII violation flags

6. **ReviewPilot reviews the PR**
   ```
   Review PR for TASK-[N] | Requirement: REQ-[ID]
   Provide: PR diff
   ```
   - Input: PR diff, openspec.yaml, .cursorrules
   - Output: structured review with blocking/advisory/informational findings

**For AI features only (any task involving prompt engineering):**

7. **PromptBench benchmarks prompt variants**
   ```
   Run PromptBench for feature REQ-AI-[ID]
   Provide: prompt variants, query sample set
   ```
   - Input: prompt variants, query samples, NFR targets
   - Output: `prompt-bench-report.md` with recommended winner

---

### Thursday EOD — Sprint Close-Out

**NexusDeploy — Completeness check and deploy manifest**
```
Run NexusDeploy sprint close-out.
Sprint: [sprint_id]
```
- Input: task-breakdown.yaml, ai-manifest.json, all review/compliance verdicts
- Output: sprint completeness report + `deploy-manifest.yaml` (if complete)

If NexusDeploy reports blockers, resolve them before end of day. The deploy manifest is the input to Friday's Release phase.

---

## HITL Gates Summary

| Gate | Skill | POD Lead Action |
|------|-------|----------------|
| Gate 2 — Design sign-off | ExperienceStudio | Review conformance report; approve or resolve revisions |
| Data contract gaps | TrustFabric | Classify unclassified fields in `data-contracts/*.yaml` |
| Spec ambiguity | DevCopilot | Resolve escalated ambiguity questions before generation continues |
| Budget alert (80%) | PerformanceOptimizer | Review recommendations; approve model downgrades or task deferrals |
| PR review judgment calls | ReviewPilot | Review UNTESTABLE findings; approve advisory deferrals |
| Prompt selection | PromptBench | Confirm recommended winner; override if business context requires |
| Sprint completeness | NexusDeploy | Resolve blockers; approve deploy manifest |
| Secret detection block | SecretShield | Investigate blocked payload; rotate credentials if real secret found |

---

## Skill Directory Structure

```
.claude/
├── experience-studio/
│   ├── SKILL.md
│   ├── references/
│   │   ├── ux-elicitation-questions.md
│   │   ├── journey-mapping-guide.md
│   │   └── conformance-scoring-rubric.md
│   ├── sample_input/
│   │   └── sample-ui-spec.md
│   └── sample_output/
│       └── sample-conformance-report.md
│
├── knowledge-mesh/
│   ├── SKILL.md
│   ├── references/
│   │   └── chunking-strategy.md
│   ├── sample_input/
│   │   └── sample-knowledge-query.yaml
│   └── sample_output/
│       └── sample-retrieval-response.yaml
│
├── trust-fabric/
│   ├── SKILL.md
│   ├── references/
│   │   └── data-contract-schema.md
│   ├── sample_input/
│   │   └── sample-data-contract.yaml
│   └── sample_output/
│       └── [generated at runtime]
│
├── dev-copilot/
│   ├── SKILL.md
│   ├── references/
│   │   ├── coding-conventions.md
│   │   └── stack-patterns.md
│   ├── sample_input/
│   └── sample_output/
│
├── review-pilot/
│   ├── SKILL.md
│   ├── references/
│   │   └── review-checklist.md
│   ├── sample_input/
│   └── sample_output/
│
├── prompt-bench/
│   ├── SKILL.md
│   ├── references/
│   │   ├── evaluation-methods.md
│   │   └── model-pricing.md
│   ├── sample_input/
│   └── sample_output/
│
├── secret-shield/
│   ├── SKILL.md
│   ├── references/
│   │   ├── secret-patterns.yaml
│   │   └── secret-whitelist.yaml
│   ├── sample_input/
│   └── sample_output/
│
├── performance-optimizer/
│   ├── SKILL.md
│   ├── references/
│   ├── sample_input/
│   │   └── sample-sprint-capacity.yaml
│   └── sample_output/
│
└── nexus-deploy/
    ├── SKILL.md
    ├── references/
    │   └── rollout-strategies.md
    ├── sample_input/
    └── sample_output/
```

---

## Output Files Registry
Files produced by build-phase skills (written to `artifacts/` unless noted):

| File | Produced by | Consumed by |
|------|------------|-------------|
| `experience-conformance-report.md` | ExperienceStudio | POD Lead, DevCopilot, ReviewPilot |
| `knowledge-mesh-index.md` | KnowledgeMesh | Internal (agents query through it) |
| `knowledge-mesh-invalidation.log` | KnowledgeMesh | POD Lead monitoring |
| `data-contract-compliance-report.md` | TrustFabric | POD Lead, ReviewPilot |
| `data-contract-violations.yaml` | TrustFabric | ReviewPilot, NexusDeploy |
| `unclassified-fields-report.md` | TrustFabric | POD Lead |
| `spec-ambiguity-escalation.log` | DevCopilot | POD Lead |
| `review-verdict.yaml` | ReviewPilot | NexusDeploy |
| `prompt-bench-report.md` | PromptBench | POD Lead, PerformanceOptimizer |
| `prompt-bench-nfr-evidence.yaml` | PromptBench | NexusDeploy |
| `secret-shield-redaction.log` | SecretShield | POD Lead (weekly review) |
| `token-consumption-report.yaml` | PerformanceOptimizer | POD Lead, next sprint calibration |
| `deploy-manifest.yaml` | NexusDeploy | Release phase CI/CD |
| `ai-manifest.json` (updated) | NexusDeploy | Next sprint KnowledgeMesh |

---

## Quick Reference: Invocation Phrases

| Skill | Invocation Example |
|-------|-------------------|
| ExperienceStudio | `"Run ExperienceStudio on LoginForm.tsx against REQ-UI-001"` |
| KnowledgeMesh | `"Build context index for sprint SP-007"` or `"Retrieve context for REQ-API-003"` |
| TrustFabric | `"Run TrustFabric on src/api/routes/users.py"` |
| DevCopilot | `"Implement TASK-042 | REQ-API-003 | POST /api/v1/users"` |
| ReviewPilot | `"Review PR feature/user-registration for REQ-API-003"` |
| PromptBench | `"Benchmark these 3 prompt variants for REQ-AI-001, sample set: [queries]"` |
| SecretShield | `"Scan this config file before injecting as context"` |
| PerformanceOptimizer | `"Route TASK-042 | complexity: MEDIUM | context: SMALL | output: CODE"` |
| NexusDeploy | `"Run NexusDeploy sprint close-out for SP-007"` |

---

## Skill Inter-Dependencies

```
SecretShield ──────────────────────────────────────────┐
                                                        ↓ (gate: all payloads)
KnowledgeMesh ──────── provides context ──────────► DevCopilot ──► ReviewPilot ──► NexusDeploy
     ↑                                                   ↑                               ↑
     │                                              TrustFabric ──────────────────────────┤
     │                                                   ↑                               │
ExperienceStudio ──────────────────────────────────────────────────────────────────────────┤
                                                                                           │
PromptBench ───────────────────────────────────────────────────────────────────────────────┤
                                                                                           │
PerformanceOptimizer ──── routes all generation tasks ──────────────────────────────────────┘
```

---

*AAxon Framework v2.1.0 · Aligned Automation · Build Phase Skills · Confidential*
