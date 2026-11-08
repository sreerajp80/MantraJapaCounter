# Move store graphics into docs/ so GitHub and Play Store share one copy

**Status:** completed

## Issue

The app's artwork lives in two places:

- `docs/screenshots/` — phone screenshots, used by `README.md` on GitHub.
- `play_store_graphics/` — feature graphic (PNG + SVG source) and the 512 px icon, used only
  for the Play Store listing.

The user wants one place for all graphics, so the same files serve both GitHub and the Play
Store, and chose `docs/`.

## Files to change

| File | Change |
|------|--------|
| `play_store_graphics/play_feature_1024x500.png` | Move to `docs/graphics/play_feature_1024x500.png` (`git mv`, keeps history). |
| `play_store_graphics/play_feature_1024x500.svg` | Move to `docs/graphics/play_feature_1024x500.svg` (not yet tracked, plain move). |
| `play_store_graphics/play_icon_512.png` | Move to `docs/graphics/play_icon_512.png` (`git mv`). |
| `play_store_graphics/` | Removed once empty. |
| `README.md` | Show the feature graphic as a banner under the `# Japam` title. |
| `docs/release_process.md` | Store-listing checklist line names `docs/graphics/` and `docs/screenshots/`. |
| `CLAUDE.md`, `AGENTS.md` | "Where things live": note that `docs/` also holds `graphics/` and `screenshots/`. |

## Plan for the fix

1. Create `docs/graphics/` and move the three files there. File names stay the same.
2. Delete the empty `play_store_graphics/` folder.
3. `README.md`: add, under the title,
   `<img src="docs/graphics/play_feature_1024x500.png" alt="Japam — a calm digital japa mala" />`.
   This is the "GitHub use" of the graphic.
4. Update the one checklist line in `docs/release_process.md` and the folder tree in
   `CLAUDE.md` / `AGENTS.md`.
5. Search the repo (outside `plans/`, `change_log/` and the read-only `docs/guidelines/`) for
   any other `play_store_graphics` reference and fix it.
6. Older plans and change logs keep their old paths — they are history.
7. Write a change log.

## Why `docs/graphics/` and not straight into `docs/` or `docs/screenshots/`

- `docs/` root holds the Markdown documents; loose images there make it messy.
- Screenshots and store artwork are different things (screenshots get retaken often, artwork
  rarely), so a sibling folder keeps each set easy to find.

## Not in scope

- Moving or renaming the screenshots.
- Uploading anything to Play Console.

## Security impact

None. Only images and Markdown move or change; no code, permissions, storage or dependencies.
