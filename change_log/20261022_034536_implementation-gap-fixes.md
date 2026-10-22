# Change log — Fix implementation gaps

**Date:** 2026-10-22 03:45
**Plan:** `plans/20261022_033000_implementation-gap-fixes.md` (status: `partial_completion`)

---

## Summary

Closed most gaps found in the app review: plan status lines, out-of-date docs, import
value checks, missing tests, and one real bug the new tests found in the counting
screen. The old-app export test (§3.1) was dropped because the old Kotlin app no longer
exists (your decision, 2026-10-22). Daily reminders moved to their own plan
(`plans/20261022_035112_daily-practice-reminders.md`, waiting for approval).

`flutter analyze`: no issues. `flutter test`: 372 tests pass (318 before).

---

## Changes

### Plan status lines (`plans/`)
15 older plans now use the allowed status words. Each was checked against its change
log. 14 are `completed`; `20260922_203500_r8-tuning.md` is `dropped`. The old status
text is kept on a line under the new one.

### Docs
- `docs/implementation_progress.md`, `docs/implementation_plan.md`: schema v5 (was
  "v3"), per-counter mala size (default 108, 0 = no mala), notifications are goal
  alerts only, daily reminders marked "planned, not built yet".
- `docs/improvements.md` §4–§5: the meaning/shloka fields would need a future
  migration; the real v5 migration added `malaSize`.

### Import value checks
- `lib/services/export_service.dart`: new `_validateValues` step after parsing. A
  file is rejected as a whole (nothing written) when it has an `exportVersion` newer
  than the app supports, an empty or duplicate counter id, an empty name, an
  increment step below 1, a negative initial count / goal / daily goal / mala size,
  a session for a counter not in the file, or a negative session count / duration.
  The error uses the existing `ValidationException`.
- `test/services/export_service_test.dart`: 14 new tests (one per rule, a valid file
  still imports, a rejected file leaves data untouched).

### Bug fix — counting screen `dispose()` (approved separately)
- `lib/screens/counting_screen.dart`: `dispose()` called `ref.read(...)`, which
  Riverpod 3 forbids and throws on in release builds too. As a result
  `removeObserver` and `super.dispose()` never ran when the screen closed, the closed
  screen kept getting app pause/resume events (each one threw again), and DND was not
  restored from `dispose()`. The screen now reads `DndService` once in `initState`
  into a `late final _dndService` field and uses it in `dispose()`.

### New tests
| File | Covers |
|------|--------|
| `test/services/notification_service_test.dart` | goal alerts use the right channel, id and strings; follow the app language; `cancelAll` |
| `test/services/dnd_service_test.dart` | native calls and safe fallbacks |
| `test/services/haptic_feedback_service_test.dart` | each feedback event; never throws |
| `test/providers/counters_provider_test.dart` | sort order, add, update, disable, lock, delete (with sessions and paused session), clear all |
| `test/providers/history_provider_test.dart` | grouping by day, totals, filter, clear history |
| `test/screens/counting_screen_test.dart` | tap counts and saves, two-finger swipe undo, back button saves (mid-mala kept paused), app pause saves pending taps |
| `test/screens/backup_settings_screen_test.dart` | actions shown, picker cancel, bad file error keeps data, clear all with confirm |
| `test/screens/optical_sync_screen_test.dart` | send asks for counters first, then shows QR; no counters message; receive shows progress and no camera off-device |

`test/helpers/fake_japa_counter_repository.dart` gained `getSessionById`,
`insertSession`, `updateSession`, `deleteAllCounters` and `exportSelectedData`.

---

## Not done

- **§3.1 old-app export test:** dropped. The old Kotlin app no longer exists, so
  there are no old-app backups to stay compatible with. The backup file you provided
  was made by this Flutter app and holds real practice data, so it was not copied
  into the repository. Removing the remaining old-app references (docs, comments,
  the "byte-compatible" rule) is a separate plan.
- **Daily reminders:** separate plan, waiting for approval.
- **Dropped test idea:** "locked counter cannot count" on the counting screen — the
  lock only blocks opening a counter from its card, which is already tested.
