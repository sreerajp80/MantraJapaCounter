# Update the guidelines submodule

**Status:** completed

## What the issue is

The `docs/guidelines` submodule (Flutter_Guidelines repo) is behind its remote `master` by 2 commits:

- `bf8ab85` — Update built-in Kotlin notes for Flutter 3.47+ / AGP 9+
- `0607386` — Make the guidelines submodule strictly read-only for projects

The project currently points at `519e7f3`. The user asked to update it to the latest version.

## Files to be changed

- `docs/guidelines` (submodule pointer only: `519e7f3` → `0607386`)
- `change_log/20261012_<time>_update-guidelines-submodule.md` (new change log)

No file inside `docs/guidelines/` is edited. Only the version the parent project points to changes.

## Plan for the fix

1. Run `git submodule update --remote docs/guidelines` to move the submodule to the latest `master` commit (`0607386`).
2. Check with `git submodule status` and `git status` that only the submodule pointer changed.
3. Stage the new pointer (`git add docs/guidelines`). Do not commit unless the user asks.
4. Write the change log.

## Follow-up items (not part of this plan)

The new guideline versions ask for things this project does not do yet. Each needs its own plan:

- **Built-in Kotlin** (`bf8ab85`): guidelines now say to set `android.builtInKotlin=true`, not apply
  `kotlin-android` in the app module, and keep `newDsl=false`. Project `CLAUDE.md` still says
  `android.builtInKotlin=false`.
- **Read-only submodule rule** (`0607386`): the `CLAUDE.md` / `AGENTS.md` templates now include a
  "never change the guidelines submodule" rule. Project `CLAUDE.md`, `AGENTS.md` and
  `docs/GUIDELINES_MANIFEST.md` (the project copy) may need this text synced.
