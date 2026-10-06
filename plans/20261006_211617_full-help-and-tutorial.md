# Full Help Section and App Tutorial Update

**Status:** completed

## Goal

Update the in-app Help section so it explains everything the app does. The App
Tutorial must walk the user through every feature, in order, from first launch to
backup and privacy.

## What is wrong today

I checked the help text against the real code. Problems found:

1. **Tutorial is short and partly wrong** (`lib/screens/help/tutorial_help_screen.dart`):
   - Only 7 steps. Many features are missing: history, Sadhana Flow calendar,
     counter statistics, Meru pause, pacing hint, unfinished mala / "Finish & start
     new", reset session vs reset counter, disable/complete, delete, language,
     appearance, Do Not Disturb, dimmed mode, permissions, clear all data.
   - Says "Swipe downwards to undo". The real undo is a **two-finger sideways
     swipe** on the mala circle.
   - Says "+1 / +108" buttons. These do not exist; the counter has an
     **increment step** field.
   - Says "Long-press any counter card to lock it". Real behaviour: tap the **lock
     icon on the card** (or use the long-press menu). A locked counter cannot be
     opened for counting.
   - Says "stillness slider" is on the counting screen. It is in Settings.
   - The 7 "tip" lines are **hard-coded English strings**. This breaks the
     localization rule (no raw strings in widgets). Malayalam and Sanskrit users
     see English.
2. **Counting guide has wrong facts** (`counting_help_screen.dart` + ARB):
   - "Tap anywhere on the central screen" — wrong. Only taps **inside the mala
     circle** count; taps outside are ignored.
   - "A gentle vibration confirms every chant" — wrong. There is no per-tap
     vibration. Vibration happens on undo, on each mala of 108, and on goals.
   - "Every 5 taps are saved" — partly true; the real rule is every 5 taps or 5
     seconds (quick save), plus a database save every 20 taps or 30 seconds.
3. **Mala guide**: "Set how many malas you commit to every day" — the daily goal
   is in **chants**, not malas. "The card turns green" — really a green tick badge
   appears and the bead strip fills.
4. **Sound guide**: misses the real sound choices (Temple Bronze Bell, Tibetan
   Singing Bowl, Synthesized Tone, Sacred Shankha, system tones, own audio file),
   the lifetime-goal tone and notification, the preview button, and that the mala
   sound is skipped when the same tap also completes the daily goal.
5. **Backup guide**: misses encrypted backup (passphrase, AES-256-GCM, cannot be
   recovered if lost), the second entry point (Home menu → Import / Export), that
   import **replaces all data**, and Clear all data.
6. **Optical sync guide**: misses choosing which counters to send, the brightness
   slider on the send screen, the receiver's zoom, tap-to-focus and torch, the
   import preview, and that a selective import **merges** counters.
7. **Privacy guide** says the database is "encrypted". It is not encrypted; it is
   private app storage. Must be corrected.
8. **No help topics** for: the home screen and counter management, history and
   statistics, display and stillness, language and appearance, permissions.
9. **FAQ** has only 4 questions.
10. `docs/features.md` §11 (Help) is out of date.

## Plan for the fix

### A. Rewrite the App Tutorial (`tutorial_help_screen.dart`)

Make it a complete, ordered walkthrough split into chapters. Each step has a
title, a description and a tip. **All text comes from the ARB files** (no
hard-coded strings). Steps are grouped under chapter headers:

1. **Getting started**
   - 01 Welcome — what the app is, works fully offline.
   - 02 Choose your language — Settings → Language (English, Malayalam, Sanskrit, or system default).
2. **Your counters (home screen)**
   - 03 Create a counter — the + button; name, initial count, increment step,
     lifetime goal, daily goal, start date; the two validation rules.
   - 04 Reading a counter card — total, malas, today's chants, 27-segment bead
     strip, lifetime bar, green tick (daily goal), gold trophy (lifetime goal).
   - 05 Today summary — the pill at the top: chants, malas, active counters today.
   - 06 Counter options — long-press a card: Counter info, History, Edit, Lock,
     Disable as completed, Disable (not completed), Delete.
   - 07 Lock a counter — lock icon on the card; locked counters cannot be opened.
3. **Counting**
   - 08 Start counting — tap a card to open the counting screen.
   - 09 Tap to count — tap inside the mala circle; taps outside are ignored.
   - 10 Undo — two-finger sideways swipe; vibrates once to confirm.
   - 11 Screen guide — timer pill, beads remaining, malas this session, footer
     (Session / Daily / Lifetime), diya colour on goals.
   - 12 Leaving and coming back — back saves silently; timer pauses in the
     background; unfinished mala waits, even on another day; "Start new" and
     "Finish & start new".
   - 13 Counting menu — History, About, Settings, Finish & start new, Reset session,
     Reset counter (and the difference).
4. **Malas and goals**
   - 14 108 beads — 1 mala = 108 counts; how the circle fills.
   - 15 Daily and lifetime goals — what happens when each is reached.
   - 16 Meru pause — optional pause after each mala (3/5/10 s).
   - 17 Gentle pacing hint — glow when tapping faster than ~3 per second.
5. **History and statistics**
   - 18 History — grouped by day; filter by counter; delete a session; clear history.
   - 19 Sadhana Flow — 16-week calendar; no streaks, no "missed day" marks.
   - 20 Counter statistics — gauges and details table, average daily chants.
6. **Sound, vibration and stillness**
   - 21 Sounds — mala sound, daily goal tone, lifetime goal tone, choices, preview.
   - 22 Vibration and notifications.
   - 23 Display and stillness — brightness (still / full / system), dimmed
     chanting mode, Do Not Disturb.
   - 24 Appearance — temple palette and fonts.
7. **Your data**
   - 25 Backup to a file — export (plain or encrypted), share sheet.
   - 26 Restore from a file — import replaces all data; passphrase for encrypted files.
   - 27 Phone-to-phone optical sync — send and receive with animated QR codes.
   - 28 Clear all data.
8. **Privacy**
   - 29 Fully offline and private — no internet permission, no tracking.
   - 30 Permissions — what each one is for (camera, notifications, vibration,
     audio, Do Not Disturb).

Each chapter header and step is a simple data list in the screen; the visual
style (cards, step number, icon, tip box) stays the same as today.

### B. Fix and extend the existing help topic screens

Update ARB text (and add bullets/sections where needed) in:

- `counting_help_screen.dart` — fix tap area, vibration, save rule; add a
  "Counting menu" section (Finish & start new, Reset session, Reset counter) and
  a "Leaving the screen" bullet (silent auto-save, timer pause).
- `mala_math_help_screen.dart` — fix daily goal wording; add the bead strip,
  badges, lifetime card colour, increment step note.
- `sound_haptics_help_screen.dart` — real sound list, lifetime tone and
  notification, preview, mala-sound skip rule, alarm-stream volume note,
  vibration events.
- `backup_help_screen.dart` — encrypted backup, both entry points, import
  replaces all, clear all data.
- `optical_sync_help_screen.dart` — counter selection, brightness slider,
  zoom/focus/torch, import preview, merge on selective import.
- `privacy_offline_help_screen.dart` — remove the "encrypted database" claim;
  add a permissions section.
- `faq_help_screen.dart` — grow from 4 to about 12 questions (for example: why my
  tap did not count, how to undo, why a counter will not open (locked), what
  happens if I leave mid-mala, why the mala sound did not play, why sound plays
  in silent mode, lost passphrase, import replaced my data, scanning is slow,
  reset session vs reset counter, daily goal reset time / which day taps count on).

### C. Add new help topic screens

New files in `lib/screens/help/`, built with the existing `help_widgets.dart`
widgets (`HelpDetailTopBar`, `HelpIntroCard`, `HelpSection`, `HelpBullet`):

- `counters_help_screen.dart` — home screen and counter management.
- `history_help_screen.dart` — history, Sadhana Flow, counter statistics.
- `display_help_screen.dart` — brightness, dimmed mode, Do Not Disturb, Meru
  pause and pacing hint settings, language and appearance.

Add routes `/help/counters`, `/help/history`, `/help/display` in
`lib/core/routing/router.dart`, and add their cards to
`help_home_screen.dart` (new "Your counters" category and new entries under the
existing categories). Update the header subtitle to mention all topics.

### D. Localization

- Add all new keys, with `@key` descriptions, to `app_en.arb`, `app_ml.arb`
  and `app_sa.arb` (full Malayalam and Sanskrit translations, simple wording).
- Remove the old `tutorialStep1..7` keys that are replaced.
- Run `flutter gen-l10n`. The parity test must stay green.

### E. Docs

- Update `docs/features.md` §11 to describe the new Help structure.

### F. Checks

- `dart format .`, `flutter analyze` (0 issues), `flutter test`.
- Add a small widget test `test/screens/help/help_screens_test.dart` that pumps
  the tutorial and each help screen in all 3 locales and checks they build
  without errors.

## Files to change

- `lib/screens/help/tutorial_help_screen.dart` (rewrite)
- `lib/screens/help/help_home_screen.dart`
- `lib/screens/help/counting_help_screen.dart`
- `lib/screens/help/mala_math_help_screen.dart`
- `lib/screens/help/sound_haptics_help_screen.dart`
- `lib/screens/help/backup_help_screen.dart`
- `lib/screens/help/optical_sync_help_screen.dart`
- `lib/screens/help/privacy_offline_help_screen.dart`
- `lib/screens/help/faq_help_screen.dart`
- `lib/screens/help/counters_help_screen.dart` (new)
- `lib/screens/help/history_help_screen.dart` (new)
- `lib/screens/help/display_help_screen.dart` (new)
- `lib/core/routing/router.dart`
- `lib/l10n/app_en.arb`, `lib/l10n/app_ml.arb`, `lib/l10n/app_sa.arb`
- `lib/l10n/app_localizations*.dart` (generated)
- `docs/features.md`
- `test/screens/help/help_screens_test.dart` (new)

## Out of scope

- No change to app behaviour, only help text and help screens.
- Unused legacy help keys (`helpCountingTitle`, `helpUndoBody`, etc.) are left
  as they are; they can be cleaned up in a separate change.
