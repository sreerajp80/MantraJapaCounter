# Plan: Strict Guidelines Adherence

**Status:** Proposed
**Date:** 2026-09-13
**Author:** AI Agent

---

## 1. Objective

Ensure that the project strictly adheres to all conventions and standards defined in `docs/guidelines`:
- `docs/guidelines/guideline.md`:
  - §1.1–§1.6: Dynamic About-screen configuration with `LocalizedText`, lowerCamelCase detail keys, and `aboutDetail<Key>` localization.
  - §1.7: Fixed "Made with ❤️ from India" badge using `MadeWithLove` widget and mandatory ARB keys (`madeWithLove`, `madeWithLoveA11y`).
- `docs/guidelines/flutter_project_engineering_standard.md`:
  - §8.1–§8.3: Full support for the three mandatory languages (`en`, `ml`, `sa`) and Sanskrit framework localization delegates (`SaMaterialLocalizationsDelegate`, `SaCupertinoLocalizationsDelegate`, `SaWidgetsLocalizationsDelegate`).
  - §8.7: Key parity test (`test/l10n/arb_parity_test.dart`) ensuring key parity and translation completeness across all three ARBs.
- `docs/guidelines/AGENTS_MD_GUIDELINE.md` & `CLAUDE_MD_GUIDELINE.md`:
  - Update root `AGENTS.md` and `CLAUDE.md` to reflect full three-language support and About config conventions.
- `docs/guidelines/DOCS_FOLDER_GUIDELINE.md`:
  - Ensure `docs/GUIDELINES_MANIFEST.md` matches `docs/guidelines/GUIDELINES_MANIFEST.md`.

---

## 2. Issues Identified

1. **`AppConfig` & `app_config.json`**:
   - `lib/core/config/app_config.dart` currently uses `String description` and `Map<String, String> details` rather than `LocalizedText`.
   - `assets/config/app_config.json` uses plain strings for `description` and `license` instead of locale maps (`{"en": ..., "ml": ..., "sa": ...}`), and details keys are Title Case (`Author`, `Email`, etc.) instead of standard lowerCamelCase (`author`, `email`, `license`, `aiUsed`, `ideUsed`).
2. **About Screen & Made with Love Badge**:
   - The About screen manually concatenates prefix and suffix with an icon rather than using the standard `MadeWithLove` widget specified in `guideline.md` §1.7.
   - Missing required ARB keys: `madeWithLove` (with `{heart}` placeholder) and `madeWithLoveA11y` across all 3 ARB files.
   - Missing ARB keys: `aboutDetailAuthor`, `aboutDetailEmail`, `aboutDetailLicense`, `aboutDetailAiUsed`, `aboutDetailIdeUsed`.
   - `lib/widgets/made_with_love.dart` does not exist.
3. **Sanskrit Framework Delegates**:
   - Standard Sanskrit fallback delegates specified in `flutter_project_engineering_standard.md` §8.3.1 (`SaMaterialLocalizationsDelegate`, `SaCupertinoLocalizationsDelegate`, `SaWidgetsLocalizationsDelegate`) should reside in `lib/l10n/sa_material_localizations.dart` and delegate to English framework strings.
4. **ARB Parity Test**:
   - `test/l10n/arb_parity_test.dart` required by `flutter_project_engineering_standard.md` §8.7 is missing.
5. **Pointer Manifest & Documentation**:
   - `docs/GUIDELINES_MANIFEST.md` has slight divergence from `docs/guidelines/GUIDELINES_MANIFEST.md`.
   - `AGENTS.md` mentions "ships only en and ml", which is outdated now that Sanskrit is supported.

---

## 3. Files to Change / Create

### Create:
- `lib/widgets/made_with_love.dart` (The standard "Made with ❤️ from India" badge per `guideline.md` §1.7)
- `lib/l10n/sa_material_localizations.dart` (Sanskrit framework delegates per engineering standard §8.3.1)
- `test/l10n/arb_parity_test.dart` (ARB key parity test per engineering standard §8.7)

### Modify:
- `assets/config/app_config.json` (Add locale maps for description/license, convert keys to lowerCamelCase)
- `lib/core/config/app_config.dart` (Add `LocalizedText`, update `AppConfig` fields and fallback/fromJson)
- `lib/l10n/app_en.arb`, `lib/l10n/app_ml.arb`, `lib/l10n/app_sa.arb` (Add `madeWithLove`, `madeWithLoveA11y`, `aboutDetail*` keys)
- `lib/screens/about_screen.dart` (Adopt dynamic detail rows with `aboutDetailLabel` and `MadeWithLove` widget)
- `lib/core/locale/locale_config.dart` & `lib/main.dart` (Reference standard Sanskrit delegates)
- `docs/GUIDELINES_MANIFEST.md` (Synchronize with `docs/guidelines/GUIDELINES_MANIFEST.md`)
- `AGENTS.md` & `CLAUDE.md` (Update localization section to include Sanskrit)
- `test/screens/about_screen_test.dart` (Update tests to reflect `LocalizedText` and new About screen widgets)

---

## 4. Step-by-Step Implementation Plan

1. **Update `AppConfig` Model & Asset JSON**:
   - Implement `LocalizedText` in `lib/core/config/app_config.dart`.
   - Update `AppConfig` to use `LocalizedText` for `description` and `details`.
   - Update `assets/config/app_config.json` with English, Malayalam, and Sanskrit translations for prose fields, and lowerCamelCase detail keys.
2. **Add Missing ARB Keys & Regenerate Localizations**:
   - Add `aboutDetailAuthor`, `aboutDetailEmail`, `aboutDetailLicense`, `aboutDetailAiUsed`, `aboutDetailIdeUsed` to `app_en.arb`, `app_ml.arb`, `app_sa.arb`.
   - Add `madeWithLove` and `madeWithLoveA11y` verbatim from `guideline.md` §1.7 to all three ARB files.
   - Run `flutter gen-l10n`.
3. **Implement `MadeWithLove` Widget & Sanskrit Delegates**:
   - Create `lib/widgets/made_with_love.dart`.
   - Create `lib/l10n/sa_material_localizations.dart` and configure in `LocaleConfig` / `main.dart`.
4. **Update `AboutScreen`**:
   - Use `aboutDetailLabel` mapping to translate detail keys.
   - Resolve detail values and description against active locale via `LocalizedText.resolve(languageCode)`.
   - Place `const MadeWithLove()` at the bottom of `AboutScreen`.
5. **Add Mandatory ARB Parity Test**:
   - Create `test/l10n/arb_parity_test.dart` to assert key parity across `en`, `ml`, and `sa`.
6. **Documentation and Manifest Updates**:
   - Sync `docs/GUIDELINES_MANIFEST.md` with `docs/guidelines/GUIDELINES_MANIFEST.md`.
   - Update `AGENTS.md` and `CLAUDE.md` to reference `en`, `ml`, `sa`.
7. **Verification**:
   - Run `flutter analyze`.
   - Run `flutter test`.
   - Run `dart format .`.

---

## 5. Verification Plan

- `flutter gen-l10n` runs with 0 errors.
- `flutter analyze` passes with 0 issues.
- `flutter test` passes all tests including the new `arb_parity_test.dart` and updated `about_screen_test.dart`.
