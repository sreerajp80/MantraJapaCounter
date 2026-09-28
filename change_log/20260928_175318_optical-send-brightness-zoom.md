# Optical Sync: 75% send brightness and 1× start zoom

Implements plan: `plans/20260928_174927_optical-send-brightness-zoom.md`

## What changed

### Send brightness is now 75%

- `android/app/src/main/kotlin/com/sreerajp/mantrajapacounter/MainActivity.kt`
  - Added `sendModeBrightness = 0.75f`.
  - `setSendMode(true)` now sets the window to this value instead of
    `BRIGHTNESS_OVERRIDE_FULL` (100%).
  - The screen is still kept on while sending, and the user's own brightness
    setting still comes back when sending stops.
  - Comments updated from "full brightness" to "75% brightness".
- `lib/services/screen_service.dart`: doc comment updated to say 75%.

### Receiver camera starts at 1× zoom

- `lib/widgets/qr_camera_view.dart`
  - `_startZoom` changed from `2.0` to `1.0` (still kept inside the camera's
    own zoom range).
  - The start zoom is now always sent to the camera when it opens (the old
    `_zoom != _minZoom` check was removed), so it is truly at 1× every time.
  - Zoom slider (up to 4×), tap-to-focus and light are unchanged.

### Docs

- `docs/features.md`: sender goes to 75% brightness; receiver starts at 1× zoom.
- `docs/architecture.md`: `ScreenService` sets 75% brightness while sending.

## Checks

- `flutter analyze`: no issues.
- `flutter test`: all 189 tests passed.
- Not yet checked on a real device.
