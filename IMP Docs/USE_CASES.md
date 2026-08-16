# USE CASES — Skills-Directory (v1 · 2026-07-18)

> **What this doc is:** the exploration of what this project can become — concrete,
> prioritized use cases beyond the shipped v1 directory site. Each entry states the
> user it serves, what to build, and its rough cost. Version-stamped.

## Shipped today (v1 baseline)
Public, searchable catalog of the repo's 5 agent skills at
<https://arnav1771.github.io/Skills-Directory/> — browse, filter, read full
SKILL.md docs, copy install commands, follow composes-well links, submit via PR.

## Near-term (high value, low effort)

1. **MCP server listings (`/servers`)** — the mcpmarket model this site copies
   has two catalogs; the code is already structured for a parallel schema
   (`name`, `github_url`, `install_command`, `client_compatibility`, stars).
   Add an `mcp-servers/` folder convention (one `manifest.yaml` per server) and
   mirror the routes. *Serves:* anyone consolidating their agent tooling.
2. **One-line installer** — `npx skills-dir add mod` (or a `install.sh`) that
   clones sparsely and copies a skill into `~/.claude/skills/`. The site's copy
   button then offers both the `cp -r` and the one-liner. *Serves:* newcomers;
   removes the clone-the-whole-repo step.
3. **CI validation gate** — run `IMP Docs/validate_manifests.py` + frontmatter
   lint + `bash -n` on scripts for every PR, and rebuild/redeploy the site on
   merge to main. Needs a PAT with `workflow` scope (current local token lacks
   it) or adding the workflow file via the GitHub web UI once. *Serves:*
   contributors; keeps the catalog trustworthy.
4. **Per-skill OG images** — generate social cards at build time (icon + name +
   description) so shared links preview nicely. *Serves:* discovery/sharing.
5. **RSS / JSON feed of new & updated skills** — trivial to emit from
   `skills.json` at build time. *Serves:* agent-tooling watchers.

## Mid-term (needs modest new plumbing)

6. **Trigger-phrase search** — index each SKILL.md's trigger phrases ("Mod:",
   "Grimoire, build me…") as a first-class field, so users can search by *what
   they'd say* rather than by name. The build script already parses frontmatter;
   add extraction + a search facet.
7. **Skill changelogs from git history** — per-skill version timeline derived
   from commits touching that folder (the build script already shells out to
   git). Render on the detail page. *Serves:* upgrade decisions.
8. **Federation / multi-repo index** — accept a list of external skill repos
   (yours or the community's) in a `sources.yaml`; the build script clones and
   indexes them all. The site becomes a *directory of directories*. *Serves:*
   the broader skill ecosystem; biggest reach multiplier on this list.
9. **Claude Code plugin-marketplace export** — emit the catalog in the format
   Claude Code's plugin/skill marketplaces consume, so the repo is installable
   as a marketplace source, not just a git clone. *Serves:* teams standardizing
   on a shared skill set.
10. **Install analytics (honest ones)** — GitHub's traffic API (clones/views)
    polled by a scheduled job into a small JSON, powering a real `/daily`
    trending page. Explicitly deferred until real data exists.

## Long-term (product-shaped bets)

11. **Team/org private catalogs** — template-ize the site so any org can fork,
    point it at their internal skills repo, and get a branded internal
    directory (the Aligned Automation use case: WFM/RCA playbook skills, Dell
    SOW tooling as internal skills).
12. **Skill quality badges** — automated scoring (has scripts? references?
    examples? diagram? passes validation? recently updated?) surfaced as badges
    on cards; the leaderboard's rankScore already computes most of this.
13. **In-browser skill preview** — paste a request, see which skill's
    description would trigger (a client-side matcher over frontmatter
    descriptions). Educational + great for debugging trigger phrases.
14. **Supabase/Postgres backend swap** — the UI reads only `skills.json` via
    `lib/skills.ts`, so the promised DB swap is a one-file change when
    user-generated content (ratings, comments, submissions without PRs)
    arrives.

## Non-goals (unchanged from the build spec)
- User accounts/auth, payments/"sell skills", fake ticking install counters.
