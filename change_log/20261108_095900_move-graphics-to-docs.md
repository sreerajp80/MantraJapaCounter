# Change log: store graphics moved into docs/graphics/

Implements plan: `plans/20261108_095420_move-graphics-to-docs.md`

## What changed

| File | Change |
|------|--------|
| `docs/graphics/play_feature_1024x500.png` | Moved from `play_store_graphics/` (`git mv`, history kept). |
| `docs/graphics/play_feature_1024x500.svg` | Moved from `play_store_graphics/` (was not yet tracked). |
| `docs/graphics/play_icon_512.png` | Moved from `play_store_graphics/` (`git mv`, history kept). |
| `play_store_graphics/` | Deleted (empty). |
| `README.md` | Feature graphic shown as a banner under the `# Japam` title. |
| `docs/release_process.md` | Store-listing checklist line now names `docs/screenshots/` and `docs/graphics/`. |
| `CLAUDE.md`, `AGENTS.md` | "Where things live" tree lists `docs/graphics/` and `docs/screenshots/`. |

## Why

All app artwork now sits under `docs/`, so one copy serves both GitHub (README) and the
Play Store listing. Screenshots stay in `docs/screenshots/`; store artwork goes in its own
sibling folder `docs/graphics/`.

## Notes

- File names did not change.
- No other `play_store_graphics` reference was left outside `plans/`, `change_log/` and the
  read-only `docs/guidelines/`. Older plans and change logs keep the old path as history
  (including `change_log/20261107_223800_feature-graphic-japam.md`).
- No app code changed, so `flutter analyze` / `flutter test` were not re-run.
