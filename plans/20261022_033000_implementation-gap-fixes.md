# Plan — Fix implementation gaps (import test file, import checks, reminders, docs, tests)

**Status:** partial_completion

**Date:** 2026-10-22 03:30
**Change log (after work is done):** `change_log/20261022_<hhMMss>_implementation-gap-fixes.md`, timed after this plan.

---

## 1. Background

A review of the app (no code changed) found that `flutter analyze` is clean and all
318 tests pass, but some things the docs promise are missing or untested. This plan
covers only those gaps.

**Out of scope:** all roadmap ideas in `docs/improvements.md` (pocket mode, volume-key
counting, bead drag, Dhyana mode, etc.). None of them will be started.

---

## 2. Issues

| # | Issue | Where |
|---|-------|-------|
| 1 | No real old-app export file is tested. `CLAUDE.md` hard rule 3 needs import to stay compatible with the original Android export. `test/fixtures/` holds only a README, and the `import_compatibility_test.dart` it asks for does not exist. | `test/fixtures/`, `test/repositories/` |
| 2 | Import checks only the JSON shape, not the values. Bad values (negative `malaSize`, `incrementStep` ≤ 0, empty name, duplicate counter IDs, sessions for counters not in the file, negative counts or durations, `exportVersion` newer than the app knows) are saved as they are. | `lib/services/export_service.dart` |
| 3 | `docs/implementation_progress.md` marks "offline daily reminders" as done. The code has no reminder scheduling; `NotificationService` only sends goal-reached alerts. | `docs/implementation_progress.md`, `docs/implementation_plan.md` |
| 4 | Docs are out of date: "Schema v3" (the database is v5), "1 mala = 108" (mala size is now per counter), and `docs/improvements.md` §4 says v5 will add meaning/shloka fields (v5 really added `malaSize`). | `docs/implementation_progress.md`, `docs/implementation_plan.md`, `docs/improvements.md` |
| 5 | 15 plan files use status words that are not allowed (`Proposed`, `Done`, `Complete`, `Implemented`, `Skipped`, `Approved by user — in progress`, …). | `plans/` (list in §3.4) |
| 6 | Missing tests for: counting screen, optical sync screen, backup settings screen, `counters_provider`, `history_provider`, `NotificationService`, `DndService`, `HapticFeedbackService`. | `test/` |

---

## 3. Fix plan

### 3.1 Old-app export test (issue 1)

- **You need to provide one file:** an export from the old Android app (v4.x).
  For privacy, please make it from **test counters only** (dummy names, a few
  sessions, one disabled counter, one with a daily goal), not your real practice data,
  because the file will be committed to the repository.
- Save it as `test/fixtures/android_v4_export.json`.
- Add `test/repositories/import_compatibility_test.dart` that:
  - parses the file with `ExportService.parseExportData`;
  - imports it into an in-memory database (`sqflite_common_ffi`) and checks every
    counter and session field;
  - exports again and checks that every field from the old file comes back with the
    same name, type and value (new fields `isLocked` / `malaSize` stay absent for
    default counters).
- Update `test/fixtures/README.md` to name the file and the test.
- If you cannot provide the file, this part is left out and the plan ends as
  `partial_completion`.
- **Dropped (2026-10-22):** the old Kotlin app no longer exists, so this part is not
  needed. See the change log `change_log/20261022_050000_implementation-gap-fixes.md`.

### 3.2 Import value checks (issue 2)

- In `ExportService._parseAndValidate`, after `ExportData.fromJson`, add a private
  `_validateValues(ExportData)` step that throws the existing `ValidationException`
  with a clear message when:
  - `exportVersion` is greater than `AppConstants.exportFormatVersion`;
  - a counter `id` or `name` is empty, or a counter `id` appears twice;
  - `incrementStep` < 1, or `malaSize`, `goal`, `dailyGoal`, `initialCount` < 0;
  - a session's `counterId` is not one of the file's counters;
  - a session has a negative count or duration.
- The whole file is rejected; nothing is written (same as today for bad JSON).
- No change to the JSON format, models or database.
- Tests: one test per rule in `test/services/export_service_test.dart`, plus a test
  that a valid file still imports.

> Note: import errors are shown today as `l.importFailed('$e')`, so the detail text is
> English only. This plan keeps that behaviour; localizing error details would be
> separate work.

### 3.3 Daily reminders (issue 3) — your decision needed

- **Option A (recommended): fix the docs only.** Change the doc lines to say
  notifications are used for daily-goal and lifetime-goal alerts. No code change.
- **Option B: build daily reminders.** A new setting (on/off + time), scheduled with
  `flutter_local_notifications` (exact-alarm permission questions, reboot handling,
  new ARB strings in en/ml/sa, tests). This is a new feature and would get its own
  separate plan.

**Decision (2026-10-22): Option B.** Daily reminders get their own separate plan.
In this plan the docs only change the "daily reminders" line from done to
"planned — not built yet", so the docs stop claiming a feature that does not exist.

### 3.4 Doc and plan status cleanup (issues 4 and 5)

- `docs/implementation_progress.md` and `docs/implementation_plan.md`: schema v5,
  per-counter mala size (default 108, 0 = no mala), notification wording from §3.3,
  refresh the date.
- `docs/improvements.md` §4 table: say the v5 migration added `malaSize`, and the
  meaning/shloka fields would need a future migration.
- Plan status lines (only the `**Status:**` line changes; anything after it, like
  "see change_log/…", is kept on a following line):

  | Plan file | New status |
  |-----------|-----------|
  | `20260910_185144_move_config_utils_under_core.md` | `completed` |
  | `20260910_190800_split_large_screens.md` | `completed` |
  | `20260910_191700_fix_options_sheet_dialog_context.md` | `completed` |
  | `20260912_224500_add_screenshots_update_readme.md` | `completed` |
  | `20260913_145200_guidelines_strict_adherence.md` | `completed` |
  | `20260913_150000_localize_app_config_fields.md` | `completed` |
  | `20260913_194500_authentic_sacred_soundscapes.md` | `completed` |
  | `20260913_195500_mark_soundscapes_completed.md` | `completed` |
  | `20260913_200500_selective_counter_merging_and_export_encryption.md` | `completed` |
  | `20260919_100500_settings_features_permissions_polish.md` | `completed` |
  | `20260919_105000_low_power_optimization.md` | `completed` (or `partial_completion` if its change log shows steps not done) |
  | `20260919_111300_update_readme_and_screenshots.md` | `completed` |
  | `20260922_201837_target-sdk-36.md` | `completed` |
  | `20260922_203500_r8-tuning.md` | `dropped` |
  | `20260922_205000_portrait-lock-large-screens.md` | `completed` |

  Each `completed` is checked against its matching change log before changing it.

### 3.5 Missing tests (issue 6)

All new tests use the existing `test/helpers/fake_japa_counter_repository.dart` and
fake platform channels; no app code changes unless a test shows a real bug (any such
bug is reported to you first, not fixed silently).

| New test file | What it checks |
|---------------|----------------|
| `test/screens/counting_screen_test.dart` | tap adds a count; undo; leaving the screen (back) saves pending taps; app pause calls save; locked counter cannot count |
| `test/screens/optical_sync_screen_test.dart` | send and receive tabs build; no camera start until asked (camera faked) |
| `test/screens/backup_settings_screen_test.dart` | export / import buttons show; a failed import shows the error snackbar |
| `test/providers/counters_provider_test.dart` | add, edit, disable, lock, delete counter; delete-all clears saved sessions |
| `test/providers/history_provider_test.dart` | sessions grouped by day; totals per day; empty history |
| `test/services/notification_service_test.dart` | goal alerts call the plugin with the right channel; `cancelAll` (plugin faked) |
| `test/services/dnd_service_test.dart` | enable / restore calls the method channel; restore does nothing when not enabled |
| `test/services/haptic_feedback_service_test.dart` | each event sends the expected vibration call |

---

## 4. Files to change

**New**
- `test/fixtures/android_v4_export.json` (provided by you)
- `test/repositories/import_compatibility_test.dart`
- the 8 test files in §3.5

**Changed**
- `lib/services/export_service.dart`
- `test/services/export_service_test.dart`
- `test/fixtures/README.md`
- `docs/implementation_progress.md`
- `docs/implementation_plan.md`
- `docs/improvements.md`
- the 15 plan files in §3.4 (status line only)

**Not touched:** `docs/guidelines/` (submodule), models, database schema, JSON format,
ARB files, Android files.

**Added during work (approved 2026-10-22):** `lib/screens/counting_screen.dart`
(dispose bug fix, see §6.1) and `test/helpers/fake_japa_counter_repository.dart`.

---

## 5. Order of work

1. Plan status cleanup and doc fixes (§3.4, §3.3 Option A).
2. Import value checks + tests (§3.2).
3. Missing tests (§3.5).
4. Old-app export test (§3.1), once the file is provided.
5. Run `dart format .`, `flutter analyze`, `flutter test` — all must be clean.
6. Write the change log and set this plan to `completed` (or `partial_completion`).

---

## 6. Findings during work (2026-10-22)

1. **Bug found by the new counting screen test — fixed 2026-10-22 with your OK.**
   `_CountingScreenState.dispose()` in `lib/screens/counting_screen.dart` calls
   `ref.read(dndServiceProvider)`. Riverpod 3 throws a `StateError` when `ref` is used
   in `dispose()`, in release builds too (it is a plain `throw`, not a debug assert).
   So every time the counting screen closes:
   - `WidgetsBinding.instance.removeObserver(this)` and `super.dispose()` never run;
   - the closed screen stays registered for app lifecycle events, and each later
     pause/resume throws the same error again;
   - `restoreDnd()` from `dispose()` never runs (the back button path still restores
     DND first, in `_saveAndExit`).
   Proposed fix (same pattern `optical_sync_screen.dart` already uses): read
   `DndService` once in `initState` into a `late final` field and use that field in
   `dispose()`. One file, about 5 lines.
   **Done:** `lib/screens/counting_screen.dart` now keeps `DndService` in a
   `late final _dndService` field set in `initState`. All 5 counting screen tests
   pass; full suite 372 tests pass and `flutter analyze` is clean.
   The back-button test was also corrected: a session stopped mid-mala is kept as a
   paused session by design (`completeSession`), so the test now expects that.
2. **Dropped test idea:** "locked counter cannot count" on the counting screen. The lock
   only blocks opening the counter from its card (`counter_card.dart`, already tested);
   the counting screen does not check it. No test added here.
3. **Plan statuses:** each old plan's change log was checked; none listed skipped steps,
   so all are `completed` except R8 tuning (`dropped`). The old status text is kept on
   a line under the new status.
4. **Test helper:** `test/helpers/fake_japa_counter_repository.dart` gained
   `getSessionById`, `insertSession`, `updateSession`, `deleteAllCounters` and
   `exportSelectedData` for the new screen tests.

---

## 7. Risks

- New import checks could reject an old backup that has odd but harmless values. The
  old-app export test (§3.1) guards against this; if a real file fails a rule, the
  rule is relaxed, not the file changed.
- Widget tests for the counting screen depend on timers; tests will use
  `fakeAsync` / `tester.pump` with durations to stay stable.
