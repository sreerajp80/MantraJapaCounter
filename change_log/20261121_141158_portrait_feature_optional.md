# Make the portrait screen feature optional

Implements plan: `plans/20261121_141158_portrait_feature_optional.md`

## What changed

- `android/app/src/main/AndroidManifest.xml`: added
  `<uses-feature android:name="android.hardware.screen.portrait" android:required="false" />`
  with a short comment, next to the existing camera `uses-feature`.

## Why

`android:screenOrientation="portrait"` on the main activity made Android imply a required
`android.hardware.screen.portrait` feature. Google Play flagged this for release
`MantraJapaCounter-v6.13.20_51` because it hides the app from devices without a portrait screen
(some tablets, desktops, Android XR).

## What did not change

- `android:screenOrientation="portrait"` stays on the activity.
- The programmatic portrait lock in `main.dart` stays.

## Security impact

None. No permission, network or data change.

## Still to do

- Build a new release and confirm the Play Console warning is gone.
- Separate: with targetSdk 36, large screens ignore the orientation lock; check the
  landscape layout on a tablet.
