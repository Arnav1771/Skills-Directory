---
name: nexus-deploy
description: Verifies that every sprint requirement has a reviewed, policy-clean artifact before generating a containerized deploy manifest, blocking deployment until all completeness conditions are satisfied.
---

# NexusDeploy

**AAxon phase:** 03-Platform-Enablement (also active in 04-AI-Solution-Deployment and 05-Simplified-AI-Operations)

## Purpose

Sprint close-out gate that verifies every requirement has a corresponding reviewed, policy-clean artifact before issuing the deploy manifest; also executes deployment pipeline in the Release phase and registers production artifacts in the Operate phase.

## Capabilities

- Artifact registry construction from provenance headers in source files
- Per-requirement completeness validation: artifact present, review approved, no policy violations, NFR evidence pass
- Deploy manifest preparation with checksums, rollout strategy, and service definitions
- ai-manifest.json update merging new sprint artifacts with prior sprint catalogue
- Completeness report with specific blocker identification

## Owned Responsibilities

- Sprint completeness verification before deployment
- Deploy manifest generation
- Artifact registry maintenance across sprints

## Inputs

Mandatory:
    - artifacts/task-breakdown.yaml: Expected artifact list per requirement
    - artifacts/openspec.yaml: Requirement IDs and acceptance criteria
    - artifacts/ai-manifest.json: Current artifact catalogue
    - artifacts/review-verdict.yaml: PR review pass/fail per requirement (from ReviewPilot)
    - data-contract-violations.yaml: Unresolved PII violations (from TrustFabric)
    - prompt-bench-nfr-evidence.yaml: NFR pass/fail for AI features (from PromptBench)
    - Source code modules with provenance headers: Generated artifacts
    - Infrastructure config (Dockerfile, docker-compose): Container build definitions

## Outputs

- Sprint Completeness Report with COMPLETE/ARTIFACT_MISSING/REVIEW_PENDING/REVIEW_BLOCKED/POLICY_VIOLATION/NFR_FAIL status per requirement
- deploy-manifest.yaml: Generated only when all requirements are COMPLETE
- Updated ai-manifest.json

## Dependencies

- ReviewPilot: Provides review-verdict.yaml
- TrustFabric: Provides data-contract-violations.yaml
- PromptBench: Provides prompt-bench-nfr-evidence.yaml

## Constraints

- Requirements added informally outside the spec process are invisible to NexusDeploy
- Does not execute builds; only prepares the manifest for CI/CD pipeline consumption
- Does not manage secrets in manifest; environment variables referenced by name only

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
