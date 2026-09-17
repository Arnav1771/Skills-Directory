---
name: knowledge-mesh
description: Provides a centralised, versioned RAG knowledge index for build-phase agents, indexing all sprint spec files and serving relevance-scored context chunks with staleness detection.
---

# KnowledgeMesh

**AAxon phase:** 03-Platform-Enablement

## Purpose

Centralised RAG context backbone for all build-phase agents — prevents context divergence by indexing all sprint spec files into a single versioned knowledge plane from which DevCopilot, ExperienceStudio, ReviewPilot, and TrustFabric retrieve context.

## Capabilities

- Index construction from all spec files with 300–500 token chunks tagged by source, section, requirement IDs, sprint ID, and version hash
- Relevance-scored query handling with top-N chunk retrieval
- Staleness detection and invalidation on source document changes
- Coverage assessment reporting retrieval confidence per spec area

## Owned Responsibilities

- Build-phase knowledge retrieval centralisation
- Context version management and staleness detection
- Single knowledge plane across all build agents

## Inputs

Mandatory:
    - specs/knowledge.md: As-is system knowledge
    - specs/design.md: Technical architecture
    - specs/api.md: API contracts
    - specs/database.md: Schema definitions
    - specs/features.md: Feature catalogue
    - specs/impl.md: Implementation constraints
    - artifacts/openspec.yaml: Sprint requirements
    - artifacts/task-breakdown.yaml: Decomposed task tree
    - artifacts/decision-ledger.md: Architectural decisions
  Optional:
    - artifacts/ai-manifest.json: Previously generated artifacts

## Outputs

- knowledge-mesh-index.md: Chunk inventory and requirement coverage map (internal)
- Retrieval responses: Chunks with metadata delivered to requesting agent per query
- knowledge-coverage-report.md: Per-spec-area retrieval confidence (on audit request)
- knowledge-mesh-invalidation.log: Timestamped staleness events

## Dependencies

- ContextFabric: Receives invalidation signals when platform context changes

## Constraints

- Retrieval quality bounded by documentation coverage; undocumented behavior requires direct code analysis by AI Builder
- Does not perform semantic understanding of retrieved chunks; DevCopilot applies context to generation
- Does not persist state between conversations; index rebuilt each sprint session

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
