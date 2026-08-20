---
name: context-profiler
description: ContextProfiler is a deterministic accounting agent that measures context window pressure without invoking an LLM (except optionally for narration via Haiku). It surfaces the silent context tax of tool schemas and conversation history, and recommends targeted compaction or pruning before context pressure causes failures.
---

# ContextProfiler

**AAxon phase:** 05-Simplified-AI-Operations

## Purpose

Measures the token footprint of every context segment — system prompt, tool schemas, conversation history, injected files, memory blocks — and fires threshold alerts that trigger downstream compaction or pruning, making silent context pressure visible before it becomes catastrophic.

## Capabilities

- Independent tokenization of five context segments: system_prompt, tool_schemas, conversation_history, injected_files, memory_blocks
- Utilization percentage and headroom calculation against model window (default 200K, configurable)
- Threshold alerts: warn (approaching limit), critical (near capacity), emergency (overflow imminent)
- Downstream recommendations: StrategicCompactor at warn/critical; RelevancePruner at emergency
- Optional Haiku narration of findings for human-readable context health report
- Versioned snapshot: preserves prior context-budget.json as context-budget-\<timestamp\>.json

## Owned Responsibilities

- Context window utilization measurement
- Alert firing to trigger StrategicCompactor and RelevancePruner
- Context segment breakdown for audit

## Inputs

Mandatory:
    - input/conversation-transcript.md: Current conversation history
    - input/system-prompt.md: Active system prompt
    - input/mcp-tools.json: Enabled tool schemas
  Optional:
    - input/memory-blocks.json: Active memory blocks
    - input/injected-files.json: Injected file contents
    - model_window_size: Override (default 200K tokens)

## Outputs

- output/context-budget.json: Per-segment token counts, utilization %, headroom, alert level, recommendations
- output/context-budget-\<timestamp\>.json: Versioned prior snapshot

## Dependencies

- StrategicCompactor: Triggered at warn and critical alert levels
- RelevancePruner: Triggered at emergency alert level

## Constraints

- Uses character-based heuristic (÷3.8 for prose, ÷3.5 for JSON); conservative bias — cannot claim byte-exact token counts
- If a source segment is missing, treats as 0 tokens with a logged warning
- Overflow classified as emergency halt regardless of other thresholds
- Tool schemas are often the hidden cost: 8 Salesforce tools can consume 12–15K tokens silently

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
