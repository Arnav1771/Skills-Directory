---
name: review-pilot
description: Pre-reviews every PR for spec conformance, acceptance criteria coverage, and convention compliance, classifying findings as BLOCKING/ADVISORY/INFORMATIONAL before POD Lead review.
---

# ReviewPilot

**AAxon phase:** 03-Platform-Enablement

## Purpose

Automated PR review layer that pre-reviews every pull request for spec compliance, acceptance criteria coverage, coding convention violations, and structural issues, classifying findings as BLOCKING, ADVISORY, or INFORMATIONAL before the POD Lead's human review.

## Capabilities

- PR metadata extraction from provenance headers with requirement-to-acceptance-criteria mapping
- Spec conformance check per requirement: PASS / FAIL / PARTIAL / UNTESTABLE verdict per criterion
- Python convention checks: no print(), type annotations, no raw SQL, exception handling in routes, no PII in responses
- TypeScript/React convention checks: no console.log, no any type, API client usage, loading/error states, props interfaces
- Structural analysis: wrong directory placement, missing test files, circular imports, direct DB access from route layer
- Finding classification: BLOCKING / ADVISORY / INFORMATIONAL

## Owned Responsibilities

- Automated PR spec compliance verification
- Coding convention enforcement
- Finding classification before POD Lead review

## Inputs

Mandatory:
    - PR diff (changed files and line diffs): Primary review target
    - artifacts/openspec.yaml: Acceptance criteria
  Recommended:
    - .cursorrules: Coding conventions
    - AGENTS.md: Project conventions
    - TrustFabric compliance flags: PII violations in changed code
    - artifacts/ai-manifest.json: Existing component registry
    - specs/design.md: Architecture constraints

## Outputs

- PR Review Report: Spec conformance table, blocking findings, advisory findings, informational findings, merge verdict
- review-verdict.yaml: Machine-readable verdict for NexusDeploy

## Dependencies

- TrustFabric: Provides PII compliance flags
- KnowledgeMesh: Retrieves acceptance criteria and convention context
- NexusDeploy: Receives review-verdict.yaml as deploy gate input

## Constraints

- Per-PR scope only; cannot evaluate cross-PR architectural decisions spanning multiple PRs
- Does not execute code or run tests; spec conformance assessed by static analysis
- Cannot review infrastructure changes (Dockerfile, docker-compose, CI config)

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
