---
name: parity-checker
description: Compares staging and production environment configurations across eight dimensions, classifying drift and blocking Gate 3 if any critical drift exists.
---

# ParityChecker

**AAxon phase:** 04-AI-Solution-Deployment

## Purpose

Verifies staging-to-production environment parity before Gate 3 sign-off by comparing configurations across eight environment dimensions and classifying drift as CRITICAL_DRIFT (deploy blocker), NOTABLE_DRIFT, or EXPECTED_DIFF.

## Capabilities

- First-run elicitation across eight dimensions: runtime/infrastructure, application dependencies, database and data services, external services and API versions, feature flags, secrets and environment variables, monitoring and observability, network and security
- YAML config file generation for staging and production (persisted for future sprint reuse)
- Diff mode for subsequent sprints (compares stored YAML files directly)
- Classification of each difference with gate impact

## Owned Responsibilities

- Staging-to-production environment parity verification
- Gate 3 (QA Sign-off) parity prerequisite

## Inputs

Optional (determines run mode):
    - artifacts/release/env-config-staging.yaml: If present with production file, runs diff mode
    - artifacts/release/env-config-production.yaml: Required alongside staging config for diff mode

## Outputs

- artifacts/release/parity-check-report.md: Full diff with classification and gate verdict
- artifacts/release/env-config-staging.yaml: Generated on first run
- artifacts/release/env-config-production.yaml: Generated on first run

## Dependencies

- None (ReleaseIntel and RolloutAdvisor depend on this skill's output)

## Constraints

- Secrets are names never values; actual secret values must never be elicited, stored, or logged
- One CRITICAL_DRIFT item blocks Gate 3 with no partial credit
- EXPECTED_DIFF items must be declared with rationale; undeclared expected differences are treated as drift

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
