---
name: performance-optimizer
description: Routes each generation task to the optimal model tier and monitors sprint token budget, alerting at 80% consumption and blocking further LLM calls at 100%.
---

# PerformanceOptimizer

**AAxon phase:** 03-Platform-Enablement

## Purpose

Enforces intelligent model routing and sprint token budget compliance — matching each generation task to the optimal model tier based on complexity, context size, and output type, while monitoring cumulative token spend to prevent budget overruns.

## Capabilities

- Task profiling on three dimensions: complexity (LOW/MEDIUM/HIGH), context size (SMALL/MEDIUM/LARGE), output type (CODE/STRUCTURED/ANALYSIS/EXTRACTION)
- Model routing decisions with explicit routing matrix for Anthropic and OpenAI model tiers
- Sprint token budget monitoring with projected overrun calculation
- Threshold-based alerting (80%: alert with recommendations; 95%: force route to Haiku; 100%: block)
- Cost reduction recommendations identifying highest-cost remaining tasks
- End-of-sprint token consumption report for budget calibration

## Owned Responsibilities

- Per-task model routing decisions
- Sprint token budget monitoring and enforcement

## Inputs

Mandatory:
    - artifacts/task-breakdown.yaml: Task list with complexity and context size estimates
    - artifacts/openspec.yaml: NFR latency targets per feature
    - artifacts/sprint-capacity.yaml: Sprint token budget allocation
    - Live token consumption: Running totals per agent and builder
  Optional:
    - PromptBench results: Per-task-type quality/cost profiles for routing calibration

## Outputs

- Routing decision per task (YAML): recommended model, rationale, estimated tokens and cost
- Token Consumption Dashboard: Snapshot on demand or at 80% alert
- token-consumption-report.yaml: End-of-sprint per-agent, per-task, per-model consumption log

## Dependencies

- PromptBench: Provides benchmark results to calibrate routing heuristics

## Constraints

- Routing heuristics are task-type-based, not outcome-based; improve with PromptBench data after 2–3 sprints
- Does not control model selection inside third-party tools (e.g. Cursor internal calls)
- Budget tracking requires agents to report token usage; unreported usage produces inaccurate estimates

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
