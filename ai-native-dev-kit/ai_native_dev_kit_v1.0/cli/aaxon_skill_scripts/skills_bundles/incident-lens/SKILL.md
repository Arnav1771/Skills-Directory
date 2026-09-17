---
name: incident-lens
description: Classifies production incidents as one-off, pattern, or systemic, traces root causes, and generates sprint backlog items for recurring systemic issues to close the incident-to-improvement loop.
---

# IncidentLens

**AAxon phase:** 05-Simplified-AI-Operations

## Purpose

Converts production incidents from a cost centre into a product improvement signal by classifying incidents as one-off, pattern, or systemic, tracing root causes to spec gaps or infrastructure limits, and producing actionable sprint backlog items for recurring systemic issues.

## Capabilities

- New incident intake and structured logging (Mode A: log + classify)
- Pattern analysis across accumulated incident history (Mode B: pattern + backlog generation)
- SLA metric cross-reference at time of incident from RuntimeIQ sla-breach-log.md
- Root cause classification: spec_gap, missing_test, infrastructure_limit, dependency_failure, data_quality
- Sprint backlog item generation for systemic issues in Markdown or YAML format
- RunbookSynth enrichment with root causes and verified fixes

## Owned Responsibilities

- Production incident classification and pattern analysis
- Incident-derived sprint backlog items for systemic issues
- Failure intelligence accumulation across sprints

## Inputs

Mandatory:
    - artifacts/openspec.yaml: Spec baseline for spec gap classification
    - artifacts/deploy-manifest.yaml: Deployment version at time of incident
    - operate/runtime-iq/sla-breach-log.md: SLA metrics for incident cross-reference
    - operate/runtime-iq/thresholds.yaml: NFR baselines for context
    - operate/control-plane/security-event-log.md: Security events for cross-reference
    - Incident details: Elicited for Mode A (timestamp, affected services, symptom, error type, resolution, root cause)

## Outputs

- operate/incident-lens/incident-log.md: Classified incident history
- operate/incident-lens/incident-pattern-report.md: Pattern analysis with root causes
- operate/incident-lens/backlog-items.md: Sprint backlog recommendations
- operate/incident-lens/backlog-items.yaml: Machine-readable backlog for Conductor
- operate/incident-lens/runbook-enrichments.yaml: Known issue and verified fix data for RunbookSynth

## Dependencies

- RuntimeIQ: Provides sla-breach-log.md and thresholds.yaml
- ControlPlane: Provides security-event-log.md

## Constraints

- Only captures incidents that flow through defined channels; verbal-only incidents leave no trace
- Root cause unknown incidents flagged as pending_investigation
- Intelligence base builds meaningfully over 4–6 sprints of data
- Pattern/systemic backlog items require POD Lead HITL gate before writing to sprint board

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
