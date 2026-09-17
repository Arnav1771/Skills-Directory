---
name: release-intel
description: Synthesizes sprint planning artifacts into a binary READY/NOT READY release verdict with blast-radius assessment per component and a prioritized P0–P3 open issues list.
---

# ReleaseIntel

**AAxon phase:** 04-AI-Solution-Deployment

## Purpose

Synthesizes planning artifacts into a binary release verdict with a structured blast-radius table, replacing the POD Lead's manual cross-referencing of five separate reports during Friday QA review and targeting a 30–45 minute review time.

## Capabilities

- Input audit and deployment scope extraction from sprint-board.md or deploy-manifest.yaml
- Readiness signal synthesis from traceability, scenario matrix, assumption log, and decision ledger
- Per-component blast-radius quantification across five dimensions: user segments, dependent features, integration points, data risk, rollback complexity
- Open issues classification: P0 (deploy blocker), P1 (high risk), P2 (medium risk), P3 (low risk)
- Binary release verdict: READY TO DEPLOY or NOT READY — BLOCKED

## Owned Responsibilities

- Release readiness synthesis
- Blast-radius assessment per deployed component
- Gate 3 evidence report

## Inputs

Mandatory:
    - artifacts/sprint-board.md: Task completion status (fallback if no deploy-manifest)
    - artifacts/task-breakdown.yaml: Task tree with component detail
  Strongly recommended:
    - artifacts/traceability-report.md: Requirements coverage
    - artifacts/scenario-matrix.md: Risk scenario assessment
  Recommended:
    - artifacts/assumption-log.md: Unresolved HITL blockers
    - artifacts/decision-ledger.md: Pending ADRs
    - specs/spec.md: Master specification
  Optional:
    - artifacts/release/deploy-manifest.yaml: Explicit deployment scope (priority 1 if present)

## Outputs

- artifacts/release/release-intel-report.md: Binary verdict with blast-radius table and open issues list

## Dependencies

- TraceGraph: Provides traceability-report.md
- ScenarioPlanner: Provides scenario-matrix.md
- AssumptionTracker: Provides assumption-log.md
- DecisionLedger: Provides decision-ledger.md
- SpecFlow: Provides task-breakdown.yaml

## Constraints

- Verdict appears first in the report; evidence follows
- Every blast-radius rating must cite a specific source artifact
- Deployment scope inferred from sprint-board.md must be declared as inference
- Informs the POD Lead; the Go/No-Go decision belongs to a named human

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
