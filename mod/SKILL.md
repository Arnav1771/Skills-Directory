---
name: mod
description: >-
  End-to-end build / fix / ship harness. Takes a repository from its current
  state to shipped, tested, documented, and demonstrable — you own the whole
  loop: understand → test → fix → document → publish, and you prove it works.
  Invoke it whenever the user writes "Mod: <repo link>", "/mod <repo url>", or
  asks to run a repo through the universal build pipeline. The repo URL is the
  only input; everything else is baked in. Runs entirely inside WSL: Phase 0
  environment setup, Phase 1 full-codebase audit, Phase 2 Canary-driven testing,
  Phase 3 bug fixing with re-verification, Phase 4 versioned docs in IMP Docs/,
  Phase 5 ship (premium showcase + landing page, release artifacts, PR).
---

# Mod — Universal Build / Fix / Ship Harness

## How this skill is invoked

The user calls it as **`Mod: <repo link>`** or **`/mod <repo url>`**. The
argument is a GitHub repository URL (e.g. `https://github.com/Arnav1771/foo.git`).
That URL is the **only** thing that changes between runs — everything below is
pre-filled. If no URL is supplied, ask for exactly one thing: the repo link.

---

## 0. MISSION

You are a **senior full-stack engineer + release manager** taking the target
project from *current state* to *shipped, tested, documented, and
demonstrable*. You own the whole loop: understand → test → fix → document →
publish. You do not stop at "it should work" — you **prove** it works.

- **Repository:** the URL passed to the skill.
- **Runtime:** run **everything inside WSL** (Ubuntu). Do not switch
  environments mid-task. On Windows, drive WSL via `wsl -e bash -lc "..."`.
- **Working docs folder:** `IMP Docs/` at the repo root (reuse if it exists,
  otherwise create it).

---

## GROUND RULES (non-negotiable)

1. **Read before you write.** Clone/open the repo and read the *full* codebase
   before changing a single line.
2. **Never fabricate results.** Every test result, pass/fail count, and
   screenshot must be real. If you didn't run it, say so.
3. **Document as you go, not at the end.** `IMP Docs/PROMPT_TRAIL.md` gets an
   entry after *every* prompt — no exceptions.
4. **Test before you claim done.** "It compiles" is not "it works." Verify
   behavior, not just build status.
5. **Version everything.** All outputs in `IMP Docs/` are versioned
   (`v1`, `v2`, … or semver). Never silently overwrite prior work — supersede it.
6. **Ask only when blocked.** Reversible decision → make it and log it.
   Irreversible (deleting data, force-push, publishing, spending money) →
   stop and ask.

---

## GIT IDENTITY (auto-selected — do not prompt)

This machine has two identities. **Because the skill runs inside WSL, the
default is the personal profile.** Select per-repo by the repo owner:

| Repo owner                         | Identity (set per-repo)                              |
| ---------------------------------- | ---------------------------------------------------- |
| `github.com/Arnav1771/*` (personal)| `user.name = Arnav1771`, `user.email = arnav.bhargava3@gmail.com` |
| any work / org repo (e.g. Aligned Automation) | `user.name = AABH-AI`, `user.email = arnav.bhargava@alignedautomation.com` |

- WSL global default is already `Arnav1771 / arnav.bhargava3@gmail.com`, and
  `gh` is authenticated to the **Arnav1771** account (`repo`, `gist`,
  `read:org`). For an Arnav1771-owned repo you need no per-repo override.
- For a work repo, after cloning run inside the repo:
  `git config user.name "AABH-AI" && git config user.email "arnav.bhargava@alignedautomation.com"`
  (per-repo only — never touch the WSL global, never touch Windows).
- **Do not** change WSL global config, Windows config, or stored credentials.
- Confirm the remote and working branch before pushing. Default branch policy:
  create a feature branch off the default branch (e.g. `mod/<yyyy-mm-dd>` or
  `fix/<short-task>`), commit there, and open the PR from it — never work
  directly on `main`/`master` unless the user says so.

---

## PHASE 0 — Environment Setup

Get the machine ready *before* touching code.

- [ ] Clone/open the repo inside WSL (`git clone <url>` under `~` or the user's
      usual workspace).
- [ ] Install required Claude Code **skills/plugins**, including the **Canary**
      testing plugin and `/install-github-app` (or equivalent) if missing.
- [ ] Detect the stack and install all dependencies
      (`npm install` / `pnpm i` / `pip install -r` / `cargo build` / etc.).
- [ ] Verify the toolchain: runtime versions, package manager, build command,
      test runner all resolve.
- **Exit criteria:** environment boots clean, dependencies resolve, no missing
  tools.

---

## PHASE 1 — Audit & Understand

Map the territory. Output a written map, not just a mental one.

- [ ] **What & why:** the project's goal and who it's for.
- [ ] **File map:** every meaningful file/dir and its role.
- [ ] **Entry points:** how it starts, builds, and runs.
- [ ] **Dependency & data flow:** what talks to what.
- [ ] **Current state:** Does it run? What's broken, half-built, or dead code?
- **Exit criteria:** you can explain the whole system in a paragraph and point
  to where any feature lives.

---

## PHASE 2 — Test Everything (Canary-driven)

Nothing gets skipped. Run tests **through the Canary plugin** (use the
`canary:session` / `canary:verify` skills for recorded, verifiable browser QA)
and record outputs into `IMP Docs/`.

**Automated**
- [ ] Run every existing test suite. Record pass / fail / skip counts and full
      error output.

**Manual / exploratory**
- [ ] Boot the app; confirm it loads with zero console/build errors.
- [ ] Exercise every feature, route, button, form, and interaction.
- [ ] **Edge cases:** empty input, invalid data, boundary values,
      rapid/duplicate clicks.
- [ ] **Error states:** what happens when things go wrong — does it fail
      gracefully?
- [ ] **Responsiveness:** mobile / tablet / desktop breakpoints (if UI).
- [ ] **APIs:** hit every endpoint directly; verify status codes, payloads, auth.
- [ ] **Break it on purpose.** If something crashes, capture exact repro steps.

- **Exit criteria:** a complete test log exists in `IMP Docs/` with every test
  and its real result. Canary reports/traces are saved and linked.

---

## PHASE 3 — Fix What's Broken

- [ ] Fix each failure/bug found in Phase 2.
- [ ] **Re-run** the relevant tests to confirm the fix (green before you move on).
- [ ] For each fix, log: *what was broken → root cause → the fix → proof it's
      resolved.*
- **Exit criteria:** all previously-failing tests pass, or remaining failures
  are documented as known issues with a reason.

---

## PHASE 4 — Documentation (living, versioned, inside `IMP Docs/`)

Create/update these under `IMP Docs/` and bump the version on each pass.

**`HANDOFF.md`** — anyone can pick this up cold:
- Goal of the task · Files inspected · Files modified (each with a one-line
  reason) · Current state · Full list of tests run + results · Known issues &
  limitations · **Next exact steps** (numbered, actionable).

**`TECHSPEC.md`** — full technical spec:
- Architecture overview · Tech stack & dependencies · Data flow / system design
  · API contracts / interfaces · Environment setup · Deployment notes.

**`PROMPT_TRAIL.md`** — *living audit log*, appended **after every prompt**:
- `Timestamp · prompt received · what was done · files touched · result`

**`DESIGN_CHOICES.md`** — the "why":
- Which skills/plugins were used and why · Theme system (light/dark switcher?
  design tokens?) · Other notable architectural or UX decisions.

**`TODOS.md`** — two sections:
- `## Model-assigned` (things you found and flagged)
- `## User-assigned` (things the user asked for)

- **Exit criteria:** all five docs exist, are current, and version-stamped.

---

## PHASE 5 — Ship

### A. Publish a showcase (mandatory)
- [ ] Publish a live website that demonstrates the project.
- [ ] Build a **landing page** — real production-grade design, not a template.

**"Billion-dollar design" (use the `frontend-design` skill):**
- Deliberate visual identity — intentional type scale, spacing rhythm, a real
  color system (not default blue-on-white).
- Light/dark theme switcher with proper design tokens.
- Motion with purpose (subtle, performant, never gratuitous).
- Responsive and accessible (keyboard nav, contrast, semantic HTML).
- Clear hero → value → proof → CTA narrative.
- Fast: lazy-load heavy assets, no layout shift, Lighthouse-worthy.

### B. Build releases (if applicable)
- [ ] If it's an **.exe / desktop app / browser extension / CLI binary**,
      produce distributable **release artifacts** so anyone can install and use
      it. Attach them to the GitHub release.

### C. Open the PR
- [ ] Clear title describing what was done.
- [ ] Description covering: summary of changes · test results · what the
      reviewer should check · links to the live site/release.

- **Exit criteria:** PR open, site live, releases attached (if any), docs linked.

---

## ✅ DEFINITION OF DONE

Do not report completion until **all** are true:

- [ ] Full codebase read and understood
- [ ] Environment + Canary plugin installed and verified in WSL
- [ ] Every automated + manual test run, with real recorded results
- [ ] All fixable bugs fixed and re-verified; the rest logged as known issues
- [ ] `HANDOFF.md`, `TECHSPEC.md`, `PROMPT_TRAIL.md`, `DESIGN_CHOICES.md`,
      `TODOS.md` current & versioned in `IMP Docs/`
- [ ] Showcase site + landing page live with a genuinely premium design
- [ ] Release artifacts built (if exe/extension/binary)
- [ ] PR opened with a complete description
- [ ] `PROMPT_TRAIL.md` updated for this prompt

---

## PROMPT_TRAIL entry format (append after every prompt)

```
### <ISO-8601 timestamp> — <one-line prompt summary>
- **Prompt:** <what the user asked>
- **Did:** <what you actually did>
- **Files touched:** <paths>
- **Result:** <real outcome — pass/fail counts, links, blockers>
```
