---
name: research-copilot
description: Validates sprint requirements against discovery evidence, classifying evidence strength per requirement and escalating weak or contradicted requirements to AssumptionTracker.
---

# ResearchCopilot

**AAxon phase:** 02-Data-Readiness

## Purpose

Validates each draft requirement against available discovery evidence — interviews, analytics, support tickets, and prior sprint reports — classifying evidence strength, surfacing contradictions, and flagging weak-evidence requirements as AssumptionTracker candidates.

## Capabilities

- Evidence source indexing (qualitative interviews, analytics exports, support tickets, prior sprint reports)
- Per-requirement cross-reference against evidence index
- Evidence strength classification: CONFIRMED / PARTIAL / WEAK / CONTRADICTED / NO-EVIDENCE
- Contradiction detection with MINOR / MAJOR / BLOCKING severity
- AssumptionTracker escalation for WEAK, CONTRADICTED, and NO-EVIDENCE requirements

## Owned Responsibilities

- Sprint requirement evidence validation
- Discovery evidence synthesis and classification

## Inputs

Mandatory:
    - artifacts/openspec.yaml: Draft requirements to validate
    - specs/knowledge.md: Domain context and prior research signals
    - specs/features.md: Feature intent context
  Optional:
    - Interview transcripts or meeting notes
    - Analytics exports / usage telemetry
    - Prior sprint validation reports
    - Support ticket exports

## Outputs

- artifacts/evidence-map.md: Per-requirement evidence strength classification with citations and AssumptionTracker escalation list

## Dependencies

- AssumptionTracker: Receives escalation of WEAK/CONTRADICTED/NO-EVIDENCE requirements

## Constraints

- Only as good as the evidence inputs provided; tribal knowledge without transcript input is invisible
- Evidence older than 90 days is automatically downweighted to WEAK unless corroborated by a recent source
- Classification is heuristic; identifies signals, not legal proof of user need
- BLOCKING contradictions prevent requirement dispatch until resolved

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
