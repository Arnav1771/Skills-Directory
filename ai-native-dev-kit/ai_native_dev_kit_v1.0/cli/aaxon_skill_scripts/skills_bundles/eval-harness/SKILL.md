---
name: eval-harness
description: Constructs a shared LLM-as-Judge evaluation rubric from openspec.yaml criteria and POD Lead-defined golden references, scoring AI outputs and detecting quality drift across sprints.
---

# EvalHarness

**AAxon phase:** 03-Platform-Enablement

## Purpose

Provides a shared, consistent LLM-as-Judge scoring rubric for evaluating the semantic quality of every AI-generated output across the sprint — consumed by Guardian, RedTeamX, and SimLab — ensuring that quality means the same thing regardless of which agent is evaluating.

## Capabilities

- Rubric construction from openspec.yaml semantic criteria (accuracy, tone, completeness, conciseness, safety, groundedness, custom dimensions)
- HITL golden reference elicitation (POD Lead defines expected outputs or pass/fail thresholds)
- LLM-as-Judge evaluation with structured scoring prompt
- Weighted aggregate score calculation per output
- Drift detection against prior sprint rubric (flags shifts > 0.5 points)
- eval-rubric.yaml generation as shared rubric for all Validate agents

## Owned Responsibilities

- Shared semantic evaluation framework
- LLM-as-Judge scoring methodology
- Sprint-level evaluation rubric management
- Evaluation drift detection across sprints

## Inputs

Mandatory:
    - artifacts/openspec.yaml: Semantic evaluation criteria per feature
    - artifacts/golden-references/: Human-defined expected outputs per feature
    - AI model outputs: Actual outputs to evaluate (from Guardian, RedTeamX, SimLab, or direct)
  Optional:
    - artifacts/eval-rubric-prev.yaml: Prior sprint rubric for drift detection

## Outputs

- artifacts/eval-rubric.yaml: Compiled rubric consumed by Guardian, RedTeamX, and SimLab
- artifacts/eval-results.json: Per-output scores with rationale
- artifacts/eval-summary.md: Sprint-level quality summary for Release gate
- artifacts/eval-drift-alert.md: Written only if drift detected

## Dependencies

- None (EvalHarness provides shared rubric to other agents; it does not depend on them)

## Constraints

- Cannot operate without golden references; POD Lead must define them before scoring
- LLM-as-judge evaluations carry systematic biases (length bias, position bias, self-familiarity bias)
- Drift detection requires at least one prior sprint's rubric
- Scores semantic quality only; functional correctness is Guardian's domain

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
