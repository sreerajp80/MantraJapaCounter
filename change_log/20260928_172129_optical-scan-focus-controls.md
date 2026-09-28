# Optical Sync receive: camera focus, controls and easier QR codes

Implements plan: `plans/20260928_171302_optical-scan-focus-controls.md`

## Problem

The Optical Sync receiver could not focus on the sender's QR code at close
range. It stayed at "0 / 17 chunks". There was no tap-to-focus, zoom or light.

## What changed

### Receiver camera — `lib/widgets/qr_camera_view.dart`
- Turns on auto focus and auto exposure after the camera starts. If the
  camera does not support them, scanning still works.
- **Tap to focus:** tapping the preview sets the focus and exposure point
  there (the tap is mapped through the cropped preview). A white focus ring
  shows for a moment.
- **Zoom slider** from the camera's minimum zoom up to 4× (or the camera's
  own maximum if lower). Hidden when the camera cannot zoom.
- **Light button** turns the torch on/off. Hidden if the camera has no light.
  The light goes off when the app goes to the background.
- Every 3 seconds with no QR read, the last focus point is sent again to
  nudge auto focus.
- Short hint over the preview: "Tap the code to focus. Use zoom if it looks
  blurred."
- Camera resolution raised from 720p (`high`) to 1080p (`veryHigh`).

### Receiver screen — `lib/screens/optical_sync_screen.dart`
- The guide box over the camera is wrapped in `IgnorePointer`, so taps reach
  the camera for focusing.

### Sender — `lib/screens/optical_sync_screen.dart`,
`lib/services/optical_sync_service.dart`, `lib/providers/optical_sync_provider.dart`
- QR code is now plain black on white. The vermillion corner squares looked
  grey to the scanner.
- QR size uses the screen width, 200–320 px (was fixed 260 px).
- Chunk size lowered from 180 to 120 bytes, so each QR code has fewer, larger
  squares. Receivers read chunk count and length from each frame, so this
  still works with other app versions.
- Default speed lowered from 12 to 8 FPS.

### Decoder — `android/app/src/main/kotlin/com/sreerajp/mantrajapacounter/QrFrameDecoder.kt`
- Added the ZXing `TRY_HARDER` hint.

### Text — `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb`
- New keys, each with an `@` description: `opticalTorchOn`,
  `opticalTorchOff`, `opticalZoom`, `opticalScanTip`. Generated files
  updated with `flutter gen-l10n`.

### Tests — `test/services/optical_sync_service_test.dart`
- New test: chunk size is 120 and each frame's QR text stays short.
- New test: a multi-chunk payload with a short last chunk round-trips
  through QR text, with parity frames fed before systematic frames.

### Docs — `docs/features.md`
- Added "Scanner Controls" and updated the FPS range.

## Checks
- `flutter analyze`: no issues.
- `flutter test`: all 172 tests passed.
- Kotlin compiles (`:app:compileDevDebugKotlin`).
- Not yet tested on a real phone.
