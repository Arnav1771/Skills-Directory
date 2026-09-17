---
name: memory-persistence
description: MemoryPersistence bridges sessions by extracting actionable state (commitments, open decisions, IDs, constraints) and reinjecting a capped block at session start. Complex multi-threaded sessions escalate from Haiku to Sonnet. The rehydration block is the first system message, preserving decision context without the full prior conversation.
---

# MemoryPersistence

**AAxon phase:** 05-Simplified-AI-Operations

## Purpose

Saves session state at session end and rehydrates a capped context block at session start — eliminating cold-start re-explanation and preserving decision continuity across sessions without reintroducing context bloat.

## Capabilities

- MODE 1 SAVE: Serializes session state into structured JSON (Haiku default; escalates to Sonnet for complex multi-threaded sessions with >3 open threads or interdependencies)
- MODE 2 REHYDRATE: Loads prior state, validates staleness (fresh <24h, potentially_stale 24–168h, stale >168h), caps to 6,000 chars in priority order: commitments > open_decisions > active_task > constraints > context_notes
- PII scrubbing: strips auth tokens, passwords, credit card numbers before persistence
- Versioned snapshots: prior sessions archived to session-history/ for auditing
- Staleness warnings surfaced on rehydration when state is >24h old

## Owned Responsibilities

- Cross-session state serialization and rehydration
- PII-safe persistence with cap enforcement
- Session history archive

## Inputs

Mandatory (SAVE):
    - Session-end conversation context
  Mandatory (REHYDRATE):
    - .claude/memory/\<agent_id\>/session-state.json: Prior persisted state
    - rehydration-config.json: Cap size, staleness thresholds, priority order

## Outputs

SAVE:
    - .claude/memory/\<agent_id\>/session-state.json: Current session state
    - .claude/memory/\<agent_id\>/session-history/: Versioned prior sessions
  REHYDRATE:
    - rehydration-block.md: Injected as first system message — capped state block

## Dependencies

- StrategicCompactor: Optional complement in multi-session workflows for in-session compaction

## Constraints

- Escalation to Sonnet on: >3 open threads, >2 interdependencies, state_complexity="high", or commitment deadline <12h
- PII must be explicitly scrubbed before persistence; truncation at cap is logged to persistence-log.json
- Staleness warning required on rehydration when state is >24h old; stale state (>168h) flagged prominently

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
