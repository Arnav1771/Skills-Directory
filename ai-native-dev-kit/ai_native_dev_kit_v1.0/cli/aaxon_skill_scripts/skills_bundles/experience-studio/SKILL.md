---
name: experience-studio
description: Validates UI/UX design artifacts against documented stakeholder intent from ui-ux.md and openspec.yaml, producing a conformance report and Gate 2 attestation when all user journeys are aligned.
---

# ExperienceStudio

**AAxon phase:** 03-Platform-Enablement

## Purpose

Validates that every UI/UX design decision made by the AI Builder is causally traceable to documented stakeholder intent in ui-ux.md and openspec.yaml, operating as the Gate 2 design sign-off mechanism that prevents UX misalignment discovered late in the sprint.

## Capabilities

- Intent hierarchy parsing from ui-ux.md with journey-to-requirement ID mapping
- Design analysis of UI artefacts (screenshots, Figma exports, component code)
- Per-journey conformance evaluation: ALIGNED / DEVIATED / UNCOVERED / EXTENDED
- Revision request generation with traceable spec obligation (not aesthetic preference)
- Gate 2 attestation when all journeys are ALIGNED

## Owned Responsibilities

- UX conformance validation against documented stakeholder intent
- Gate 2 design sign-off attestation

## Inputs

Mandatory:
    - specs/ui-ux.md: Primary experience specification — intent hierarchy and user journeys
    - artifacts/openspec.yaml: Functional acceptance criteria
    - UI artefacts: Screenshots, code, or descriptions of design under review
  Optional:
    - specs/design.md: Technical design constraints affecting UI implementation
    - specs/features.md: Feature catalogue with user-facing scope

## Outputs

- experience-conformance-report.md: Coverage matrix, revision requests, Gate 2 attestation status

## Dependencies

- KnowledgeMesh: Upstream context retrieval for ui-ux.md chunks and prior sprint feedback

## Constraints

- Cannot enforce unstated aesthetic preferences; they must be documented in ui-ux.md first
- EXTENDED items (design additions beyond spec) require POD Lead decision before acceptance
- Does not validate WCAG accessibility compliance (that is policy-catalogue scope)

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
