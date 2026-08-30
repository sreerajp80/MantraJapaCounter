# Implementation Plan: Counter Lock Feature

**Status:** COMPLETED

## Overview
Add a lock/unlock capability to mantra counters on the counter list page. When a counter is locked, accidental taps on the card will not open the counting screen, preventing users from inadvertently counting towards the wrong counter. Users can toggle lock status via a dedicated lock button on the counter card as well as via the counter options menu.

---

## Proposed Changes

### 1. Data Model & Serialization
- **File:** `lib/models/counter.dart`
  - Add `final bool isLocked;` property to `Counter` (default: `false`).
  - Update `copyWith`, `toMap`, `fromMap`, `toJson`, and `fromJson` to support `isLocked`.
  - Maintain backwards and Android Gson export/import compatibility.

### 2. Database Schema & Migration
- **File:** `lib/repositories/japa_counter_repository.dart`
  - Bump SQLite schema handling to version 4.
  - Add `_createV4` step to add `isLocked INTEGER NOT NULL DEFAULT 0` column to `counters` table via `_addColumnIfMissing`.
  - Add `v3 -> v4` migration path in `onUpgrade`.
- **File:** `lib/main.dart`
  - Set database version to `4`.

### 3. State Management
- **File:** `lib/providers/counters_provider.dart`
  - Add `toggleLock(String id)` method to `CountersNotifier` that toggles `isLocked` in SQLite and refreshes the counter list state.

### 4. UI Components & Screen
- **File:** `lib/widgets/counter_card.dart`
  - Add `onToggleLock` callback parameter to `CounterCard`.
  - Add a dedicated lock icon button to the counter card header.
    - Locked state: prominent `Icons.lock` icon with tooltip.
    - Unlocked state: subtle `Icons.lock_open_outlined` icon with tooltip.
  - If card is tapped while locked, prevent navigation to the counting screen and show a SnackBar explaining that the counter is locked.
- **File:** `lib/screens/counter_list_screen.dart`
  - Pass `onToggleLock` to `CounterCard` connecting to `ref.read(countersNotifierProvider.notifier).toggleLock(counter.id)`.
  - Add "Lock counter" / "Unlock counter" ListTile to `_CounterOptionsSheet`.
- **File:** `lib/screens/about_counter_screen.dart`
  - Display lock status under counter details info table.

### 5. Localization
- **File:** `lib/l10n/app_en.arb` & `lib/l10n/app_ml.arb`
  - Add ARB localization entries for:
    - `lockCounter`
    - `unlockCounter`
    - `counterLockedNotice`
    - `counterLockedTooltip`
    - `counterUnlockedTooltip`
    - `statusLocked`
- Run `flutter gen-l10n` to update generated localizations.

### 6. Tests
- **File:** `test/models/counter_test.dart`
  - Add unit tests for `isLocked` field defaults, serialization, deserialization, and `copyWith`.
- **File:** `test/repositories/japa_counter_repository_test.dart` (or new test file)
  - Add test verifying `isLocked` database storage and retrieval.

---

## Verification Plan

### Automated Tests
- Run `flutter test` to ensure all existing and new tests pass.
- Run `flutter analyze` to verify static analysis is clean.

### Manual Verification
- Launch application on Android / emulator.
- Create a counter and verify lock icon is displayed.
- Tap lock icon to lock counter; verify icon updates to locked state.
- Tap card body; verify navigation is blocked and lock notice is shown.
- Tap lock icon again to unlock; verify card can be opened for counting.
- Check options bottom sheet menu for lock/unlock action.
