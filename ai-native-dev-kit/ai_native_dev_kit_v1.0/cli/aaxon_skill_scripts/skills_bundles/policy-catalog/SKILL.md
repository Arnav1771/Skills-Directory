---
name: policy-catalog
description: Maps all sprint requirements to applicable compliance policies from the policy library and generates per-task guard prompts injected into build phase cluster definitions.
---

# PolicyCatalog

**AAxon phase:** 02-Data-Readiness (also active in 03-Platform-Enablement for compliance rail injection)

## Purpose

Maps every requirement in openspec.yaml to its applicable compliance policies before build starts, generating per-task compliance guard prompts injected into SpecFlow cluster definitions and Conductor task dispatches to ensure compliance is enforced at code generation time.

## Capabilities

- Requirement compliance signal scanning (PII fields, auth flows, data persistence, external transmission, audit logging, consent flows, deletion/retention operations)
- Policy matching against policy library with POL-[FRAMEWORK]-[NNN] IDs
- Compliance guard prompt generation (3–5 sentences per policy, builder-ready)
- Gap analysis flagging requirements with unmatched compliance signals as POLICY_GAP

## Owned Responsibilities

- Per-requirement compliance policy assignment
- Compliance guard prompt generation for build phase injection

## Inputs

Mandatory:
    - artifacts/openspec.yaml: Sprint requirements to scan
    - specs/database.md: Schema for PII field identification
    - specs/api.md: Endpoint definitions for compliance signal detection
    - specs/features.md: Feature context
    - references/policy-library.md: Master policy catalogue with guard prompts per framework

## Outputs

- artifacts/policy-catalogue.yaml: Per-requirement compliance status and guard prompts
- Per-task compliance rail prompts: Injected into artifacts/task-breakdown.yaml via SpecFlow

## Dependencies

- spec-database: Provides database.md
- spec-api: Provides api.md
- spec-generation: Provides features.md
- SpecFlow: Receives policy_rails arrays appended to cluster entries

## Constraints

- Catalogue coverage bounded by policy-library.md; novel requirements must be manually added before enforcement
- Classifies compliance signals but does not perform legal interpretation
- Final compliance responsibility remains with the POD Lead

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
