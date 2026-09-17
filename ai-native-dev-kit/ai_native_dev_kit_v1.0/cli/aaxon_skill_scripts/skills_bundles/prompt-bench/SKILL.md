---
name: prompt-bench
description: Benchmarks prompt variants across models on quality, latency, and cost to recommend the optimal variant for production and provide NFR pass/fail evidence for the release gate.
---

# PromptBench

**AAxon phase:** 03-Platform-Enablement

## Purpose

Benchmarks AI feature prompt variants before they enter production by running each against a representative query sample across multiple models, measuring quality, latency, and cost, and delivering a ranked recommendation with NFR pass/fail evidence for the Release gate.

## Capabilities

- Benchmark matrix construction (prompt variant × model × query)
- Multi-provider execution: Claude (Haiku/Sonnet/Opus), OpenAI (GPT-4o-mini/GPT-4o/o3-mini), and configurable others
- Quality scoring via LLM-as-judge, exact match against ground truth, or human-defined rubric
- Metric aggregation: quality_avg, quality_p10, latency_p50/p95, cost_per_1k
- NFR pass/fail verdict per variant/model combination
- Three-dimensional ranking: best quality, best cost, best balanced

## Owned Responsibilities

- Prompt variant benchmarking before production deployment
- Model selection evidence and recommendation
- NFR pass/fail evidence for NexusDeploy release gate

## Inputs

Mandatory:
    - Candidate prompt variants (2–5): From AI Builder
    - Query sample set (10–50 queries): Curated by POD Lead
    - artifacts/openspec.yaml: NFR targets (accuracy threshold, latency p95, cost per request)
    - Target model list: From POD Lead or default
    - Evaluation criteria: LLM-as-judge rubric, ground truth labels, or human rubric

## Outputs

- prompt-bench-report.md: Results matrix, winner recommendation, failure analysis, model routing recommendation
- prompt-bench-nfr-evidence.yaml: Structured NFR pass/fail per variant/model for NexusDeploy

## Dependencies

- NexusDeploy: Consumes prompt-bench-nfr-evidence.yaml as deploy gate input
- PerformanceOptimizer: Receives benchmark results for sprint routing calibration

## Constraints

- Benchmark quality depends entirely on query sample representativeness; minimum 20 queries including edge cases recommended
- Does not run real API calls by default; POD Lead must explicitly confirm live execution
- LLM-as-judge scoring introduces evaluator bias; high-stakes features should supplement with human-reviewed ground truth

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
