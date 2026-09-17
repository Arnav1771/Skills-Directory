---
name: regex-llm-router
description: RegexLLMRouter eliminates wasteful LLM spend on tasks solvable in code. For every parsing task, it scores structural regularity and routes to deterministic regex (cost ~$0), hybrid (regex with LLM fallback), or full LLM. Pre-scored taxonomy handles common customer-service patterns.
---

# RegexLLMRouter

**AAxon phase:** 05-Simplified-AI-Operations

## Purpose

Assesses text-parsing tasks across five structural regularity dimensions and routes each to regex/parser, hybrid, or LLM execution — eliminating wasteful LLM spend on tasks solvable deterministically in code.

## Capabilities

- Five-dimension scoring per parsing task: schema_consistency, delimiter_reliability, ambiguity_level, error_tolerance, volume (each 1–5)
- Route mapping by total score: 20–25 → regex; 13–19 → hybrid; 0–12 → LLM
- Hybrid detail: regex handles structured majority; LLM handles ambiguous residual; fallthrough rate monitored (promote if <10%, demote if >60%)
- Regex pattern emission: working Python patterns with capture groups, ≥3 positive and 2 negative test cases, known failures documented
- Pre-scored taxonomy for customer-service domain: order IDs, email, amounts → always regex; sentiment, intent → always LLM

## Owned Responsibilities

- Parse-task routing between deterministic and LLM execution
- Regex pattern generation for routed-to-code tasks

## Inputs

Mandatory:
    - input/parsing-tasks.json: Tasks to route with sample inputs
    - input/routing-config.json: Domain taxonomy overrides and fallthrough thresholds

## Outputs

- output/routing-decisions.json: Per-task route (regex/hybrid/LLM) with score breakdown
- output/regex-patterns.json: Generated patterns with test cases for regex-routed tasks
- output/hybrid-strategy.json: Fallthrough rules and monitoring thresholds for hybrid-routed tasks

## Dependencies

- None

## Constraints

- Regexes must be syntactically valid; known failures must be documented — no silent pattern gaps
- Hybrid fallthrough logged and monitored; high fallthrough rate triggers tier demotion
- Volume dimension bias: low volume may not justify regex engineering time even at high total score

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
