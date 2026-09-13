# Change Log: Selective Counter Merging and Optional Local Export Encryption

**Date:** 2026-09-13
**Author:** AI Agent
**Reference Plan:** plans/20260913_200500_selective_counter_merging_and_export_encryption.md

---

## 1. Summary of Changes

- **Repository Layer (`lib/repositories/japa_counter_repository.dart`)**:
  - Implemented `exportSelectedData(List<String> counterIds)` to retrieve only specified counters and their corresponding sessions.
  - Implemented `importSelectedData(ExportData data, List<String> counterIds)` using a transactional merge strategy (SQLite `ConflictAlgorithm.replace`), safely updating matched counters without deleting any existing unselected counters.

- **Offline Encryption Engine (`lib/services/encryption_service.dart`)**:
  - Added pure-Dart `EncryptionService` powered by `cryptography: ^2.7.0` (zero native binaries, fully offline).
  - Implemented authenticated AES-256-GCM encryption with PBKDF2 key derivation (100,000 iterations, HMAC-SHA256, 16-byte random salt, 12-byte IV).
  - Implemented `decrypt(envelopeJson, passphrase)` and auto-detection `isEncrypted(content)`.
  - Registered `encryptionServiceProvider` in `lib/providers/app_providers.dart`.

- **Export Service Updates (`lib/services/export_service.dart`)**:
  - Added optional passphrase protection to `exportAndShare()` and `exportSelectedAndShare()`, writing to `.json.enc` files when encryption is enabled.
  - Introduced `EncryptedExportException` thrown when importing encrypted files without a passphrase.
  - Added `importEncryptedFromJson()`, `importSelectedFromJson()`, and `importSelectedEncryptedFromJson()`.

- **Optical Sync Provider (`lib/providers/optical_sync_provider.dart`)**:
  - Added selective counter filtering on both transmission and reception sides.
  - Added `selectedCounterIds` state and `setSelectedCounterIds()` methods to `OpticalSyncTransmitNotifier` and `OpticalSyncReceiveNotifier`.

- **UI Components & Modals**:
  - Created `lib/widgets/counter_selection_sheet.dart`: Reusable modal bottom sheet displaying a checklist of counters with "Select All / Deselect All".
  - Created `lib/widgets/passphrase_dialog.dart`: Dialog for passphrase entry with visibility toggle, length validation, and confirm password check.
  - Updated `lib/screens/optical_sync_screen.dart` to open `CounterSelectionSheet` before starting QR frame generation.
  - Updated `lib/widgets/optical_sync_import_preview_sheet.dart` to allow selecting which counters to import from the scanned payload.
  - Updated `lib/screens/settings/settings_screen.dart` and `lib/screens/counter_list/import_export_dialog.dart` with passphrase dialog integration on export and auto-detection decryption on import.

- **Localization (`lib/l10n/`)**:
  - Added localized strings across English (`app_en.arb`), Malayalam (`app_ml.arb`), and Sanskrit (`app_sa.arb`) for all counter selection and encryption dialogs.
  - Maintained complete key parity across all 3 languages.

- **Documentation**:
  - Updated `docs/improvements.md`: Marked items 10 and 11 as Completed with architectural highlights.
  - Updated `docs/security.md`: Documented AES-256-GCM encryption parameters in §6 and updated export risk in §17 to mitigated.
  - Updated `docs/architecture.md`: Documented `EncryptionService`, `OpticalSyncService`, `SoundService`, and `EncryptedExportException`.

- **Automated Tests**:
  - Added `test/services/encryption_service_test.dart` (5 tests for AES-256-GCM encryption, decryption, password checks, malformed envelopes).
  - Added `test/repositories/japa_counter_repository_export_test.dart` (4 tests for selective export and non-destructive merge).
  - Added `test/services/export_service_test.dart` (5 tests for parsing, encrypted import detection, decrypted import, and selective import).
  - Verified 100% pass rate on `flutter analyze` and `flutter test` (153 tests passing).

---

## 2. Files Changed

- `pubspec.yaml`
- `pubspec.lock`
- `lib/services/encryption_service.dart` [NEW]
- `lib/services/export_service.dart`
- `lib/repositories/japa_counter_repository.dart`
- `lib/providers/app_providers.dart`
- `lib/providers/optical_sync_provider.dart`
- `lib/widgets/counter_selection_sheet.dart` [NEW]
- `lib/widgets/passphrase_dialog.dart` [NEW]
- `lib/widgets/optical_sync_import_preview_sheet.dart`
- `lib/screens/optical_sync_screen.dart`
- `lib/screens/settings/settings_screen.dart`
- `lib/screens/counter_list/import_export_dialog.dart`
- `lib/l10n/app_en.arb`
- `lib/l10n/app_ml.arb`
- `lib/l10n/app_sa.arb`
- `lib/l10n/app_localizations.dart`
- `lib/l10n/app_localizations_en.dart`
- `lib/l10n/app_localizations_ml.dart`
- `lib/l10n/app_localizations_sa.dart`
- `docs/improvements.md`
- `docs/security.md`
- `docs/architecture.md`
- `plans/20260913_200500_selective_counter_merging_and_export_encryption.md` [NEW]
- `test/services/encryption_service_test.dart` [NEW]
- `test/repositories/japa_counter_repository_export_test.dart` [NEW]
- `test/services/export_service_test.dart` [NEW]
