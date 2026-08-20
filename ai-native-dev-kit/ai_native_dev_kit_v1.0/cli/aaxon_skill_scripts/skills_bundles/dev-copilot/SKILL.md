---
name: dev-copilot
description: Generates spec-anchored, convention-compliant code for React/FastAPI/PostgreSQL tasks, then gates delivery behind a closed-loop SCS ≥ 90% / zero critical failures conformance check with up to three automated re-engineering passes, producing a per-task spec-conformance-report.json and escalating unresolved failures to the POD Lead.
---

# DevCopilot

**AAxon phase:** 03-Platform-Enablement

## Purpose

Primary implementation assistant for AI Builders during build days — generates spec-anchored code for a React/Python FastAPI/PostgreSQL stack with provenance headers, spec traceability IDs, and convention compliance, then gates delivery behind a closed-loop Spec Conformance Score (SCS ≥ 90%, zero critical failures) with up to three automated re-engineering passes before escalating to the POD Lead.

## Capabilities

- Task context assembly from task-breakdown.yaml, openspec.yaml, KnowledgeMesh, and TrustFabric
- Pre-generation checklist validation (requirement clarity, data contracts, duplication check, compliance rail)
- Stack-specific code generation: React/TypeScript (functional components, Tailwind, React Query, Zod), Python FastAPI (Pydantic v2, SQLAlchemy 2.0 async, Alembic), PostgreSQL (UUID PKs, Alembic migrations)
- Provenance header injection per generated file
- Closed-loop Spec Conformance Validation: six-dimension SCS scoring (D1 acceptance criteria 35%, D2 API contract 20%, D3 data model 15%, D4 convention 10%, D5 policy 10%, D6 TrustFabric PII 10%) using an adversarial verifier role separate from the generator
- Dual delivery gate: SCS ≥ 0.90 AND zero critical-severity failures — a single critical FAIL blocks delivery regardless of aggregate score
- Targeted re-engineering loop (max 3 iterations) with monotonic SCS improvement guard; escalates to POD Lead on plateau or exhaustion
- Convention compliance enforcement against .cursorrules (dimension D4)
- TrustFabric PII constraint enforcement (dimension D6, every iteration, any FAIL is critical)
- Ambiguity escalation to POD Lead with spec-ambiguity-escalation.log (takes precedence over the conformance loop)

## Owned Responsibilities

- Spec-anchored code generation for React/FastAPI/PostgreSQL stack
- Closed-loop spec-conformance validation and re-engineering before delivery
- Convention compliance enforcement
- Provenance header injection
- Per-task spec-conformance-report.json production
- Ambiguity escalation logging

## Inputs

Mandatory:
    - artifacts/task-breakdown.yaml: Assigned task and requirement ID
    - artifacts/openspec.yaml: Acceptance criteria for the requirement (verifier ground truth)
    - specs/design.md: Architectural patterns and naming conventions
    - specs/api.md: API contracts and request/response schemas (verifier ground truth for D2)
    - specs/database.md: Schema definitions and ORM patterns (verifier ground truth for D3)
    - artifacts/policy-catalogue.yaml: Compliance rail prompt for this task (verifier ground truth for D5)
    - .cursorrules: Coding conventions (verifier ground truth for D4)
    - AGENTS.md: Builder operating instructions
    - KnowledgeMesh retrieval: Contextualised spec chunks per task
    - TrustFabric flags: PII and data contract constraints (verifier ground truth for D6)
  Optional:
    - artifacts/ai-manifest.json: Existing component registry for duplication check

## Outputs

- Implementation code files with provenance headers (delivered only after clearing the conformance gate)
- spec-conformance-report.json: Per-task final SCS, dimension scores, iteration audit trail, and DELIVERED or ESCALATED verdict
- spec-ambiguity-escalation.log: One entry per escalated ambiguity

## Dependencies

- KnowledgeMesh: Provides contextualised spec chunks (upstream)
- TrustFabric: Provides PII constraints and data contract rules (upstream, scored as D6 every iteration)
- SecretShield: All context payloads pass through SecretShield before injection (upstream gate)
- ReviewPilot: Receives only gate-cleared artifacts; spec-conformance-report.json accompanies the PR (downstream)
- NexusDeploy: Artifacts registered against requirement IDs (downstream)
- EvalHarness / TraceGraph: Boundary — DevCopilot's loop validates spec conformance of the artefact; behavioural test generation and BDD coverage remain owned downstream

## Constraints

- Does not generate infrastructure-as-code (NexusDeploy scope)
- Does not write BDD feature files (TraceGraph scope)
- Ambiguous spec requirements must be escalated before generation; the conformance loop assumes an unambiguous, atomic requirement as its ground truth
- Works best with atomic, well-defined spec requirements — compound requirements should be split by the POD Lead before invocation
- The 90% gate is a delivery threshold, not a quality ceiling; it never licenses shipping a critical-severity failure
- The re-engineering loop is bounded at MAX_REENGINEER_ITERS (default 3); persistent sub-threshold results are escalated, never silently shipped
- Token budget: ~50K base + ~15K per re-engineering iteration, ~95K worst case (first-pass estimates — confirm empirically before registering in aaxon_skill_execution_tracker.xlsx)

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
