---
name: code-extraction
description: Analyzes legacy or existing source code to extract and document as-is system behavior, API surface, data model, and architecture into program knowledge files.
---

# code-extraction

**AAxon phase:** 01-Establish-Strategy

## Purpose

Parses legacy or existing source code to extract as-is system knowledge into the program knowledge base, covering source code behavior, API surface, data model, and architectural patterns.

## Capabilities

- Source code analysis (entry points, module structure, business logic, external dependencies, auth patterns)
- API definition parsing (OpenAPI, Swagger, WSDL, gRPC)
- Database schema extraction from SQL schemas and migration scripts
- Infrastructure and IaC analysis
- knowledge.md update with AS-IS system entries
- api.md update with AS-IS API surface
- database.md update with AS-IS data model and entity relationship summary
- design.md update with AS-IS architecture seed and technical debt register

## Owned Responsibilities

- As-is system knowledge extraction from code artifacts
- Legacy system behavior documentation
- Technical debt identification

## Inputs

Mandatory:
    - Source code artifacts: At least one of — source files, repository, schema SQL, migration scripts, OpenAPI/Swagger/WSDL, config files, or IaC
  Optional:
    - knowledge.md: Existing knowledge for conflict detection
    - api.md: Existing API docs for conflict detection
    - database.md: Existing schema for conflict detection
    - design.md: Existing design for conflict detection

## Outputs

- Updates to knowledge.md (AS-IS SYSTEM section)
- Updates to api.md (AS-IS API surface)
- Updates to database.md (AS-IS data model)
- Updates to design.md (AS-IS ARCHITECTURE seed)
- Code Extraction Report

## Dependencies

- None

## Constraints

- Never infer business rules not evidenced in code; flag as [INFERRED — requires validation]
- Dead code goes to Technical Debt Register, not active behavior documentation
- Credentials or secrets found in code must not be reproduced — note presence as security finding only
- Large codebases: prioritize entry points → routing → domain models → schema → service logic

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
