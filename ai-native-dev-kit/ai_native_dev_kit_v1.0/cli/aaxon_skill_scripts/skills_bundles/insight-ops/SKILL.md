---
name: insight-ops
description: Synthesizes all five Validate-phase agent outputs to identify cross-agent failure patterns, trace root causes to spec gaps, and produce a priority action list with consolidated release gate verdict.
---

# InsightOps

**AAxon phase:** 03-Platform-Enablement (also active in 05-Simplified-AI-Operations for feedback loop contribution)

## Purpose

Aggregates outputs from all five preceding validation agents — Guardian, EvalHarness, RedTeamX, SimLab, and PolicyEnforcer — identifies failure patterns that no individual agent can detect in isolation, and traces patterns back to spec gaps with specific amendment recommendations.

## Capabilities

- Cross-agent signal aggregation per requirement ID with aggregate signal (GREEN / AMBER / RED)
- Pattern detection across five types: cross-agent correlation, component blast radius, spec gap signal, environmental pattern, regression signal
- Spec amendment recommendations with affected requirement IDs and estimated amendment effort
- Priority action list generation ordered by severity and effort
- Consolidated validation report with release gate verdict

## Owned Responsibilities

- Validation results synthesis across all Validate-phase agents
- Spec gap identification and amendment recommendation
- Release gate evidence consolidation
- Feedback loop triggers for next sprint planning

## Inputs

Mandatory:
    - artifacts/test-results.json: Guardian functional test results
    - artifacts/eval-results.json: EvalHarness semantic quality scores
    - artifacts/adversarial-test-suite.json: RedTeamX adversarial test results
    - artifacts/simlab-results.json: SimLab load and chaos test results
    - artifacts/policy-scan-results.json: PolicyEnforcer compliance scan results
    - artifacts/openspec.yaml: For spec amendment recommendations
    - artifacts/traceability-report.md: For root cause requirement tracing
  Optional:
    - artifacts/operate-metrics/: Prior Operate phase logs for trend analysis

## Outputs

- artifacts/validation-report.md: Consolidated sprint quality summary and release gate verdict
- artifacts/spec-amendments.md: Specific openspec.yaml amendment recommendations
- artifacts/action-list.md: POD Lead-ready ordered action list with owners and effort
- artifacts/feedback-loop-triggers.yaml: Operate-phase production signal file (when Operate logs available)

## Dependencies

- Guardian: Provides test-results.json
- EvalHarness: Provides eval-results.json
- RedTeamX: Provides adversarial-test-suite.json
- SimLab: Provides simlab-results.json
- PolicyEnforcer: Provides policy-scan-results.json
- TraceGraph: Provides traceability-report.md

## Constraints

- Cannot run until all five validation agents have produced outputs for the current sprint
- Pattern detection is probabilistic; POD Lead judgment required to validate root cause hypotheses
- Spec amendment recommendations are starting points, not final amendments

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
