# Change Log — Strict Guidelines Adherence

**Date:** 2026-09-13  
**Plan Reference:** [plans/20260913_193500_strict_guidelines_adherence.md](../plans/20260913_193500_strict_guidelines_adherence.md)

## 1. Summary

Aligned the project with the updated Flutter guidelines (`docs/guidelines`):
- Added Google Play App Bundle language splitting prevention in Gradle (`bundle.language.enableSplit = false`).
- Updated the `MadeWithLove` signature badge to use `WidgetSpan` with `Icon(Icons.favorite)` for consistent vector heart rendering.
- Updated About screen terminology in Malayalam (`ആപ്പിനെക്കുറിച്ച്`) and Sanskrit (`विषयपरिचयः`) per the UI glossary.
- Replaced the basic ARB key test with the full `translation_parity_test.dart` suite covering ARBs, About JSON config, and content assets.
- Updated `about_screen_test.dart`, `AGENTS.md`, and `CLAUDE.md`.

---

## 2. Files Changed

| File | Change |
|---|---|
| `android/app/build.gradle.kts` | Configured `bundle { language { enableSplit = false } }` in `android { ... }` block to preserve language resources on Play Store downloads. |
| `lib/widgets/made_with_love.dart` | Switched from text emoji glyph to `WidgetSpan` with `Icon(Icons.favorite, color: Color(0xFFE53935))` for OEM-independent vector rendering. |
| `lib/l10n/app_ml.arb` | Updated `menuAbout` and `aboutTitle` from `"കുറിച്ച്"` to `"ആപ്പിനെക്കുറിച്ച്"`. |
| `lib/l10n/app_sa.arb` | Updated `menuAbout` and `aboutTitle` from `"विषये"` to `"विषयपरिचयः"`. |
| `lib/l10n/app_localizations_ml.dart` | Regenerated via `flutter gen-l10n`. |
| `lib/l10n/app_localizations_sa.dart` | Regenerated via `flutter gen-l10n`. |
| `test/l10n/translation_parity_test.dart` | Added comprehensive parity test suite covering ARB key parity, non-English translation completeness, heart badge marker retention, About JSON config validation, and content asset twins. |
| `test/l10n/arb_parity_test.dart` | Deleted (subsumed by `translation_parity_test.dart`). |
| `test/screens/about_screen_test.dart` | Updated expectations to match new About titles and aligned mock versions to prevent console warnings. |
| `AGENTS.md` | Updated parity test reference to `test/l10n/translation_parity_test.dart`. |
| `CLAUDE.md` | Updated parity test reference to `test/l10n/translation_parity_test.dart`. |
| `plans/20260913_193500_strict_guidelines_adherence.md` | Marked implementation plan as completed. |

---

## 3. Verification

- `flutter gen-l10n`: Completed with code 0.
- `dart format .`: Formatted 104 files with 0 syntax issues.
- `flutter analyze`: Completed with 0 issues.
- `flutter test`: All 124 tests passed cleanly with 0 failures and 0 warnings.
