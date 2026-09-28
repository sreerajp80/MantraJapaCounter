# Change log: Keep portrait lock on large screens (Android 16)

**Plan:** [plans/20260922_205000_portrait-lock-large-screens.md](../plans/20260922_205000_portrait-lock-large-screens.md)

## Why

With `targetSdk = 36`, Android 16 ignores orientation locks on screens 600 dp wide or
more (tablets, Chromebooks, unfolded foldables). The app is portrait-only.

## What changed

| File | Change |
|------|--------|
| `android/app/src/main/AndroidManifest.xml` | Added `<property android:name="android.window.PROPERTY_COMPAT_ALLOW_RESTRICTED_RESIZABILITY" android:value="true" />` inside `<application>`, with a comment. Added `android:screenOrientation="portrait"` to `MainActivity`. |
| `docs/architecture.md` | Orientation decision row now describes the manifest lock, the Android 16 opt-out, the Play Console tablet exclusion, and the API 37 limit. |
| `docs/release_process.md` | Two checklist items: tablets/Chromebooks excluded in Play Console; handle landscape before targeting API 37. |

The Dart lock in `lib/main.dart` (`SystemChrome.setPreferredOrientations`) is unchanged.

## Verification

- `flutter analyze` — no issues.
- `flutter test` — all 160 tests pass.
- `flutter build apk --flavor dev --debug` — builds. The merged manifest contains
  the opt-out property and `screenOrientation="portrait"`.

## Still to do (manual)

- Play Console → Release → Device catalog: exclude the Tablet and Chromebook form
  factors.
- Check on an unfolded foldable or an Android 16 tablet emulator that the app stays
  in portrait.
