# Optical Sync: clear old data after cancel, and faster receiving

Implements plan: `plans/20260928_172825_optical-receive-stale-state.md`

## Part 1 — Old received data stays after cancel

- `lib/providers/optical_sync_provider.dart`: both Optical Sync providers
  are now `NotifierProvider.autoDispose`. Leaving the screen drops the
  received chunks (and the sender's session). The receive decoder is a plain
  field made in `build()` (was `late final`).
- `lib/screens/optical_sync_screen.dart`: the import preview sheet is
  awaited. If it closes without a successful import (Cancel or failure), the
  receive state is reset and the sheet can show again. Progress goes back to
  0 and scanning restarts.
- `lib/widgets/optical_sync_import_preview_sheet.dart`: the sheet now
  returns `true` on a successful import and `false` on Cancel or failure.
  (This file was not in the plan's list; it is needed so the screen knows
  how the sheet closed.)

## Part 2 — Faster and easier receiving

- **Scan only the guide box**
  - `lib/widgets/qr_camera_view.dart`:
    - The guide box now lives in the camera view (removed from the screen).
      It is 250 px, or smaller on tiny views.
    - For each frame, the centred square under the box (plus 15%) is worked
      out in frame pixels. Only those rows are sent (`Uint8List.sublistView`),
      with a crop rectangle.
  - `lib/services/qr_decoder_service.dart`: optional `crop` argument
    (`QrCropRect`).
  - `MainActivity.kt`: reads the optional crop arguments.
  - `QrFrameDecoder.kt`: decodes only the crop rectangle.
- **Start at 2× zoom** (limited to the camera's range) in `qr_camera_view.dart`.
- **Fast search first** in `QrFrameDecoder.kt`: every frame uses the fast
  search. Every 4th miss also runs the slow `TRY_HARDER` search, then the
  inverted image.
- **Bright, awake sender**
  - New `lib/services/screen_service.dart` (`ScreenService`), with
    `screenServiceProvider` in `lib/providers/app_providers.dart`.
  - `MainActivity.kt` adds channel `com.sreerajp.mantrajapacounter/screen`,
    method `setSendMode(on)`:
    - on: saves the window brightness, sets full brightness, adds
      `FLAG_KEEP_SCREEN_ON`.
    - off: puts back the saved brightness and clears the flag.
    - `onDestroy` turns it off as a safety net.
  - The send screen turns it on when streaming starts, off in `dispose()`
    and when the app is paused, and on again when the app resumes.
- **Endless mix frames**
  - `lib/services/optical_sync_service.dart`: new `OpticalSyncEncoder` with
    `frameAt(index)`:
    - Frames `0…N-1` are the plain chunks.
    - After that, a repeating pattern of 1 plain chunk + 2 mix frames.
    - Mix frames XOR 2 chunks (60%), 3 (30%) or 4 (10%), seeded from
      `CRC32(sessionId) ^ index`.
    - Frame numbers wrap at 1,000,000.
    - `generateFrames` stays as a wrapper that returns the first frames of
      this stream.
  - The `AIRQR|LT1` text format is unchanged.
  - `lib/models/optical_sync_frame.dart`: `isSystematic` now means "exactly
    one chunk".
  - Transmit state holds the encoder instead of a fixed frame list.
  - The sender label shows "Frame {n}" and the plain-chunk label shows the
    chunk number.
- **Frames received**
  - The decoder counts unique frame numbers. Repeated frames are skipped
    early.
  - `OpticalSyncReceiveProgress.framesReceived` was added and is shown under
    the progress line.

## Text
- `app_en.arb`, `app_ml.arb`, `app_sa.arb`: added `opticalFrameCounter` and
  `opticalFramesReceived`; removed `opticalFrameProgress`. Ran
  `flutter gen-l10n`.

## Tests
- New `test/providers/optical_sync_provider_test.dart`:
  - reset after a full receive starts a new scan;
  - state is dropped when no one listens.
- `test/services/optical_sync_service_test.dart`:
  - stable `frameAt`;
  - plain chunks repeat and mixes vary;
  - frame numbers wrap;
  - a mid-stream receiver missing half the frames rebuilds the payload;
  - `framesReceived` counts each frame once.
- `test/services/qr_decoder_service_test.dart`: crop keys are sent only when
  given.

## Docs
- `docs/features.md`: endless stream, bright sender, 2× zoom, guide-box
  scanning, fast search, frames received, cancel resets.
- `docs/architecture.md`: services list and Optical Sync notes.

## Checks
- `flutter analyze`: no issues.
- `flutter test`: all 181 tests passed.
- Kotlin compiles (`:app:compileDevDebugKotlin`).
- Not yet tested on a real phone.

## Noticed, not changed
- The saved "screen brightness" setting (Appearance / Display settings) is
  stored but no code applies it to the screen.
