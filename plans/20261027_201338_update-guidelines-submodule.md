# Update the guidelines submodule

**Status:** completed

## Files to be changed

- `docs/guidelines` (submodule pointer only — no file inside the submodule is edited)

## What the issue is

The `docs/guidelines` submodule points at commit `41fa45b`. Its remote
(`Flutter_Guidelines`, branch `master`) has one newer commit:

- `644faee` "Updates" — 32 files changed. Main areas: the engineering standard,
  security baseline, release process, build flavors guide, `guideline.md`, store
  readiness, docs-folder guideline, CLAUDE.md / AGENTS.md guidelines, the Sanskrit /
  Malayalam language pack, plus the submodule's own plans and change logs.

The project rule says the submodule is read-only. Moving the pointer is done here only
because the user asked for it directly. Nothing inside `docs/guidelines/` is edited.

## Plan for the fix

1. In `docs/guidelines`, check out `origin/master` (`644faee`).
2. Check `git submodule status` shows the new commit.
3. Commit the new pointer in the parent repo (only when the user asks to commit).
4. Write a change log in `change_log/`.

## Out of scope (note for later)

The new guidelines add a security baseline and fix several guideline conflicts. This
project's own docs (`CLAUDE.md`, `AGENTS.md`, `docs/security.md`,
`docs/release_process.md`) may need syncing to match. That is a separate change with its
own plan.
