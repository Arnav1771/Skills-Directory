---
name: transform-iq
description: Rescores the AI opportunity backlog against current sprint context and prior sprint operational signals, surfacing top-value unmapped candidates for PortfolioPrioritizer consideration.
---

# TransformIQ

**AAxon phase:** 02-Data-Readiness

## Purpose

Rescores the AI opportunity backlog against the current sprint's requirements and operational signals from prior sprints, surfacing unmapped high-value candidates not yet in scope for PortfolioPrioritizer consideration.

## Capabilities

- Backlog scan identifying items already in scope vs. unmapped candidates
- Signal ingestion from prior sprint operational feedback (delivered value, underdelivery patterns, recurring pain points)
- Composite rescoring with five dimensions weighted by POD Lead strategic priorities
- Prior sprint calibration adjusting scores based on actual delivery vs. forecast
- Candidate surfacing above configurable value-density threshold
- Top-5 quick wins summary for business lead consumption

## Owned Responsibilities

- AI opportunity backlog rescoring per sprint
- Unmapped value candidate surfacing for PortfolioPrioritizer

## Inputs

Mandatory:
    - artifacts/openspec.yaml: Current sprint requirements for already-in-scope identification
    - specs/features.md: Features already planned
    - specs/program.md: Programme objectives for strategic fit scoring
    - references/opportunity-catalogue.yaml: Full AI opportunity backlog with historical scores
  Optional:
    - artifacts/feedback-loop-triggers.yaml: Prior sprint operational signals

## Outputs

- artifacts/opportunity-backlog-rescored.md: Rescored backlog with current sprint items, candidate additions above threshold, value density top-5 summary, and descored items

## Dependencies

- PortfolioPrioritizer: Receives opportunity-backlog-rescored.md as mandatory input

## Constraints

- Scoring accuracy depends on richness of operational feedback from prior sprints
- First sprint scores are approximations based on strategic weights alone
- Surfaces candidates only; PortfolioPrioritizer and POD Lead make the final inclusion decision

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
