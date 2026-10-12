# Update the guidelines submodule (again)

**Status:** completed

## What the issue is

The `docs/guidelines` submodule (Flutter_Guidelines repo) is 1 commit behind its remote `master`:

- `1f728b9` — "Updates: GitHub CI does only analyze/test checks and Dependabot"

The project currently points at `0607386`. This new commit changes guideline text about CI
(CI should only run analyze/test checks and Dependabot) across 14 guideline files.

## Files to be changed

- `docs/guidelines` (submodule pointer only: `0607386` → `1f728b9`)
- `change_log/<timestamp>_update-guidelines-submodule-2.md` (new change log)

No file inside `docs/guidelines/` is edited. Only the version the parent project points to changes.

## Plan for the fix

1. Run `git submodule update --remote docs/guidelines` to move the submodule to `1f728b9`.
2. Check with `git submodule status` and `git status` that only the submodule pointer changed.
3. Stage the new pointer (`git add docs/guidelines`). Do not commit unless the user asks.
4. Write the change log.

## Follow-up items (not part of this plan)

- Compare the project's `.github/` CI setup (added today) with the new CI guidance in `1f728b9`.
  If they differ, that needs its own plan.
