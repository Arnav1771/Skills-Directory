---
name: tool-surface-auditor
description: Identifies tool schema bloat via usage telemetry and recommends disabling idle MCP tools to reclaim standing-context tokens. At typical metrics, disabling never-used tools can free 5–15% of context window. All disable decisions require human confirmation.
---

# ToolSurfaceAuditor

**AAxon phase:** 05-Simplified-AI-Operations

## Purpose

Audits enabled MCP servers and tool schemas against 30-day usage telemetry, produces disable/keep recommendations per tool, and quantifies standing-context token reclaim by identifying idle tool descriptions consuming permanent context every session.

## Capabilities

- Tool inventory loading with per-tool token cost (description + schema)
- 30-day telemetry ingestion: calls_30d, last_called, error_rate, latency_ms
- Usage scoring per tool: (calls_per_session × 0.5) + (recency_score × 0.3) + ((1 − error_rate) × 0.2)
- Classification into four tiers: active (>0.4), occasional (0.1–0.4), dormant (0.0–0.1 with calls), never-used (0 calls)
- Server-level consolidation recommendation when ≥80% of a server's tools are dormant or never-used
- Token impact projection: before/after context window size, monthly savings at 1K sessions/day
- Disable configuration generation (env var snippets + JSON) for human review before apply

## Owned Responsibilities

- MCP tool usage audit and disable recommendation
- Standing-context token reclaim from idle tool schemas
- Tool surface sizing against configurable ceilings (≤10 MCP servers, ≤80 total tools)

## Inputs

Mandatory:
    - input/enabled-tools.json: Current MCP server and tool inventory with token costs
    - input/usage-telemetry.json: 30-day tool call telemetry
    - input/audit-config.json: Ceilings and thresholds

## Outputs

- output/tool-audit-report.json: Per-tool scores, classification, recommendation (sorted by score)
- output/disabled-mcps-config.md: Env var + JSON disable snippets — requires human confirmation before apply
- output/token-impact-report.json: Before/after token counts and monthly savings estimate

## Dependencies

- None (integrates with MCP configuration management)

## Constraints

- Target ceilings: ≤10 MCP servers, ≤80 total tools; flags if exceeded
- Recency bias: tools called during incidents score low in quiet windows — apply zero-call-zero-error safety rule before disabling
- Telemetry window must match tool cycle (monthly billing tool needs ≥30-day window)
- All disable recommendations require human confirmation and staged rollout; never auto-applied

## Provenance

Auto-generated from AA's internal skill_catalog.md. This bundle captures the skill's documented contract (purpose, inputs, outputs, constraints) as a starting point for Claude API execution. It does NOT include the skill's original implementation logic/scripts (those live in the AAxon framework source, not in the catalog) — review and extend before relying on this for production output.
