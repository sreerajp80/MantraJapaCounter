# Plan: Multilingual support (English + Malayalam)

Date: 2026-06-24 08:05:37
Slug: multilingual-en-ml

## Decisions (confirmed with user)

- **Language selection:** Follow device locale only. No in-app picker. Malayalam
  device → Malayalam UI; everything else → English (fallback).
- **Translations:** Claude drafts Malayalam in `app_ml.arb`; user reviews/corrects.
- **Scope:** Full app in one pass — all screens, widgets, and notifications.

## What the issue is

All user-facing UI text is hardcoded as English string literals throughout the
`lib/screens/`, `lib/widgets/`, and `lib/services/` code (~105 distinct strings).
There is no localization infrastructure, so the app cannot present Malayalam.
Additionally, the base UI text styles (`Inter`/`EBGaramond`) have no Malayalam
glyph fallback, so Malayalam UI text would render as boxes even if supplied.

User-entered data (counter/mantra names) is NOT localized — it stays as the user
typed it. Only app chrome is translated.

## The plan for the fix

### 1. Dependencies & config

- `pubspec.yaml`:
  - Add `flutter_localizations:\n    sdk: flutter` and `intl: any` to dependencies.
  - Under the `flutter:` section add `generate: true`.
- New `mantra_japa_counter/l10n.yaml`:
  ```yaml
  arb-dir: lib/l10n
  template-arb-file: app_en.arb
  output-localization-file: app_localizations.dart
  ```

### 2. ARB translation files

- New `lib/l10n/app_en.arb` — every UI string keyed (e.g. `settingsTitle`,
  `clearAllDataTitle`, `dailyGoalAchievedTitle`, …) with `@@locale: "en"`.
  Use ICU placeholders for dynamic strings (counts, names, dates) where the
  existing code interpolates values.
- New `lib/l10n/app_ml.arb` — same keys, Malayalam values, `@@locale: "ml"`.
  (Claude drafts; user reviews.)

### 3. Wire localization into the app

- `lib/main.dart` — in `MaterialApp.router`:
  - `localizationsDelegates: AppLocalizations.localizationsDelegates`
  - `supportedLocales: AppLocalizations.supportedLocales`
  - Add a `localeResolutionCallback` that returns `ml` only when the device
    locale's languageCode is `ml`, otherwise `en` (explicit English fallback).
  - Keep `title:` working: switch `onGenerateTitle` to a localized app title, or
    leave `AppFlavorConfig.appName` (brand name, not translated). Decision: leave
    the brand app name untranslated.

### 4. Font fallback for Malayalam UI text (theme.dart)

- In `lib/config/theme.dart`, add `NotoSansMalayalam` to `fontFamilyFallback`
  on `sans()`, `serif()`, and `eyebrow()` so Malayalam glyphs render in normal
  UI labels (currently only `mal()` falls back). Also apply a fallback on the
  generated `textTheme` base.

### 5. Replace hardcoded strings → `AppLocalizations.of(context)!`

Files to edit (UI chrome only):
- `lib/screens/settings_screen.dart`
- `lib/screens/counter_list_screen.dart`
- `lib/screens/counting_screen.dart`
- `lib/screens/history_screen.dart`
- `lib/screens/about_counter_screen.dart`
- `lib/screens/about_screen.dart`
- `lib/screens/help_screen.dart`
- `lib/widgets/counter_card.dart`
- `lib/widgets/session_list_tile.dart`
- `lib/widgets/goal_progress_bar.dart`
- `lib/widgets/mala_count_display.dart`
- `lib/widgets/circular_progress_widget.dart`
- `lib/widgets/temple_decorations.dart` (only if it holds copy; mostly icons)

Where a widget lacks a `BuildContext`, thread it through or read the localization
at the call site and pass the resolved string in.

### 6. Notifications (context-free localization)

- `lib/services/notification_service.dart` builds `title`/`body` outside any
  widget (lines ~53–54). `AppLocalizations.of(context)` is unavailable here.
  Approach: load `AppLocalizations.delegate.load(locale)` for the current
  device locale inside the service (or pass the two resolved strings in from a
  caller that has context). Decision: resolve via
  `lookupAppLocalizations(<deviceLocale>)` using
  `WidgetsBinding.instance.platformDispatcher.locale`, mapped through the same
  en/ml fallback rule, so notifications match the UI language.

### 7. Export service

- `lib/services/export_service.dart` — review for any user-facing copy. JSON
  export keys/format MUST stay byte-compatible with the Android Gson format
  (per CLAUDE.md import-compatibility requirement) — do NOT localize export
  field names or values. Only localize any share-sheet title/UI text if present.

### 8. Build & verify

- Run `flutter gen-l10n` (or `flutter pub get`, which triggers generation).
- `flutter analyze` must pass.
- Manually verify both locales by running with
  `flutter run --dart-define ...` and switching device language, or temporarily
  forcing `locale:` to `Locale('ml')` to spot any unstranslated/boxed text.

## Files to be changed

New:
- `mantra_japa_counter/l10n.yaml`
- `mantra_japa_counter/lib/l10n/app_en.arb`
- `mantra_japa_counter/lib/l10n/app_ml.arb`

Modified:
- `mantra_japa_counter/pubspec.yaml`
- `mantra_japa_counter/lib/main.dart`
- `mantra_japa_counter/lib/config/theme.dart`
- All screen files listed in §5
- Widget files listed in §5
- `mantra_japa_counter/lib/services/notification_service.dart`
- `mantra_japa_counter/lib/services/export_service.dart` (only if it has UI copy)

## Risks / notes

- Large diff (~105 strings across ~15 files). Mitigated by mechanical, key-by-key
  replacement.
- Malayalam wording needs native review (user will do this).
- Must not break Android-compatible JSON export format.
- `.arb` keys become a stable contract; pick clear names up front.
```