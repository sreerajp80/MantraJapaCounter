# Apply the saved screen brightness setting

Implements plan: `plans/20260928_173717_apply-screen-brightness.md`

## What was wrong

The brightness slider (Settings → Display, and the Appearance screen) saved its
value, but nothing ever applied it to the screen. The slider had no effect.

## What changed

- `android/app/src/main/kotlin/com/sreerajp/mantrajapacounter/MainActivity.kt`
  - New `setAppBrightness` method on the `.../screen` channel. It sets only this
    app's window brightness (no permission; system brightness untouched).
    Below 0 = follow system. Custom levels are clamped to 0.02–1.0 so 0% is very
    dim but never black.
  - While Optical Sync send mode is on, a new value is stored and applied when
    send mode ends.
  - `setSendMode(false)` now restores the user's brightness setting. The old
    `savedWindowBrightness` field was replaced by `appBrightness` and a
    `sendModeOn` flag.
- `lib/services/screen_service.dart`: new `setAppBrightness(double)` with the
  same safe error handling as `setSendMode`; updated doc comment.
- `lib/providers/settings_provider.dart`: `SettingsNotifier` takes an optional
  `ScreenService`. It applies the saved brightness when created (app start)
  and after each `setScreenBrightness` call (live preview while dragging).
  `settingsNotifierProvider` passes `screenServiceProvider`.
- `test/services/screen_service_test.dart` (new): channel method and values,
  and no crash on platform error or missing native side.
- `test/providers/settings_provider_test.dart` (new): saved value applied on
  creation; `setScreenBrightness` saves and applies.
- `docs/architecture.md`: described the new brightness behaviour.

No widget, ARB, or storage format changes.

## Checks

- `flutter analyze`: no issues.
- `flutter test`: all 189 tests pass.
- Kotlin compiles (`:app:compileDevDebugKotlin`).
- Not yet checked on a real device (slider live preview, restart, Optical Sync
  send and return).
