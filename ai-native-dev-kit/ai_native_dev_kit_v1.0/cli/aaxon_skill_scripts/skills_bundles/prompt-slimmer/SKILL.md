---
name: prompt-slimmer
description: Reduces system prompt bloat through five deterministic phases — audit, merge, compress, classify, diff. Safe changes auto-apply; critical sections require Opus drift-check and human sign-off. A 60% reduction on a 950-token prompt at 1K calls/day saves ~$1.14/day without changing behaviour.
---

# PromptSlimmer

**AAxon phase:** 05-Simplified-AI-Operations

## Purpose

Audits system prompts and rules files for redundancy, overlapping intent, and verbosity, produces a minimized prompt with a structured diff, and routes critical sections through Opus review and human sign-off before any changes are applied.

## Capabilities

- Phase 1 Audit: parses all directives, flags duplicates, semantic duplicates, superseded rules, and contradictions
- Phase 2 Merge: collapses redundancy while preserving intent; dead rules dropped with reason
- Phase 3 Compress: rewrites verbose directives minimally; skips protected critical directives
- Phase 4 Classify: safe (auto-apply), review (human spot-check), critical (Opus drift-check + human sign-off)
- Phase 5 Diff: produces side-by-side markdown with TOKENS_SAVED per directive
- Protected phrases copied byte-for-byte; contradictions surfaced but never auto-resolved

## Owned Responsibilities

- System prompt redundancy detection and minimization
- Critical section routing to Opus for drift-check before any change is applied

## Inputs

Mandatory:
    - --system-prompt: System prompt file to slim
    - --rules-files: One or more .mdc / rules files
    - --criticality-flags: Sections marked as critical for Opus routing
    - --output-dir: Output directory

## Outputs

- output/system-prompt-slimmed.md: Safe changes applied; critical changes staged pending sign-off
- output/prompt-diff.md: Side-by-side diff with TOKENS_SAVED annotation per directive
- output/slimming-report.json: Per-directive disposition, token delta, classification

## Dependencies

- claude-opus-4-7 (external model): Read-only drift-check for critical sections — not a catalog skill

## Constraints

- Critical sections require Opus confirmation + explicit human APPROVED mark before application
- Contradictions block merging until human resolves
- Protected phrases never paraphrased; original prompt preserved in audit record
- Token counting flagged as estimate if tokenizer unavailable

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
