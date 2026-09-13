# Implementation Plan — Localize About Screen for Sanskrit and Malayalam

**Status:** completed
**Date:** 2026-09-13
**Slug:** localize-about-screen

---

## 1. Summary of the Issue

On the About screen (`विषये`), several labels, descriptions, and detail values remain in English even when the user selects Sanskrit or Malayalam:
1. The app title at the top renders the English name from `app_config.json` instead of the localized `appTitle`.
2. The app description ("Offline-first application for tracking mantra recitation practice with customizable counters and session history.") is rendered directly in English from `app_config.json`.
3. The detail keys ("Author", "Email", "License", "AI used", "IDE used") are hardcoded in English inside `app_config.json`.
4. The detail values are also in English:
   - Author name: `Sreeraj P`
   - License text: `All libraries used are open source.`
   - AI used: `Google Gemini / Anthropic Claude`
   - IDE used: `VS Code / Antigravity IDE`

Only the email address (`sreerajp@zohomail.in`) remains unchanged.

---

## 2. Proposed Solution

### 1. Update Localization ARB Files
Add new localization keys with descriptions to:
- `lib/l10n/app_en.arb`
- `lib/l10n/app_ml.arb`
- `lib/l10n/app_sa.arb`

Keys to add:
- `aboutDescription`:
  - English: "Offline-first application for tracking mantra recitation practice with customizable counters and session history."
  - Malayalam: "മാല (108-മണി വട്ടം) എണ്ണൽ, ക്രമീകരിക്കാവുന്ന കൗണ്ടറുകൾ, സെഷൻ ചരിത്രം എന്നിവയോടെ മന്ത്രജപാഭ്യാസം ട്രാക്ക് ചെയ്യാനുള്ള ഓഫ്‌ലൈൻ ആപ്പ്."
  - Sanskrit: "अनुकूलनीय-गणकैः सत्र-इतिहासैश्च सह मन्त्रजप-अभ्यासस्य अनुसरणं कर्तुं अन्तर्जालरहितः अनुप्रयोगः।"
- `aboutAuthor`:
  - English: "Author"
  - Malayalam: "രചയിതാവ്"
  - Sanskrit: "रचयिता"
- `aboutAuthorValue`:
  - English: "Sreeraj P"
  - Malayalam: "ശ്രീരാജ് പി"
  - Sanskrit: "श्रीराज् पि"
- `aboutEmail`:
  - English: "Email"
  - Malayalam: "ഇമെയിൽ"
  - Sanskrit: "विद्युत्पत्रम्"
- `aboutLicense`:
  - English: "License"
  - Malayalam: "ലൈസൻസ്"
  - Sanskrit: "अनुज्ञापत्रम्"
- `aboutLicenseValue`:
  - English: "All libraries used are open source."
  - Malayalam: "ഉപയോഗിച്ചിരിക്കുന്ന എല്ലാ ലൈബ്രറികളും ഓപ്പൺ സോഴ്സ് ആണ്."
  - Sanskrit: "सर्वाणि प्रयुक्तानि तन्त्रांशपुस्तकानि विवृतानि (open-source) सन्ति।"
- `aboutAiUsed`:
  - English: "AI used"
  - Malayalam: "ഉപയോഗിച്ച AI"
  - Sanskrit: "प्रयुक्त-कृत्रिमबुद्धिः (AI)"
- `aboutAiUsedValue`:
  - English: "Google Gemini / Anthropic Claude"
  - Malayalam: "ഗൂഗിൾ ജെമിനി / ആന്ത്രോപിക് ക്ലോഡ്"
  - Sanskrit: "गूगल जेमिनी / एन्थ्रोपिक क्लाउड"
- `aboutIdeUsed`:
  - English: "IDE used"
  - Malayalam: "ഉപയോഗിച്ച IDE"
  - Sanskrit: "प्रयुक्त-विकासपरिवेशः (IDE)"
- `aboutIdeUsedValue`:
  - English: "VS Code / Antigravity IDE"
  - Malayalam: "വിഎസ് കോഡ് / ആന്റിഗ്രാവിറ്റി ഐഡിഇ"
  - Sanskrit: "वीएस कोड / एन्टीग्रैविटी आईडीई"

### 2. Update `AboutScreen` (`lib/screens/about_screen.dart`)
- For the app title at the top:
  If `config.appName` matches default (`SreerajP MantraJapa Counter`) or is empty, use `AppFlavorConfig.isDev ? '${l.appTitle} Dev' : l.appTitle`. If a custom app name is supplied, keep it.
- For the app description:
  If `config.description` matches default or is empty, use `l.aboutDescription`. If a custom description is provided, keep it.
- For detail rows:
  Translate known keys (`Author`, `Email`, `License`, `AI used`, `IDE used`) to their localized equivalents via `AppLocalizations`.
  Translate known default values for Author (`aboutAuthorValue`), License (`aboutLicenseValue`), AI used (`aboutAiUsedValue`), and IDE used (`aboutIdeUsedValue`).
  The email address remains as provided (`sreerajp@zohomail.in`).

### 3. Regenerate Code & Add Tests
- Run `flutter gen-l10n`.
- Update and add test coverage in `test/screens/about_screen_test.dart` to verify Sanskrit and Malayalam translations on the About screen.

---

## 3. Files to Change

- `lib/l10n/app_en.arb` [MODIFY]
- `lib/l10n/app_ml.arb` [MODIFY]
- `lib/l10n/app_sa.arb` [MODIFY]
- `lib/screens/about_screen.dart` [MODIFY]
- `test/screens/about_screen_test.dart` [MODIFY]

---

## 4. Verification Plan

1. Run `flutter gen-l10n`.
2. Run `flutter analyze` to ensure 0 warnings/errors.
3. Run `flutter test test/screens/about_screen_test.dart` and all tests.
4. Verify rendering in Sanskrit, Malayalam, and English.
