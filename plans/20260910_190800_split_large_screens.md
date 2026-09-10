# Plan — Split the three largest screens into feature folders (tests first)

**Status:** completed — see `change_log/20260910_192333_split_large_screens.md`

**Follows up:** `change_log/20260910_102935_guidelines_conformance_audit.md` §8 ("Deliberately not done").

---

## 1. The issue

The engineering standard (`docs/guidelines/flutter_project_engineering_standard.md`, file-size
table) says: "around 500 lines: split or justify". Seven files in `lib/` are over 500 lines:

| File | Lines | Decision |
|------|------:|----------|
| `lib/screens/settings_screen.dart` | 992 | **Split** (this plan) |
| `lib/screens/counter_list_screen.dart` | 839 | **Split** (this plan) |
| `lib/screens/history_screen.dart` | 813 | **Split** (this plan) |
| `lib/screens/counting_screen.dart` | 701 | Justified — see §7 |
| `lib/providers/counting_provider.dart` | 621 | Justified — see §7 |
| `lib/widgets/counter_card.dart` | 507 | Justified — see §7 |
| `lib/screens/appearance_screen.dart` | 503 | Justified — see §7 |

The three screens chosen are each **one screen plus a pile of self-contained private widgets and
dialogs**. Moving those widgets into their own files is mostly a pure move. No logic has to change.

The risk: none of these three screens has a widget test today (`test/screens/` only covers the
about, appearance, features, and help screens). A mistake during the move would not be caught.
So tests come first.

---

## 2. Decisions already made (by the user)

1. **Add safety-net tests first**, against the current code, before any file is moved.
2. **Make moved classes public and put them in a feature folder.** No `part` / `part of` files.

---

## 3. Rules for the move

These keep the split a "move only" change:

- **No logic changes.** Widget trees, styles, callbacks, provider calls, and l10n keys stay the same.
  Only the class name, the file it lives in, and its imports change.
- **Only make public what crosses a file boundary.** A small helper used by only one widget stays
  private (`_Name`) in the same file as that widget. This keeps the public surface small.
- **Public names get a feature prefix** so they cannot clash with other classes in the app
  (for example `_Section` becomes `SettingsSection`, not `Section`).
- **Public widgets get a `super.key` parameter.** The `use_key_in_widget_constructors` lint needs
  this for public widgets. It is the only constructor change.
- **The screen file moves into its feature folder too**, next to its parts. This follows the
  existing `lib/screens/help/` folder. The route paths (`/`, `/settings`, `/history`) do not change;
  only the three import lines in `lib/core/routing/router.dart` change.
- **Moves use `git mv`** for the screen files so git history follows them.

---

## 4. Phase 1 — Safety-net tests (written and passing BEFORE any move)

### 4.1 Shared test helper

**New file:** `test/helpers/fake_japa_counter_repository.dart`

A fake `JapaCounterRepository` that holds counters, sessions, and daily summaries in memory. It
uses `implements JapaCounterRepository` and overrides only the methods these screens reach:
`getAllCounters`, `getCounterById`, `getTotalCountForCounter`, `getTodayCountForCounter`,
`getAverageDailyCountForCounter`, `getDailySummaries`, `insertCounter`, `updateCounter`,
`deleteCounter`, `deleteSession`, `deleteAllSessions`, `deleteSessionsByCounterId`. Any other call
throws `UnimplementedError`, so a test fails loudly instead of passing by accident.

Tests override `japaCounterRepositoryProvider` with this fake and `settingsRepositoryProvider`
with a real `SettingsRepository` on mock `SharedPreferences` (same as
`test/screens/appearance_screen_test.dart`). The **real** providers (`countersNotifierProvider`,
`counterStatsProvider`, `todayAggregateProvider`, `historySummariesProvider`) then run on top, so
the tests cover the real screen-to-provider path, not a mocked copy of it.

Why a fake and not an in-memory sqflite database: sqflite on the desktop VM needs
`tester.runAsync` inside widget tests, which makes the tests slower and easier to get wrong. The
database layer already has its own tests (`test/repositories/japa_counter_repository_migration_test.dart`).

### 4.2 New test files

All render at a phone-sized view (1080 × 2400, like the appearance test) with the `en` locale and
find text using the English ARB values.

**`test/screens/settings_screen_test.dart`**
- Renders the four navigation cards (Appearance, Features, Help, About).
- Renders the four section titles (daily goal, mala, stillness, backup) and one `Slider`.
- Tapping the Vibration row flips `settingsNotifierProvider`'s `vibrationEnabled` value.
- The "use system" brightness button sets brightness back to "following system".
- Tapping the Clear-all-data card opens the confirm dialog; Cancel closes it with no data deleted.

**`test/screens/counter_list_screen_test.dart`**
- No counters → the empty state text shows.
- Two counters → two `CounterCard` widgets and the today summary pill with the right numbers.
- The `+` button opens the New Counter dialog.
- Counter dialog validation: a daily goal bigger than the lifetime goal shows the error text and
  does not save; a valid entry calls `insertCounter` on the fake.
- The header menu shows its three items; Import / Export opens the import/export dialog.
- Long-press on a card opens the options sheet with About counter, History, Edit, Lock, and Delete.
- Edit from the sheet opens the dialog filled in with the counter's name.
- Delete from the sheet opens the confirm dialog; confirming calls `deleteCounter` on the fake.

**`test/screens/history_screen_test.dart`**
- No sessions → the "no sessions recorded" text shows.
- With summaries → "Recent offerings" heading and one day group per summary.
- Tapping a day group expands it and shows its session rows; tapping again collapses it.
- The delete icon on a session opens the confirm dialog; confirming calls `deleteSession`.
- Filtered by one counter → the hero shows the counter name, the lifetime total, and the diya
  progress bar when the counter has a goal.

**Gate:** all three files must pass against the **current, unsplit** code. Phase 2 does not start
until they do.

---

## 5. Phase 2 — The split

### 5.1 Settings → `lib/screens/settings/`

| New file | Contents | Approx. lines |
|----------|----------|--------------:|
| `settings_screen.dart` (moved) | `SettingsScreen`: `build`, `_topBar`, `_notificationSoundSubtitle`, `_confirmClearAll` | ~300 |
| `notification_sound_picker.dart` | `showNotificationSoundPicker(...)` top-level function (was `_showNotificationSoundPicker` + `_browseAudioFile`), private `_RingtoneTile` | ~150 |
| `settings_tiles.dart` | `SettingsCard`, `SettingsSection`, `SettingsRow`, private `_Pill` (only `SettingsRow` uses it) | ~290 |
| `settings_brightness_row.dart` | `SettingsBrightnessRow` | ~120 |
| `settings_info_cards.dart` | `SettingsGuidanceCard`, `SettingsDangerCard` | ~95 |

### 5.2 Counter list → `lib/screens/counter_list/`

| New file | Contents | Approx. lines |
|----------|----------|--------------:|
| `counter_list_screen.dart` (moved) | `CounterListScreen`: `build`, `_onMenu`, `_showAddDialog`, `_showImportExport` | ~100 |
| `counter_list_header.dart` | `CounterListHeader`, private `_HeaderMenu`, `_TodaySummaryPill`, `_PillStat`, `_PillDivider` | ~170 |
| `counter_list_empty_state.dart` | `CounterListEmptyState` | ~40 |
| `counter_list_item.dart` | `CounterListItem` (was `_CounterCardWrapper`) and its `_showOptions` | ~50 |
| `counter_options_sheet.dart` | `CounterOptionsSheet` with `_confirmDelete` and `_confirmDisable` | ~200 |
| `counter_dialog.dart` | `CounterDialog` + its state class | ~200 |
| `import_export_dialog.dart` | `ImportExportDialog` + its state class | ~105 |

### 5.3 History → `lib/screens/history/`

| New file | Contents | Approx. lines |
|----------|----------|--------------:|
| `history_screen.dart` (moved) | `HistoryScreen`: `build`, `_topBar`, `_body`, `_formatDate`, `_confirmClear`; the private `_counterProvider` stays here | ~250 |
| `history_hero.dart` | `HistoryHero`, private `_DiyaProgress` | ~155 |
| `history_day_group.dart` | `HistoryDayGroup` + its state class, private `_Pair` | ~300 |
| `history_session_row.dart` | `HistorySessionRow` | ~120 |

Every new file ends up under 300 lines, the "consider splitting" line in the standard.

### 5.4 Other files touched

- `lib/core/routing/router.dart` — three import paths updated.
- `test/screens/settings_screen_test.dart`, `counter_list_screen_test.dart`,
  `history_screen_test.dart` — **only** the import line changes. Test bodies must not be edited
  during Phase 2. If a test needs a body change, the split changed behaviour and must be fixed.
- `docs/project_structure.md` and `docs/architecture.md` — update the `lib/screens/` tree and any
  screen list to show the three new feature folders.

---

## 6. Phase 3 — Verification

| Check | Expected |
|-------|----------|
| `flutter analyze` | 0 issues |
| `dart format .` | no changes |
| `flutter test` | all pass — the 80 existing tests plus the new ones |
| New screen tests | same test bodies as Phase 1, only import lines changed |
| `git diff -M --stat` | the three screens show as renames |
| Search `lib/` for files over 500 lines | only the four files justified in §7 |
| `flutter build apk --flavor dev --debug` | builds |
| Manual smoke check (by the user on a device) | open Settings, the home list, and History; open each dialog and sheet once |

Then write the change log to `change_log/` and set this plan's status to `completed`.

---

## 7. Files over 500 lines that are NOT split, and why

The standard allows "split **or justify**". These are the justifications:

- **`lib/providers/counting_provider.dart` (621)** — holds the zero-data-loss logic: the
  crash-recovery write every 5 taps / 5 seconds and the database write every 20 taps / 30 seconds.
  The timers, counters, and flush methods share state closely. Splitting them across files is
  exactly where a missed flush could creep in, and the size does not justify that risk.
- **`lib/screens/counting_screen.dart` (701)** — one stateful screen whose parts share gesture
  state (pointer move / end handlers) and the counting provider. Only the small `_FooterStat` moves
  out cleanly, which would not bring the file under 500. Left alone.
- **`lib/widgets/counter_card.dart` (507)** and **`lib/screens/appearance_screen.dart` (503)** —
  only a few lines over. Splitting them would be busywork.

---

## 8. Found while reading, NOT fixed in this plan

These are real but are behaviour or layering changes, so they do not belong in a move-only change.
Listed here so they are not forgotten; each can get its own plan.

- `SettingsScreen._confirmClearAll` and `HistoryScreen._confirmClear` call
  `japaCounterRepositoryProvider` directly from a widget. The architecture rule is
  `screens → providers → repositories`.
- `history_screen.dart` defines its own `_counterProvider` typed as `dynamic`. It belongs in
  `lib/providers/` with a real `Counter?` type.
- `CounterDialog._formatDate` and `HistoryScreen._formatDate` each hold an English month-name list.
  The history one must match the repository's date format, so it is not a simple swap for
  `intl`'s localized date format.
- `settings_screen.dart` and `counter_list_screen.dart` both contain the same JSON import flow
  (file picker → read file → `importFromJson` → invalidate counters). This could be one shared
  provider method.

---

## 9. Risks and how they are handled

| Risk | Handling |
|------|----------|
| A widget behaves differently after the move | Phase 1 tests run before and after with unchanged bodies |
| A private helper is referenced from another file by mistake | `flutter analyze` fails on it |
| A class name clashes with another class | Feature-prefixed public names |
| `showNotificationSoundPicker` loses the `context.mounted` checks | The function body is moved as-is; the checks stay |
| Router breaks | Only import paths change; route strings do not |
