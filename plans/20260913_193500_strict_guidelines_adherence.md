# Implementation Plan — Strict Guidelines Adherence

**Status:** completed

## 1. Overview

Align the project strictly with the latest shared Flutter guidelines (`docs/guidelines`), specifically incorporating recent updates from the guidelines submodule:
1. Disabling Android App Bundle language splitting in Gradle (`bundle.language.enableSplit = false`).
2. Updating the `MadeWithLove` signature badge to use `WidgetSpan` with `Icon(Icons.favorite)` for cross-platform vector consistency.
3. Updating Malayalam and Sanskrit "About" terminology to `ആപ്പിനെക്കുറിച്ച്` and `विषयपरिचयः` per the standard UI glossary (§8.5.2, §8.5.3, §8.5.4).
4. Upgrading the localization parity test to the full `test/l10n/translation_parity_test.dart` suite per §8.7 (covering ARBs, `app_config.json`, and asset twins).
5. Updating project documentation (`AGENTS.md`, `CLAUDE.md`) and tests (`about_screen_test.dart`) accordingly.

---

## 2. Issues Identified

1. **Gradle Language Splitting**:
   - `android/app/build.gradle.kts` does not configure `bundle.language.enableSplit = false`. Google Play defaults to language splitting, which strips non-English language resources for users downloading on English device locales, breaking in-app language switching.
2. **MadeWithLove Widget Heart Glyph**:
   - `lib/widgets/made_with_love.dart` currently renders the heart as a text string `❤`. Per updated `guideline.md` §1.7, it must render as a `WidgetSpan` with `Icon(Icons.favorite, color: Color(0xFFE53935))` to guarantee consistent vector rendering across OEM emoji fonts.
3. **About Title Terminology**:
   - `lib/l10n/app_ml.arb` uses `കുറിച്ച്` for `menuAbout` and `aboutTitle`. A standalone postposition is ungrammatical; the guideline requires `ആപ്പിനെക്കുറിച്ച്`.
   - `lib/l10n/app_sa.arb` uses `विषये` for `menuAbout` and `aboutTitle`. A locative fragment is improper; the guideline requires nominative `विषयपरिचयः`.
4. **Translation Parity Test Suite**:
   - The project currently has a basic `test/l10n/arb_parity_test.dart`. Engineering standard §8.7 mandates `test/l10n/translation_parity_test.dart` covering ARB key parity, untranslated English copy checks, `{heart}` placeholder preservation, `app_config.json` trilingual fields and detail keys, and asset twin checks.
5. **Test Assertions and Mock Mismatches**:
   - `test/screens/about_screen_test.dart` still expects the old `കുറിച്ച്` and `विषये` strings.
   - `test/screens/about_screen_test.dart` uses mismatched version numbers in test configs (`6.11.0+23` vs `6.10.3+20`), causing debug warnings during test execution.
6. **Documentation References**:
   - `AGENTS.md` and `CLAUDE.md` cite `test/l10n/arb_parity_test.dart` instead of `test/l10n/translation_parity_test.dart`.

---

## 3. Files to Modify / Create / Delete

### Modify:
- `android/app/build.gradle.kts` [MODIFY]
- `lib/widgets/made_with_love.dart` [MODIFY]
- `lib/l10n/app_ml.arb` [MODIFY]
- `lib/l10n/app_sa.arb` [MODIFY]
- `test/screens/about_screen_test.dart` [MODIFY]
- `AGENTS.md` [MODIFY]
- `CLAUDE.md` [MODIFY]

### Create:
- `test/l10n/translation_parity_test.dart` [NEW]

### Delete:
- `test/l10n/arb_parity_test.dart` [DELETE] (Replaced by `test/l10n/translation_parity_test.dart`)

---

## 4. Proposed Changes

### Android Build Configuration
#### [android/app/build.gradle.kts](android/app/build.gradle.kts)
- Add inside `android { ... }`:
  ```kotlin
  bundle {
      language {
          enableSplit = false
      }
  }
  ```

### Badge Widget
#### [lib/widgets/made_with_love.dart](lib/widgets/made_with_love.dart)
- Replace text glyph `_heart = '❤'` with `WidgetSpan` containing `Icon(Icons.favorite, size: (base.fontSize ?? 12) * 1.1, color: _heartColor)` aligned to `PlaceholderAlignment.middle`.

### Localization Resources
#### [lib/l10n/app_ml.arb](lib/l10n/app_ml.arb)
- Update `menuAbout` and `aboutTitle` from `"കുറിച്ച്"` to `"ആപ്പിനെക്കുറിച്ച്"`.

#### [lib/l10n/app_sa.arb](lib/l10n/app_sa.arb)
- Update `menuAbout` and `aboutTitle` from `"विषये"` to `"विषयपरिचयः"`.

- Run `flutter gen-l10n` to rebuild localization delegates.

### Tests
#### [test/l10n/translation_parity_test.dart](test/l10n/translation_parity_test.dart)
- Implement all test groups specified in `docs/guidelines/flutter_project_engineering_standard.md` §8.7:
  - ARB parity tests: key parity, untranslated English checks (allowing brand names/symbols in `sameAsEnglishAllowed`), and `{heart}` marker presence.
  - About JSON config parity tests: verifies `appName`, `description`, `details.*` in `assets/config/app_config.json` have non-empty `en`, `ml`, and `sa` strings, and all detail keys match an `aboutDetail<Key>` in `app_en.arb`.
  - Content asset parity tests: verifies `_ml` and `_sa` twins exist for any `_en` file in `assets/`.

#### [test/screens/about_screen_test.dart](test/screens/about_screen_test.dart)
- Update Sanskrit About title assertion to `expect(find.text('विषयपरिचयः'), findsOneWidget)`.
- Update Malayalam About title assertion to `expect(find.text('ആപ്പിനെക്കുറിച്ച്'), findsOneWidget)`.
- Align mock `PackageInfo` and mock config versions in tests to avoid mismatch logs.

### Documentation
#### [AGENTS.md](AGENTS.md) & [CLAUDE.md](CLAUDE.md)
- Update key parity verification command from `test/l10n/arb_parity_test.dart` to `test/l10n/translation_parity_test.dart`.

---

## 5. Verification Plan

### Automated Tests
1. `flutter gen-l10n` — ensure ARB generation succeeds without errors.
2. `flutter test` — all unit and widget tests pass, including the new `translation_parity_test.dart`.
3. `flutter analyze` — static analysis clean with 0 issues.
4. `dart format .` — ensure formatting matches Dart standards.
