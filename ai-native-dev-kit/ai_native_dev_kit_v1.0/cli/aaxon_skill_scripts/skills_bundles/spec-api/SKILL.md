---
name: spec-api
description: Creates and maintains specs/api.md with complete endpoint definitions, Pydantic schemas, authentication strategy, and error contract derived from domain entities in knowledge.md and database.md.
---

# spec-api

**AAxon phase:** 01-Establish-Strategy

## Purpose

Defines and maintains the complete backend API specification — all REST endpoints, request/response schemas, authentication strategy, error contract, and FastAPI implementation patterns — serving as the primary contract for backend and frontend pod implementation.

## Capabilities

- API foundation definition: base URL, versioning strategy, authentication, CORS
- Endpoint design derived from knowledge.md domain entities and workflows
- Request/response conventions: pagination, date format, enum representation, null handling
- Error and non-functional contract: status code conventions, rate limiting, timeout policy
- FastAPI implementation pattern templates with Pydantic v2 schemas
- Endpoint definition format with business rules applied reference
- Initialize Mode (new spec) and Review Mode (existing spec)

## Owned Responsibilities

- Backend API specification (specs/api.md)
- Endpoint definitions and Pydantic schema definitions
- Authentication and error contract

## Inputs

Mandatory:
    - specs/program.md: System domains, security NFRs, compliance requirements
    - specs/knowledge.md: Entities, workflows, business rules (become endpoints)
    - specs/database.md: Table structure (drives request/response shapes)
  Optional:
    - specs/design.md: Auth mechanism, API style, framework versions
    - Existing specs/api.md: Determines Initialize vs. Review mode

## Outputs

- specs/api.md: Complete API specification

## Dependencies

- spec-knowledge: Provides knowledge.md
- spec-database: Provides database.md
- spec-design: Provides design.md (optional)

## Constraints

- Must read all prerequisite specs before eliciting or editing
- Review Mode: flag breaking changes (removed fields, changed types, status code changes)
- Flags if spec-database needs additional indexes for new query patterns

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
