# Change Log — Purify Sanskrit Localization in app_sa.arb

**Date:** 2026-09-13
**Plan:** plans/20260913_121800_purify_sanskrit_localization.md
**Slug:** purify-sanskrit-localization

---

## 1. What Changed

Refactored `lib/l10n/app_sa.arb` to eliminate Hindi words, Arabic/Urdu loanwords, grammatical agreement errors, and literal calques, ensuring proper, classical Sanskrit:
1. **Replaced Loanwords with Pure Sanskrit**:
   - `labelTotal`: Replaced Hindi/Arabic `कुलम्` with `समग्रम्`.
   - `infoAvgDaily`: Replaced Arabic loanword `दैनिकौसतम्` with `दैनिकमाध्यम्`.
   - `featFountainDesc`: Replaced Hindi `छूटाः` with `लुप्ताः`.
   - `aboutLicenseValue`: Replaced literal translation of libraries as books (`तन्त्रांशपुस्तकानि`) with `तन्त्रांशग्रन्थालयाः`.
2. **Fixed Grammatical Agreements and Cases**:
   - `aboutPrivacyBody`: Corrected neuter agreement to `भवतः सर्वं जपविवरणं केवलं भवतः यन्त्रे एव सुरक्षितं तिष्ठति।`.
   - `helpPrivacyOfflineBullet1`: Fixed mismatched case from `अस्मिन् अनुप्रयोगात्` to locative `अस्मिन् अनुप्रयोगे`.
   - `clearAllDataSub` and `importExportBody`: Changed neuter plural `सर्वाणि गणकानि` to masculine plural accusative `सर्वान् गणकान्` and nominative `सर्वे गणकाः`.
   - `todayActive`: Changed neuter singular `सक्रियम्` to masculine plural `सक्रियाः` (counters).
3. **Fixed Sandhi, Spelling, and Typos**:
   - `recentOfferings`: Fixed typo `समपितानि` to `समर्पितानि`.
   - `resetSessionMessage` and `resetCounterMessage`: Corrected `शुन्यं प्रति` to `शून्ये`.
   - `helpMalaBeadsBullet3`: Corrected sense-modality conflict to `सौम्यः घण्टानादः श्रूयते, मृदुकम्पनं चानुभूयते।`.
   - Sandhi before sibilants: Fixed `पुनर्स्थाप्यन्ते` -> `पुनःस्थाप्यन्ते`, `पुनर्स्थापितः` -> `पुनःस्थापितः`, `पुनर्स्थापयतु` -> `पुनःस्थापयतु`.
   - Corrected double repha `पुनर्रचना` to `पुनर्निर्माणम्`.
4. **Natural Sanskrit Expressions**:
   - Replaced pseudo-word `निष्क्रियतम्` with `निष्क्रियीकर्तुम्`.
   - Replaced Hindi-style `सफलम् जातम्` with `साफल्येन सम्पन्नः` and `विफलम् जातम्` with `विफलो जातः`.
   - Standardized touch action to `स्पृशतु` / `स्पृशन्तु` instead of mixing with `नुदन्तु`.
   - Updated `test/screens/about_screen_test.dart` to match the refined Sanskrit test expectations.

---

## 2. Files Changed

- `lib/l10n/app_sa.arb`: Corrected all strings to proper Sanskrit.
- `test/screens/about_screen_test.dart`: Updated expected Sanskrit strings for description and license.
- `plans/20260913_121800_purify_sanskrit_localization.md`: Updated plan status to completed.

---

## 3. Verification

- `flutter gen-l10n`: Successfully generated updated localization classes.
- `flutter analyze`: Passed with 0 issues / 0 warnings.
- `flutter test`: All 116 tests passed.
- `dart format .`: All files formatted cleanly.
