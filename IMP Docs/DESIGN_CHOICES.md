# DESIGN_CHOICES

**Document version:** v1
**Date:** 2026-08-04
**Branch:** `mod/2026-07-18-directory-site`

Why the repository and the site are built this way, and what each choice costs.
`TECHSPEC.md` describes the architecture and the skill contract; `Update.md` is the
changelog; this file is the reasoning behind them.

---

## 1. `manifest.yaml` beside `SKILL.md`, rather than more frontmatter

**Decision.** Each skill carries two files: `SKILL.md`, whose frontmatter belongs to
the Agent Skills standard and is read by the agent, and `manifest.yaml`, which
carries catalog metadata — categories, description, links — and is read by the site.

**Why not one file.** `SKILL.md` frontmatter is loaded into the agent's context every
session. Every field added there costs tokens on every conversation, forever, to
serve a directory page the agent never looks at. Splitting keeps the standard file
minimal and the catalog free to grow.

**The cost.** Two files to keep in sync, and nothing in the standard enforces the
pairing. That is exactly why `IMP Docs/validate_manifests.py` exists and why CI runs
it plus a "every manifest has a SKILL.md" check — the invariant is ours, so we
enforce it ourselves. Verified 2026-08-04: five skills, all manifests valid.

## 2. The site is generated from the manifests, not maintained beside them

`site/scripts/build-content.mjs` runs as an npm `prebuild`, walks every skill folder,
parses `manifest.yaml` and `SKILL.md`, augments with git and GitHub metadata, and
writes `site/content/skills.json` — the single source the UI reads.

**Why.** A directory whose content is hand-maintained goes stale the first time
someone adds a skill in a hurry. Generating it means adding a skill is one folder,
and the site follows.

**Where it bites.** `skills.json` is a **tracked generated file** and the generator
stamps `generatedAt` plus live repo stats into it, so every build dirties the working
tree whether or not anything changed. Confirmed on 2026-08-04: a clean checkout,
`npm run build`, and `git status` reports ` M site/content/skills.json`. CI
deliberately does not assert the file is unchanged after a build, because that check
would be non-deterministic — the comment saying so is in `ci.yml`. The real
resolution is `TODOS.md` §2.

## 3. Static export, and a plain-git deploy script

**Decision.** Next 16 with `output: export`; `site/scripts/deploy-ghpages.sh`
copies `site/out` into a scratch directory, `git init`s a `gh-pages` branch there and
force-pushes it.

**Why a script rather than an Action.** Not preference — the available token lacks
`workflow` scope, so a deploy workflow cannot be created or updated. The script is
the honest workaround, and it is deliberately plain: `cp`, `git init`, `git push`.
No third-party deploy action, no credential embedded in the file (it relies on the
ambient git credential helper; a secret scan of the repo found none).

**The cost.** Publishing is a human running a script on one machine. Nothing rebuilds
on merge, and the live site can silently fall behind `main`. `TODOS.md` §1.

**Why static at all.** The content is five markdown files and a JSON blob. A server
would add hosting, an origin to secure and a build to keep alive, in exchange for
nothing the export cannot do. Search is client-side (`fuse.js`) for the same reason.

## 4. Skills stay in this repo instead of one repo each

**Why.** Five skills, most of them small, sharing an authoring convention and a
single README. Separate repositories would multiply CI, docs and release overhead by
five and make the catalog — the actual product — a cross-repo aggregation problem.

**The cost.** Installing one skill means copying a subdirectory
(`cp -r Skills-Directory/mod ~/.claude/skills/`), which is what the README documents.
There is no per-skill version, no changelog per skill, and no install command.
`TODOS.md` §4 is the intended fix.

## 5. Validation is mechanical where it can be, manual where it cannot

CI checks the things a machine can decide: manifests parse and satisfy the contract,
every manifest has a `SKILL.md`, every shell script passes `bash -n`, the site
builds and exports. Verified 2026-08-04: 5 manifests valid, 13 scripts clean, 23
static pages generated.

What none of that touches is the only thing that matters about a skill — whether it
**triggers** on the right request and not on unrelated ones, and whether its workflow
runs end to end. That is a judgement about prose in a description field, and it stays
manual, as `HANDOFF.md` §Validation says. The mechanical gate exists to stop the
stupid failures reaching a reader, not to certify the skills.

## 6. No runtime, no dependencies, no LICENSE decision deferred twice

The catalog half of this repository has no build graph and no shared code — the
consuming agent is the runtime. That is what makes the flat-folder layout viable and
why "it works" is defined as "the skill loads and triggers".

The one open consequence: there is still no `LICENSE` file, which `HANDOFF.md` has
listed as next step 1 through two passes. A catalog meant to be copied from needs to
say what copying is permitted.
