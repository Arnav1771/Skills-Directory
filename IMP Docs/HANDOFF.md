# HANDOFF — Skills-Directory (v1 · 2026-07-04)

> **What this doc is:** the cold-start briefing. Anyone (human or agent) should be
> able to read only this file and know what the repo is, its current state, how to
> work on it, and exactly what to do next. Rules: no jargon without a pointer,
> every claim reflects the repo as it actually is, and it ends with numbered next
> steps. Version-stamped; superseded, never silently overwritten.

> ## Current state — 2026-08-07 (read this first; the v1 body below predates the site and CI)
>
> - **5 skills**, not 4: `claude-assassin`, `code-translator`, `grimoire`, `mod`,
>   `supply-chain-prober`. `IMP Docs/validate_manifests.py` reports all five valid
>   (verified 2026-08-07).
> - **There is now a site.** `site/` is a Next 16 static export (23 pages) generated
>   from the skill manifests. `TECHSPEC.md` §9 has the architecture.
> - **There is now CI.** `.github/workflows/ci.yml` runs two jobs — "manifests + shell
>   scripts" and "Next.js static export" — so the v1 body's "no CI, validation is
>   manual" is out of date for the *mechanical* checks. Trigger quality is still
>   manual, as `DESIGN_CHOICES.md` §5 explains.
> - **Two build flavours since 2026-08-07.** `npm run build` emits a root-relative
>   export that serves from any document root; `npm run build:pages` emits the
>   `/Skills-Directory`-prefixed export for GitHub Pages. Preview them with
>   `npm run preview` / `npm run preview:pages`. Reasoning in `DESIGN_CHOICES.md` §7.
>   Do not assume `site/out` holds the flavour you want — nothing in the directory
>   records which build produced it.
> - **Open work:** PR #8 (`mod/2026-07-18-directory-site` → `main`) is OPEN and
>   MERGEABLE with 4/4 checks passing. `LICENSE` is still missing (v1 next step 1,
>   now carried across three passes). `site/content/skills.json` is still a tracked
>   generated file — `TODOS.md` §2.
> - **Deploy is still a manual script** (`site/scripts/deploy-ghpages.sh`, which now
>   runs `build:pages` itself); the gh token lacks `workflow` scope. `TODOS.md` §1.
>
> _Everything below is the v1 · 2026-07-04 handoff, kept for provenance. Where the two
> disagree, this block is current._

## Goal
`Skills-Directory` is a curated catalog of **agent skills** — reusable, portable
capabilities (following Anthropic's Agent Skills standard) that plug into Claude
Code, Claude.ai, or the API. Each skill is a self-contained folder; the repo is
the shared home + install source for them.

## Repo layout
```
Skills-Directory/
├── README.md                 # human landing page: catalog, install/use, authoring ritual
├── IMP Docs/                 # repo-level living docs (this folder)
│   ├── HANDOFF.md            # this file
│   ├── TECHSPEC.md           # architecture & the skill standard
│   └── Update.md             # changelog
├── mod/                      # build/fix/ship harness (multi-file: references/, scripts/, svg)
├── claude-assassin/          # session-limit auto-resume daemon (scripts/, references/, svgs)
├── code-translator/          # cross-language code translation (SKILL.md only)
└── supply-chain-prober/      # conversational supply-chain intake (scripts/, examples/)
```

## Current state
- **4 skills**, all with valid `SKILL.md` frontmatter. `mod` (v1.1.0) and
  `claude-assassin` use the full multi-file layout; `code-translator` is a lean
  single-file skill; `supply-chain-prober` ships scripts + examples.
- No build system, CI, dependencies, or `LICENSE` — it's a docs/scripts catalog.
  Nothing to compile; "it works" = the skill loads and triggers correctly.
- `README.md` covers the catalog, an Install & Use guide, and the authoring ritual
  (aligned to the official skill-building guide).

## How it's maintained (workflow)
- Personal repo under the **Arnav1771** GitHub account; `gh` in WSL is authed to it.
- **Direct pushes to `main` are blocked** — publish via a feature branch + PR
  (`gh pr create`), then merge.
- Commits are authored as `Arnav1771 <arnav.bhargava3@gmail.com>`; **no AI
  attribution** in commits or PRs.

## Validation
- Manual, per the guide's testing approach: does the skill **trigger** on the
  right requests (and not on unrelated ones)? does its workflow run end-to-end?
- Mechanical checks before merge: `SKILL.md` exists (exact case), frontmatter has
  `name` + `description` and **no `<`/`>` angle brackets**, scripts pass `bash -n`,
  any SVG is well-formed XML.

## Known issues / limitations
- No automated CI to lint skills — validation is manual today.
- No `LICENSE` file yet (skills are open-standard but the repo license is unstated).
- `code-translator` has no supporting files/examples (fine, but lighter than the others).

## Next exact steps
1. Add a `LICENSE` (MIT or Apache-2.0) and reference it in the README frontmatter guidance.
2. Add a lightweight CI check (frontmatter lint: name/description present, no `<`/`>`; `bash -n` on scripts).
3. Give `code-translator` an `examples/` sample translation for parity with the others.
4. Keep [`Update.md`](./Update.md) current on every skill add/upgrade.
