# Apply the saved screen brightness setting

**Status:** completed

## The issue

Settings → Display (and the Appearance screen) has a "Brightness level" slider
with "Still", "Use system" and "Full". Moving the slider saves the value
(`screen_brightness` in SharedPreferences, `-1` = follow system), but no code
ever sends that value to the screen. So the slider does nothing, and the
"Stillness" dim mode described in `README.md` and `docs/features.md` does not
work.

The only code that changes brightness today is Optical Sync send mode
(`ScreenService.setSendMode`), which goes to full brightness and then puts back
the earlier window brightness.

## How the fix works

Android lets an app set its **own window** brightness
(`WindowManager.LayoutParams.screenBrightness`). This needs no permission and
only affects this app while it is on screen; the phone's system brightness is
not touched. `-1` (`BRIGHTNESS_OVERRIDE_NONE`) means "follow the system".

1. **Native side** (`MainActivity.kt`, existing `.../screen` channel):
   - Add a method `setAppBrightness(value)`.
   - Keep the chosen value in a field `appBrightness` (default `-1`).
   - A value below 0 means "follow system". Values from 0 to 1 are clamped to a
     small minimum (0.02) so "Still" at 0% is very dim but the screen is never
     fully black and unreadable.
   - If send mode is off, apply it to the window right away. If send mode is
     on, only store it (send mode stays at full brightness).
   - Change `setSendMode(false)` to restore `appBrightness` instead of the old
     saved window value, so leaving Optical Sync returns to the user's chosen
     brightness. Replace `savedWindowBrightness` with a simple `sendModeOn`
     flag.

2. **Dart service** (`lib/services/screen_service.dart`):
   - Add `Future<void> setAppBrightness(double value)`, with the same
     error handling as `setSendMode` (ignore missing plugin; log only the error
     code, never user data). Update the class doc comment.

3. **Provider** (`lib/providers/settings_provider.dart`):
   - `SettingsNotifier` takes an optional `ScreenService`.
   - On creation it applies the saved brightness once (so the setting works
     from app start).
   - `setScreenBrightness` applies the new value right after saving it, so the
     slider gives a live preview while dragging and "Use system" resets it.
   - `settingsNotifierProvider` passes `ref.read(screenServiceProvider)`.

   Widgets stay unchanged; they already call `notifier.setScreenBrightness`.

4. **Tests**
   - New `test/services/screen_service_test.dart`: `setAppBrightness` sends
     the right method and value on the channel; no crash when the native side
     is missing.
   - New `test/providers/settings_provider_test.dart`: the saved value is
     applied on creation, and `setScreenBrightness` saves and applies the new
     value (using a fake `ScreenService`).

5. **Docs**: short note in `docs/architecture.md` (ScreenService section) that
   it now also applies the user's brightness setting.

## Files to change

- `android/app/src/main/kotlin/com/sreerajp/mantrajapacounter/MainActivity.kt`
- `lib/services/screen_service.dart`
- `lib/providers/settings_provider.dart`
- `test/services/screen_service_test.dart` (new)
- `test/providers/settings_provider_test.dart` (new)
- `docs/architecture.md`
- `change_log/<timestamp>_apply-screen-brightness.md` (new, after the change)

## Out of scope

- No change to the slider UI, ARB strings, or the stored format of the
  setting.
- The separate "dimmed chanting mode" switch is not changed.

## Checks

- `flutter analyze` clean, `flutter test` passes.
- Manual check on a device: move the slider → screen dims/brightens live;
  "Use system" → back to system level; restart app → saved level applied;
  Optical Sync send → full brightness, then back to the saved level.
