# Change Log: Counter Lock Feature

**Plan reference:** `plans/20260829_052800_counter_lock_feature.md`  
**Date:** 2026-08-29

## Summary of Changes
Added a counter lock/unlock feature on the counter list page so users can prevent accidental taps and unintentional counting on the wrong mantra counter.

## Key Changes
1. **Model (`lib/models/counter.dart`)**:
   - Added `isLocked` (boolean, defaults to `false`) to the immutable `Counter` domain model.
   - Updated `copyWith`, `toMap`, `fromMap`, `toJson`, and `fromJson` while maintaining complete Android Gson JSON export/import compatibility.

2. **Database & Migrations (`lib/repositories/japa_counter_repository.dart`, `lib/main.dart`)**:
   - Upgraded SQLite database schema version to `4`.
   - Added `_createV4` migration that adds the `isLocked` column via `_addColumnIfMissing`.
   - Updated `onCreate` and `onUpgrade` methods in `JapaCounterRepository`.

3. **State Management (`lib/providers/counters_provider.dart`)**:
   - Added `toggleLock(String id)` method to `CountersNotifier` to toggle the lock state and refresh the provider state.

4. **UI & Widgets (`lib/widgets/counter_card.dart`, `lib/screens/counter_list_screen.dart`, `lib/screens/about_counter_screen.dart`)**:
   - Added `onToggleLock` callback and a dedicated lock button in the header of `CounterCard`.
   - When unlocked: shows an open lock icon (`Icons.lock_open_outlined`).
   - When locked: shows a locked icon (`Icons.lock`) with highlight styling.
   - When a locked card is tapped, navigation to the counting screen is prevented and a floating SnackBar notice is displayed.
   - Added a "Lock counter" / "Unlock counter" option in the long-press options bottom sheet.
   - Updated `AboutCounterScreen` to display the locked status alongside active state.

5. **Localization (`lib/l10n/app_en.arb`, `lib/l10n/app_ml.arb`)**:
   - Added localized strings for `lockCounter`, `unlockCounter`, `counterLockedNotice`, `counterLockedTooltip`, `counterUnlockedTooltip`, and `statusLocked` for both English and Malayalam.

6. **Tests (`test/models/counter_test.dart`, `test/widgets/counter_card_test.dart`)**:
   - Added unit tests for `isLocked` domain model behaviors (defaults, `copyWith`, map conversion, JSON serialization).
   - Added widget tests validating lock toggle buttons, tap prevention, and SnackBar alerts when locked.

## Verification
- Ran `flutter test` — all 62 tests passed.
- Ran `flutter analyze` — 0 issues reported.
