# Change Log — Localize About Screen for Sanskrit and Malayalam

**Date:** 2026-09-13
**Plan:** plans/20260913_120400_localize_about_screen.md
**Slug:** localize-about-screen

---

## 1. What Changed

Localized the About screen for Sanskrit and Malayalam so that English text is replaced with native language strings:
1. **App Title**: Uses the localized `l.appTitle` (appending `Dev` if on the dev flavor) when the default app name is present.
2. **App Description**: Added `aboutDescription` localization keys to `app_en.arb`, `app_ml.arb`, and `app_sa.arb`.
3. **Detail Row Keys**: Added localized labels for `Author` (`aboutAuthor`), `Email` (`aboutEmail`), `License` (`aboutLicense`), `AI used` (`aboutAiUsed`), and `IDE used` (`aboutIdeUsed`).
4. **Detail Row Values**: Added localized translations for:
   - Author name: `Sreeraj P` -> `ശ്രീരാജ് പി` (ml), `श्रीराज् पि` (sa).
   - License description: `All libraries used are open source.` -> `ഉപയോഗിച്ചിരിക്കുന്ന എല്ലാ ലൈബ്രറികളും ഓപ്പൺ സോഴ്സ് ആണ്.` (ml), `सर्वाणि प्रयुक्तानि तन्त्रांशपुस्तकानि विवृतानि (open-source) सन्ति।` (sa).
   - AI used: `Google Gemini / Anthropic Claude` -> `ഗൂഗിൾ ജെമിനി / ആന്ത്രോപിക് ക്ലോഡ്` (ml), `गूगल जेमिनी / एन्थ्रोपिक क्लाउड` (sa).
   - IDE used: `VS Code / Antigravity IDE` -> `വിഎസ് കോഡ് / ആന്റിഗ്രാവിറ്റി ഐഡിഇ` (ml), `वीएस कोड / एन्टीഗ്രാവിറ്റി ഐഡിഇ` (sa).
   - Email address remains unchanged (`sreerajp@zohomail.in`).

---

## 2. Files Changed

- `lib/l10n/app_en.arb`: Added About screen keys and descriptions.
- `lib/l10n/app_ml.arb`: Added Malayalam translations for About screen strings.
- `lib/l10n/app_sa.arb`: Added Sanskrit translations for About screen strings.
- `lib/screens/about_screen.dart`: Updated to resolve localized app title, description, detail labels, and values.
- `test/screens/about_screen_test.dart`: Added widget test coverage for Sanskrit and Malayalam rendering.

---

## 3. Verification

- `flutter gen-l10n`: Successfully generated updated localization classes.
- `flutter analyze`: Completed with 0 issues / 0 warnings.
- `flutter test`: All 116 tests passed.
- `dart format .`: Code formatted cleanly.
