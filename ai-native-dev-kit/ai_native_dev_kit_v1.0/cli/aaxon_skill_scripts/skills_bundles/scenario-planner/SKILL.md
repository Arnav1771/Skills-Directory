---
name: scenario-planner
description: Stress-tests sprint scope options by computing best/expected/worst ROI scenarios, identifying the highest-sensitivity assumptions, and calculating minimum viable scope.
---

# ScenarioPlanner

**AAxon phase:** 02-Data-Readiness

## Purpose

Stress-tests sprint scope choices by running a 3-scenario (best/expected/worst) ROI analysis per major scope configuration, identifying the assumptions that most heavily influence outcomes, calculating minimum viable scope, and flagging high-variance items.

## Capabilities

- Assumption sensitivity analysis ranking by value_at_risk × (1 - confidence_score)
- 3-scenario ROI matrix computation (best/expected/worst) per POD Lead-selected scope option
- Minimum viable scope calculation (must-ship items expanded until ROI threshold met in expected scenario)
- Variance ratio flagging: > 3× best/worst = HIGH_VARIANCE, 2–3× = MEDIUM_VARIANCE

## Owned Responsibilities

- Sprint scope ROI sensitivity analysis
- Minimum viable scope identification
- High-variance scope item flagging

## Inputs

Mandatory:
    - artifacts/roi-brief.md: Base ROI estimates (from ValueModeler)
    - artifacts/sprint-scope-ranked.md: PROCEED/DEFERRED scope list (from PortfolioPrioritizer)
    - artifacts/assumption-log.md: Assumption confidence scores (from AssumptionTracker)
    - artifacts/task-breakdown.yaml: Effort estimates per cluster (from SpecFlow)
    - specs/program.md: Programme objectives

## Outputs

- artifacts/scenario-matrix.md: 3-scenario ROI matrix per scope option, top-3 assumption sensitivities, high-variance items, and scope recommendation

## Dependencies

- ValueModeler: Provides roi-brief.md
- PortfolioPrioritizer: Provides sprint-scope-ranked.md
- AssumptionTracker: Provides assumption-log.md
- SpecFlow: Provides task-breakdown.yaml

## Constraints

- Scenario quality entirely dependent on accuracy of ValueModeler inputs and realism of POD Lead best/worst estimates
- Probability estimates are illustrative, not statistical predictions
- Informs POD Lead judgment; does not make the scope decision
- Proposed status: scenario parameters and sensitivity ranges require business definition before meaningful outputs

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
