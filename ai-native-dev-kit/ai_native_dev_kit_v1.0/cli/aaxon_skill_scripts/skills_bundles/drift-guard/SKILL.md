---
name: drift-guard
description: Monitors production AI output quality by sampling live traffic and scoring against spec and EvalHarness baselines, triggering a revalidation workflow when drift exceeds the configured threshold.
---

# DriftGuard

**AAxon phase:** 05-Simplified-AI-Operations

## Purpose

Continuously samples live AI model outputs from production traffic and evaluates them against the locked openspec.yaml behavioral specification and EvalHarness golden-set baselines, scoring semantic drift per feature and triggering revalidation workflows when cumulative drift exceeds the configured threshold.

## Capabilities

- Spec baseline parsing from openspec.yaml acceptance criteria and output format contracts
- EvalHarness golden output baseline management
- Configurable traffic sampling with observability stack integration
- Multi-dimension drift scoring: semantic quality, output format compliance, response length, accuracy, latency, tone/safety
- Drift direction classification (regression vs. improvement)
- Revalidation trigger generation when threshold breached
- Per-feature drift report and dashboard

## Owned Responsibilities

- Production model output drift detection
- Revalidation trigger when drift threshold exceeded
- Drift history and trend reporting

## Inputs

Mandatory:
    - artifacts/openspec.yaml: Behavioral spec, acceptance criteria, output format contracts
    - artifacts/deploy-manifest.yaml: Deployed model versions and endpoints
    - artifacts/traceability-report.md: Requirement-to-feature mapping
    - specs/features.md: Feature acceptance criteria
    - EvalHarness baseline: Golden output set from sprint validation
    - Live production traffic: Via configured observability stack
  Optional:
    - Prior context.yaml: For change detection

## Outputs

- operate/drift-guard/drift-config.yaml: All drift configuration
- operate/drift-guard/drift-scorer.py: Sampling, scoring, and reporting agent
- operate/drift-guard/sampling-config.yaml: Observability stack sampler
- operate/drift-guard/drift-report.md: Per-feature drift score history
- operate/drift-guard/revalidation-trigger.yaml: Written when threshold exceeded
- operate/drift-guard/eval-baseline/baseline-manifest.yaml: Golden output manifest
- operate/drift-guard/drift-dashboard.json: Drift trend dashboard

## Dependencies

- EvalHarness: Provides golden output baseline
- TraceGraph: Provides traceability-report.md

## Constraints

- Operates in spec-only mode if no EvalHarness baseline exists
- Claude API unavailable falls back to regex/rule-based scoring flagged as scored_by: fallback
- Does not validate capabilities against live running systems

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
