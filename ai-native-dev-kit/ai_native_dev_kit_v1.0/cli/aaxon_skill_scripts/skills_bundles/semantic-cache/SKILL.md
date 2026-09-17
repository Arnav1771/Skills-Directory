---
name: semantic-cache
description: SemanticCache is the first-stage interceptor, checking for exact (hash) and semantic (embedding) matches before any downstream agent runs. Exact hits cost zero tokens (~1–3 ms). Semantic hits cost only the embedding (~300 tokens). At 71.7% hit rate over 12,450 requests/month, ~7.5M tokens avoided. Semantic hits carry mandatory verification flags; PII is never cached.
---

# SemanticCache

**AAxon phase:** 05-Simplified-AI-Operations

## Purpose

Eliminates redundant model invocations by returning stored results for inputs that are identical (exact hash match) or semantically equivalent (cosine similarity ≥ threshold) to previously-answered queries — the first interceptor in the optimization pipeline.

## Capabilities

- Step 1: Input normalization (strip, lowercase, collapse whitespace) + SHA-256 hash
- Step 2: Exact lookup — zero tokens, ~1–3 ms; returns cached result if not expired
- Step 3: Semantic path on miss — compute embedding via text-embedding-3-small (~200–400 tokens)
- Step 4: Nearest-neighbor search (FAISS flat index ≤100K entries; HNSW for larger)
- Step 5: Semantic hit decision at configurable cosine_sim threshold (default 0.92) with mandatory verification warning
- Step 6: Cache miss — compute result, seed into cache with TTL and source tags
- Session metrics: hit rate, tokens avoided, latency savings

## Owned Responsibilities

- First-stage interception before all downstream agents
- Exact and semantic cache hit/miss routing
- PII-safe caching with never-cache pattern enforcement

## Inputs

Mandatory:
    - prompt / file / artifact: Raw input to check
    - cache_store: JSON file or vector index (FAISS/HNSW)
    - similarity_threshold: Default 0.92 (configurable)
  Optional:
    - content_hash (SHA-256): Pre-computed hash to skip normalization

## Outputs

- CacheResult: hit (exact or semantic) | miss
- hit_metadata: cache_type, similarity score, tokens_saved, latency_ms, verification warning (semantic hits)
- session_metrics: aggregate hit_rate, tokens_avoided this session

## Dependencies

- None — SemanticCache is the first agent in the optimization pipeline; all downstream agents (ModelRouter, Model) are called only on miss

## Constraints

- Semantic hits carry mandatory warning: `warning: semantic_match_verify_appropriateness` — require human review or lightweight classifier before use in high-stakes contexts
- Never cache PII patterns: customer_id, account_number, email, real-time balance
- TTL by category: static FAQ 72h, policy rules 24h, dynamic data 1h
- Version-based cache segmentation required on model upgrade to prevent stale hits

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
