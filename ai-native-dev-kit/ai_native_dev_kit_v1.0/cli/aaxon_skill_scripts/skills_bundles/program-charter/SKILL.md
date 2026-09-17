---
name: program-charter
description: Generates specs/program.md via structured elicitation and scaffolds the complete project folder structure including spec stubs for all downstream specification skills.
---

# program-charter

**AAxon phase:** 01-Establish-Strategy

## Purpose

Guides the user through a structured elicitation session to capture all dimensions of a software program, then generates a canonical specs/program.md and scaffolds the standard project folder layout. This is the mandatory entry point for all program work.

## Capabilities

- Structured elicitation across five groups: foundation, scope and users, architecture and systems, design and UX, delivery and risk
- specs/program.md generation from elicitation
- Spec stub creation for knowledge.md, design.md, ui-ux.md, database.md, api.md
- Project folder scaffolding (specs/, src/, tests/, CLAUDE.md, .claude/)
- CLAUDE.md generation with AI collaboration instructions
- Recommended spec initialization order guidance

## Owned Responsibilities

- Program charter creation (specs/program.md)
- Project folder structure initialization
- Spec stub creation for all downstream specs

## Inputs

Mandatory:
    - User elicitation responses across five groups
  Optional:
    - Existing charter (for adaptation or re-generation)

## Outputs

- specs/program.md: Authoritative program charter
- specs/knowledge.md: Stub with pending notice
- specs/design.md: Stub with pending notice
- specs/ui-ux.md: Stub with pending notice
- specs/database.md: Stub with pending notice
- specs/api.md: Stub with pending notice
- CLAUDE.md: AI collaboration instructions
- src/, tests/, .claude/ directories

## Dependencies

- None

## Constraints

- No feature decomposition section in program.md; features managed by feature-brief skill
- Must precede all other spec skills and feature briefs
- No sprint plans, architecture decisions, or sub-skills should precede program-charter

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
