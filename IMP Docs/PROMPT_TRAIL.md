# PROMPT TRAIL — Skills-Directory

> **What this doc is:** one entry per prompt/work session — what was asked, what
> was done, what's left. Append-only, newest on top.

---

## 2026-08-07 — "the site is broken / unstyled when I serve it locally"

**Asked:** the static export, served locally, came up as unstyled plain text with
nothing interactive. Find out why and fix it. Then update `IMP Docs`.

**Diagnosed:** not a CSS or build failure — a serving-root mismatch.
`site/next.config.ts` hard-coded `basePath: "/Skills-Directory"`, correct for a GitHub
Pages *project* page and wrong everywhere else. Serving `site/out` as a document root
meant every asset URL in `out/index.html` pointed at `/Skills-Directory/_next/...`, so
all 12 of them 404'd: `document.styleSheets[0].cssRules.length === 0`, Times New Roman
fallback, no JS, nothing interactive. The HTML itself was correct throughout.

**Fixed:** made the prefix opt-in via `NEXT_PUBLIC_BASE_PATH`, with
`GITHUB_ACTIONS === "true"` as a fallback so a deploy can't ship a root-relative build
by accident. `npm run build` → root-relative (serves anywhere);
`npm run build:pages` (new, `site/scripts/build-pages.mjs`) → prefixed. Added a
dependency-free static server `site/scripts/preview.mjs` behind `npm run preview` /
`npm run preview:pages`. `deploy-ghpages.sh` now runs `build:pages` itself instead of
publishing whatever happened to be in `out/`. CI builds and asserts **both** flavours.
Rewrote `site/README.md` (still create-next-app boilerplate) and added the local-run
recipe to the root README.

**Verified (HTTP layer only — no browser was used, so nothing is claimed about how the
page looks):** default build served at a document root — `GET /` → 200, all 10 asset
URLs from `out/index.html` → 200, e.g. `/_next/static/chunks/3kky2t8mmyzem.css` → 200,
26,545 bytes; the same path under `/Skills-Directory/` correctly 404s. Pages build
under `/Skills-Directory/` → all 10 prefixed assets 200. Both flavours: 23 static
pages, exit 0. `IMP Docs/validate_manifests.py` → 5 skills, all manifests valid.

**Shipped:** rebased `mod/2026-07-18-directory-site` onto `main` — it was 5 ahead / 4
behind and **CONFLICTING** (the only conflict was `IMP Docs/Update.md`); PR #8 is now
**MERGEABLE** with all 4 CI checks passing (2 jobs × 2 runs: "Next.js static export",
"manifests + shell scripts").

**Docs:** `Update.md` 2026-08-07 entry, `DESIGN_CHOICES.md` §7 (why opt-in is the right
default), `TODOS.md` v2 (skills.json re-confirmed still tracked; two new smaller items),
this entry, and a current-state block at the top of `HANDOFF.md`.

**Left / known:** `site/content/skills.json` is still a tracked generated file and still
dirties the tree on every build (`TODOS.md` §2) — untracking it is the next cleanup.
Deploy is still a manual script pending a `workflow`-scoped token (`TODOS.md` §1). Still
no `LICENSE`.

---

## 2026-07-18 — `/mod` + "build the Skills & MCP Directory website, host on GitHub Pages"

**Asked:** Run the repo through the mod pipeline with a full build spec: an
mcpmarket.com-style directory site for the repo's skills (Next.js App Router +
TS + Tailwind, manifest-driven, search/filter/leaderboard/detail pages/submit
flow), hosted on GitHub Pages, built in WSL. Mid-session addition: QA the live
site with Canary (full report + MP4 screen recording) and explore more use
cases for the project.

**Done:**
- Phase 0/1: synced `main` (post-PR #5), audited all 5 skills' manifests +
  README; toolchain verified (node 24, gh authed as Arnav1771 — token has no
  `workflow` scope, which ruled out Actions-based deploys).
- Built `site/`: Next 16 static export (basePath `/Skills-Directory`),
  build-time content pipeline (`scripts/build-content.mjs` → `content/skills.json`),
  9 routes + per-skill/per-category SSG pages + sitemap, Fuse.js search,
  URL-synced filters, theme toggle, copy-to-clipboard installs, rendered
  SKILL.md docs, composite-score leaderboard. `/daily` omitted (no analytics —
  spec says don't fake it).
- Fixed during build: `next.config.ts` export config initially unsaved (build
  produced no `out/`); lucide-react ≥1.x removed the `Github` brand icon
  (replaced with inline SVG); npm `prebuild` script mangled by shell quoting.
- Tested: HTTP-layer smoke suite (`site/scripts/smoke-test*.sh`) — 15/15
  routes 200 under the GitHub Pages base path, assets resolve, content spot
  checks pass, `.nojekyll` present, sitemap 19 URLs.
- Shipped: branch `mod/2026-07-18-directory-site` pushed; `out/` published to
  `gh-pages` via `site/scripts/deploy-ghpages.sh`; Pages enabled; **live at
  <https://arnav1771.github.io/Skills-Directory/>** (200 + correct title).
- Docs: this file, `USE_CASES.md` (14 candidate use cases, prioritized),
  `Update.md` entry, HANDOFF v2, TECHSPEC v3 (§8 site architecture).
- QA: Canary session against the live URL (report + video → MP4) — results
  recorded in the session directory and summarized in the PR.

**Left / known:**
- CI (validate + rebuild-on-merge) blocked on a `workflow`-scoped token — see
  USE_CASES #3.
- Site redeploys are manual (`npm run build` + `deploy-ghpages.sh`) until then.
