---
name: design-setup
description: Leads a structured 8-domain design session to capture all TO-BE technical architecture decisions and populate design.md, uiux.md, api.md, database.md, and impl.md.
---

# design-setup

**AAxon phase:** 01-Establish-Strategy

## Purpose

Conducts a structured interactive design session with the Pod Lead and Program Lead to define all to-be technical architecture decisions and populate TO-BE content across design.md, uiux.md, api.md, database.md, and impl.md.

## Capabilities

- Pre-design context load from knowledge.md, features.md, and existing design files
- Structured questionnaire across 8 design domains: system architecture, technology stack, data architecture, API design, UI/UX direction, infrastructure and deployment, security and compliance, cross-cutting concerns
- Constraint and compatibility validation against knowledge.md
- Design Validation Report with confirmed decisions, constraint conflicts, migration risks, and pending decisions
- TO-BE content population for all five design files

## Owned Responsibilities

- TO-BE technical architecture definition
- Technology stack selection and documentation
- Design document population across design.md, uiux.md, api.md, database.md, impl.md

## Inputs

Mandatory:
    - knowledge.md: Business objectives, constraints, as-is system, technology constraints
    - features.md: Feature requirements and priorities
  Optional:
    - design.md: Existing AS-IS architecture and any seeded TO-BE decisions
    - uiux.md: Existing AS-IS UI documentation

## Outputs

- design.md (TO-BE SYSTEM ARCHITECTURE section)
- uiux.md (TO-BE UI/UX DESIGN section)
- api.md (TO-BE API DESIGN section)
- database.md (TO-BE DATA MODEL section)
- impl.md (Implementation Guide — full document)

## Dependencies

- knowledge-review: Recommended prerequisite; warned if knowledge.md lacks REVIEWED status

## Constraints

- Never overwrites AS-IS sections in any file
- Endpoint inventory in api.md and full entity model in database.md deferred to Sprint 0 detailed design
- All design decisions must reference the constraint or expectation from knowledge.md that motivated them
- TBD or not-sure answers recorded as [DESIGN DECISION PENDING] with explicit owner

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
