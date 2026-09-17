---
name: model-router
description: ModelRouter is a lightweight Haiku classifier that routes tasks to Haiku, Sonnet, or Opus based on six reasoning dimensions. It is the largest cost lever in the optimization layer — proper routing cuts model spend several-fold. Budget pressure can force downgrades, but safety_criticality ≥7 anchors a Sonnet floor.
---

# ModelRouter

**AAxon phase:** 05-Simplified-AI-Operations

## Purpose

Routes each task step to the least expensive model capable of meeting its quality bar by classifying reasoning depth across six dimensions and applying budget-pressure overrides from BudgetGovernor.

## Capabilities

- Six-dimension classification per task: reasoning_depth, ambiguity_level, domain_expertise, multi_step_planning, safety_criticality, output_precision (each 1–10, weighted composite)
- Tier mapping: MECHANICAL composite 1–3.4 → Haiku; STANDARD 3.5–6.4 → Sonnet; DEEP 6.5–10 → Opus
- Low-confidence escalation: classification_confidence < 0.7 → upgrade to Sonnet
- Budget-pressure override: ≥90% utilization forces Haiku except safety_criticality ≥7 (Sonnet floor)
- Escalation logging: original model, escalated model, cost delta — for offline tier calibration
- Escalation frequency monitoring: >15% for a task type triggers tier promotion in routing policy

## Owned Responsibilities

- Per-task model tier selection
- Budget-pressure downgrade with safety_criticality floor enforcement
- Escalation audit trail for routing policy calibration

## Inputs

Mandatory:
    - input/task-metadata.json: Task description, type, estimated tokens
    - input/routing-policy.json: Tier thresholds and dimension weights
    - input/budget-signal.json: Current utilization % from BudgetGovernor

## Outputs

- output/routing-decisions.json: Per-task model assignment with composite score and rationale
- output/routing-decisions-budget-pressure.json: Decisions made under budget pressure override
- output/escalation-log.json: Escalation events with original/escalated model and cost delta

## Dependencies

- BudgetGovernor: Provides budget-signal.json with current utilization %

## Constraints

- Classifier confidence threshold 0.70; below this, upgrades to Sonnet regardless of composite score
- Escalation limited to 2 per task to prevent loops
- High-confidence signal patterns are domain-specific and improve over time with calibration data
- Does not override routing when safety_criticality ≥7 even at full budget pressure

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
