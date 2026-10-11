# Per-counter mala count (with "no mala" option)

Implements plan: `plans/20261011_070315_per_counter_mala_count.md`

## What changed

### Data
- `Counter` has a new `malaSize` field (default 108; `0` = no mala count) and a
  `hasMala` getter. It is saved in the database and in JSON.
- JSON export writes `malaSize` only when it is not 108, so default counters
  still export in the original Android format. Old files without it import as
  108.
- Database schema is now **v5**. `_createV5` adds
  `counters.malaSize INTEGER NOT NULL DEFAULT 108`. Existing counters get 108.
- `ActiveSession` has `malaSize` (copied from the counter when a session
  starts), plus `hasMala` and `isMidMala`. Old saved sessions restore as 108.
- `AppConstants.malaSize` was renamed to `AppConstants.defaultMalaSize`. A new
  `AppConstants.ringBeads` (108) is the number of beads on the ring.

### Mala math
- `core/utils/mala.dart`: `malaForCount(count, malaSize)` now needs the mala
  count. New `malasOf`, `chantsOf`, `malaRingFill` and `noMalaRingFill`
  helpers.
- `CountingService.calculateMalas/Chants` take the mala count.
- `counting_provider.dart`, `session_recovery_service.dart`: every raw `108`
  now uses the session's mala count. With no mala count there is no mala
  sound / vibration, no Meru pause, and leaving the screen always finishes the
  session (so the earlier-day banner never shows).
- `counter_stats_provider.dart`: today's total malas is the sum of each
  counter's own malas.

### Screens
- **Add / Edit counter dialog:** new "Mala count" field (108 by default) and a
  "No mala count" switch. Checks: at least 1, at least the increment step, not
  more than the daily goal or the lifetime goal when set.
- **Counting screen ring** (`temple_mala_circle.dart` gained an `arcFraction`
  option):
  - Mala count divides 108 → dots; each count fills `108 / m` beads.
  - Mala count is a multiple of 108 → dots; every `m / 108` counts fill one
    bead.
  - Any other mala count → smooth percentage arc.
  - No mala count → arc shows today vs daily goal, else lifetime vs lifetime
    goal, else empty.
- Counting screen centre: shows "of {m}" for a custom mala count (108 keeps
  "of one hundred eight"); no subtitle and no "beads remain" line with no mala
  count. Footer hides the malas column with no mala count.
- Earlier-day banner text now shows `{chants}/{malaSize}` instead of `/108`.
- Counter card, About counter screen and history day rows use the counter's
  mala count and hide mala text when there is none. The About counter screen
  also lists the mala count.
- The card's lifetime "N / M mala" text was an English-only string; it now uses
  the translated `cardMalaProgress` text.

### Localization
- New keys in en / ml / sa: `malaSizeLabel`, `noMalaCountLabel`,
  `malaSizeTooSmall`, `malaSizeBelowStep`, `malaSizeExceedsDaily`,
  `malaSizeExceedsLifetime`, `ofMalaCount`. `unfinishedMalaBanner` gained a
  `malaSize` placeholder. Ran `flutter gen-l10n`.

### Tests
- New: ring mode and fill tests, custom / zero mala math, `Counter` and
  `ActiveSession` mala size round trips, v4 → v5 migration, counting provider
  (Meru pause at 27, no-mala session finishes on exit, full custom mala
  finishes), and `test/screens/counter_list/counter_dialog_test.dart`.
- Updated: old mala tests for the new signatures; the add-dialog test in
  `counter_list_screen_test.dart` now sets a mala count (its daily goal of 50
  is below the default 108).
- Golden `test/widgets/goldens/counter_card_ml.png` was regenerated. It is
  1 pixel taller because the lifetime mala text is now in Malayalam.
- `flutter analyze`: no issues. `flutter test`: all 313 tests pass.

### Docs
- `docs/architecture.md`: schema v5, migration table rows 4 and 5, new
  "Per-Counter Mala Count" section.
- `CLAUDE.md`, `AGENTS.md`: schema v5 and the migration / mala test notes.

## Notes
- Saved history rows keep their old malas / chants split.
- The unfiltered history view (all counters) still uses 108 for its per-day
  mala figure. When filtered to one counter it uses that counter's mala count.
- A paused session keeps the mala count it started with. A new mala count
  applies from the next session.
