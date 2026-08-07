# TODOS

**Document version:** v2
**Date:** 2026-08-07
**Branch:** `mod/2026-07-18-directory-site`

Open items. Completed work is in `Update.md`; candidate directions with sizing are in
`USE_CASES.md`; `HANDOFF.md` ends with its own numbered next steps and they are not
duplicated here.

---

## 1. Deploy is a manual local script

`site/scripts/deploy-ghpages.sh` is the **only reproducible publish path**: it builds
nothing itself, copies `site/out` into `~/.cache/ghpages-deploy`, `git init`s a
`gh-pages` branch there, and force-pushes it. Plain git — no deploy action, no
credential in the file, auth taken from the ambient git helper.

It is manual because the available token lacks `workflow` scope, so a Pages workflow
cannot be created. Consequences: nothing rebuilds on merge, and the live site drifts
from `main` without any signal.

**Unblock:** a token with `workflow` scope, then a two-job workflow — `npm ci`,
`npm run build`, upload `site/out` via `actions/upload-pages-artifact` and
`actions/deploy-pages`. The script stays as the break-glass path. Tracked in
`USE_CASES.md` #3.

## 2. `site/content/skills.json` is a tracked generated file

The `prebuild` step regenerates it on every build and stamps `generatedAt` plus live
repo metadata into it, so **every build dirties the tree** even when no skill
changed. Reproduced on 2026-08-04: clean checkout → `npm run build` → `git status`
shows ` M site/content/skills.json`. Anyone who builds before committing will either
commit noise or spend time on a diff that means nothing.

CI already refuses to check it for staleness, and says why in a comment — the value
is non-deterministic, so the check would flake.

**Fix:** untrack it (`git rm --cached site/content/skills.json`, add to
`site/.gitignore`) and let `prebuild` produce it. The one thing to confirm first is
that no deploy path consumes a *committed* copy — the deploy script builds from
`site/out`, which is produced after `prebuild` runs, so this looks safe. Verify
before pulling the trigger.

Second-best option if it must stay tracked: drop `generatedAt` and the live GitHub
stats from the committed artefact and fetch them at runtime, which makes the file
deterministic and the diff meaningful again.

**Still open, re-confirmed 2026-08-07.** The 2026-08-07 base-path work added a *second*
build command (`npm run build:pages`) and a preview loop, so the tree now gets dirtied
by more paths than before, not fewer — anyone verifying both flavours runs `prebuild`
twice and restamps `generatedAt` twice. The file is still tracked:
`git ls-files site/content/` → `site/content/skills.json`. Recommendation unchanged and
now slightly more urgent: untrack it. `site/README.md` and the CI comment both already
treat it as generated output, so the repo's own documentation is out of step with the
fact that git owns the file.

## 3. An MCP-server catalog (`/servers`) was planned and does not exist

The site currently lists **skills** only. The planned second surface catalogs MCP
servers alongside them, in the same shape — a manifest per entry, generated pages,
the same search and category machinery.

Most of the cost is already paid: `build-content.mjs`, the category routes, the
search index and the card components are all content-shaped rather than
skill-shaped. What is needed is a manifest contract for a server entry (transport,
install command, required credentials, tools exposed), a second content source, and
a decision about whether servers share the category taxonomy with skills or get
their own. Sized in `USE_CASES.md`.

## 4. Installing a skill means `cp -r`

The README's install instruction is to copy a folder into `~/.claude/skills/`. That
works and it is unversioned, unaudited and easy to get subtly wrong.

The intended replacement is a one-liner — `npx skills-dir add mod` — that reads the
same `skills.json` the site consumes, fetches the folder, writes it to the right
place, and prints what it installed. Scope it small: `add`, `list`, `remove`, no
registry, no auth, published from this repo. The catalog data it needs already
exists.

## 5. Still no `LICENSE`

`HANDOFF.md` has carried this as next step 1 across two passes. A repository whose
whole purpose is to be copied from must state what copying is permitted. Pick MIT or
Apache-2.0 and reference it from the README's authoring section.

---

## Smaller

- **`code-translator` has no supporting files.** Every other skill ships scripts,
  references or examples. An `examples/` sample translation brings it to parity —
  `HANDOFF.md` next step 3.
- **Two smoke-test scripts.** `site/scripts/smoke-test.sh` and `smoke-test2.sh` both
  exist; only one is referenced by the prompt trail's 15/15 route check. On 2026-08-07
  both gained header comments saying they test the **Pages** flavour and must be run
  after `npm run build:pages` — comments only, no behaviour change: both still hard-code
  `/Skills-Directory` and both still symlink `$HOME/Skills-Directory/site/out`, so
  neither works from a checkout at any other path. Fold them into one, take the base
  path and the repo root as parameters, or name the second for what it does.
- **The site is built but never linted in CI.** `package.json` declares
  `lint: eslint`; the workflow builds both flavours (2026-08-07) but still never lints.
  One more step, near-zero cost.
- **`site/out` does not record which flavour it holds.** After the 2026-08-07 change
  the same directory can contain either a root-relative or a `/Skills-Directory`-prefixed
  export, and nothing in it says which. A one-line marker file written by each build
  (or a `flavour` field in the build output) would make `preview` vs `preview:pages`
  a checkable choice rather than a remembered one. See `DESIGN_CHOICES.md` §7, "The
  cost".
- **Skill trigger quality is untested by anything.** Mechanical checks pass — 5
  manifests valid, 13 scripts `bash -n` clean, 23 static pages exported (verified
  2026-08-04) — and none of them say whether a skill fires on the right request. If
  this is ever automated, a fixture of "should trigger" / "should not trigger"
  prompts per skill is the shape to aim for.
