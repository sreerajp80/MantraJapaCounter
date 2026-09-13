# Plan: Selective Counter Merging and Optional Local Export Encryption

**Status:** Completed
**Date:** 2026-09-13
**Author:** AI Agent

---

## 1. Overview

This plan implements two data-protection and sync features:
1. **Selective Counter Merging**: Allow practitioners to select specific counters to export or import via the optical QR stream or JSON file export/import, rather than always syncing all counters in bulk.
2. **Optional Local Export Encryption**: Provide an optional passphrase-protected AES-256-GCM encryption toggle for export files. This ensures notes, mantra names, and vows stay confidential when backups are moved to external storage or shared devices.

---

## 2. Issues & Current State

1. **All-or-Nothing Sync**: Optical sync and file export always bundled every counter and session. Practitioners wishing to migrate a single completed sankalpa counter to another device had no selective options.
2. **Destructive Import**: Standard import purged all existing local data before writing imported items. Selective migration requires non-destructive merging (upsert) so unselected counters remain untouched.
3. **Plaintext File Backups**: Exported JSON files were plain text. Sensitive personal intentions, notes, or vows could be exposed if backup files were copied to external storage.

---

## 3. Proposed Fix & Architecture

1. **Selective Export & Merge in Repository**:
   - In `lib/repositories/japa_counter_repository.dart`:
     - Add `exportSelectedData(List<String> counterIds)`.
     - Add `importSelectedData(ExportData data, List<String> counterIds)` using SQLite transaction and upsert (`ConflictAlgorithm.replace`), preserving existing non-selected counters.

2. **Offline Encryption Service**:
   - Add `cryptography: ^2.7.0` to `pubspec.yaml` (pure Dart, zero native code, zero network access).
   - In `lib/services/encryption_service.dart`:
     - Implement AES-256-GCM encryption and decryption.
     - Key derivation using PBKDF2 with HMAC-SHA256 (100,000 iterations, 16-byte random salt, 12-byte IV).
     - Envelope format: `{"encrypted": true, "version": 1, "salt": "...", "iv": "...", "ciphertext": "..."}`.
     - Auto-detection helper `isEncrypted(String content)`.

3. **Export Service Integration**:
   - In `lib/services/export_service.dart`:
     - Support optional passphrase in `exportAndShare()` and `exportSelectedAndShare()`.
     - Output `.json.enc` file extension for encrypted backups.
     - Throw `EncryptedExportException` when importing encrypted content without a passphrase.
     - Add `importEncryptedFromJson()`, `importSelectedFromJson()`, and `importSelectedEncryptedFromJson()`.

4. **UI Components & Dialogs**:
   - Create `lib/widgets/counter_selection_sheet.dart`: Reusable modal bottom sheet showing counter checklist with select/deselect all toggle.
   - Create `lib/widgets/passphrase_dialog.dart`: Dialog for setting a passphrase on export (minimum 6 chars, match verification) or entering a passphrase on import.
   - Update `lib/screens/optical_sync_screen.dart` to offer counter selection before transmission.
   - Update `lib/widgets/optical_sync_import_preview_sheet.dart` to allow selective counter selection before merging.
   - Update `lib/screens/settings/settings_screen.dart` and `lib/screens/counter_list/import_export_dialog.dart` to support encryption on export and password prompt on import.

5. **Multilingual Localization**:
   - Add localized strings across `lib/l10n/app_en.arb`, `lib/l10n/app_ml.arb`, and `lib/l10n/app_sa.arb`.
   - Run `flutter gen-l10n`.

6. **Documentation & Tests**:
   - Update `docs/improvements.md`, `docs/security.md`, `docs/architecture.md`.
   - Add unit tests for `EncryptionService`, `JapaCounterRepository`, and `ExportService`.

---

## 4. Files to Change

- `pubspec.yaml`
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
- `docs/improvements.md`
- `docs/security.md`
- `docs/architecture.md`
- `test/services/encryption_service_test.dart` [NEW]
- `test/repositories/japa_counter_repository_export_test.dart` [NEW]
- `test/services/export_service_test.dart` [NEW]
