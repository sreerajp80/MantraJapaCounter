# Update the guidelines submodule

**Status:** completed

## Files to be changed

- `docs/guidelines` (submodule pointer only — no file inside the submodule is edited)

## What the issue is

The `docs/guidelines` submodule points at commit `34dfd4a`. Its remote
(`Flutter_Guidelines`, branch `master`) has one newer commit:

- `41fa45b` "Updates" — removes Dependabot from the guidelines (touches the
  engineering standard, CLAUDE.md / AGENTS.md guidelines, release process,
  build flavors guide, and others).

The project rule says the submodule is read-only. Moving the pointer is done here only
because the user asked for it directly. Nothing inside `docs/guidelines/` is edited.

## Plan for the fix

1. In `docs/guidelines`, check out `origin/master` (`41fa45b`).
2. Check `git submodule status` shows the new commit.
3. Commit the new pointer in the parent repo (only when the user asks to commit).
4. Write a change log in `change_log/`.

## Out of scope (note for later)

The new guidelines drop Dependabot. This project's `CLAUDE.md` (hard rule 5 and the
"Where things live" list) and possibly `AGENTS.md` / `.github/` docs still mention
Dependabot, while `.github/dependabot.yml` was already deleted. Syncing those docs is a
separate change with its own plan.
