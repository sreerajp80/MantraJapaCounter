# Optical Sync: clear old data after cancel, and faster receiving

**Status:** completed

This plan has two parts:

- **Part 1:** fix the bug where old received data stays after Cancel.
- **Part 2:** make receiving faster and easier.

---

# Part 1 — Old received data stays after cancel

## What the user sees

After a full receive (26 / 26 chunks, 100%), the user taps **Cancel** on the
import preview. The receiver screen stays at 100% and scanning stops. Leaving
the screen and opening it again still shows the old 100% data. A new scan is
not possible without restarting the app.

## What is wrong

1. `opticalSyncReceiveProvider` and `opticalSyncTransmitProvider` in
   `lib/providers/optical_sync_provider.dart` are plain `NotifierProvider`s.
   They are never disposed. The decoder and its solved chunks stay in memory
   for the whole app session, even after the screen closes.
2. **Cancel** on the preview sheet (and a failed import) only closes the
   sheet. Nothing resets the receive state, and `processScannedFrame()`
   ignores new frames once the state is complete. `_sheetShown` in the screen
   also stays `true`, so the sheet can never show again.
3. The sender has the same problem: reopening "Send" briefly shows the old
   session's frames.

## Fix

### 1A. Dispose state when the screen closes — `lib/providers/optical_sync_provider.dart`
- Change both providers to `NotifierProvider.autoDispose`. The state then
  lives only while the Optical Sync screen (or its sheet) uses it. Opening the
  screen again always starts fresh.
- Change `late final OpticalSyncDecoder _decoder` to a plain field set in
  `build()`, so a rebuild never throws "field already set".

### 1B. Cancel means "scan again" — `lib/screens/optical_sync_screen.dart`
- `await` the `showModalBottomSheet(...)` for the import preview. When it
  closes and the screen is still open (Cancel or a failed import), call
  `reset()` on the receive notifier and set `_sheetShown = false`. Progress
  goes back to 0 and scanning starts again.
- A successful import already closes the scanner screen. With auto-dispose,
  its state is then dropped.

---

# Part 2 — Faster and easier receiving

## What the user sees

Reconstruction takes a long time. The user has to zoom in by hand before any
chunk is read. The progress shows 0 for a long time, so it looks stuck.

## Why it is slow

1. Every 1920×1080 frame (about 2 MB) is copied to Android and searched in
   full, with the slow `TRY_HARDER` mode on every frame.
2. The camera starts at 1× zoom, so the QR is small in the frame.
3. The sender plays a fixed list of 120 frames in a loop (15 s at 8 FPS). A
   missed chunk must wait for a mix frame that covers it, or for the next
   loop.
4. A dim sender screen makes the camera use long exposures and blurs frames
   when the code changes. The sender screen may also dim or sleep.
5. The progress only counts fully solved chunks, so early frames show no
   change.

## Fix

### 2A. Scan only the guide box — `lib/widgets/qr_camera_view.dart`,
`lib/services/qr_decoder_service.dart`, `MainActivity.kt`, `QrFrameDecoder.kt`
- Move the orange guide box from the screen into `QrCameraView`, so the box
  that is drawn and the area that is decoded come from one number.
- From the view size and preview size (the same mapping used for
  tap-to-focus), work out the box's area in the camera frame, plus a 15%
  margin. The frame is landscape, so the mapping handles the 90° turn.
- Send only the rows that contain the box: a `Uint8List.sublistView` of the
  Y plane, so the message is much smaller than 2 MB. Also send the crop
  `left`, `top` (inside that band), `cropWidth` and `cropHeight`.
- Native side: `PlanarYUVLuminanceSource` gets the crop rectangle directly
  (ZXing supports this). Old arguments stay optional: with no crop, the
  whole frame is used.

### 2B. Start at 2× zoom — `lib/widgets/qr_camera_view.dart`
- After the camera starts, set zoom to 2× (limited to the camera's range).
  The slider still lets the user change it.

### 2C. Fast search first — `QrFrameDecoder.kt`
- Keep two hint sets: fast (no `TRY_HARDER`) and slow (`TRY_HARDER`).
- Each frame uses the fast search. Every 4th frame that still finds nothing
  also tries the slow search. A small counter in the decoder handles this.
  The decoder runs on one thread only, so the counter is safe.

### 2D. Sender screen bright and awake — new `lib/services/screen_service.dart`, `MainActivity.kt`
- New channel `com.sreerajp.mantrajapacounter/screen` with
  `setSendMode(bool on)`:
  - on: window brightness 100% and `FLAG_KEEP_SCREEN_ON`.
  - off: brightness back to the system value and the flag cleared.
- New `ScreenService` in `lib/services/` plus a provider in
  `app_providers.dart`.
- The send screen turns it on when streaming starts, and off in `dispose()`
  and when the app goes to the background. It turns on again when the app
  comes back. `MainActivity` also clears it in `onDestroy` as a safety net.

### 2E. Endless mix frames — `lib/services/optical_sync_service.dart`,
`lib/models/optical_sync_frame.dart`, `lib/providers/optical_sync_provider.dart`,
`lib/screens/optical_sync_screen.dart`
- Replace the fixed 120-frame list with frames made on demand:
  `OpticalSyncEncoder(payload, sessionId).frameAt(index)`.
  - Frames `0 … N-1`: the plain chunks, once, in order.
  - After that, in a repeating pattern of 3: one plain chunk (cycling through
    all chunks), then two mix frames.
  - Mix frames use a stable random number generator seeded from
    `CRC32(sessionId) ^ index`. Each index always gives the same frame, and
    every index gives a new mix. The mix size is 2 most of the time, and 3–4
    now and then.
- The frame text format (`AIRQR|LT1`, fields `v s i t l p d c`) does not
  change. Older receivers still read these frames, because each frame lists
  its own chunk numbers.
- `isSystematic` becomes "has exactly one chunk", because plain chunks now
  also appear at other frame numbers.
- Sender labels: "Frame {current} / {total}" becomes "Frame {current}" (new
  ARB key `opticalFrameCounter`; the old key is removed from all three ARB
  files). "Systematic Data Chunk #n" shows the chunk number, not the frame
  number.
- The frame index wraps at a large limit (1,000,000), so it can never
  overflow.

### 2F. Show frames received — `lib/services/optical_sync_service.dart`,
`lib/providers/optical_sync_provider.dart`, `lib/screens/optical_sync_screen.dart`
- The decoder counts unique frames received (a set of frame numbers). This
  count is added to `OpticalSyncReceiveProgress` as `framesReceived`.
- The progress banner shows a second line: "Frames received: {count}" (new
  ARB key `opticalFramesReceived`).

---

## Text — `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb`
- Add `opticalFrameCounter` and `opticalFramesReceived` (with `@`
  descriptions and placeholders).
- Remove `opticalFrameProgress` (no longer used).
- Run `flutter gen-l10n`.

## Tests
- `test/providers/optical_sync_provider_test.dart`: after a full receive,
  `reset()` brings the state back to 0 and new frames are accepted. The
  receive provider is dropped when no one listens.
- `test/services/optical_sync_service_test.dart`:
  - `frameAt(i)` returns the same frame each time.
  - Frames past `N` contain regular plain chunks.
  - A receiver that starts mid-stream (for example at frame 500) and misses
    half the frames still rebuilds the payload.
  - `framesReceived` counts unique frames.
- `test/services/qr_decoder_service_test.dart`: the crop arguments are sent.
- Update existing tests that use `generateFrames` / `maxFramesToGenerate`.

## Docs — `docs/features.md`, `docs/architecture.md`
- Describe the endless frame stream, guide-box scanning, 2× start zoom, and
  the bright, awake sender screen. Add `ScreenService` to the services list.

## Files to change
- `lib/providers/optical_sync_provider.dart`
- `lib/providers/app_providers.dart`
- `lib/screens/optical_sync_screen.dart`
- `lib/widgets/qr_camera_view.dart`
- `lib/services/optical_sync_service.dart`
- `lib/services/qr_decoder_service.dart`
- `lib/services/screen_service.dart` (new)
- `lib/models/optical_sync_frame.dart`
- `android/app/src/main/kotlin/com/sreerajp/mantrajapacounter/MainActivity.kt`
- `android/app/src/main/kotlin/com/sreerajp/mantrajapacounter/QrFrameDecoder.kt`
- `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` (+ generated files)
- `test/providers/optical_sync_provider_test.dart`
- `test/services/optical_sync_service_test.dart`
- `test/services/qr_decoder_service_test.dart`
- `docs/features.md`, `docs/architecture.md`

## Check after the change
- `flutter analyze` clean, `flutter test` passes, Kotlin compiles.
- On the phone:
  - Receive fully, tap Cancel → progress back to 0 and scanning works again.
  - Leave and reopen → starts at 0.
  - Reading starts without zooming by hand; "Frames received" goes up.
  - The sender screen stays bright and does not sleep, and goes back to
    normal when leaving the send screen.
