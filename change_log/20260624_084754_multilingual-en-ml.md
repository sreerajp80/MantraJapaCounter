# Change Log: Multilingual support (English + Malayalam)

Date: 2026-06-24 08:47:54
Implements: plans/20260624_080537_multilingual-en-ml.md

## Summary

Added full internationalization to the Flutter app with English and Malayalam.
The app follows the **device locale**: Malayalam devices render Malayalam, every
other locale falls back to English. There is no in-app language picker (per the
agreed decision). All ~108 UI strings plus the daily-goal notification and the
backup share subject are now localized.

## Approach

Flutter's official i18n flow: `flutter_localizations` + `intl` + `gen-l10n`
with ARB files. Generated `AppLocalizations` accessed via
`AppLocalizations.of(context)` (configured non-nullable).

## Files added

- `mantra_japa_counter/l10n.yaml` — gen-l10n config (arb-dir `lib/l10n`,
  template `app_en.arb`, output class `AppLocalizations`, `nullable-getter: false`).
- `mantra_japa_counter/lib/l10n/app_en.arb` — English template, all keys.
- `mantra_japa_counter/lib/l10n/app_ml.arb` — Malayalam translations (drafted by
  Claude; **pending native review by the user**).
- `mantra_japa_counter/lib/config/locale_config.dart` — locale policy:
  `resolve()` maps any device locale to `en`/`ml`; `localeResolution()` for
  `MaterialApp.localeResolutionCallback`; `strings()` for context-free lookup
  (used outside the widget tree).
- Generated (by `flutter gen-l10n`, committed): `lib/l10n/app_localizations.dart`,
  `app_localizations_en.dart`, `app_localizations_ml.dart`.

## Files modified

- `pubspec.yaml` — added `flutter_localizations` (sdk) + `intl: any`; set
  `generate: true`.
- `lib/main.dart` — wired `localizationsDelegates`, `supportedLocales`, and
  `localeResolutionCallback: LocaleConfig.localeResolution` into
  `MaterialApp.router`. App brand `title` left untranslated.
- `lib/config/theme.dart` — added `NotoSansMalayalam` as `fontFamilyFallback` on
  the base `sans()`, `serif()`, `eyebrow()` styles and the generated `textTheme`,
  so Malayalam UI text renders instead of showing boxes (Inter/EB Garamond have
  no Malayalam glyphs).
- `lib/services/notification_service.dart` — daily-goal title/body now use
  `LocaleConfig.strings()` (context-free, follows device locale).
- `lib/services/export_service.dart` — share-sheet `subject` localized via
  `LocaleConfig.strings().backupShareSubject`. **Export JSON field names/format
  left untouched** (Android Gson import compatibility preserved).
- Screens: `counter_list_screen.dart`, `counting_screen.dart`,
  `history_screen.dart`, `settings_screen.dart`, `help_screen.dart`,
  `about_counter_screen.dart`, `about_screen.dart` — all hardcoded strings
  replaced with `AppLocalizations` lookups (ICU placeholders/plurals for
  dynamic counts, session/day/chant pluralization).
- Widget: `counter_card.dart` — all card copy localized; helper methods take an
  `AppLocalizations` argument.

## Not changed (intentional)

- `lib/widgets/session_list_tile.dart`, `goal_progress_bar.dart`,
  `mala_count_display.dart` — dead code (each referenced only in its own file);
  left untouched.
- User-entered data (counter/mantra names) is never translated.
- Date/time/duration formatting (e.g. `Jan 05, 2026`, `1h 2m`) left as-is.
- Internal `dayLabel` ('Day N') is not user-visible (only the number is shown via
  regex), so it was left in English.
- Export JSON keys and values (Android import compatibility).

## Verification

- `flutter pub get` + `flutter gen-l10n` succeed.
- `flutter analyze` → "No issues found!".
- No test suite exists in the project, so no tests were affected.

## Follow-ups for the user

- **Review the Malayalam in `app_ml.arb`** — these are AI drafts and need a
  native check, especially the longer help/about/guidance paragraphs and the
  "Made with ❤ from India" prefix/suffix split.
- Optionally verify rendering by setting the device language to Malayalam (or
  temporarily forcing `locale: const Locale('ml')` in `MaterialApp.router`).
