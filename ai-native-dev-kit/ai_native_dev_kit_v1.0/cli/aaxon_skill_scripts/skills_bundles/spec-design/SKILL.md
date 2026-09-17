---
name: spec-design
description: Creates and maintains specs/design.md defining the technology stack, infrastructure, and coding standards that all pods must follow consistently.
---

# spec-design

**AAxon phase:** 01-Establish-Strategy

## Purpose

Defines and maintains the technical blueprint of the program — programming language, frameworks, libraries, infrastructure, architectural patterns, and tooling decisions — preventing pods from making independent, conflicting technology choices.

## Capabilities

- Language and runtime selection across backend, frontend, and deployment targets
- Framework and library selection: backend framework, frontend framework, ORM, auth, testing, domain libraries
- Infrastructure and deployment configuration: cloud provider, containerization, CI/CD, environments, secrets management
- Standards and conventions: code style, API style, logging and observability, branch strategy, documentation standard
- Initialize Mode (new spec) and Review Mode (existing spec)

## Owned Responsibilities

- Technical design specification (specs/design.md)
- Technology stack decisions as program-wide standard
- Coding standards and conventions

## Inputs

Mandatory:
    - specs/program.md: System domains, NFRs, pod structure, compliance requirements
  Optional:
    - specs/knowledge.md: Entity complexity and workflow needs
    - Existing specs/design.md: Determines Initialize vs. Review mode

## Outputs

- specs/design.md: Complete technical blueprint

## Dependencies

- spec-knowledge: Provides knowledge.md (if it exists)

## Constraints

- Must be done before any coding begins and whenever technology decisions change
- Flags downstream specs that need alignment when technology choices are updated
- Conflicts with NFRs or compliance requirements must be confirmed by user before writing

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
