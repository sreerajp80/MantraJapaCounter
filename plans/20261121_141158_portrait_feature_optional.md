# Make the portrait screen feature optional

**Status:** completed

## Issue

Google Play blocked review of release `MantraJapaCounter-v6.13.20_51` with the warning
"Required hardware feature declarations are restricting your app's availability":
`android.hardware.screen.portrait` affects Phone, Tablet, Desktop and Android XR users.

The main activity sets `android:screenOrientation="portrait"`. Android treats this as an
implied `<uses-feature android:name="android.hardware.screen.portrait" android:required="true" />`.
Play then hides the app from devices that do not report a portrait screen.

## Files to change

- `android/app/src/main/AndroidManifest.xml`

## Fix

Add one line next to the existing camera `uses-feature`:

```xml
<!-- Portrait lock stays; this only stops Play from hiding the app on devices
     that do not report a portrait screen (some tablets, desktops, XR). -->
<uses-feature android:name="android.hardware.screen.portrait" android:required="false" />
```

`android:screenOrientation="portrait"` and the lock in `main.dart` stay as they are. The app
still runs in portrait wherever the system allows it.

## Note (not part of this change)

With targetSdk 36, Android 16 ignores orientation locks on large screens (600dp wide or more).
The app may rotate on tablets and open foldables whatever the manifest says. Checking the
landscape layout there is a separate task.

## Security impact

None. No new permission, no network, no data change. Only a feature declaration is made optional.

## Checks

- `flutter analyze` and `flutter test` (no Dart change, so only as a sanity check).
- After the next release build, the Play Console warning should be gone.
