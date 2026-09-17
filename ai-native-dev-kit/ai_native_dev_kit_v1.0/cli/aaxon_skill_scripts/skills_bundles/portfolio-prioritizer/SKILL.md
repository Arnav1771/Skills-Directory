---
name: portfolio-prioritizer
description: Ranks all sprint backlog candidates using weighted composite scoring and draws a capacity cut line, producing a PROCEED/DEFERRED/BORDERLINE ranked scope list with defer rationale.
---

# PortfolioPrioritizer

**AAxon phase:** 02-Data-Readiness

## Purpose

Ranks all sprint backlog candidates using a composite score of business value, urgency, strategic alignment, dependency enablement, and risk reduction, then draws a capacity cut line to determine what ships this sprint versus deferred to the next.

## Capabilities

- Unified candidate inventory combining task-breakdown requirements and TransformIQ candidates
- Composite scoring with five dimensions and POD Lead-configurable strategic weights
- Must-ship override insertion at top of ranked list
- Dependency cluster locking (clusters score as their weakest item)
- Capacity cut line calculation with configurable buffer
- BORDERLINE item flagging for POD Lead judgment
- Defer rationale generation per deferred item

## Owned Responsibilities

- Sprint backlog ranking and prioritization
- Capacity allocation and cut line determination
- Defer decision documentation with rationale

## Inputs

Mandatory:
    - artifacts/roi-brief.md: Value/effort ratio per requirement (from ValueModeler)
    - artifacts/task-breakdown.yaml: Candidate requirements with effort estimates (from SpecFlow)
    - artifacts/traceability-report.md: Dependency graph for cluster locking (from TraceGraph)
    - artifacts/opportunity-backlog-rescored.md: Candidate additions (from TransformIQ)
    - specs/features.md: Feature context and priority signals
    - specs/program.md: Programme objectives for strategic alignment scoring

## Outputs

- artifacts/sprint-scope-ranked.md: Ranked scope with PROCEED/DEFERRED/BORDERLINE classification and rationale

## Dependencies

- ValueModeler: Provides roi-brief.md
- SpecFlow: Provides task-breakdown.yaml
- TraceGraph: Provides traceability-report.md
- TransformIQ: Provides opportunity-backlog-rescored.md

## Constraints

- Scoring weights must be calibrated by humans; stale weights produce misleading rankings
- Political priorities and stakeholder relationships not in the spec cannot be inferred; apply manually via overrides
- Recommends only; POD Lead makes the final scope decision
- Proposed status: scoring model and weighting criteria require stakeholder alignment before production use

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
