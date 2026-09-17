---
name: rolling-summarizer
description: RollingSummarizer proactively folds conversation history into a compact rolling digest on a schedule (Haiku by default, Sonnet for legal/formal commitments). It preserves IDs, amounts, and commitments verbatim while aggressively compressing exploratory context. Context replacement removes old raw turns and inserts the updated summary in their place.
---

# RollingSummarizer

**AAxon phase:** 05-Simplified-AI-Operations

## Purpose

Maintains a bounded, predictable context size across long-running sessions by folding newly accumulated turns into a compact rolling summary on a regular cadence — every ≥10 turns or ≥3K new tokens — preserving all actionable state while aggressively discarding exploratory chatter.

## Capabilities

- Cadence trigger: turns_since_last_summary ≥10 OR token_count_of_new_turns >3K
- Haiku default; escalates to Sonnet on legal_language, formal_commitment, regulatory_compliance, or dispute_escalation content
- Folding logic: identifies new facts, updates/appends existing sections, deduplicates — never discards verbatim commitments
- Six-section rolling summary: ## Session Context, ## Customer Profile, ## Issue Summary, ## Actions Taken, ## Pending Items, ## Commitments Made
- Token budget enforcement (max 800 tokens default): compresses Session Context first, then Issue Summary — never Commitments Made or Customer Profile
- Context replacement: removes raw accumulated turns and inserts updated summary in their place

## Owned Responsibilities

- Cadence-based conversation history compaction
- Commitment and key-ID preservation across compaction cycles

## Inputs

Mandatory:
    - input/recent-turns.md: New conversation turns since last summary
    - input/prior-summary.md: Prior rolling summary or seed
    - input/summarizer-config.json: Cadence thresholds, max_summary_tokens, escalation triggers

## Outputs

- Updated rolling-summary.md block (replaces raw accumulated turns in context)

## Dependencies

- StrategicCompactor: Optional — for pressure-based compaction between cadence cycles
- MemoryPersistence: Optional — for cross-session state continuity

## Constraints

- Escalation to Sonnet required for formal commitments and legal language; escalation_reason logged
- commitment_text never compressed — preserved verbatim regardless of budget pressure
- Max summary token budget strictly enforced; truncation logged to persistence-log.json

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
