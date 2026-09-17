---
name: spec-generation
description: Synthesizes program knowledge into a complete Epics → Stories → Tasks specification in specs/spec.md and specs/tasks.md with all tasks scoped to 3 business days or fewer.
---

# spec-generation

**AAxon phase:** 01-Establish-Strategy

## Purpose

Synthesizes all program knowledge into a complete hierarchical specification — Epics → Stories → Tasks — and produces two delivery-ready output files (specs/spec.md and specs/tasks.md), where every task is scoped to 3 business days or fewer.

## Capabilities

- Epic derivation from feature categories, technical foundation requirements, data migration, UI foundation, and integration work
- Story derivation from FR-n entries, business rules, workflows, NFRs, screens, and migration steps
- Task derivation with absolute 3-business-day ceiling and task type tagging (DESIGN/BACKEND/FRONTEND/DATA/INTEGRATION/TESTING/INFRA/DOCS)
- Cross-cutting task generation: Sprint 0 foundation, security, observability, and documentation tasks
- Pre-generation source summary with prerequisite checks and proposed epic structure
- Spec review presentation before file writing with blocked task identification

## Owned Responsibilities

- Program specification hierarchy (Epics, Stories, Tasks)
- Delivery planning with effort estimates
- specs/spec.md and specs/tasks.md

## Inputs

Mandatory:
    - knowledge.md: Business context, business rules, business workflows, constraints
    - features.md: All FR-n entries with priority signals and acceptance notes
  Recommended:
    - design.md (TO-BE sections): Architecture pattern, components, NFRs
    - uiux.md (TO-BE sections): Screen inventory, personas, navigation model
  Optional:
    - api.md (TO-BE sections): API style, auth model, endpoint inventory
    - database.md (TO-BE sections): Data model, migration strategy
    - impl.md: Tech stack, environment structure, CI/CD, pending decisions

## Outputs

- specs/spec.md: Epics and stories with acceptance criteria and business rule references
- specs/tasks.md: Complete task inventory with type tags, effort estimates, and blocked task list

## Dependencies

- design-setup: Provides design.md TO-BE content (recommended)
- knowledge-review: Provides validated knowledge.md (recommended)

## Constraints

- 3-business-day task ceiling is absolute; tasks exceeding this must be split
- Every task must belong to a story; every story must belong to an epic
- Every story must reference its source (FR-n, business rule, workflow, or design requirement)
- Acceptance criteria must be specific and observable; vague criteria are not acceptable
- NICE TO HAVE features excluded from spec iteration unless explicitly included

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
