# Per-counter mala count (with "no mala" option)

**Status:** completed

> This replaces the dropped plan `plans/20261008_212107_per_counter_mala_size.md`.
> It reuses most of that plan and adds the "no mala count" option and the new
> ring rules.

## The issue

The mala count is fixed at 108 for every counter. It is a constant
(`AppConstants.malaSize`) and is also typed as a raw `108` in many places.

Some mantras are not counted in 108s. Some are said once a day, some 5 times a
day. So the user wants:

1. Each counter card has its own **mala count** (default 108).
2. A counter can have **no mala count** at all.
3. The mala ring on the counting screen follows new rules (see step 4).

## Decisions (from the user)

- Ring uses **two modes**: exact dot steps when the mala count fits 108 well,
  otherwise a smooth percentage arc.
- With no mala count, the ring shows progress toward the **daily goal**; if
  there is no daily goal, the **lifetime goal**; if neither, the ring is empty
  and only the number shows.
- With no mala count, these turn off: **mala sound / vibration**, **Meru
  pause**, and **mala text** ("N malas", "N/108").

## Plan for the fix

### 1. Model — `Counter.malaSize`
- Add `final int malaSize;` Default `AppConstants.defaultMalaSize` (108).
  `0` means **no mala count**. Add a getter `bool get hasMala => malaSize > 0;`
- Add to `copyWith`, `toMap`, `fromMap` (missing → 108).
- JSON: `fromJson` reads `malaSize`, missing → 108 (old files still import).
  `toJson` writes `malaSize` **only when it is not 108** — same pattern as
  `isLocked`. Default counters export byte-identical to the original Android
  format (hard rule 3). The old Kotlin app ignores unknown keys.
- Model stays pure Dart.

### 2. Database — schema v4 → v5
- `AppConstants.dbVersion` 4 → 5.
- `_createV5`: add column `malaSize INTEGER NOT NULL DEFAULT 108` to
  `counters` (using the existing safe "add column if missing" helper), and
  call it from both `onCreate` and `onUpgrade`.
- Existing counters get 108. Old `japa_sessions` rows are not rewritten.

### 3. Mala math uses the counter's mala count
- Rename `AppConstants.malaSize` → `AppConstants.defaultMalaSize`.
- `core/utils/mala.dart` and `CountingService.calculateMalas/Chants` take a
  required `malaSize`. When `malaSize == 0`: malas = 0, chants = count.
- `ActiveSession` gets `malaSize` (copied from the counter when a session
  starts, like `incrementStep`). Saved in the crash-recovery JSON; missing →
  108. `malas` / `chants` getters use it.
- `counting_provider.dart`: replace every `~/ 108`, `% 108` and
  `AppConstants.malaSize` with the session's mala count. With no mala:
  - no mala sound / vibration, no Meru pause;
  - leaving the screen **finishes** the session (there is no "unfinished
    mala" to pause and resume);
  - so the earlier-day "unfinished mala" banner never appears (it has
    nothing to show).
- `session_recovery_service.dart`: use the saved session's mala count.
- If a counter is edited while a session is paused, the session keeps the
  mala count it started with; the new count applies from the next session.
- `counter_stats_provider.dart` "today" malas: sum each counter's own malas
  (counters can differ) instead of one 108-based division.

### 4. Mala ring on the counting screen (two modes)
The ring always has 108 dots. Let `m` = mala count, `n` = counts done in the
current mala (`tapCount % m`).

| Case | How the ring fills |
|------|--------------------|
| `m` divides 108 (1, 2, 3, 4, 6, 9, 12, 18, 27, 36, 54, 108) | **Dot mode.** Each tap fills `108 / m` dots. Mala 1: 1 tap = all 108. Mala 2: 1 tap = 54. |
| `m` is a multiple of 108 (216, 324, 432, …) | **Dot mode.** Every `m / 108` taps fill 1 dot. Mala 216: 2 taps = 1 dot. |
| Any other `m` (e.g. 5, 100, 360) | **Percentage mode.** The dots stay as a faint track; a smooth arc fills around the ring by `n / m`. |
| No mala count | **Percentage mode.** Arc = today's count ÷ daily goal; if no daily goal, lifetime count ÷ lifetime goal; if neither, empty ring. |

- Note: 360 is not a multiple of 108 (360 ÷ 108 = 3.33), so it uses the
  percentage arc.
- `temple_mala_circle.dart`: add a "percentage arc" drawing option next to
  the existing dot drawing. The ring decides the mode with a small pure
  helper (e.g. `MalaRingMode` in `core/utils/mala.dart`) so it is easy to
  unit-test.
- Centre number: with a mala count it shows the count in this mala and
  "N/m" (not "N/108"); with no mala it shows the session count and no "N/m".

### 5. Mala text elsewhere
- `counter_card.dart`, `about_counter_screen.dart`, counting screen stat
  rows, `history_day_group.dart`: use the counter's mala count. With no mala
  count, hide the malas text and show only the count.
- The 27-segment strip on the card shows **daily progress**, not malas, so it
  stays as it is.

### 6. Add / Edit counter dialog
- `counter_dialog.dart`: new number field **"Mala count"** (108 for new
  counters, current value on edit) and a switch **"No mala count"**. When the
  switch is on, the field is disabled and the value saved is `0`.
- Validation when a mala count is used:
  - empty / < 1 → "Mala count must be at least 1"
  - smaller than the increment step → "Mala count must be at least the
    increment step"
  - larger than the daily goal (if set) → "Mala count cannot exceed daily goal"
  - larger than the lifetime goal (if set) → "Mala count cannot exceed
    lifetime goal"
- Callers of the dialog and `counters_provider.dart` `addCounter` /
  update pass `malaSize` through.

### 7. Localization
New keys in `app_en.arb`, `app_ml.arb`, `app_sa.arb`, each with an `@key`
description, then `flutter gen-l10n`:
- `malaSizeLabel` — "Mala count"
- `noMalaCountLabel` — "No mala count"
- `malaSizeTooSmall`, `malaSizeBelowStep`, `malaSizeExceedsDaily`,
  `malaSizeExceedsLifetime` — the error texts above
- Any "N/108"-style string becomes a placeholder string using the counter's
  mala count.

### 8. Tests
- Counter model: default 108, `0` = no mala, map/JSON round trip, JSON omits
  `malaSize` when 108, old JSON → 108.
- `ActiveSession`: malas/chants with custom size and with 0; old saved JSON →
  108.
- Migration test: v4 → v5 adds `malaSize` = 108.
- `mala.dart` / `counting_service.dart`: custom size, size 0.
- Ring mode helper: 1, 2, 27, 108, 216 → dot mode with the right fill;
  5, 100, 360 → percentage; no mala → daily / lifetime / empty.
- Counting provider: mala completes at a custom size; no mala → no Meru
  pause, no mala sound, exit finishes the session.
- Dialog widget test: each error shows; "No mala count" saves 0.
- Update existing tests for changed signatures.
- Run `flutter analyze` (clean) and `flutter test`.

### 9. Docs
- `docs/architecture.md`: schema v5, `Counter.malaSize` (0 = none), ring modes.
- `CLAUDE.md`: schema v4 → v5, migrations list to v5, "1 mala = 108 counts"
  → "default mala = 108 counts, set per counter; 0 = no mala".

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
- `lib/screens/counter_list/counter_dialog.dart` and its caller(s) in
  `lib/screens/counter_list/`
- `lib/screens/counting_screen.dart`
- `lib/screens/about_counter_screen.dart`
- `lib/screens/history/history_day_group.dart`
- `lib/widgets/counter_card.dart`
- `lib/widgets/temple_mala_circle.dart`
- `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` + generated
  `app_localizations*.dart`
- Tests listed in step 8
- `docs/architecture.md`, `CLAUDE.md`

## Risks / notes

- Exports stay byte-compatible for counters with mala 108. Others add one
  `malaSize` key, which the old Kotlin app ignores (it will use 108).
- Saved history rows keep their old 108-based malas/chants.
- An existing counter whose daily or lifetime goal is below 108 will fail the
  "cannot exceed goal" check when edited. The user can lower the mala count or
  pick "No mala count" then.
- There are already uncommitted changes from earlier plans; this work goes on
  top without changing them otherwise.
