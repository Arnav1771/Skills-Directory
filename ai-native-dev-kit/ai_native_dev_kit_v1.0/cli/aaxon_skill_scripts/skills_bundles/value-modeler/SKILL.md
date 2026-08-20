---
name: value-modeler
description: Calculates forecasted business value and ROI per sprint requirement, flags low-value candidates for PortfolioPrioritizer, and produces a locked ROI baseline for ValueTracker post-sprint comparison.
---

# ValueModeler

**AAxon phase:** 02-Data-Readiness

## Purpose

Quantifies the expected business value of each sprint requirement before a single line of code is written — calculating per-requirement value forecasts and a sprint-level ROI estimate — making ROI accountability visible at the spec level on Monday morning.

## Capabilities

- Requirement value classification: direct value, enabling value, quality value, experience value, technical value
- Per-requirement value quantification with formulas for time saved, revenue enablement, error reduction, and qualitative proxies
- Sprint-level ROI calculation with confidence range (±15% high / ±30% medium / ±50% low)
- Low-value flagging for requirements where annual value < 2× allocated sprint investment
- Value baseline record creation for ValueTracker post-sprint comparison

## Owned Responsibilities

- Sprint ROI forecasting
- Per-requirement value quantification
- Value baseline record for post-sprint measurement

## Inputs

Mandatory:
    - artifacts/openspec.yaml: Sprint requirements
    - artifacts/task-breakdown.yaml: Effort estimates per cluster (from SpecFlow)
    - specs/features.md: Feature context
    - specs/program.md: Programme objectives
    - references/opportunity-catalogue.yaml: Opportunity context
    - Baseline metrics (time saved, error rates, revenue at risk): Elicited from POD Lead
  Optional:
    - Prior sprint ValueTracker actuals: For calibration

## Outputs

- artifacts/roi-brief.md: Sprint ROI summary, per-requirement value forecast, defer candidates, value baseline record for ValueTracker

## Dependencies

- SpecFlow: Provides task-breakdown.yaml with effort estimates
- PortfolioPrioritizer: Receives roi-brief.md as mandatory input
- ScenarioPlanner: Receives roi-brief.md as mandatory input

## Constraints

- Requires consistent baseline metric inputs from the business; garbage in, garbage out
- Accuracy improves over 3–5 sprints as ValueTracker actuals accumulate
- Technical and experience value use qualitative proxies; treat as directional, not accountable figures
- Proposed status: integration with ValueTracker requires further design; baseline metrics must be agreed before first use

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
