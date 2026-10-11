# Per-counter mala size

**Status:** dropped

> Dropped on 2026-10-08 at the user's request. The mala size stays fixed at
> 108 for all counters. No code was changed.

## The issue

The mala size is fixed at 108 for every counter. It is a constant
(`AppConstants.malaSize`) and is also typed as a raw `108` in many places.
The user wants to set the mala size for each counter card:

- Default for every counter (new and existing) is **108**.
- Mala size must be **≥ increment step**.
- Mala size must be **≤ daily goal** (when a daily goal is set, i.e. > 0).
- Mala size must be **≤ lifetime goal** (when a lifetime goal is set, i.e. > 0).
- Mala size must be at least 1.
- All hard-coded `108` values used for mala math must go. They must read the
  counter's own mala size instead.

## Plan for the fix

### 1. Model — `Counter` gets a `malaSize` field
- Add `final int malaSize;` (default `AppConstants.defaultMalaSize` = 108).
  The model stays pure Dart (the constants file has no Flutter imports).
- Add it to `copyWith`, `toMap`, `fromMap` (missing → 108).
- JSON: `fromJson` reads `malaSize`, missing → 108 (so old export files and
  old Kotlin app files still import). `toJson` writes `malaSize` **only when it
  is not 108** — same pattern already used for `isLocked`. This keeps exports
  of default counters byte-identical to the original Android Gson format
  (hard rule 3).
- Add a pure helper `int malaForCount(int count, int malaSize)` style usage via
  the utility in step 3.

### 2. Database — schema v4 → v5
- `AppConstants.dbVersion` 4 → 5.
- Add `_createV5`: `ALTER TABLE counters ADD COLUMN malaSize INTEGER NOT NULL DEFAULT 108`
  using the existing safe "add column if missing" helper.
- Add the column to the fresh `CREATE TABLE counters` too.
- Existing counters get 108 automatically from the column default.
- Old `japa_sessions` rows keep their stored `malas`/`chants` as they are
  (history is not rewritten).

### 3. Mala math uses the counter's size
- Rename the constant `AppConstants.malaSize` → `AppConstants.defaultMalaSize`
  (it is only a default now).
- `core/utils/mala.dart`: `malaForCount(int count, {int malaSize = 108})` →
  change to a required `malaSize` parameter so no caller forgets it.
- `CountingService.calculateMalas/calculateChants` take `malaSize`.
- `ActiveSession` gets a `malaSize` field (copied from the counter when a
  session starts, like `incrementStep`). It is saved in the crash-recovery
  JSON; missing → 108 so saved sessions from the old version still restore.
  `malas` / `chants` getters use it.
- `counting_provider.dart`: replace every `~/ 108`, `% 108`, and
  `AppConstants.malaSize` with `session.malaSize` (mala-complete detection,
  meru pause, sound/haptics on mala complete, earlier-day banner logic,
  row writes).
- `session_recovery_service.dart`: use the saved session's `malaSize`.
- `counting_screen.dart`: mala ring (`goal: 108`, beads remaining, "N/108"
  text) uses the counter's mala size. The ring draws one bead per count up
  to 108; for bigger sizes it keeps 108 beads and fills them by fraction
  (cannot draw thousands of beads).
- Mala labels in `counter_card.dart`, `about_counter_screen.dart`,
  `counting_screen.dart` stat rows, `history_day_group.dart` use the counter's
  mala size.
- `counter_stats_provider.dart` "today" header: malas across counters become
  the **sum of each counter's own malas** (counters may have different sizes)
  instead of `malaForCount(totalChants)`.
- Code comments that say "108" are updated where they describe the logic
  (comments about the visual 108-bead strip on the card stay, since that strip
  is about daily progress, not mala size).

### 4. Add / Edit counter dialog
- `counter_dialog.dart`: new number field "Mala count" (prefilled 108 for new
  counters, current value for edit). `onSave` gets an extra `malaSize` value.
- Validation on Save (shows an error under the Mala count field):
  - empty / < 1 → "Mala count must be at least 1"
  - `malaSize < step` → "Mala count must be at least the increment step"
  - `daily > 0 && malaSize > daily` → "Mala count cannot exceed daily goal"
  - `goal > 0 && malaSize > goal` → "Mala count cannot exceed lifetime goal"
  - Existing checks (daily ≤ lifetime, step < daily) stay as they are.
- `counter_list_screen.dart` / `counter_options_sheet.dart` (whoever builds the
  dialog) and `counters_provider.dart` `addCounter` pass `malaSize` through.
- If a counter is edited while a session is in progress, the running session
  keeps the mala size it started with; the new size applies from the next
  session (same behaviour as increment step today).

### 5. Localization
New keys in `app_en.arb`, `app_ml.arb`, `app_sa.arb`, each with an `@key`
description, then `flutter gen-l10n`:
- `malaSizeLabel` — "Mala count"
- `malaSizeTooSmall` — "Mala count must be at least 1"
- `malaSizeBelowStep` — "Mala count must be at least the increment step"
- `malaSizeExceedsDaily` — "Mala count cannot exceed daily goal"
- `malaSizeExceedsLifetime` — "Mala count cannot exceed lifetime goal"

Help / Features text that says "108 beads" is general teaching text about a
traditional mala; it stays. (Can be changed in a later plan if wanted.)

### 6. Tests
- `test/models/counter_test.dart` (or existing model test): default 108,
  map/JSON round trip, JSON omits `malaSize` when 108, old JSON without it → 108.
- `test/models/active_session_test.dart`: `malas`/`chants` with a custom size;
  old saved JSON → 108.
- `test/repositories/japa_counter_repository_migration_test.dart`: v4 → v5
  adds `malaSize` = 108 to existing counters.
- `test/core/utils/mala_test.dart`, `test/services/counting_service_test.dart`:
  pass mala size; add a non-108 case.
- `test/providers/counting_provider_test.dart`: mala completes at a custom
  size (e.g. 27).
- Dialog widget test: each validation error appears; valid value saves.
- Update existing tests for the changed function signatures.
- Run `flutter analyze` (clean) and `flutter test`.

### 7. Docs
- `docs/architecture.md`: schema v5, `Counter.malaSize`, mala math is per counter.
- `CLAUDE.md`: schema version (v4 → v5), migrations list (v1 → … → v5), and
  "1 mala = 108 counts" testing note → "default mala = 108 counts, per counter".

## Files to be changed

- `lib/core/constants/app_constants.dart`
- `lib/core/utils/mala.dart`
- `lib/models/counter.dart`
- `lib/models/active_session.dart`
- `lib/repositories/japa_counter_repository.dart`
- `lib/services/counting_service.dart`
- `lib/services/session_recovery_service.dart`
- `lib/providers/counting_provider.dart`
- `lib/providers/counters_provider.dart`
- `lib/providers/counter_stats_provider.dart`
- `lib/screens/counter_list/counter_dialog.dart`
- `lib/screens/counter_list/counter_list_screen.dart` and/or `counter_options_sheet.dart` (dialog callers)
- `lib/screens/counting_screen.dart`
- `lib/screens/about_counter_screen.dart`
- `lib/screens/history/history_day_group.dart`
- `lib/widgets/counter_card.dart`
- `lib/widgets/temple_mala_circle.dart` (doc comment only, if needed)
- `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` + generated `app_localizations*.dart`
- Tests listed in step 6
- `docs/architecture.md`, `CLAUDE.md`

## Risks / notes

- Export stays byte-compatible for default counters. A counter with a custom
  mala size adds one extra `malaSize` key; the old Kotlin app (Gson) ignores
  unknown keys, so it can still import the file (it will just use 108).
- History rows already saved keep their old 108-based malas/chants split.
- There are already uncommitted changes in the working tree from earlier
  plans; this work will be added on top without touching them otherwise.
