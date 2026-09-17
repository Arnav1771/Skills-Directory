---
name: guardian
description: Generates executable Gherkin test suites from acceptance criteria and executes them against built code modules, triaging every failure as SPEC_ERROR, CODE_ERROR, or ENV_ERROR.
---

# Guardian

**AAxon phase:** 03-Platform-Enablement

## Purpose

Converts locked acceptance criteria into executable Gherkin test suites before the Build phase begins, then continuously executes those tests as code modules land, triaging every failure into exactly one of three categories — SPEC_ERROR, CODE_ERROR, or ENV_ERROR.

## Capabilities

- Acceptance criteria parsing from openspec.yaml with ambiguity elicitation
- Gherkin feature file generation (Generation Mode): happy path + negative path + boundary scenarios per criterion
- Test execution against available source code modules (Execution + Triage Mode)
- Failure triage: SPEC_ERROR (POD Lead amends spec), CODE_ERROR (AI Builder fixes code), ENV_ERROR (POD Lead resolves infra)
- Requirement coverage reporting with Release gate verdict

## Owned Responsibilities

- Test suite generation from acceptance criteria
- Test execution and failure triage
- Requirement coverage reporting

## Inputs

Mandatory:
    - artifacts/openspec.yaml: Acceptance criteria source of truth
    - artifacts/ai-manifest.json: Component-to-builder mapping for test tagging
    - artifacts/traceability-report.md: Requirement IDs for test linkage
  Conditional:
    - Source code modules (src/**): Required for Execution + Triage Mode; not needed for Generation Mode
  Optional:
    - artifacts/eval-rubric.yaml: EvalHarness rubric for semantic test scoring

## Outputs

- tests/*.feature: One .feature file per requirement/component
- artifacts/test-results.json: Structured pass/fail with triage categories
- artifacts/coverage-report.md: Requirement coverage percentage and Release gate verdict

## Dependencies

- TraceGraph: Provides traceability-report.md
- EvalHarness: Provides eval-rubric.yaml for semantic scoring (optional)

## Constraints

- Test coverage quality bounded by acceptance criteria completeness; vague criteria produce shallow tests
- Generates Gherkin scenarios but not step definition implementations (builders implement step defs)
- Does not execute tests requiring live external APIs without stubs
- Release gate requires ≥ 80% coverage and zero untriaged failures

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
