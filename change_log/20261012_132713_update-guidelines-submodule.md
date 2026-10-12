# Update the guidelines submodule

Implements plan: `plans/20261012_132644_update-guidelines-submodule.md`

## What changed

- `docs/guidelines` submodule pointer moved from `519e7f3` to `0607386` (latest `master` of the
  Flutter_Guidelines repo), using `git submodule update --remote docs/guidelines`.
- The new pointer is staged. It is not committed yet.
- No file inside `docs/guidelines/` was edited.

## New upstream commits pulled in

- `bf8ab85` — Update built-in Kotlin notes for Flutter 3.47+ / AGP 9+
- `0607386` — Make the guidelines submodule strictly read-only for projects

## Follow-ups (not done here)

- Switch the project to built-in Kotlin (`android.builtInKotlin=true`) as the new guidelines say,
  and update `CLAUDE.md` to match.
- Copy the "never change the guidelines submodule" rule into `CLAUDE.md`, `AGENTS.md` and
  `docs/GUIDELINES_MANIFEST.md`.
