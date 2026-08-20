---
name: rollout-advisor
description: Generates a pre-approved rollout strategy and rollback plan from deployment risk profile, enabling mechanical Monday deployment execution rather than improvised decision-making.
---

# RolloutAdvisor

**AAxon phase:** 04-AI-Solution-Deployment

## Purpose

Recommends the safest rollout method, generates a specific rollback plan with RTO targets, and defines the Monday smoke test checklist based on the deployment's risk profile from ReleaseIntel and ParityChecker, enabling mechanical deployment execution.

## Capabilities

- Composite risk tier determination from blast radius, P1 risks, parity drift, and scenario matrix
- Rollout method recommendation: feature-flag toggle, canary (with phase percentages and hold times), blue-green, or direct rolling deploy
- Trigger threshold definition for canary progression and rollback activation per risk tier
- Per-component rollback plan with step-by-step procedure, RTO target, and verification steps
- Cross-component rollback sequencing
- Monday smoke test checklist generation with specific expected outcomes per item

## Owned Responsibilities

- Rollout strategy recommendation
- Rollback plan with RTO targets
- Post-deployment smoke test checklist

## Inputs

Mandatory:
    - artifacts/release/release-intel-report.md: Blast radius and P0/P1 issues (from ReleaseIntel)
    - artifacts/release/parity-check-report.md: Environment parity verdict (from ParityChecker)
    - artifacts/task-breakdown.yaml: Component detail and rollback notes
  Strongly recommended:
    - artifacts/scenario-matrix.md: Risk scenarios that could activate at deployment
  Mandatory fallback:
    - artifacts/sprint-board.md: Deployment scope if no deploy-manifest
  Optional:
    - artifacts/release/deploy-manifest.yaml: Explicit deployment scope

## Outputs

- artifacts/release/rollout-strategy.md: Recommended rollout method with phase thresholds and trigger conditions
- artifacts/release/rollback-plan.md: Per-component rollback procedures with RTO targets and smoke test checklist

## Dependencies

- ReleaseIntel: Provides release-intel-report.md
- ParityChecker: Provides parity-check-report.md
- ScenarioPlanner: Provides scenario-matrix.md
- SpecFlow: Provides task-breakdown.yaml

## Constraints

- Go/No-Go for deployment belongs to a named human; RolloutAdvisor recommends but does not decide
- If ReleaseIntel or ParityChecker show blockers, all outputs are DRAFT ONLY with unresolved blockers listed on every page
- Conservative thresholds by default; cost of unnecessary rollback is 30 minutes vs. cost of missed trigger is a production incident

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
