# Skills-Directory site

The directory website for this repo's agent skills: Next.js (App Router) +
TypeScript + Tailwind v4, **statically exported** to `site/out`, live at
<https://arnav1771.github.io/Skills-Directory/>.

All content comes from `content/skills.json`, regenerated on every build by
`scripts/build-content.mjs` (walks each skill folder, parses `manifest.yaml` +
`SKILL.md`, adds git/GitHub metadata). It is a tracked generated file — its
`generatedAt` stamp changes every build, so don't commit that churn.

## Quick start

```bash
npm ci

npm run dev        # dev server on http://localhost:3000

npm run build      # static export -> out/  (root-relative asset URLs)
npm run preview    # serve out/ at http://127.0.0.1:8123/
```

## The basePath constraint (read this before you deploy)

GitHub Pages serves this repo as a **project page**, at
`https://arnav1771.github.io/Skills-Directory/` — not at a domain root. A
Next.js export only works there if it is built with
`basePath: "/Skills-Directory"`, which bakes that prefix into every asset URL.

That prefix is exactly wrong when you serve `out/` as the document root: every
`/Skills-Directory/_next/...` request 404s, the CSS never loads, no JS runs, and
the page renders as unstyled Times New Roman. (That was the bug this setup
fixes.)

So the prefix is **opt-in**, driven by `NEXT_PUBLIC_BASE_PATH` in
`next.config.ts`:

| Command | `basePath` | Serve it at | Use for |
| --- | --- | --- | --- |
| `npm run build` | none | any document root | local preview, generic static hosts |
| `npm run build:pages` | `/Skills-Directory` | `<host>/Skills-Directory/` | GitHub Pages |

`GITHUB_ACTIONS=true` is honoured as a fallback default so a Pages deploy
workflow can't accidentally ship a root-relative build; set
`NEXT_PUBLIC_BASE_PATH=''` explicitly to override it.

To preview the Pages flavour exactly as GitHub serves it:

```bash
npm run build:pages
npm run preview:pages   # http://127.0.0.1:8123/Skills-Directory/
```

`scripts/preview.mjs` is a dependency-free static file server; `--port=`,
`--dir=`, and `--base-path=` are the only flags.

## Deploying

`scripts/deploy-ghpages.sh` runs `npm run build:pages` itself and force-pushes
`out/` to the `gh-pages` branch. Never deploy the output of a plain
`npm run build`.

CI (`.github/workflows/ci.yml`) builds both flavours and asserts that the
default build's asset URLs are root-relative while the Pages build's are
`/Skills-Directory`-prefixed, and that both resolve to files that exist.
