# Update the docs/guidelines submodule

Implements plan: `plans/20260929_215110_update-guidelines-submodule.md`

## What changed

- `docs/guidelines` submodule moved from `eb4b462` to `3f1aa0b` (upstream `master`).
- New upstream content: glossary entries for Contact, Call, Tag and Phone number in
  section 8.5.4 of `flutter_project_engineering_standard.md`, plus the guidelines repo's own
  plan and change-log files for that change.

## Notes

- The submodule pointer change is not committed. It sits in the working tree with the other
  pending changes.
- No app code changed, so `flutter analyze` and `flutter test` are not affected.
