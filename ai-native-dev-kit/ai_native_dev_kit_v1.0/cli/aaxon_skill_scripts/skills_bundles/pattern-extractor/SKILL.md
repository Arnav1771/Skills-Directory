---
name: pattern-extractor
description: PatternExtractor harvests tacit knowledge from sessions — tool sequences, phrasing, heuristics — and packages them into reviewable skill candidate stubs. Confidence scoring surfaces patterns needing more evidence vs. ready for promotion. Anti-pattern detection flags patterns correlated with quality failures. All promotion requires explicit human review. --- # Catalog Quality Report
---

# PatternExtractor

**AAxon phase:** 05-Simplified-AI-Operations

## Purpose

Mines session transcripts and artifacts for recurring decision patterns, tool call sequences, and reasoning chains, scores confidence, clusters into candidate skills, and queues high-confidence patterns for human promotion review.

## Capabilities

- Five pattern types extracted: tool_sequence, reasoning_chain, phrasing, decision_heuristic, artifact
- Confidence scoring: min(1.0, (occurrences − 1) × 0.25 + consistency_score × 0.5)
- Anti-pattern detection: patterns correlated with quality-failure sessions flagged regardless of confidence
- Candidate skill clustering: related patterns grouped by Jaccard ≥0.4 step overlap
- Overlap check against existing skill library: >60% step overlap → suggest enhance vs. new
- SKILL-\<id\>-candidate.md stub generation: trigger, instructions, examples, caveats

## Owned Responsibilities

- Tacit knowledge harvesting from sessions
- Candidate skill stub generation for human review
- Anti-pattern flagging from failure-correlated patterns

## Inputs

Mandatory:
    - input/session-transcript.md: Session transcript to mine
    - input/session-artifacts.json: Artifacts produced (git diff format)
    - input/existing-skill-library.json: Current skill library for overlap detection

## Outputs

- output/pattern-catalogue.json: All extracted patterns with scores and type classifications
- output/SKILL-\<pattern_id\>-candidate.md: One stub per promotable pattern (≥0.50 confidence)
- output/promotion-queue.json: Ready (≥0.75) and needs-more-evidence (0.50–0.74) patterns
- output/extraction-report.json: Summary statistics and anti-pattern flags

## Dependencies

- Human reviewer: Final promotion gate — no pattern is auto-promoted to a live skill

## Constraints

- Confidence ≥0.75 queues as ready; 0.50–0.74 as needs-more-evidence; <0.50 stored only
- Single-session bias cap: ≥0.75 confidence requires evidence from at least 2 sessions
- Anti-patterns flagged for explicit human override — never auto-suppressed
- No automatic promotion; human review is mandatory for all candidate skills

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
