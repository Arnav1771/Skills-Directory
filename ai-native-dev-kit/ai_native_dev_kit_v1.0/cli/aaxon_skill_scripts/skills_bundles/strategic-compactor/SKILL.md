---
name: strategic-compactor
description: StrategicCompactor is a lossy-but-aware history digest that collapses stale context while preserving all load-bearing state. It classifies turns into ANCHOR/LIVE/STALE/DISCARD, produces a six-section digest with an audit trail, and calibrates reduction aggressiveness to the ContextProfiler alert level (warn ~50–60%, critical ~65–75%).
---

# StrategicCompactor

**AAxon phase:** 05-Simplified-AI-Operations

## Purpose

Transforms long, stale conversation history into a compact, structured digest that preserves all actionable state — IDs, decisions, constraints, open threads — while aggressively discarding exploratory chatter and superseded attempts, reclaiming 40–70% of history tokens.

## Capabilities

- Turn classification: ANCHOR (verbatim preserve), LIVE (summarize, keep intent), STALE (collapse into count), DISCARD (drop entirely)
- Six-section digest: Task State, Decisions Made, Open Threads, Key IDs & References, Constraints, Discarded Material
- Collapse-exploration-loops rule: discard intermediate steps, keep final result + pivot decision
- Greedy compaction calibrated by ContextProfiler alert level: warn → ~50–60% reduction; critical → ~65–75% reduction
- Audit trail: retained-anchor-manifest.json records every kept item with its classification reason
- Quality checklist before output: anchors preserved, open threads retained, constraints verbatim, tokens saved 40–80%

## Owned Responsibilities

- Pressure-triggered history compaction
- ANCHOR-class item preservation with zero paraphrase
- Audit trail of all retained and discarded content

## Inputs

Mandatory:
    - full-session.md: Conversation history to compact
    - keep-anchors.json: Values that MUST be preserved verbatim (IDs, amounts, commitments)
    - context-profiler-alert.json: Utilization % and alert level from ContextProfiler

## Outputs

- output/compacted-context.md: Structured six-section digest
- output/retained-anchor-manifest.json: Per-item audit with classification and preservation reason
- output/token-delta.json: Pre/post token counts, reduction %, quality assessment tier

## Dependencies

- ContextProfiler: Provides alert level and utilization % as trigger and calibration signal

## Constraints

- No ANCHOR-classified turn may be paraphrased beyond recognition
- Monetary amounts must not be rounded; status must not be invented
- Distinct decisions kept separate — no merging of unrelated decisions
- All IDs preserved verbatim; no abbreviation permitted

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
