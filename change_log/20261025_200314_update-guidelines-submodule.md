# Update the guidelines submodule

Implements plan: `plans/20261025_200245_update-guidelines-submodule.md`

## What changed

- Moved the `docs/guidelines` submodule from `34dfd4a` to `41fa45b` (latest `origin/master`
  of `Flutter_Guidelines`). That commit removes Dependabot from the guidelines.
- No file inside `docs/guidelines/` was edited. Only the submodule pointer changed.

## Checks

- `git submodule status` shows `41fa45b` for `docs/guidelines`.
- No app code changed, so no build, analyze or test run was needed.

## Not done

- The new pointer is not committed yet.
- This project's `CLAUDE.md` still mentions Dependabot. Syncing it is a separate change.
