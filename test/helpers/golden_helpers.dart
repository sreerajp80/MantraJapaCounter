import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:mantra_japa_counter/core/locale/locale_config.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/theme/theme.dart';

/// Helpers for golden (reference image) tests.
///
/// Golden images are made on Windows and must only be updated on Windows,
/// because text is drawn slightly differently on each operating system.
/// See docs/release_process.md section 16.

/// Fixed phone-sized surface used by every golden test.
const Size goldenSurfaceSize = Size(411, 891);

bool _fontsLoaded = false;

/// Loads every font listed in the app's font manifest (EB Garamond, Inter,
/// Noto Sans Malayalam and the Material icon font).
///
/// Without this, Flutter tests draw all text as plain boxes, which would hide
/// font and spacing changes.
Future<void> loadAppFonts() async {
  if (_fontsLoaded) return;
  final manifestJson = await rootBundle.loadString('FontManifest.json');
  final manifest = jsonDecode(manifestJson) as List<dynamic>;
  for (final entry in manifest.cast<Map<String, dynamic>>()) {
    final family = entry['family'] as String;
    final loader = FontLoader(family);
    for (final font in (entry['fonts'] as List<dynamic>)) {
      final asset = (font as Map<String, dynamic>)['asset'] as String;
      loader.addFont(rootBundle.load(asset));
    }
    await loader.load();
  }
  _fontsLoaded = true;
}

/// Sets the test surface to [goldenSurfaceSize] at pixel ratio 1.0, and
/// resets it when the test ends.
void setGoldenSurface(WidgetTester tester, {Size size = goldenSurfaceSize}) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

/// Wraps [child] in a [MaterialApp] with the real app theme, the app's
/// localization delegates and a fixed [locale].
Widget goldenApp(Widget child, {Locale locale = const Locale('en')}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light(),
    locale: locale,
    localizationsDelegates: LocaleConfig.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  );
}
