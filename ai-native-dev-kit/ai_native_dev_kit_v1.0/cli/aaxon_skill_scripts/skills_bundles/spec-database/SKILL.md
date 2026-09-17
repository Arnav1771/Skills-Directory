---
name: spec-database
description: Creates and maintains specs/database.md with complete schema definitions for relational or document databases derived from knowledge.md entities.
---

# spec-database

**AAxon phase:** 01-Establish-Strategy

## Purpose

Defines and maintains the complete database schema — tables, columns, data types, constraints, indexes, relationships, and migration strategy — as the authoritative source that the backend pod uses to write migrations and queries.

## Capabilities

- Database platform selection and configuration for relational (PostgreSQL, MySQL, SQLite) and document databases (MongoDB, DynamoDB, Firestore)
- Schema design derived from knowledge.md entities with full column/field definitions
- Index design, foreign key specification, and constraint definition
- Compliance handling: PII encryption fields, data retention, GDPR deletion
- Relational schema format (table columns, indexes, foreign keys) and document schema format (JSON Schema)
- Initialize Mode (new spec) and Review Mode (existing spec)

## Owned Responsibilities

- Database schema specification (specs/database.md)
- Migration strategy documentation
- ORM model source of truth

## Inputs

Mandatory:
    - specs/program.md: System domains, compliance requirements (PCI, GDPR)
    - specs/knowledge.md: Core entities, attributes, relationships, business rules
  Optional:
    - specs/design.md: Database technology choice, ORM, migration tool
    - Existing specs/database.md: Determines Initialize vs. Review mode

## Outputs

- specs/database.md: Complete database schema specification

## Dependencies

- spec-knowledge: Provides knowledge.md
- spec-design: Provides database technology and ORM choices (optional)

## Constraints

- Schema derived from knowledge.md entities; additions or deviations confirmed with user
- Business rules should have corresponding database-level enforcement where appropriate
- Flags if spec-api needs updating when new tables are added

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
