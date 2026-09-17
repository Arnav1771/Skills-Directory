---
name: assumption-tracker
description: Scores sprint assumptions from ResearchCopilot evidence and openspec.yaml, flags low-confidence items as HITL gate blockers, and escalates risk-accepted items to DecisionLedger.
---

# AssumptionTracker

**AAxon phase:** 02-Data-Readiness

## Purpose

Ingests weak-evidence flags from ResearchCopilot and explicit assumptions in openspec.yaml, assigns a confidence score (0–1) to each assumption, flags low-confidence items as HITL gate blockers, tracks resolution throughout the sprint lifecycle, and escalates unresolved items to DecisionLedger for explicit risk acceptance.

## Capabilities

- Assumption inventory from openspec.yaml and evidence-map.md with deduplication
- Confidence scoring using evidence strength, prior sprint history, and dependency factors
- HITL blocker classification based on configurable threshold and risk posture
- Resolution tracking with VALIDATE / ACCEPT_RISK / DEFER / DESCOPE recommendations
- Escalation payload generation for DecisionLedger on risk-accepted assumptions

## Owned Responsibilities

- Sprint assumption confidence management
- HITL gate blocker identification and tracking
- Assumption resolution lifecycle

## Inputs

Mandatory:
    - artifacts/evidence-map.md: Weak-evidence flags from ResearchCopilot
    - artifacts/openspec.yaml: Sprint requirements with assumption tags
    - specs/knowledge.md: Domain-level assumption context
  Optional:
    - references/assumption-history.yaml: Prior sprint assumption resolutions

## Outputs

- artifacts/assumption-log.md: Scored assumptions with HITL blocker classification and resolution status

## Dependencies

- ResearchCopilot: Provides evidence-map.md used as primary input
- DecisionLedger: Receives escalation payloads for ACCEPT_RISK resolutions

## Constraints

- Confidence thresholds are subjective until calibrated across 2–3 sprints
- First sprint scoring is approximation — all HITL_BLOCKERS require manual POD Lead review
- Identifies risks; does not resolve them — resolution requires human judgment
- Proposed status: threshold definition and escalation rules need stakeholder alignment before production use

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
