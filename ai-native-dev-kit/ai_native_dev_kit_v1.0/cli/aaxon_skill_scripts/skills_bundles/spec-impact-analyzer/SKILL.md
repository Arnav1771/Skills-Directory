---
name: spec-impact-analyzer
description: Analyzes proposed spec changes to quantify downstream artifact impact, estimate rework effort in builder-hours, classify risk, and produce a POD Lead proceed/defer/escalate recommendation.
---

# SpecImpactAnalyzer

**AAxon phase:** 02-Data-Readiness

## Purpose

Traces the full downstream impact of a proposed openspec.yaml change across all existing artifacts, estimates regeneration and retest effort, classifies change risk, and flags any closed HITL gates that would be invalidated — giving the POD Lead a data-driven proceed/defer/escalate decision in under 10 minutes.

## Capabilities

- Diff parsing classifying changes as ADDITIVE, MODIFICATIVE, DESTRUCTIVE, or NFR CHANGE
- Ripple tracing through traceability-report.md with transitive dependency expansion
- Effort estimation per affected artifact (code regeneration, test regeneration, integration retest, gate re-attestation) with ±30% variance range
- Risk classification: IN-SPRINT SAFE / DEFER TO NEXT SPRINT / SCOPE RISK / ESCALATE
- Rework scope patch generation when change is approved

## Owned Responsibilities

- Spec change downstream impact analysis
- Artifact ripple detection across clusters and tests

## Inputs

Mandatory:
    - artifacts/openspec.yaml (current): Locked sprint spec
    - artifacts/openspec-proposed.yaml OR inline diff: Proposed change
    - artifacts/ai-manifest.json: All existing artifacts with spec IDs (from SpecFlow)
    - artifacts/traceability-report.md: Artifact dependency graph (from TraceGraph)
    - artifacts/task-breakdown.yaml: Current task assignments (from SpecFlow)
    - artifacts/decision-ledger.md: Closed HITL gates to check for invalidation
    - specs/spec.md: Master specification
  Optional:
    - tests/*.feature: For test regeneration estimation

## Outputs

- artifacts/impact-analysis.md: Affected artifacts, HITL gate impact, effort estimate, risk classification, recommendation
- artifacts/rework-scope-patch.yaml: Re-queue list for Conductor (generated only if change is approved)

## Dependencies

- SpecFlow: Provides ai-manifest.json and task-breakdown.yaml
- TraceGraph: Provides traceability-report.md
- DecisionLedger: Provides decision-ledger.md for gate invalidation check

## Constraints

- Effort estimates are heuristic; POD Lead makes the final proceed/defer decision
- Cannot detect semantic impact from wording changes that look minor but have large architectural implications; flag for manual review
- First sprint has no historical baseline for estimation accuracy

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
