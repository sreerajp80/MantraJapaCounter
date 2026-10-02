# Update docs/guidelines submodule

Implements plan: `plans/20261002_233947_update-guidelines-submodule.md`

## What changed

- `docs/guidelines` submodule pointer moved from `3f1aa0b` to `519e7f3`
  (latest `master` of Flutter_Guidelines). This pulls in 2 commits (`d3e5041`, `519e7f3`)
  that change 30 guideline files.

## Main guideline updates pulled in

- Toolchain update to Flutter 3.47.
- Guidance to use latest stable versions instead of pinned versions.
- Guidelines made generic and multi-platform.
- New files: `AI_AGENT_START_HERE.md`, `PROJECT_PROFILE_TEMPLATE.md`,
  `platform_store_readiness.md`, `language_packs/sanskrit_malayalam.md`,
  `profiles/example_en_ml_sa_profile.md`.

## Not changed

- No app code or project docs were changed. Any follow-up to match the new guidelines
  will need a separate plan.

## Verification

- `git submodule status` shows `docs/guidelines` at `519e7f3`.
