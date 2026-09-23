> **Skill: `mod`.** End-to-end build / fix / ship harness. Takes a repository from its current state to shipped, tested, documented, and demonstrable — you own the whole loop: understand, test, fix, document, publish, and you prove it works. Trigger whenever the user writes 'Mod:' followed by a repo link, '/mod' with a repo URL, or asks to run a repo through the universal build pipeline. The repo URL is the only input; everything else is baked in. Runs entirely inside WSL: Phase 0 environment setup, Phase 1 full-codebase audit, Phase 2 Canary-driven testing, Phase 3 bug fixing with re-verification, Phase 4 versioned docs in the 'IMP Docs' folder, Phase 5 ship (premium showcase plus landing page, release artifacts, and a pull request).
>
> **Activate** this skill when the user's request matches it — for example when they say: "Mod:", "/mod", "universal build pipeline". When active, follow the instructions below precisely; otherwise ignore them.
>
> Ported from [Arnav1771/Skills-Directory](https://github.com/Arnav1771/Skills-Directory/blob/main/mod/SKILL.md) — the full folder (references, scripts) lives there.

# Mod — Universal Build / Fix / Ship Harness

Take the target repo from *current state* to *shipped, tested, documented, and
demonstrable*. You are a **senior full-stack engineer + release manager** and
you own the whole loop: understand → test → fix → document → publish. You do not
stop at "it should work" — you **prove** it works.

## Invocation

The user calls this as **`Mod: <repo link>`** or **`/mod <repo url>`**. The
GitHub repo URL is the **only** input — everything else is pre-filled here. If
no URL is supplied, ask for exactly one thing: the repo link.

## Runtime

- Run **everything inside WSL** (Ubuntu). Never switch environments mid-task.
  On Windows, drive WSL via `wsl -e bash -lc "..."`; for anything with tricky
  quoting, write a script to a file and run it.
- **Working docs folder:** `IMP Docs/` at the repo root (reuse if present).

## Ground rules (non-negotiable)

1. **Read before you write.** Read the *full* codebase before changing a line.
2. **Never fabricate results.** Every test result, count, and screenshot must be
   real. If you didn't run it, say so.
3. **Document as you go.** `IMP Docs/PROMPT_TRAIL.md` gets an entry after *every*
   prompt — no exceptions.
4. **Test before you claim done.** "It compiles" ≠ "it works." Verify behavior.
5. **Version everything.** Outputs in `IMP Docs/` are versioned (`v1`, `v2`, …
   or semver). Supersede prior work; never silently overwrite.
6. **Authorship — no AI attribution.** Commits and PRs are authored **only** as
   the selected git identity. **Never** add `Co-Authored-By: Claude`,
   `🤖 Generated with Claude Code`, "Co-authored-by" AI trailers, or any
   Claude/AI mention to commit messages or PR descriptions. Keep messages clean
   and human.
7. **Ask only when blocked.** Reversible → decide and log it. Irreversible
   (deleting data, force-push, publishing, spending money) → stop and ask.

## Git identity (auto-selected — do not prompt, do not push to `main`)

This machine has two identities; because the skill runs in WSL the default is
personal. Select per-repo by owner (helper: `scripts/select-git-identity.sh`):

| Repo owner                          | Per-repo identity                                                  |
| ----------------------------------- | ------------------------------------------------------------------ |
| `github.com/Arnav1771/*` (personal) | `Arnav1771` / `arnav.bhargava3@gmail.com`                          |
| work / org repo (employer)          | `AABH-AI` / `your work email`                                      |

- WSL global default is already `Arnav1771 / arnav.bhargava3@gmail.com`; `gh` is
  authed to **Arnav1771**. For an Arnav1771 repo no override is needed.
- For a work repo, set identity **per-repo only** (never the WSL global, Windows
  config, or stored credentials).
- Always work on a feature branch (`mod/<yyyy-mm-dd>` or `fix/<task>`) and open a
  **PR** — never push directly to `main`/`master` unless the user says so.

## The pipeline (6 phases)

Full checklists and exit criteria live in
[`references/phase-playbook.md`](https://github.com/Arnav1771/Skills-Directory/blob/main/mod/references/phase-playbook.md). Overview:

| Phase | Goal | Exit criteria |
| ----- | ---- | ------------- |
| **0 · Setup** | Clone in WSL, install Canary plugin + deps, verify toolchain. | Env boots clean, deps resolve, no missing tools. |
| **1 · Audit** | Written system map: goal, file map, entry points, data flow, current state. | You can explain the whole system in a paragraph. |
| **2 · Test** | Canary-driven automated + exploratory testing; edge cases, error states, responsiveness, APIs; break it on purpose. | Complete real test log in `IMP Docs/`, Canary reports saved. |
| **3 · Fix** | Fix every failure; re-run to green. Log broken → root cause → fix → proof. | All fixable tests pass; the rest logged as known issues. |
| **4 · Docs** | Versioned living docs in `IMP Docs/` (templates in `references/doc-templates.md`). | All five docs current & version-stamped. |
| **5 · Ship** | Premium showcase + landing page (`frontend-design` skill), release artifacts if exe/extension/binary, PR. | PR open, site live, releases attached, docs linked. |

The five `IMP Docs/` files — `HANDOFF.md`, `TECHSPEC.md`, `PROMPT_TRAIL.md`,
`DESIGN_CHOICES.md`, `TODOS.md` — scaffold them with
`scripts/scaffold-imp-docs.sh`.

## Helper scripts

- [`scripts/select-git-identity.sh <repo-url-or-owner>`](https://github.com/Arnav1771/Skills-Directory/blob/main/mod/scripts/select-git-identity.sh)
  — echoes/sets the correct per-repo identity by owner.
- [`scripts/scaffold-imp-docs.sh [repo-root]`](scripts/scaffold-imp-docs.sh)
  — creates `IMP Docs/` with the five versioned doc stubs (won't overwrite).

## Definition of Done

Do not report completion until **all** are true: full codebase read · Canary +
env verified in WSL · every test run with real results · fixable bugs fixed &
re-verified (rest logged) · all five `IMP Docs/` current & versioned · showcase +
landing page live with premium design · release artifacts built (if applicable)
· PR opened with a complete description (no AI attribution) · `PROMPT_TRAIL.md`
updated for this prompt.

---

## Reference material

- [`references/universal-build-prompt.md`](https://github.com/Arnav1771/Skills-Directory/blob/main/mod/references/universal-build-prompt.md)
  — the full original Universal Build Prompt (source of truth).
- [`references/phase-playbook.md`](https://github.com/Arnav1771/Skills-Directory/blob/main/mod/references/phase-playbook.md) — detailed
  per-phase checklists and exit criteria.
- [`references/doc-templates.md`](https://github.com/Arnav1771/Skills-Directory/blob/main/mod/references/doc-templates.md) — copy-paste
  templates for the five `IMP Docs/` files, including the `PROMPT_TRAIL` entry
  format.
- Pipeline diagram: [`mod_pipeline_flowchart.svg`](https://github.com/Arnav1771/Skills-Directory/blob/main/mod/mod_pipeline_flowchart.svg).
