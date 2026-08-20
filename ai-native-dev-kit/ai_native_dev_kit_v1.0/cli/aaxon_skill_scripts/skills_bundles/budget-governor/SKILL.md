---
name: budget-governor
description: BudgetGovernor gates agentic pipelines with pure-arithmetic cost accounting, never invoking an LLM. It prevents budget breaches by comparing projected spend against tiered caps, routing high-cost steps to ModelRouter for transparent downgrade, and maintaining an append-only ledger. Canonical use case: multi-step agentic loops with risk of runaway token consumption.
---

# BudgetGovernor

**AAxon phase:** 05-Simplified-AI-Operations

## Purpose

Enforces token and dollar budgets on AI agent task graphs before execution and at every loop iteration using pure-arithmetic cost accounting, preventing runaway costs and surprise bills without invoking any LLM.

## Capabilities

- Deterministic cost forecast from task graph: token estimates × pricing-table per model per step
- Comparison against tiered caps: task-level, session-level, sprint-level
- Gate decisions: proceed, warn (approaching cap), block (cap would be exceeded)
- Highest-cost step identification with model-downgrade suggestions routed to ModelRouter
- Running spend ledger: append-only per-step cost record for transparency
- Loop runaway detection: mid-iteration budget breach halts execution before the next loop turn

## Owned Responsibilities

- Pre-execution cost gate for agentic pipelines
- Budget cap enforcement at task, session, and sprint tiers
- Spend ledger maintenance

## Inputs

Mandatory:
    - input/task-graph.json: Agent task graph with per-step token estimates
    - input/pricing-table.json: Per-model token prices
    - input/budget-caps.json: Configured caps at task, session, and sprint tiers

## Outputs

- output/cost-forecast.json: Per-step projected cost, gate decision (proceed/warn/block)
- output/spend-ledger.json: Append-only per-step actual spend record

## Dependencies

- ModelRouter: Receives remediation suggestions when BudgetGovernor emits warn or block on a step

## Constraints

- Forecast accuracy bounded by upstream I/O token estimates; assumes 0% cache hit rate conservatively
- Does not observe actual mid-step token usage; reconciles post-step only
- Loop runaway detection requires the task graph to expose iteration boundaries

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
