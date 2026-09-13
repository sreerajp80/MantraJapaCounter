# Implementation Plan — Purify Sanskrit Localization in app_sa.arb

**Status:** completed
**Date:** 2026-09-13
**Slug:** purify-sanskrit-localization

---

## 1. Summary of the Issue

The Sanskrit localization file `lib/l10n/app_sa.arb` contains several issues where Hindi words, Hindi grammar, and loanwords were used instead of authentic Sanskrit:
1. **Hindi/Arabic loanwords**:
   - `"labelTotal": "कुलम्"` uses Hindi "कुल" (from Arabic kull / कुल, meaning sum/total in Hindi). In Sanskrit, "कुलम्" means lineage, family, or clan. Total is "समग्रम्" or "सर्वयोगः".
   - `"infoAvgDaily": "दैनिकौसतम्"` compounds the Arabic loanword "औसत" (meaning average in Hindi/Urdu). In Sanskrit, average is "माध्यम्", so daily average is "दैनिकमाध्यम्" or "प्रतिदिनमाध्यम्".
   - `"featFountainDesc"` contains `"छूटाः"` ("केचन सङ्केताः छूटाः चेदपि"), which is purely Hindi ("छूट गए"). In Sanskrit, this should be "लुप्ताः" or "त्रुटिताः".
   - `"aboutLicenseValue"` translated software libraries literally as books ("तन्त्रांशपुस्तकानि"). In Sanskrit technical usage, software libraries are "तन्त्रांशग्रन्थालयाः".
2. **Grammar and Case Agreement Errors**:
   - `aboutPrivacyBody`: `"भवतः सर्वः जपविवरणः केवलं भवतः यन्त्रे एव सुरक्षिता तिष्ठति।"` mixed neuter `विवरणम्` with masculine `सर्वः जपविवरणः` and feminine `सुरक्षिता` (following Hindi "जानकारी सुरक्षित रहती है"). Correct neuter agreement: `"भवतः सर्वं जपविवरणं केवलं भवतः यन्त्रे एव सुरक्षितं तिष्ठति।"`.
   - `helpPrivacyOfflineBullet1`: `"अस्मिन् अनुप्रयोगात्"` mixes locative pronoun (`अस्मिन्`) with ablative noun (`अनुप्रयोगात्`). It must be `"अस्मिन् अनुप्रयोगे"` (locative).
   - `clearAllDataSub` and `importExportBody`: `"सर्वाणि गणकानि"` treats `गणकः` (masculine) as neuter plural. The correct masculine plural accusative is `"सर्वान् गणकान्"` and nominative is `"सर्वे गणकाः"`.
   - `todayActive`: `"सक्रियम्"` (neuter singular) should be `"सक्रियाः"` (masculine plural, referring to active counters `गणकाः`).
3. **Spelling and Sandhi Errors**:
   - `recentOfferings`: Typo `"समपितानि"` missing repha, should be `"समर्पितानि"`.
   - `resetSessionMessage` and `resetCounterMessage`: Misspelled `"शुन्यं"` (short u) instead of `"शून्ये"` (long ū, locative).
   - `helpMalaBeadsBullet3`: `"घण्टानादः कम्पनञ्च श्रूयते"` claimed vibration is heard. Chimes are heard and vibration is felt: `"सौम्यः घण्टानादः श्रूयते, मृदुकम्पनं चानुभूयते।"`.
   - Repha sandhi violations: `"पुनर्स्थाप्यन्ते"`, `"पुनर्स्थापयतु"`, and `"पुनर्स्थापितः"` violate Paninian sandhi rules before sibilants (`पुनःस्थाप्यन्ते` / `पुनस्स्थाप्यन्ते`).
   - `"पुनर्रचना"` has invalid double repha.
4. **Hindi Sentence Calques and Fake Words**:
   - `disableCounterTitle`: `"गणकं निष्क्रियतम् इच्छन्ति किम्?"` uses an invented non-word `"निष्क्रियतम्"`. Must be `"गणकं निष्क्रियीकर्तुम् इच्छन्ति किम्?"`.
   - `importSuccessful`: `"आयातं सफलम् जातम्"` and `opticalImportFailed`: `"दत्तांशस्यायातं विफलम् जातम्।"` calque Hindi "सफल हुआ / विफल हुआ". In Sanskrit: `"आयातः सफलः सम्पन्नः"` and `"दत्तांशायातो विफलः संवृत्तः।"`.
   - `previewToneSub`: `"समाप्तौ यः ध्वनिः भवति तं शृणोतु"` calques Hindi "जो ध्वनि होती है". In Sanskrit: `"पूर्तौ भवं ध्वनिं शृणोतु"`.
   - Inconsistent verbs for tapping/clicking (`नुदन्तु` vs `स्पृशन्तु` / `स्पृशतु`).

---

## 2. Proposed Changes

### 1. Refactor `lib/l10n/app_sa.arb`
- Correct all vocabulary, verb conjugations, sandhi rules, case agreements, and gender agreements to pure, elegant Sanskrit.
- Ensure all technical terms use accepted Sanskrit standards without Hindiisms or English literalisms.

### 2. Update `test/screens/about_screen_test.dart`
- Update the Sanskrit test expectations in `test/screens/about_screen_test.dart` to match the corrected Sanskrit strings for `aboutDescription` and `aboutLicenseValue`.

### 3. Regenerate and Test
- Run `flutter gen-l10n`.
- Run `flutter test` and `flutter analyze`.

---

## 3. Files to Change

- `lib/l10n/app_sa.arb` [MODIFY]
- `test/screens/about_screen_test.dart` [MODIFY]

---

## 4. Verification Plan

1. Run `flutter gen-l10n` to regenerate localization classes.
2. Run `flutter analyze` to ensure zero static analysis warnings.
3. Run `flutter test` to verify all test suites pass.
