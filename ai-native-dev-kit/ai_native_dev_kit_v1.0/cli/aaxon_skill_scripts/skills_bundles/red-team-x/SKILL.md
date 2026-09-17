---
name: red-team-x
description: Systematically attacks AI components using six adversarial categories, classifying each as ROBUST/DEGRADED/VULNERABLE and providing specific remediation guidance for any vulnerabilities found.
---

# RedTeamX

**AAxon phase:** 03-Platform-Enablement

## Purpose

Subjects every AI-generated component to systematic adversarial attack before deployment, covering prompt injection, jailbreaks, PII extraction probes, role confusion, and boundary manipulation from the attacker's perspective.

## Capabilities

- Component risk profiling (CRITICAL / HIGH / MEDIUM / LOW based on data sensitivity and user exposure)
- Adversarial attack suite generation across six categories: prompt injection, jailbreak/role confusion, PII extraction, data exfiltration, boundary manipulation, semantic manipulation
- Attack count scaling by risk level (5 per CRITICAL, 3 per HIGH, 2 per MEDIUM, 1 per LOW)
- Response classification: ROBUST / DEGRADED / VULNERABLE
- Remediation recommendations with input sanitisation, output filtering, and architectural options

## Owned Responsibilities

- Adversarial and safety testing of AI components
- Vulnerability identification and remediation guidance

## Inputs

Mandatory:
    - artifacts/openspec.yaml: Risk profile and safety-critical paths
    - artifacts/ai-manifest.json: AI component inventory
    - artifacts/eval-rubric.yaml: Safety dimension scoring (from EvalHarness)
    - Source prompts/handlers (src/): AI-facing code under test
    - references/adversarial-vector-library.yaml: Known attack patterns
  Optional:
    - artifacts/policy-catalogue.yaml: For policy-specific attack generation

## Outputs

- artifacts/adversarial-test-suite.json: All attack vectors with pass/fail per component
- artifacts/vulnerability-report.md: Human-readable findings with remediation guidance
- artifacts/redteam-summary.md: Sprint-level safety verdict for Release gate

## Dependencies

- EvalHarness: Provides eval-rubric.yaml for safety dimension scoring
- SpecFlow: Provides ai-manifest.json

## Constraints

- Covers known vectors from adversarial-vector-library.yaml only; novel zero-day techniques require manual library additions
- Does not test infrastructure-level security (PolicyEnforcer scope)
- ROBUST classification means resistant to known vectors, not unconditionally safe
- VULNERABLE findings are immediate blockers; surface to POD Lead before proceeding to next component

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
