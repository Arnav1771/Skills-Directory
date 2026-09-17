---
name: runbook-synth
description: Generates versioned operational runbooks per deployed feature from spec and deploy manifest, automatically updating on deployment events and enriching with IncidentLens incident data.
---

# RunbookSynth

**AAxon phase:** 05-Simplified-AI-Operations

## Purpose

Generates and maintains complete, step-by-step operational runbooks per deployed feature by reading the deploy manifest, system architecture, and incident history — automatically updating on deployment events and enriching with IncidentLens verified fixes to prevent stale documentation.

## Capabilities

- Deploy manifest parsing to enumerate deployed features, versions, dependencies, configurations
- System context extraction from design.md and api.md for operational procedures
- Per-feature runbook generation across POD Lead-selected sections: system overview, deployment procedures, health checks, scaling, rollback, alert response, known issues, dependency management, security incident response, contact matrix
- Rollback runbook generation from RolloutAdvisor rollback plan in deploy manifest
- Runbook versioning with prior versions moved to history directory
- Update trigger script generation for configured trigger events

## Owned Responsibilities

- Operational runbook generation and maintenance
- Incident-enriched Known Issues and Verified Fixes documentation

## Inputs

Mandatory:
    - artifacts/deploy-manifest.yaml: Deployed services, versions, configs, rollback plan
    - artifacts/openspec.yaml: Feature specs and integration contracts
    - specs/design.md: System architecture and dependency map
    - specs/api.md: API contracts and error response codes
    - artifacts/decision-ledger.md: Architectural decisions relevant to operations
  Optional:
    - operate/incident-lens/incident-log.md: Resolved incidents for Known Issues section
    - operate/drift-guard/drift-report.md: Known drift patterns for runbook enrichment

## Outputs

- operate/runbook-synth/runbook-[feature-id]-[version].md: Per-feature operational runbook
- operate/runbook-synth/runbook-rollback-[version].md: Rollback-specific runbook (if selected)
- operate/runbook-synth/runbook-index.md: Master index with version history
- operate/runbook-synth/runbook-update-trigger.sh: Watch script for trigger events
- operate/runbook-synth/runbook-config.yaml: RunbookSynth configuration
- operate/runbook-synth/history/: Prior runbook versions

## Dependencies

- IncidentLens: Provides incident-log.md and runbook-enrichments.yaml
- DriftGuard: Provides drift-report.md for drift pattern enrichment

## Constraints

- deploy-manifest.yaml required; cannot generate runbooks without deployment context
- Features in openspec.yaml not in deploy manifest generate spec-only runbooks with a warning
- Runbook sections with no available source content are omitted silently and noted in runbook-config.yaml

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
