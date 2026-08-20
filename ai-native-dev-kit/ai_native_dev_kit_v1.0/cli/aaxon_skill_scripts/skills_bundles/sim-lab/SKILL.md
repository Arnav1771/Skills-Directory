---
name: sim-lab
description: Generates and executes load, chaos, and resilience tests against staged components, validating NFR compliance and blocking release on any FAIL verdict.
---

# SimLab

**AAxon phase:** 03-Platform-Enablement

## Purpose

Validates that every built component meets its Non-Functional Requirements under realistic stress conditions — generating load test scripts, injecting failure scenarios, and validating circuit-breaker behavior — before deployment.

## Capabilities

- NFR target extraction from openspec.yaml with HITL elicitation if absent
- k6 load test script generation per endpoint with parameterized NFR thresholds (no hardcoded values)
- Failure injection scenario generation: dependency unavailable, degraded, rate-limited, partial failure, cascade failure
- Circuit-breaker validation (time-to-open, fallback response correctness, recovery time)
- Edge case simulation: minimum/maximum input, concurrent duplicates, rapid successive requests
- NFR pass/fail verdict: PASS / WARN / FAIL per metric

## Owned Responsibilities

- NFR validation under load and chaos conditions
- Circuit-breaker and resilience verification

## Inputs

Mandatory:
    - artifacts/openspec.yaml: NFR targets (latency percentiles, concurrency, error rate, availability, circuit-breaker config)
    - artifacts/deploy-manifest.yaml: Integration endpoint list for load targeting
  Optional:
    - artifacts/task-breakdown.yaml: Edge case scenarios from acceptance criteria
    - artifacts/context.yaml: Delivery context for environment assumptions

## Outputs

- tests/load/: Generated k6 load test scripts (one per endpoint)
- tests/chaos/: Generated failure injection test scripts
- artifacts/simlab-results.json: Raw metrics per endpoint and scenario
- artifacts/nfr-verdict.md: Human-readable NFR pass/fail with Release gate input

## Dependencies

- None (InsightOps consumes simlab-results.json)

## Constraints

- Simulations run against staging environment; infrastructure differences can produce false-pass results
- POD Lead must confirm staging-production equivalence before results are treated as valid
- Generates k6 scripts by default; alternate framework specified in openspec.yaml nfr.test_framework
- Chaos scenarios simulate via mock responses, not actual network fault injection (requires Toxiproxy or equivalent separately)

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
