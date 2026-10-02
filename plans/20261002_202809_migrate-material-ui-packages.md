# Plan: Migrate to the standalone material_ui and cupertino_ui packages

**Status:** completed

## The issue

From Flutter 3.47, Material and Cupertino widgets are moving out of the Flutter SDK
into two normal pub.dev packages:

| Old import (inside the SDK) | New import (separate package) |
|---|---|
| `package:flutter/material.dart` | `package:material_ui/material_ui.dart` |
| `package:flutter/cupertino.dart` | `package:cupertino_ui/cupertino_ui.dart` |

The SDK copies are frozen. Nothing new has been added to them since Flutter 3.44, and
Flutter plans to deprecate them in a later stable release. Today the app imports the old
libraries in 69 files. Once the deprecation lands, `flutter analyze` will report
warnings, which breaks our "0 warnings" rule. Moving now means:

- Material bug fixes come from `flutter pub upgrade` (planned weekly releases), with no
  full SDK upgrade needed.
- The Material version is pinned in `pubspec.yaml` and `pubspec.lock`, like any other
  dependency.
- We do the move calmly now, instead of being forced into it later.

## Facts checked before writing this plan

- Flutter 3.47.6 / Dart 3.13.5 is installed. The `migrate_design_widgets` lint rule and
  its `dart fix` are available.
- `material_ui` (1.5.0) and `cupertino_ui` (1.1.1) are **already in `pubspec.lock`** as
  indirect dependencies. A dry run of `flutter pub add` changes only these two entries,
  from indirect to direct. No other package versions change.
- None of our UI dependencies (go_router, flutter_riverpod, qr_flutter, share_plus,
  file_picker, camera) import `flutter/material.dart` in their `lib/` code. So
  `MaterialUiCompatibilityBridge` should not be needed.
- No new network code or prohibited dependency is added. Both packages are pure UI
  code from the Flutter team.

## Key risk: never mix old and new imports

Dart treats `Theme` from `flutter/material.dart` and `Theme` from `material_ui` as two
**different types**, even though they have the same name. So the whole app (lib and
test) must move in **one change**. After the change, no file may import the old
libraries. We will enforce this with the lint rule (step 7).

The localization code has the highest risk of mixing types:

- `lib/l10n/app_localizations.dart` is **generated** by `flutter gen-l10n`, and it
  imports `flutter_localizations`. We must check which import the 3.47 generator now
  writes. If it still uses the old `GlobalMaterialLocalizations` from
  `flutter_localizations`, those delegates would give old-type `MaterialLocalizations`
  to a new-type `MaterialApp`. Material widgets would then fail to find their
  localizations at runtime.
- `lib/l10n/sa_material_localizations.dart` (our Sanskrit fallback delegates) uses
  `GlobalMaterialLocalizations`, `GlobalCupertinoLocalizations` and
  `GlobalWidgetsLocalizations` from `flutter_localizations`. These now live in
  `material_ui` / `cupertino_ui`.

**Stop rule:** if, after step 4, the generated file still produces old-type delegates
and there is no clean fix (a newer gen-l10n option, or switching to the new
`GlobalMaterialLocalizations.delegates`), I will stop, report back, and set this plan to
`partial_completion` (or revert it to the start), rather than ship a mixed setup.

## Files to be changed

### Config
- `pubspec.yaml` — add `material_ui` and `cupertino_ui` as direct dependencies. Keep
  `flutter_localizations` only if gen-l10n still needs it (decided in step 4).
- `pubspec.lock` — updated by pub (the two entries change from indirect to direct).
- `analysis_options.yaml` — add the `migrate_design_widgets: true` lint rule.

### Localization (manual review)
- `lib/l10n/sa_material_localizations.dart` — move to the new packages' localization
  classes.
- `lib/l10n/app_localizations.dart` — regenerated only (never edited by hand).
- `lib/main.dart` — the `localizationsDelegates` list may need small changes if the
  delegate names change.
- `lib/core/locale/locale_config.dart` — check the typedefs to the Sa delegates. Change
  only if needed.

### Docs
- `docs/architecture.md` — note that Material/Cupertino now come from `material_ui` /
  `cupertino_ui`, not the SDK.
- `CLAUDE.md` — add a short note under "Code style / naming": import
  `package:material_ui/material_ui.dart`, never `package:flutter/material.dart`.
- `docs/guidelines/` is a shared submodule. **It will not be changed here.**

### Import rewrite (done by `dart fix`, one import line per file)
- `lib/core/locale/locale_config.dart`
- `lib/core/routing/router.dart`
- `lib/l10n/sa_material_localizations.dart`
- `lib/main.dart`
- `lib/screens/about_counter_screen.dart`
- `lib/screens/about_screen.dart`
- `lib/screens/appearance_screen.dart`
- `lib/screens/counter_list/counter_dialog.dart`
- `lib/screens/counter_list/counter_list_empty_state.dart`
- `lib/screens/counter_list/counter_list_header.dart`
- `lib/screens/counter_list/counter_list_item.dart`
- `lib/screens/counter_list/counter_list_screen.dart`
- `lib/screens/counter_list/counter_options_sheet.dart`
- `lib/screens/counter_list/import_export_dialog.dart`
- `lib/screens/counting_screen.dart`
- `lib/screens/features_screen.dart`
- `lib/screens/help/backup_help_screen.dart`
- `lib/screens/help/counting_help_screen.dart`
- `lib/screens/help/faq_help_screen.dart`
- `lib/screens/help/help_home_screen.dart`
- `lib/screens/help/help_widgets.dart`
- `lib/screens/help/mala_math_help_screen.dart`
- `lib/screens/help/optical_sync_help_screen.dart`
- `lib/screens/help/privacy_offline_help_screen.dart`
- `lib/screens/help/sound_haptics_help_screen.dart`
- `lib/screens/help/tutorial_help_screen.dart`
- `lib/screens/help_screen.dart`
- `lib/screens/history/history_day_group.dart`
- `lib/screens/history/history_hero.dart`
- `lib/screens/history/history_screen.dart`
- `lib/screens/history/history_session_row.dart`
- `lib/screens/history/sadhana_flow_card.dart`
- `lib/screens/optical_sync_screen.dart`
- `lib/screens/settings/backup_settings_screen.dart`
- `lib/screens/settings/display_settings_screen.dart`
- `lib/screens/settings/language_picker.dart`
- `lib/screens/settings/language_settings_screen.dart`
- `lib/screens/settings/mala_sound_picker.dart`
- `lib/screens/settings/notification_sound_picker.dart`
- `lib/screens/settings/permissions_screen.dart`
- `lib/screens/settings/settings_brightness_row.dart`
- `lib/screens/settings/settings_info_cards.dart`
- `lib/screens/settings/settings_screen.dart`
- `lib/screens/settings/settings_tiles.dart`
- `lib/screens/settings/sound_settings_screen.dart`
- `lib/theme/theme.dart`
- `lib/widgets/circular_progress_widget.dart`
- `lib/widgets/counter_card.dart`
- `lib/widgets/counter_selection_sheet.dart`
- `lib/widgets/goal_progress_bar.dart`
- `lib/widgets/made_with_love.dart`
- `lib/widgets/mala_count_display.dart`
- `lib/widgets/optical_sync_import_preview_sheet.dart`
- `lib/widgets/passphrase_dialog.dart`
- `lib/widgets/qr_camera_view.dart`
- `lib/widgets/session_list_tile.dart`
- `lib/widgets/temple_decorations.dart`
- `lib/widgets/temple_mala_circle.dart`
- `test/core/locale/locale_config_test.dart`
- `test/screens/about_screen_test.dart`
- `test/screens/appearance_screen_test.dart`
- `test/screens/counter_list_screen_test.dart`
- `test/screens/features_screen_test.dart`
- `test/screens/help_screen_test.dart`
- `test/screens/history_screen_test.dart`
- `test/screens/settings_screen_test.dart`
- `test/screens/sound_settings_screen_test.dart`
- `test/screens/tutorial_help_screen_test.dart`
- `test/widgets/counter_card_test.dart`

## Steps

1. Run `flutter pub add material_ui cupertino_ui`.
2. Run `dart fix --apply --code=migrate_design_widgets`. This rewrites the imports in
   the files listed above.
3. Search `lib/` and `test/` for any leftover `package:flutter/material.dart` or
   `package:flutter/cupertino.dart` imports, and fix them.
4. Run `flutter gen-l10n`. Check the imports and delegates in the regenerated
   `lib/l10n/app_localizations.dart`. Apply the stop rule above if needed.
5. Update `lib/l10n/sa_material_localizations.dart` (and `main.dart` /
   `locale_config.dart` if needed) so that every delegate gives the new-package types.
   Keep the Sanskrit-to-English fallback behaviour exactly the same.
6. Run `dart fix --apply` (no code filter) to tidy follow-up issues, such as import
   order and unused imports. Then run `dart format .`.
7. Add `migrate_design_widgets: true` to `analysis_options.yaml`, under a new
   `# Design libraries` comment.
8. Run `flutter analyze` (must be 0 issues) and `flutter test` (must all pass).
9. Do a manual check on a device with `flutter run --flavor dev`:
   - Switch the language to English, Malayalam and Sanskrit. In each one, open a
     dialog, the date picker (History), and a long-press text selection menu. These
     are the Material-localized widgets.
   - Check that the theme, colours, dark mode and app bars look the same as before.
   - Count in the counting screen, then exit and re-open the app to confirm that saving
     still works.
10. Update the docs (`docs/architecture.md`, `CLAUDE.md`).
11. Write the change log in `change_log/` and set this plan to `completed`.

## Out of scope

- No behaviour or UI changes.
- No upgrades of other packages.
- The `cupertino_icons` package stays as it is (it only provides an icon font).

## Notes

- Keep this as its own commit, separate from the other uncommitted work (AGP 9 upgrade,
  file_picker 13). That way it can be reverted alone if needed.
