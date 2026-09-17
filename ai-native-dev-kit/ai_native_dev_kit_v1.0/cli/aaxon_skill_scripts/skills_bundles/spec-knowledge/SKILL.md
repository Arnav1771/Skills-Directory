---
name: spec-knowledge
description: Captures and maintains the shared domain knowledge layer including business rules, entities, workflows, and glossary in specs/knowledge.md, consumed by all pods.
---

# spec-knowledge

**AAxon phase:** 01-Establish-Strategy

## Purpose

Captures and maintains the domain knowledge layer of the program — business rules, domain entities, workflows, terminology, and constraints — serving as the shared vocabulary that all pods reference to build consistently without conflicting assumptions.

## Capabilities

- Domain entity elicitation with attributes and relationships
- Business rule and constraint elicitation (state transitions, validation rules, compliance constraints, edge cases)
- Glossary and workflow elicitation with step-by-step flows, actors, and triggers
- Targeted knowledge gap review and surgical update (Review Mode)
- Changelog maintenance with date-stamped history

## Owned Responsibilities

- Domain knowledge specification (specs/knowledge.md)
- Shared domain vocabulary for all pods
- Business rules and entity definitions

## Inputs

Mandatory:
    - specs/program.md: Domain, users, system domains, and scope
  Optional:
    - Existing specs/knowledge.md: Determines Initialize vs. Review mode

## Outputs

- specs/knowledge.md: Domain overview, core entities, business rules, state machines, workflows, constraints, glossary, changelog

## Dependencies

- program-charter: Provides specs/program.md

## Constraints

- Without knowledge.md, pods make conflicting assumptions about domain behavior
- In Review Mode: never rewrites accurate sections; only targeted gap fills and corrections

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
