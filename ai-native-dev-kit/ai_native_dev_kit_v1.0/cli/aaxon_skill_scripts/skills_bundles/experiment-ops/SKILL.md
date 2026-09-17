---
name: experiment-ops
description: Generates complete A/B experiment configuration with traffic routing, guardrail monitoring, and automatic stopping, enabling statistically rigorous production experiments without dedicated data science infrastructure.
---

# ExperimentOps

**AAxon phase:** 05-Simplified-AI-Operations

## Purpose

Enables a small team to run statistically rigorous A/B and multi-armed experiments in production by generating complete experiment configuration — traffic routing, variant definitions, guardrail monitors, significance calculators, and auto-stop logic — from a structured hypothesis and parameters.

## Capabilities

- Experiment manifest generation from hypothesis, variants, traffic allocation, and metric definitions
- Traffic routing configuration (header-based, user ID hash, random, feature flag, API gateway)
- Guardrail monitor generation with configurable degradation thresholds and automatic experiment stop
- Statistical significance calculator (two-proportion z-test or t-test based on metric type)
- Auto-stop enforcement at maximum runtime
- Experiment results report with winner recommendation

## Owned Responsibilities

- Production A/B and multi-armed experiment configuration
- Guardrail safety enforcement with automatic traffic reversion on breach

## Inputs

Mandatory:
    - artifacts/openspec.yaml: Feature definitions for experimentation candidates
    - artifacts/deploy-manifest.yaml: Deployed variants, service endpoints, routing layer
    - Experiment hypothesis, variants, traffic allocation, primary metric, guardrail metrics: Elicited from POD Lead
    - Statistical significance threshold, minimum and maximum runtime: Elicited
  Optional:
    - operate/runtime-iq/thresholds.yaml: Existing SLA thresholds as guardrail defaults
    - operate/value-tracker/value-tracker-config.yaml: Business metric mappings

## Outputs

- operate/experiment-ops/experiment-[id]-manifest.yaml: Complete experiment definition
- operate/experiment-ops/traffic-router.py (or routing config): Variant traffic routing
- operate/experiment-ops/guardrail-monitor.py: Continuous guardrail enforcement
- operate/experiment-ops/significance-calculator.py: Statistical significance evaluator
- operate/experiment-ops/auto-stop.sh: Maximum runtime enforcement
- operate/experiment-ops/experiment-dashboard.json: Real-time experiment dashboard
- operate/experiment-ops/experiment-results-report.md: Results with winner recommendation

## Dependencies

- RuntimeIQ: Provides thresholds.yaml for guardrail defaults
- ValueTracker: Provides value-tracker-config.yaml for metric mappings

## Constraints

- Statistical significance requirements and guardrail thresholds must be agreed with stakeholders before production experiments run
- deploy-manifest.yaml required for routing configuration
- Guardrail breach triggers immediate automatic experiment stop with all traffic routed to control
- Proposed status: experiment design and guardrail thresholds require stakeholder alignment

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
