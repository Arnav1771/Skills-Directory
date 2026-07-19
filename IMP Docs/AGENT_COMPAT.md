# AGENT COMPAT — cross-agent portability matrix (v1 · 2026-07-19)

> **What this doc is:** the authoritative per-skill × per-agent compatibility
> grid. Each skill's `manifest.yaml` carries a `compat:` map; this doc renders
> and explains it. Levels: **full** (works as-is), **partial** (core works,
> some steps are Claude-specific), **na** (not applicable). Validated by
> `IMP Docs/validate_catalog.py`. Version-stamped.

## Why this exists

Agent Skills are an open format ([agentskills.io](https://agentskills.io)), and
most of these skills are plain instructions with no Claude-specific tooling — so
they run in Cursor, Codex, GitHub Copilot, Gemini CLI, Windsurf, and Roo Code as
well as Claude Code / Claude.ai. This matrix states, honestly, where each skill
is fully portable versus where a step ties it to a specific host.

## Matrix

| Skill | claude-code | claude-ai | cursor | codex | copilot | gemini-cli | windsurf | roo-code |
|-------|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| **code-translator** | full | full | full | full | full | full | full | full |
| **supply-chain-prober** | full | full | full | full | full | full | full | full |
| **grimoire** | full | full | full | full | partial | full | full | full |
| **mod** | full | na | partial | partial | partial | partial | partial | partial |
| **claude-assassin** | full | na | na | na | na | na | na | na |

## Per-skill rationale

- **code-translator**, **supply-chain-prober** — prompt-only. No shell, no
  Claude-specific tools; the `SKILL.md` instructions are all that's needed, so
  any skill-loading agent runs them unchanged.
- **grimoire** — needs either the Grimoire MCP tools or the `grimoire` CLI
  (shell). `full` on any host with MCP or shell access; `partial` on Copilot
  where agent-mode MCP/shell is more limited.
- **mod** — the build/fix/document/PR pipeline is agent-agnostic shell (git,
  gh, WSL), but Phase 2's **Canary-recorded QA** is a Claude plugin, so non-Claude
  hosts get `partial` (everything but the recorded QA). `claude-ai` is `na`
  (no shell / WSL).
- **claude-assassin** — inherently about **Claude Code** session limits and
  relaunching the `claude` CLI; it has no meaning on other hosts (`na`).

## Maintenance

When a skill gains or loses a host-specific dependency, update its
`manifest.yaml` `compat:` map and re-run `python3 "IMP Docs/validate_catalog.py"`
(it enforces known agent keys, valid levels, and `claude-code: full`). Keep this
table in sync.
