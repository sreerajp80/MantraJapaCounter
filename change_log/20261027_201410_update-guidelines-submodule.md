# Update the guidelines submodule

Implements plan: `plans/20261027_201338_update-guidelines-submodule.md`

## What changed

- `docs/guidelines` submodule pointer moved from `41fa45b` to `644faee` ("Updates",
  latest `origin/master` of `Flutter_Guidelines`).
- The new commit updates 32 guideline files: the engineering standard, security
  baseline, release process, build flavors guide, `guideline.md`, store readiness,
  docs-folder guideline, CLAUDE.md / AGENTS.md guidelines, and the Sanskrit /
  Malayalam language pack.
- No file inside `docs/guidelines/` was edited. Only the pointer moved, because the user
  asked for it directly.

## Checks

- `git submodule status` shows `644faee` for `docs/guidelines`.
- No app code changed, so `flutter analyze` and `flutter test` were not needed.

## Not done

- The new pointer is not committed yet.
- This project's own docs (`CLAUDE.md`, `AGENTS.md`, `docs/security.md`,
  `docs/release_process.md`) may need syncing with the new guidelines. That is a
  separate change with its own plan.
