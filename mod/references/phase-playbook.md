# Phase Playbook — detailed checklists & exit criteria

Work the phases in order. Do not advance until the exit criteria are met (or a
blocker is logged in `PROMPT_TRAIL.md`). Everything runs in WSL.

## Phase 0 — Environment Setup
- [ ] `git clone <url>` inside WSL (under `~` or the user's usual workspace).
- [ ] Select git identity for the repo (`scripts/select-git-identity.sh`).
- [ ] Ensure the Canary testing plugin is installed; install `/install-github-app`
      or equivalent if missing.
- [ ] Detect stack (package.json / pyproject / go.mod / Cargo.toml / etc.) and
      install deps (`npm i` / `pnpm i` / `pip install -r` / `cargo build` …).
- [ ] Verify toolchain: runtime versions, package manager, build cmd, test runner.
- **Exit:** env boots clean, deps resolve, no missing tools.

## Phase 1 — Audit & Understand
- [ ] Write the system map to `IMP Docs/` (feeds `TECHSPEC.md`).
- [ ] What & why · file map · entry points · dependency/data flow · current state
      (runs? broken/half-built/dead code?).
- **Exit:** you can explain the system in a paragraph and locate any feature.

## Phase 2 — Test Everything (Canary-driven)
- [ ] Run every existing suite; record pass/fail/skip + full error output.
- [ ] Boot the app; confirm zero console/build errors.
- [ ] Exercise every feature, route, button, form, interaction.
- [ ] Edge cases: empty input, invalid data, boundary values, rapid/dup clicks.
- [ ] Error states: does it fail gracefully?
- [ ] Responsiveness: mobile / tablet / desktop (if UI).
- [ ] APIs: hit every endpoint; verify status codes, payloads, auth.
- [ ] Break it on purpose; capture exact repro steps.
- [ ] Use `canary:session` / `canary:verify` for recorded, verifiable QA; save
      reports/traces under `IMP Docs/`.
- **Exit:** complete real test log in `IMP Docs/`; Canary reports linked.

## Phase 3 — Fix What's Broken
- [ ] Fix each failure/bug.
- [ ] Re-run relevant tests to green before moving on.
- [ ] Log per fix: broken → root cause → fix → proof.
- **Exit:** all fixable tests pass; the rest logged as known issues with reasons.

## Phase 4 — Documentation
- [ ] Scaffold `IMP Docs/` (`scripts/scaffold-imp-docs.sh`) if not present.
- [ ] Fill/refresh HANDOFF, TECHSPEC, PROMPT_TRAIL, DESIGN_CHOICES, TODOS.
- [ ] Bump version stamp on each doc.
- **Exit:** all five docs current & version-stamped.

## Phase 5 — Ship
- [ ] Build the showcase site + landing page with the `frontend-design` skill.
- [ ] Verify: light/dark tokens, responsive, accessible (keyboard, contrast,
      semantic HTML), purposeful motion, no layout shift, fast.
- [ ] Build & attach release artifacts if exe/desktop/extension/CLI binary.
- [ ] Open the PR (feature branch → base; never push `main` directly). Title +
      description with summary, test results, reviewer checklist, live links.
      **No AI/Claude attribution anywhere in the commit or PR.**
- **Exit:** PR open, site live, releases attached (if any), docs linked.

## Definition of Done
All phase exits met · real recorded results · docs versioned · showcase live ·
artifacts built (if applicable) · PR opened · `PROMPT_TRAIL.md` updated.
