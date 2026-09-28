# Optical Sync: 75% send brightness and 1× start zoom

**Status:** completed

## The issue

1. When Optical Sync is sending, the sender window goes to full (100%)
   brightness. Full brightness is not needed for the camera to read the QR
   code, and it is harsh on the eyes and uses more battery.
2. When the receiver camera opens, it starts at 2× zoom. The user wants it to
   start at 1× (no zoom). The zoom slider still lets the user zoom in by hand.

## Files to change

- `android/app/src/main/kotlin/com/sreerajp/mantrajapacounter/MainActivity.kt`
- `lib/widgets/qr_camera_view.dart`
- `lib/services/screen_service.dart` (doc comment only)
- `docs/features.md`
- `docs/architecture.md`
- `change_log/<new file>` (after the change)

## The fix

### 1. Send brightness 75%

- In `MainActivity.kt`, add a constant `sendModeBrightness = 0.75f`.
- In `setSendMode(true)`, use this value instead of
  `BRIGHTNESS_OVERRIDE_FULL`.
- Screen-kept-on behaviour and restoring the user's own brightness when
  sending stops stay the same.
- Update the comments that say "full brightness" in `MainActivity.kt` and
  `screen_service.dart`.

### 2. Receiver starts at 1× zoom

- In `qr_camera_view.dart`, change `_startZoom` from `2.0` to `1.0` and update
  its comment.
- The start value is still kept inside the camera's own zoom range.
- Always send the start zoom to the camera (drop the `_zoom != _minZoom`
  check), so the camera is truly at 1× when opened, even if it was left
  zoomed from an earlier use.
- Slider range (up to 4×), tap-to-focus and torch are unchanged.

### 3. Docs

- `docs/features.md`: "goes to full brightness" → "goes to 75% brightness";
  "starts at 2× zoom" → "starts at 1× zoom".
- `docs/architecture.md`: same brightness wording change.

## Checks

- `flutter analyze` (must be clean) and `flutter test`.
- Manual check on device: send screen is bright but not full; receiver opens
  at 1× and the slider shows 1×.
