# Update Log — Skills-Directory

> **What this doc is:** the changelog. Rules: reverse-chronological (newest on
> top); one dated entry per change, grouped as **Added / Changed / Fixed /
> Removed**; link the PR where there is one; **append, never rewrite history**.
> Dates are `YYYY-MM-DD`. Format follows Keep-a-Changelog conventions.

---

## 2026-07-05
### Added
- `grimoire` skill — generate/modify a full app from plain English and push it to a private GitHub repo (with IMP_DOCS/), via the Grimoire MCP tools or CLI. BYO-keys (GitHub + one AI provider). SKILL.md + references/ + flow SVG.

## 2026-07-04
### Added
- `IMP Docs/` for the repo itself — `HANDOFF.md` (cold-start briefing),
  `TECHSPEC.md` (architecture + skill standard), and this `Update.md`.
- README **Install & Use** section (Claude Code + Claude.ai) with per-skill
  example triggers.
### Changed
- README: softened the `SKILL.md` "format" from a rigid structure to an
  adaptable template (matching the official guide); switched the "Push & Ship"
  flow to feature-branch + PR; linked `IMP Docs/`.
- _(PR pending)_

## 2026-07-04 — `mod` v1.1.0  ([PR #2](https://github.com/Arnav1771/Skills-Directory/pull/2))
### Changed
- Restructured `mod` from a single `SKILL.md` into the full multi-file layout:
  `references/` (universal-build-prompt, phase-playbook, doc-templates),
  `scripts/` (select-git-identity, scaffold-imp-docs), and a pipeline SVG.
- Cleaned frontmatter: removed forbidden `<`/`>` angle brackets, added
  `metadata` (author/version), added an explicit **no-AI-attribution** rule.
- README: linked Anthropic's skill-building guide and expanded the folder-
  structure convention + frontmatter rules.

## 2026-07-04 — `mod` v1.0.0  ([PR #1](https://github.com/Arnav1771/Skills-Directory/pull/1))
### Added
- `mod` skill — end-to-end build/fix/ship harness invoked as `Mod: <repo link>`
  (initial single-file version).

## 2026-07-02
### Added
- `claude-assassin` skill — silent daemon that saves task state on a Claude Code
  session limit and auto-relaunches when the reset timer expires; ships scripts,
  references, and two SVG diagrams.

## 2026-06-29
### Added
- `supply-chain-prober` skill — conversational supply-chain intake with scripts,
  a question bank, and examples.
- `code-translator` skill — cross-language code translation preserving logic.
- Skill-creation "Ritual" section in the README.
### Changed
- Upgraded `supply-chain-prober`: role routing, confidence scoring, risk
  taxonomy, data schema, analytics report, CSV template.
- Brought `SKILL.md` files in line with the Claude skill standards.

### Added (repo)
- Initial commit — repository scaffold and README.
