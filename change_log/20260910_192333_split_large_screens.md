# Change Log: Split the three largest screens into feature folders (tests first)

**Date:** 2026-09-10

**Plan Reference:** [../plans/20260910_190800_split_large_screens.md](../plans/20260910_190800_split_large_screens.md)

**Result:** Settings, counter list, and history screens are now split into feature folders.
No file in them is over 352 lines. `flutter analyze` reports 0 issues, `dart format` makes no
changes, and the test suite grew from 80 to 97 passing tests.

---

## 1. Phase 1 — Safety-net tests

Written and run against the **unsplit** code first.

- `test/helpers/fake_japa_counter_repository.dart` — new in-memory fake of
  `JapaCounterRepository`. It implements only the methods the screens reach; any other call throws.
  Tests override `japaCounterRepositoryProvider` with it, so the real providers run on top.
- `test/screens/settings_screen_test.dart` — 4 tests: cards and sections render, the vibration row
  flips the setting, "use system" resets a brightness override, Clear-all asks first and Cancel
  deletes nothing.
- `test/screens/counter_list_screen_test.dart` — 8 tests: empty state, cards and today pill, add
  dialog goal checks and create, header menu and import/export dialog, options sheet items, Edit
  pre-fills the dialog, Delete removes the counter, Disable saves status and trimmed reason.
- `test/screens/history_screen_test.dart` — 5 tests: empty state, day groups newest first,
  expand/collapse a day, delete a session, the filtered hero with goal progress.

### Bug found by these tests

The Delete test failed on the original code. Delete and Disable from the long-press options sheet
did not work. That was fixed separately, before the split, under its own plan:
[../plans/20260910_191700_fix_options_sheet_dialog_context.md](../plans/20260910_191700_fix_options_sheet_dialog_context.md)
and change log
[20260910_191931_fix_options_sheet_dialog_context.md](20260910_191931_fix_options_sheet_dialog_context.md).
The Disable test was added as part of that fix.

---

## 2. Phase 2 — The split

The code was cut out of the original files **by exact line ranges** with a one-off script, not
retyped. The only edits on top of that were:

- private class names made public with a feature prefix,
- `super.key` added to each public widget constructor (the `use_key_in_widget_constructors` lint needs it),
- the two sound-picker methods turned into top-level functions (indent reduced by two spaces),
- unused imports removed by `dart fix --apply`, and one `const` added by it,
- a one-line doc comment on the now-public `showNotificationSoundPicker`.

Small helpers used by only one widget stayed private in that widget's file.

### `lib/screens/settings/`

| File | Contents | Lines |
|------|----------|------:|
| `settings_screen.dart` | `SettingsScreen` | 352 |
| `settings_tiles.dart` | `SettingsCard`, `SettingsSection`, `SettingsRow`, private `_Pill` | 291 |
| `notification_sound_picker.dart` | `showNotificationSoundPicker()`, private `_browseAudioFile()`, `_RingtoneTile` | 159 |
| `settings_brightness_row.dart` | `SettingsBrightnessRow` | 124 |
| `settings_info_cards.dart` | `SettingsGuidanceCard`, `SettingsDangerCard` | 96 |

### `lib/screens/counter_list/`

| File | Contents | Lines |
|------|----------|------:|
| `counter_list_screen.dart` | `CounterListScreen` | 98 |
| `counter_list_header.dart` | `CounterListHeader`, private `_HeaderMenu`, `_TodaySummaryPill`, `_PillStat`, `_PillDivider` | 170 |
| `counter_list_empty_state.dart` | `CounterListEmptyState` | 38 |
| `counter_list_item.dart` | `CounterListItem` (was `_CounterCardWrapper`) | 55 |
| `counter_options_sheet.dart` | `CounterOptionsSheet` | 210 |
| `counter_dialog.dart` | `CounterDialog` | 200 |
| `import_export_dialog.dart` | `ImportExportDialog` | 111 |

### `lib/screens/history/`

| File | Contents | Lines |
|------|----------|------:|
| `history_screen.dart` | `HistoryScreen`, private `_counterProvider` | 246 |
| `history_hero.dart` | `HistoryHero`, private `_DiyaProgress` | 157 |
| `history_day_group.dart` | `HistoryDayGroup`, private `_Pair` | 308 |
| `history_session_row.dart` | `HistorySessionRow` | 123 |

### Other files

- `lib/core/routing/router.dart` — three import paths updated. Route strings unchanged.
- The three new screen test files — only their import line changed. No test body was edited.
- `docs/architecture.md` and `docs/project_structure.md` — `lib/screens/` tree now shows the
  `counter_list/`, `history/`, `settings/`, and `help/` feature folders, with a note that parts in a
  feature folder are for that screen only.

---

## 3. Verification

| Check | Result |
|-------|--------|
| `flutter analyze` | 0 issues |
| `dart format lib test` | 0 files changed |
| `flutter test` | 97 passing (80 before this work) |
| New screen tests after the split | same bodies as Phase 1, only import lines changed, all pass |
| `flutter build apk --flavor dev --debug` | success |
| Files in `lib/` over 500 lines | only the four justified in plan §7: `counting_screen.dart` (701), `counting_provider.dart` (621), `counter_card.dart` (507), `appearance_screen.dart` (503) |

### Differences from the plan

- **Git does not show the three screens as renames.** The plan expected `git diff -M` to show
  them as renames. Each original file lost more than half its lines, so git's rename detection
  (which needs 50% similarity) sees a delete plus new files. No code is affected; only
  `git log --follow` on the new screen files will not reach back past this change.
- **`settings_screen.dart` is 352 lines**, not the ~300 estimated. It is still well under 500.
  Most of it is the one `build` method that lists every settings row.
- **Not done by me:** the manual smoke test on a device. Please open Settings, the home list, and
  History once and try each dialog and sheet.

---

## 4. Still open (from plan §8, not part of this change)

- Screens calling `japaCounterRepositoryProvider` directly (`SettingsScreen._confirmClearAll`,
  `HistoryScreen._confirmClear`, `HistoryDayGroup._confirmDelete`).
- `_counterProvider` in `history_screen.dart` typed `dynamic`; belongs in `lib/providers/`.
- English month-name lists in `CounterDialog` and `HistoryScreen`.
- The JSON import flow duplicated in `settings_screen.dart` and `import_export_dialog.dart`.
