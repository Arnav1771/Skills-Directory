---
name: policy-enforcer
description: Scans source code statically and runtime behaviour against the compliance policy catalogue, blocking release on any critical or high severity violations.
---

# PolicyEnforcer

**AAxon phase:** 03-Platform-Enablement (also active in 05-Simplified-AI-Operations for runtime governance)

## Purpose

Scans generated source code and runtime behavior against the project's compliance policy catalogue, enforcing a hard gate requiring zero critical violations and zero high violations before any artifact enters the Release phase.

## Capabilities

- Policy catalogue loading and validation
- Static source code scan: PII in logs, hardcoded secrets, injection vulnerabilities, insecure dependencies, missing input validation, insecure cryptography
- Runtime behaviour scan: PII in API responses, sensitive data over unencrypted channels, auth bypass, rate limit gaps, error message leakage
- Violation classification by severity: critical, high, medium, informational
- Release gate compliance attestation generation

## Owned Responsibilities

- Source code compliance policy enforcement
- Runtime behaviour compliance scanning
- Release gate compliance attestation

## Inputs

Mandatory:
    - artifacts/policy-catalogue.yaml: Defines all enforceable policies
    - Source code (src/**): All build-phase generated code
    - Configuration files (*.yaml, *.env, *.json): Scanned for secrets and hardcoded values
  Optional:
    - artifacts/deploy-manifest.yaml: Runtime endpoint list
    - Runtime request/response logs: Required for runtime scan mode
    - TrustFabric PII classification: Per-field sensitivity classification

## Outputs

- artifacts/policy-scan-report.md: Full violation list with severity and remediation guidance
- artifacts/policy-scan-results.json: Machine-readable results for InsightOps
- artifacts/compliance-attestation.md: Release gate attestation — critical/high violation count

## Dependencies

- PolicyCatalog: Provides policy-catalogue.yaml (must exist before scan can proceed)

## Constraints

- Only enforces policies present in policy-catalogue.yaml; unlisted regulatory requirements are invisible
- Pattern-based static scanning has false-positive risk
- Runtime scanning requires logs captured during Guardian test execution
- Does not perform penetration testing or infrastructure security assessment (RedTeamX scope for AI surfaces)

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
