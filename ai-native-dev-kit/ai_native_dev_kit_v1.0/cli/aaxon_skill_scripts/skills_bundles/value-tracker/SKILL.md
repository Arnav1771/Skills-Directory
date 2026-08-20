---
name: value-tracker
description: Measures actual post-deployment business value against ValueModeler forecasts per feature, classifying performance and generating calibration data to progressively improve ROI forecast accuracy across sprints.
---

# ValueTracker

**AAxon phase:** 05-Simplified-AI-Operations

## Purpose

Closes the ROI accountability loop by comparing actual post-deployment business metric performance against ValueModeler forecasts per requirement, identifying over/under-performing features, and feeding calibration data back to ValueModeler to improve future forecast accuracy.

## Capabilities

- ROI forecast parsing from roi-brief.md with per-feature value predictions and metric mappings
- Baseline vs. actuals comparison engine with delta and variance calculation
- Feature classification: over-performing, on-track, under-performing, insufficient-data
- Realised ROI percentage vs. forecasted ROI calculation
- ValueModeler calibration output generation (if enabled) for progressive forecast improvement
- Baseline capture script generation for pre-deployment metric collection

## Owned Responsibilities

- Post-deployment ROI realisation measurement
- ValueModeler forecast calibration over successive sprints

## Inputs

Mandatory:
    - artifacts/roi-brief.md: Sprint ROI forecast with predicted values and metric names (from ValueModeler)
    - artifacts/openspec.yaml: Feature definitions and acceptance criteria
    - artifacts/sprint-scope-ranked.md: Priority context (from PortfolioPrioritizer)
    - artifacts/deploy-manifest.yaml: Deployment timestamp for measurement window start
    - Business metrics source: Elicited (database, REST API, analytics platform, etc.)
    - Pre-deployment baseline metrics: Must be captured before deployment

## Outputs

- operate/value-tracker/value-tracker-config.yaml: All configuration including metric mappings
- operate/value-tracker/baseline-capture.py: Pre-deployment baseline capture script
- operate/value-tracker/value-tracker-fetcher.py: Post-deployment metric fetcher
- operate/value-tracker/value-comparator.py: Actual vs. forecast comparison engine
- operate/value-tracker/value-realization-report.md: Per-feature actual vs. forecast ROI
- operate/value-tracker/baseline-metrics.yaml: Captured pre-deployment baseline
- operate/value-tracker/value-modeler-calibration.yaml: Calibration data for ValueModeler (if enabled)

## Dependencies

- ValueModeler: Provides roi-brief.md
- PortfolioPrioritizer: Provides sprint-scope-ranked.md

## Constraints

- Pre-deployment baseline metrics required; without them, actuals vs. forecast comparison is impossible
- Insufficient data (< 100 data points) marks feature as insufficient-data, not under-performing
- Business metrics must be instrumented before deployment; generates instrumentation guide if not yet in place
- Proposed status: metrics integration with business systems needs further design; business metrics must be instrumented before first use

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
