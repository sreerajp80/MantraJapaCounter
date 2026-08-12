# Change Log — Optical Air-Gap Sync (High-Density Animated QR Stream)

**Plan Reference:** `plans/20260812_205500_optical_air_gap_sync.md`

## Summary of Changes

Implemented **Optical Air-Gap Sync (High-Density Animated QR Stream)** for 100% offline, serverless device-to-device synchronization of mantra counters and practice history between nearby mobile devices using screen-to-camera optical QR streams (10–15 FPS).

### Key Features Implemented:
1. **Fountain Code Engine (Luby Transform / LT)**:
   - `lib/models/optical_sync_frame.dart` [NEW]: `SystematicFrame` & `ParityFrame` models, `AIRQR|LT1` format serialization, and IEEE 802.3 CRC32 checksum verification.
   - `lib/services/optical_sync_service.dart` [NEW]: Fountain Code encoder and solver implementing belief propagation / Gaussian elimination over GF(2) for out-of-order frame reconstruction under camera frame drops.
2. **State Management & Navigation**:
   - `lib/providers/optical_sync_provider.dart` [NEW]: Riverpod `NotifierProvider` classes for Optical Sync Transmitter and Receiver states.
   - `lib/config/router.dart`: Registered routes `/backup/optical-sync/transmit` and `/backup/optical-sync/receive`.
3. **UI & User Experience**:
   - `lib/screens/optical_sync_screen.dart` [NEW]: Animated QR stream transmitter (with FPS selectors: 8, 12, 15 FPS, play/pause controls) and live camera scanner (`MobileScanner`) with real-time reconstruction progress bar.
   - `lib/widgets/optical_sync_import_preview_sheet.dart` [NEW]: Modal preview sheet showing counter and session counts before merging into local SQLite storage.
   - `lib/screens/settings_screen.dart`: Added "Data Backup & Optical Sync" section with entry points for Send, Receive, Export JSON, and Import JSON.
4. **Dependencies & Manifest**:
   - `pubspec.yaml`: Added `qr_flutter: ^4.1.0` and `mobile_scanner: ^7.1.2`.
   - `android/app/src/main/AndroidManifest.xml`: Added optional `CAMERA` permission and hardware feature declaration.
5. **Documentation & Unit Tests**:
   - `docs/features.md`: Updated Section 6 to document Optical Air-Gap Sync capabilities.
   - `test/services/optical_sync_service_test.dart` [NEW]: 100% passing test suite for CRC32 checksums, frame parsing, systematic/LT fountain encoding, 50% frame loss recovery, and payload round-trips.

## Verification
- `flutter analyze` — 0 issues found.
- `flutter test` — All 45 tests passed.
