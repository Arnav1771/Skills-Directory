---
name: spec-flow
description: Decomposes a locked sprint spec into a parallel-ready cluster build plan with dependency graph, wave assignments, policy rails, and provenance-tagged skeleton files.
---

# SpecFlow

**AAxon phase:** 02-Data-Readiness

## Purpose

Converts a locked openspec.yaml into a parallel-ready build plan by decomposing every functional and non-functional requirement into bounded generation clusters — each a self-contained unit of code that one AI Builder can generate independently.

## Capabilities

- Requirement classification: Functional (FR), Non-Functional (NFR), Integration (IR), Data (DR)
- Cluster decomposition with module boundary identification and intra-cluster dependency satisfaction
- Directed dependency graph construction with critical path identification
- Parallel wave planning grouping clusters by dependency satisfaction order
- Provenance header injection format per stack (frontend and backend)
- Manifest update appending all new artifacts to ai-manifest.json

## Owned Responsibilities

- Spec-to-build decomposition
- Parallel work plan with builder wave assignments
- Cluster dependency graph

## Inputs

Mandatory:
    - artifacts/openspec.yaml: Sprint requirements to decompose
    - artifacts/context.yaml: Enterprise context for capability deduplication (from ContextFabric)
    - artifacts/policy-catalogue.yaml: Compliance rails per cluster (from PolicyCatalog)
    - specs/spec.md: Epics and stories from prior phase
    - specs/tasks.md: Task inventory from prior phase
    - specs/design.md: Architectural patterns
    - specs/api.md: API contracts
    - specs/database.md: Schema definitions
    - specs/ui-ux.md: UI/UX spec
  Optional:
    - artifacts/ai-manifest.json: Prior sprint artifacts for iteration mode

## Outputs

- artifacts/task-breakdown.yaml: Cluster definitions with requirements, dependencies, wave assignments, builder assignments, effort, policy rails
- artifacts/ai-manifest.json: Updated artifact manifest with spec traceability IDs
- artifacts/parallel-work-plan.md: Human-readable wave plan for POD Lead review

## Dependencies

- ContextFabric: Provides context.yaml
- PolicyCatalog: Provides policy-catalogue.yaml
- spec-generation: Provides spec.md and tasks.md
- spec-design: Provides design.md
- spec-api: Provides api.md
- spec-database: Provides database.md
- spec-uiux: Provides ui-ux.md

## Constraints

- Output quality bounded by spec completeness; vague NFRs produce vague code skeletons
- If context.yaml absent, flags capability assumptions as unverified and reduces confidence scores
- Does not generate code directly; produces the plan and provenance-tagged skeletons

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
