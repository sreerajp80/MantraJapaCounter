# Update the guidelines submodule (again)

Implements plan: `plans/20261012_183218_update-guidelines-submodule-2.md`

## What changed

- Moved the `docs/guidelines` submodule pointer from `0607386` to `1f728b9`
  ("Updates: GitHub CI does only analyze/test checks and Dependabot").
- Staged the new pointer (`git add docs/guidelines`). Not committed.

No file inside `docs/guidelines/` was edited.

## Checks

- `git submodule status` shows `docs/guidelines` at `1f728b9` (same as `origin/HEAD`).
- `git status` shows no other new changes from this work.

## Follow-up (not done here)

- Compare the project's `.github/` CI setup with the new CI guidance in `1f728b9`.
