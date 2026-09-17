---
name: iterative-retrieval
description: IterativeRetrieval exploits the fact that most queries need only a small fraction of available documents. It retrieves top-3 chunks, scores confidence, detects gaps, and fetches targeted slices on demand. A heuristic-based gap-detection engine drives the loop, halting as soon as confidence reaches 0.85 or budget exhausts. Produces an auditable per-round trace.
---

# IterativeRetrieval

**AAxon phase:** 05-Simplified-AI-Operations

## Purpose

Retrieves only the minimum context needed to answer a question by loading the smallest relevant slice first and fetching additional chunks only when a reasoning gap is detected — typically cutting input tokens 5–10× versus full-context loading.

## Capabilities

- Task decomposition into retrieval dimensions: entities, intent, domain, constraints, unresolved conditions
- Initial retrieval: top-3 most relevant chunks from document index
- Confidence scoring after each round (0.0–1.0): halts at ≥0.85, max 5 rounds, or 12K token budget exhausted
- Gap-detection heuristics: explicit uncertainty markers, implicit dead-ends, customer-service-specific triggers (e.g. policy lookups, order state transitions)
- Targeted follow-up retrieval based on detected gap type
- Auditable trace: per-round queries, chunks retrieved, confidence scores, gap-detection reasoning

## Owned Responsibilities

- Minimum-context knowledge retrieval
- Confidence-gated iterative fetch loop

## Inputs

Mandatory:
    - task-spec.md: Task or question to answer
    - document-index.json: Vector-store or keyword index over knowledge base
    - retrieval-config.json: Confidence threshold, max rounds, token budget, domain heuristics

## Outputs

- output/grounded-answer.md: Answer with inline citations to source chunks
- output/retrieval-trace.json: Per-round audit — query, chunks, confidence, gap detected
- output/coverage-report.json: Final confidence score, rounds used, budget consumed

## Dependencies

- Document index quality (external): Weak embeddings force more rounds and may exhaust budget

## Constraints

- Latency: each additional round adds a network trip to the vector store
- Non-decomposable questions (requiring synthesis across all documents) require full-context loading — not appropriate for iterative retrieval
- Stop criteria (confidence threshold, max rounds) are per-task-type and require calibration

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
