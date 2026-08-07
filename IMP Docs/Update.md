# Update Log — Skills-Directory

> **What this doc is:** the changelog. Rules: reverse-chronological (newest on
> top); one dated entry per change, grouped as **Added / Changed / Fixed /
> Removed**; link the PR where there is one; **append, never rewrite history**.
> Dates are `YYYY-MM-DD`. Format follows Keep-a-Changelog conventions.

---

## 2026-08-07 — fix: site was unstyled when served from a document root  _(PR #8)_
### Fixed
- **The export only worked on GitHub Pages.** `site/next.config.ts` hard-coded
  `basePath: "/Skills-Directory"`, so every asset URL in `out/index.html` was
  `/Skills-Directory/_next/...`. Serving `site/out` as the document root — the
  obvious thing to do after `npm run build` — 404'd all 12 of them: no
  stylesheet (`document.styleSheets[0].cssRules.length === 0`, page fell back to
  Times New Roman), no JS, nothing interactive. The HTML itself was fine; it was
  purely a serving-root/basePath mismatch.
- The prefix is now **opt-in** via `NEXT_PUBLIC_BASE_PATH` (with a
  `GITHUB_ACTIONS=true` fallback so a Pages deploy can't ship a root-relative
  build by accident). `npm run build` emits root-relative assets;
  `npm run build:pages` emits the `/Skills-Directory`-prefixed ones.
### Added
- `site/scripts/build-pages.mjs` + `npm run build:pages` — the Pages flavour, as
  a node script so it works on any shell.
- `site/scripts/preview.mjs` + `npm run preview` / `npm run preview:pages` — a
  dependency-free static server for `out/`, at the root or at a base path, so
  previewing either flavour is one command.
### Changed
- `site/scripts/deploy-ghpages.sh` now runs `npm run build:pages` itself instead
  of shipping whatever happened to be in `out/`.
- `.github/workflows/ci.yml` builds **both** flavours and asserts the default
  build's asset URLs are root-relative, the Pages build's are prefixed, and both
  resolve to files that exist on disk.
- `site/README.md` rewritten (was still the create-next-app boilerplate) and the
  root README gained the local-run recipe.
### Verified
- `npm run build`: 23 static pages exported, exit 0. Served `out/` at
  `127.0.0.1:8231` — `GET /` → 200 (76,735 bytes) and **all 10** asset URLs
  grepped out of `out/index.html` → 200, e.g.
  `/_next/static/chunks/3kky2t8mmyzem.css` → 200, 26,545 bytes (the same file
  under `/Skills-Directory/...` correctly 404s). Routes `/skills/`,
  `/categories/`, `/leaderboard/`, `/search/`, `/skills/mod/`, `/sitemap.xml`
  all 200.
- `npm run build:pages` + `npm run preview:pages`: `GET /Skills-Directory/` →
  200 (78,146 bytes), all 10 prefixed asset URLs → 200, nav hrefs prefixed.
- `IMP Docs/validate_manifests.py`: all 5 manifests valid.
### Notes
- No browser verification — visual rendering was not checked. The proof is that
  every asset URL referenced by the served HTML returns 200 in both arrangements.
- Branch `mod/2026-07-18-directory-site` was rebased onto `main` (it was 5 ahead
  / 4 behind and conflicting); the only conflict was this file.

## 2026-07-19 — universal installer (inject skills into any agent CLI)  _(PR pending)_
### Added
- **`scripts/export_skills.py`** — converts every skill's `SKILL.md` into each
  major CLI's native format, writing `exports/{agents,cursor,windsurf,gemini}/`
  + a whole-catalog `exports/AGENTS.md` + `exports/index.txt`. Adds an
  activation preamble (from the trigger phrases in `skill_evals.yaml`), rewrites
  relative links to absolute GitHub URLs, and wraps appendable output in
  `<!-- skills-directory:<name> -->` markers. Flags Windsurf files over 12k.
- **`install.sh`** (repo root) — one command to install a skill into any CLI:
  `curl … | bash -s -- <skill>` or `./install.sh <skill> --tool cursor`.
  Auto-detects the tool (`.cursor` / `.windsurf` / `AGENTS.md` / `~/.gemini` /
  `~/.claude`), supports `--global`/`--project`/`--dir`, `all`, and `--list`,
  and is idempotent (replaces a skill's block on re-install).
- **`exports/`** — committed pre-converted files so users with no tooling can
  copy the one they need by hand.
- **`IMP Docs/PORTABILITY.md`** — where each tool reads instructions, how the
  port works, and honest limitations.
### Changed
- README: new "Install into any agent CLI (one command)" section under the
  cross-agent compat table.
### Verified
- Ran the installer end-to-end into a sandbox for cursor / windsurf / agents /
  gemini, plus idempotency (block replaced, single marker), `all` (5 skills
  bundled), and auto-detect (spotted `.cursor/`). Existing checks still pass
  (25 trigger evals, marketplace + compat + manifests).
### Notes
- Built in a worktree off `main` (has PR #6); does not touch `site/`.
- Ported files are the `SKILL.md` body (references/scripts link back to GitHub);
  script-heavy skills run best in native Claude form.

## 2026-07-19 — plugin marketplace, trigger evals, cross-agent compat  _(PR pending)_
### Added
- **`.claude-plugin/marketplace.json`** — the repo is now a Claude Code plugin
  marketplace. Install any skill with `/plugin marketplace add
  Arnav1771/Skills-Directory` + `/plugin install <skill>@skills-directory`
  (one plugin entry per skill, `strict: false`, `skills: ["./<skill>"]`).
- **Trigger-eval harness** — `IMP Docs/skill_evals.yaml` (per-skill
  should_trigger / should_not phrases) + `IMP Docs/eval_skills.py` asserting
  each `SKILL.md` description still contains its trigger phrases, excludes other
  skills' phrases, and flags ambiguous cross-skill matches. 25 assertions pass.
- **Cross-agent compat matrix** — a `compat:` map (`full`/`partial`/`na` across
  claude-code, claude-ai, cursor, codex, copilot, gemini-cli, windsurf,
  roo-code) in every `manifest.yaml`; rendered + explained in
  `IMP Docs/AGENT_COMPAT.md`; README gains a "Works across agents" table.
- **`IMP Docs/validate_catalog.py`** + `run_checks.sh` — validates
  marketplace↔skill consistency (entry per skill, skills paths resolve,
  version/description mirror the manifest) and the compat matrix (known agents,
  valid levels, `claude-code: full`).
### Changed
- README: added the one-command plugin-marketplace install as the recommended
  path (manual `cp -r` kept as the fallback); added the cross-agent compat table.
### Notes
- CI wiring (a `.github/workflows` gate running `run_checks.sh`) is **deferred**:
  the local token lacks `workflow` scope (see `USE_CASES.md` #3). The scripts are
  CI-ready — add the workflow via the GitHub web UI or a workflow-scoped token.
- Built in an isolated worktree off `main` to avoid the in-flight directory-site
  branch; does not touch `site/`.
## 2026-07-18 — directory website, live on GitHub Pages  _(PR pending)_
### Added
- **`site/`** — a full directory/marketplace website for the catalog (modeled on
  mcpmarket.com): Next.js App Router + TypeScript + Tailwind v4, statically
  exported and **live at
  [arnav1771.github.io/Skills-Directory](https://arnav1771.github.io/Skills-Directory/)**.
  - Build-time pipeline (`site/scripts/build-content.mjs`) walks every skill
    folder, parses `manifest.yaml` + `SKILL.md` (frontmatter stripped, body
    rendered to HTML), augments with git last-commit dates and GitHub repo
    stats, and emits `site/content/skills.json` — the single data source the UI
    consumes (swappable for a DB later without touching components).
  - Routes: `/` (hero, featured/top/latest rows, category chips, FAQ),
    `/skills` (+ `/skills/[slug]` detail with rendered SKILL.md, install
    copy-button, composes-well cross-links), `/categories` (+ per-category),
    `/leaderboard` (composite score: inbound/outbound composesWell, semver
    maturity, toolkit completeness), `/search` (Fuse.js fuzzy), `/submit`,
    `/what-is-an-agent-skill`, `sitemap.xml`.
  - Client-side fuzzy search + combinable category/tag filters reflected in the
    URL; dark/light theme persisted to localStorage; per-page SEO metadata.
  - Deployed as a static export (`output: "export"`, basePath
    `/Skills-Directory`, `.nojekyll`) pushed to the **`gh-pages`** branch via
    `site/scripts/deploy-ghpages.sh` (no Actions — the local `gh` token lacks
    `workflow` scope); Pages serves from that branch.
  - HTTP-layer smoke tests (`site/scripts/smoke-test*.sh`): 15/15 routes 200,
    basePath-prefixed assets resolve, SKILL.md bodies render, sitemap lists 19
    URLs.
- `IMP Docs/USE_CASES.md` — roadmap of candidate use cases for the directory.
- `IMP Docs/PROMPT_TRAIL.md` — per-prompt work log (mod-pipeline convention).
### Changed
- README: added the live-site link at the top.
### Notes
- `/daily` (trending) deliberately omitted — no install/view analytics exist
  yet, and the spec says don't fake counters.

## 2026-07-11 — catalog metadata layer  _(PR pending)_
### Added
- `manifest.yaml` for all five skills (`mod`, `grimoire`, `claude-assassin`,
  `code-translator`, `supply-chain-prober`) — an optional, human/catalog-facing
  discovery layer (`name`, `description`, `categories`, `tags`, `icon` [Lucide],
  `version`, `composesWell`). Modeled on the formatting concept used by community
  skill directories; **no third-party skills or content were copied.**
- `IMP Docs/validate_manifests.py` (+ `run_validate.sh`) — validates every
  manifest against the catalog contract (required fields, name/folder match, no
  angle brackets in description, quoted version, `composesWell` resolves). All
  five pass; it caught and fixed one angle-bracket violation in `mod`.
### Changed
- README: replaced the flat "Available Skills" table with a **category-grouped
  catalog** (Developer & Build Tools · Business & Data) showing tags + version,
  plus a "composes well" note; documented the `manifest.yaml` format and added it
  to the folder-structure/Ritual convention.
- `TECHSPEC.md` → v2: added §4a (`manifest.yaml` interface) and listed it in the
  skill folder contract; clarified it is catalog-only, not part of the runtime.
### Notes
- Deliberately **not** adopted from the reference: the three-way
  `skills/`/`commands/`/`agents/` top-level split (all items here are skills, and
  it would break documented install paths) and any hosted-marketplace install URL.

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
