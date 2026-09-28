# Plan: Keep portrait lock on large screens (Android 16)

**Status:** Implemented (see change_log/20260922_210500_portrait-lock-large-screens.md)

## Issue

The app now targets API 36 (Android 16). On screens 600 dp wide or more, Android 16
ignores app orientation locks. This covers tablets, Chromebooks, and foldables when
they are unfolded. The portrait lock in `lib/main.dart`
(`SystemChrome.setPreferredOrientations`) is then ignored, so the app can rotate to
landscape. The app is designed for portrait-only, one-handed counting.

## Decision

1. **Tablets and Chromebooks:** exclude them in Play Console (Device catalog →
   exclude by form factor). The owner does this in Play Console. No code change.
2. **Foldables:** Play counts them as phones, so they can still install the app. Use
   the Android 16 opt-out property so the portrait lock keeps working on their large
   inner screen.

## Files to change

1. `android/app/src/main/AndroidManifest.xml`
   - Inside `<application>`, add:
     ```xml
     <!-- Android 16 (API 36) ignores orientation locks on screens >= 600dp.
          This opt-out keeps the portrait lock on unfolded foldables.
          It is ignored from API 37, so it must be revisited then. -->
     <property
         android:name="android.window.PROPERTY_COMPAT_ALLOW_RESTRICTED_RESIZABILITY"
         android:value="true" />
     ```
   - On `MainActivity`, add `android:screenOrientation="portrait"`. This locks the
     launch screen too, before Flutter starts and runs `setPreferredOrientations`.
     The Dart lock in `main.dart` stays as it is.
2. `docs/architecture.md` — in the orientation decision row, note the manifest
   lock, the Android 16 opt-out, the tablet exclusion in Play Console, and that the
   opt-out stops working when the app targets API 37.
3. `docs/release_process.md` — add a release checklist item: "Tablets and
   Chromebooks are excluded in Play Console Device catalog", and "Before targeting
   API 37, handle landscape on large screens (the opt-out is removed)".

## Limits

- Existing tablet users keep the installed app but will not get updates.
- A sideloaded APK can still be installed on a tablet. The opt-out keeps it in
  portrait there as well.
- From API 37 (Play requirement probably around mid-2027), the opt-out is ignored.
  The layout will then need to handle landscape on large screens.

## Verification

- `flutter analyze` and `flutter test` pass.
- `flutter build apk --flavor dev` builds with no manifest errors.
- On an unfolded foldable, or an Android 16 tablet emulator, the app stays in
  portrait. On a phone, behaviour is unchanged.
