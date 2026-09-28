# Optical Sync receive: camera focus, controls and easier QR codes

**Status:** completed

## What the user sees

On the Optical Sync Receiver screen the QR code on the other phone stays
blurred. The progress shows `0 / 17 chunks` for a long time. There is no way
to focus the camera, zoom, or turn on a light.

## What is wrong

1. **No focus control.** `QrCameraView` never sets a focus mode or focus
   point. At close range (about 10–15 cm) many phones do not pick focus on
   their own, so every frame is blurred and ZXing cannot read it.
   (The pipeline itself works: one QR was read, which is where "17 chunks"
   came from.)
2. **No camera controls.** No tap-to-focus, no zoom, no torch (flash light).
   Without zoom the user must hold the phone very close, which is exactly
   where focus fails.
3. **QR code is hard to read.**
   - The three corner "eyes" are drawn in vermillion (`#C8401E`). In the
     brightness image this is mid-grey, not black. ZXing looks for these
     eyes first, so it often misses the code.
   - Each frame carries 180 bytes, which makes a dense QR (about 70×70
     squares) shown at only 260 px.
4. **Decoder not trying hard.** ZXing runs without the `TRY_HARDER` hint.
5. **Camera resolution.** `ResolutionPreset.high` (720p) gives few pixels per
   QR square. `veryHigh` (1080p) gives more.

## Plan

### A. Camera controls — `lib/widgets/qr_camera_view.dart`
- After `initialize()`: set `FocusMode.auto` and `ExposureMode.auto`
  (each wrapped in try/catch — some cameras do not support them).
- **Tap to focus:** tapping the preview calls `setFocusPoint` and
  `setExposurePoint` at the tapped spot (converted to 0–1 values), and shows
  a small focus ring for a moment.
- **Zoom slider:** read min/max zoom; show a slider (1× up to max, capped at
  4×) at the bottom of the preview. This lets the user hold the phone
  farther away, where focus works.
- **Torch button:** toggles `FlashMode.torch` / `FlashMode.off`. Hidden if the
  camera has no flash (error caught).
- Change `ResolutionPreset.high` → `ResolutionPreset.veryHigh`.
- Every 3 seconds with no QR read, re-send a centre focus point to kick the
  auto focus again (cheap; stops once the screen closes).

### B. Easier QR codes — `lib/screens/optical_sync_screen.dart`,
`lib/services/optical_sync_service.dart`
- Draw the QR eyes in black (`Colors.black`) and data squares in pure
  black; keep the white background and quiet zone.
- Make the QR bigger: use the available width (up to 320 px) instead of a
  fixed 260 px.
- Lower `chunkSize` from 180 to 120 bytes. The QR gets smaller (fewer,
  larger squares). The receiver already reads the chunk count and length
  from each frame, so this does not break older senders or receivers.
- Change default speed from 12 FPS to 8 FPS (options stay 8 / 12 / 15), so
  each code is on screen longer.

### C. Decoder — `android/app/src/main/kotlin/com/sreerajp/mantrajapacounter/QrFrameDecoder.kt`
- Add `DecodeHintType.TRY_HARDER to true`.

### D. Text — `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb`
New keys (with `@` descriptions), then `flutter gen-l10n`:
- `opticalTorchOn` / `opticalTorchOff` — torch button tooltips.
- `opticalZoom` — zoom slider label.
- `opticalScanTip` — short hint: "Tap the code to focus. Use zoom if it looks blurred."

### E. Tests
- `test/services/optical_sync_service_test.dart` (existing or new): frames with
  the new chunk size still decode back to the same JSON, including from
  parity frames only.

### F. Docs
- `docs/features.md`: mention tap-to-focus, zoom and torch on the receiver.

## Files to change
- `lib/widgets/qr_camera_view.dart`
- `lib/screens/optical_sync_screen.dart`
- `lib/services/optical_sync_service.dart`
- `lib/providers/optical_sync_provider.dart` (default FPS)
- `android/app/src/main/kotlin/com/sreerajp/mantrajapacounter/QrFrameDecoder.kt`
- `lib/l10n/app_en.arb`, `lib/l10n/app_ml.arb`, `lib/l10n/app_sa.arb` (+ generated files)
- `test/services/optical_sync_service_test.dart`
- `docs/features.md`

## Check after the change
- `flutter analyze` clean, `flutter test` passes.
- On the phone: receiver can focus by tapping, zoom works, torch toggles,
  and a full transfer completes.
