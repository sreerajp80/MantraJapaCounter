# Implementation Plan — Update Mantra Quote in Sanskrit About Screen

**Status:** completed
**Date:** 2026-09-13
**Slug:** update-sanskrit-about-quote

---

## 1. Summary of the Issue

In the Sanskrit localization file (`lib/l10n/app_sa.arb`), the string for `aboutMantraQuote` is currently:
`"ॐ नमः शिवाय · हरे कृष्ण · गायत्री"`

The user requested replacing this with:
- One word for Ganapathi
- followed by `हरे कृष्ण`
- followed by one word for Durga

Target text format:
`"गणेशाय नमः · हरे कृष्ण · दुर्गायै नमः"`

---

## 2. Proposed Changes

1. **Update `lib/l10n/app_sa.arb`**:
   - Change `aboutMantraQuote` from `"ॐ नमः शिवाय · हरे कृष्ण · गायत्री"` to `"गणेशाय नमः · हरे कृष्ण · दुर्गायै नमः"`.
2. **Regenerate localization files**:
   - Run `flutter gen-l10n` so that `lib/l10n/app_localizations_sa.dart` is updated automatically.
3. **Run validation**:
   - Run `flutter analyze` and `flutter test`.

---

## 3. Files to Change

- `lib/l10n/app_sa.arb` [MODIFY]
- `lib/l10n/app_localizations_sa.dart` [REGENERATED]

---

## 4. Verification Plan

1. Run `flutter gen-l10n`.
2. Run `flutter analyze` to ensure 0 warnings.
3. Run `flutter test` to ensure all tests pass.
