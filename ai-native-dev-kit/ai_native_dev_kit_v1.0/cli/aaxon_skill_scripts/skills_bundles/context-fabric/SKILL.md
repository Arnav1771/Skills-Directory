---
name: context-fabric
description: Refreshes a versioned enterprise context snapshot mapping requirements to existing capabilities, flags gaps requiring new build tasks, and publishes context.yaml for SpecFlow consumption.
---

# ContextFabric

**AAxon phase:** 02-Data-Readiness (also active in 03-Platform-Enablement for live context retrieval)

## Purpose

Refreshes the enterprise context snapshot each sprint by mapping new requirements to existing system capabilities, detecting gaps requiring new build tasks, and publishing a versioned context.yaml that SpecFlow uses as the authoritative system capability reference.

## Capabilities

- Capability inventory from spec files (API endpoints, database entities, UI components, business logic, integration points)
- Change detection against prior context.yaml snapshot
- Requirement-to-capability mapping with EXISTS / EXISTS_MODIFIED / GAP / ASSUMED classification
- Gap complexity estimation (LOW / MEDIUM / HIGH)
- Versioned context.yaml generation

## Owned Responsibilities

- Enterprise context grounding per sprint
- Capability gap detection and build task recommendation
- System capability registry maintenance

## Inputs

Mandatory:
    - artifacts/openspec.yaml: Sprint requirements to map
    - specs/knowledge.md: As-is system knowledge
    - specs/design.md: Technical architecture
    - specs/database.md: Schema definitions
    - specs/api.md: API contracts
  Optional:
    - artifacts/ai-manifest.json: Previously generated artifacts as confirmed capabilities
    - Enterprise API docs / schema files: Extended capability evidence
    - Change signals (incident logs, drift reports): Capability change annotations

## Outputs

- artifacts/context.yaml: Versioned capability inventory with requirement-to-capability mapping
- Capability Gap Report (section of context.yaml rendered for POD Lead)

## Dependencies

- spec-knowledge: Provides knowledge.md
- spec-design: Provides design.md
- spec-database: Provides database.md
- spec-api: Provides api.md
- SpecFlow: Provides ai-manifest.json (optional, prior sprint)

## Constraints

- Context coverage bounded by machine-readable spec files; undocumented systems are blind spots
- Tribal knowledge requires manual POD Lead annotation
- Maps capabilities but does not validate against live running systems
- Proposed status: context refresh cadence and scope boundary rules need further definition

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
