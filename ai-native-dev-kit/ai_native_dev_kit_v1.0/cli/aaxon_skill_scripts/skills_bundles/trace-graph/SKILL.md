---
name: trace-graph
description: Builds a directed traceability graph from requirements to artifacts to tests, surfaces coverage gaps by severity, and produces gate attestation records for each HITL gate.
---

# TraceGraph

**AAxon phase:** 02-Data-Readiness (also active in 03-Platform-Enablement)

## Purpose

Builds and maintains a directed traceability graph linking every requirement in openspec.yaml to its implementation artifacts, test scenarios, and deployment entries — surfacing broken links, orphaned artifacts, and untraced requirements as the chain-of-custody record for all HITL gate attestations.

## Capabilities

- Requirement inventory from openspec.yaml cross-referenced against specs/spec.md
- Artifact inventory from ai-manifest.json, test feature files, and deploy manifest
- Directed graph construction: REQ-ID → CLU-ID → files → tests → deployment
- Gap detection: UNTRACED REQUIREMENT (CRITICAL), ORPHANED ARTIFACT (WARNING), UNTESTED REQUIREMENT (WARNING→CRITICAL at Gate-2), BROKEN LINK (ERROR), MISSING PROVENANCE HEADER (WARNING)
- Gate attestation records for Gate-0 (cluster assignments), Gate-1 (artifact mappings), Gate-2 (test mappings)

## Owned Responsibilities

- Requirement-to-artifact traceability
- Chain-of-custody record for HITL gate attestations

## Inputs

Mandatory:
    - artifacts/openspec.yaml: Requirement IDs
    - artifacts/ai-manifest.json: Artifact entries with requirement ID mappings (from SpecFlow)
    - specs/spec.md: Epics and stories for ID consistency check
    - specs/tasks.md: Task inventory
  Optional:
    - tests/*.feature: Test scenarios with @REQ-XXX annotations (Build phase)
    - artifacts/deploy-manifest.yaml: Deployed component entries (Build/Deploy phase)

## Outputs

- artifacts/traceability-report.md: Coverage summary, gap report by severity, full traceability graph, gate attestation record

## Dependencies

- SpecFlow: Provides ai-manifest.json
- spec-generation: Provides spec.md and tasks.md

## Constraints

- Only traces artifacts with correctly formatted Automation30 provenance headers and @REQ-XXX test annotations
- Manually written code without provenance appears as orphaned until annotated
- Graph accuracy bounded by completeness of ai-manifest.json; SpecFlow must run first

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
