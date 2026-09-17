---
name: relevance-pruner
description: RelevancePruner filters large candidate-context pools (KB articles, CRM notes, prior turns) to the highest-value slice before reasoning. It scores by semantic similarity, recency, and source authority, protects safety-critical chunks, and greedily packs within budget. All dropped chunks are logged for threshold calibration.
---

# RelevancePruner

**AAxon phase:** 05-Simplified-AI-Operations

## Purpose

Scores candidate context chunks against the current task query by combining semantic similarity, recency, and source authority, then greedily packs the highest-scoring survivors into a token budget — typically producing 20–50% smaller prompts.

## Capabilities

- Composite relevance scoring: (semantic_similarity × 0.6) + (recency_weight × 0.2) + (source_authority × 0.2)
- Semantic similarity via cosine distance of text-embedding-3-small embeddings
- Recency decay: exponential with 6-month half-life from created_at timestamp
- Source authority defaults: knowledge_base=0.9, faq=0.75, prior_turn=0.65, user_generated=0.3 (all overridable)
- Greedy packing: sort by relevance, protect safety-critical chunks (customer_id, ticket_id, commitment_made patterns), fill budget sequentially
- Full drop log for threshold calibration: every dropped chunk logged with score and reason

## Owned Responsibilities

- Context pool filtering to highest-value slice before reasoning
- Safety-critical chunk protection regardless of relevance score

## Inputs

Mandatory:
    - input/candidate-chunks.json: Context chunks with metadata (source, created_at, content)
    - input/task-query.md: Current task or question to score against
    - input/pruning-config.json: threshold, max_tokens, weights, protected_patterns

## Outputs

- output/pruned-context.json: Kept chunks ordered by relevance score
- output/dropped-chunks-log.json: Dropped chunks with scores and reasons
- output/pruning-summary.json: Aggregate stats — chunks kept/dropped, tokens before/after

## Dependencies

- None (upstream of StrategicCompactor — pruning removes chunks; compaction summarizes them)

## Constraints

- Protected chunks immune to threshold dropping; if protected chunks alone exceed budget, sets budget_exceeded_by_protection: true and includes them anyway
- Never mutates chunk content — selection and rejection only
- Threshold calibration requires monitoring dropped-chunks-log.json over multiple sessions

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
