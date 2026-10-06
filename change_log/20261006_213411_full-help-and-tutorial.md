# Change Log — Full Help Section and App Tutorial

**Plan:** [plans/20261006_211617_full-help-and-tutorial.md](../plans/20261006_211617_full-help-and-tutorial.md)

## Summary

The Help section now explains every part of the app. The App Tutorial is a
complete walkthrough in 30 steps. Wrong facts in the old help text were fixed.
All help text is in English, Malayalam and Sanskrit. No app behaviour changed.

## What changed

### App Tutorial
- `lib/screens/help/tutorial_help_screen.dart` — rewritten. 30 steps in 8
  chapters (Getting started, Your counters, Counting, Malas and goals, History
  and statistics, Sound/vibration/display, Your data, Privacy). Chapter headings
  are shown between the step cards.
- The 7 hard-coded English tips were removed. Every title, description and tip
  now comes from the ARB files.
- Fixed wrong facts: undo is a two-finger sideways swipe (not "swipe down"); there
  are no "+1 / +108" buttons; locking is done with the lock icon on the card and
  stops the counter from opening.

### Help topic screens
- Rewritten with corrected and extended content:
  `counting_help_screen.dart`, `mala_math_help_screen.dart`,
  `sound_haptics_help_screen.dart`, `optical_sync_help_screen.dart`,
  `backup_help_screen.dart`, `privacy_offline_help_screen.dart`,
  `faq_help_screen.dart` (now 14 questions).
- Fixes include: only taps inside the circle count; taps do not vibrate; the
  daily goal is in chants, not malas; the database is private storage, not
  "encrypted"; file import replaces all data, while Optical Sync adds or
  updates only the chosen counters.
- New content includes: the counting menu, reading the screen, auto save and
  timer pause, the mala-sound skip rule, the alarm sound channel, the lifetime
  goal tone and notification, encrypted backups and lost passphrases, Optical
  Sync controls (counter choice, speed, brightness, zoom, focus, torch), clear
  all data, and the permissions list.
- New screens:
  - `lib/screens/help/counters_help_screen.dart` — creating counters, the home
    screen, the long-press options, locked and disabled counters.
  - `lib/screens/help/history_help_screen.dart` — history list, deleting
    history, Sadhana Flow calendar, counter statistics.
  - `lib/screens/help/display_help_screen.dart` — brightness, dimmed mode, Do
    Not Disturb, Meru pause, pacing hint, language, appearance.

### Help hub and routes
- `lib/screens/help/help_home_screen.dart` — new "Your Counters & History"
  category; the audio category is now "Sound, Display & Stillness"; cards for the
  3 new screens.
- `lib/core/routing/router.dart` — routes `/help/counters`, `/help/history`,
  `/help/display`.

### Localization
- `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` — old help body and
  tutorial keys replaced with the new keys; new topic and category keys added.
  Every new English key has an `@key` description. Generated files in
  `lib/l10n/app_localizations*.dart` were rebuilt with `flutter gen-l10n`.
- Old unused legacy keys (`helpCountingTitle`, `helpUndoBody`, etc.) were left
  as they are, as the plan said.

### Docs
- `docs/features.md` — section 11 now describes the new Help structure.

### Tests
- `test/screens/tutorial_help_screen_test.dart` — checks chapters and steps up
  to step 30.
- `test/screens/help_screen_test.dart` — updated for the new titles and cards.
- `test/screens/help/help_screens_test.dart` (new) — every help screen builds in
  English, Malayalam and Sanskrit without errors; the new screens show their
  sections.

## Checks

- `dart format` — clean.
- `flutter analyze` — no issues.
- `flutter test` — all 280 tests passed (including the ARB parity test).
