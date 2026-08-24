import 'package:flutter/widgets.dart';
import '../l10n/app_localizations.dart';

/// Locale policy: the app follows the device language. Malayalam devices get
/// Malayalam; every other locale falls back to English. There is no in-app
/// language picker.
class LocaleConfig {
  LocaleConfig._();

  static const Locale english = Locale('en');
  static const Locale malayalam = Locale('ml');

  /// Maps an arbitrary device locale onto one of the two supported locales.
  static Locale resolve(Locale? deviceLocale) {
    if (deviceLocale?.languageCode == 'ml') return malayalam;
    return english;
  }

  /// [MaterialApp.localeResolutionCallback] implementation. Honors the device
  /// locale when supported, otherwise English.
  static Locale localeResolution(
    Locale? deviceLocale,
    Iterable<Locale> supported,
  ) => resolve(deviceLocale);

  /// Context-free lookup for code that runs outside the widget tree (e.g. the
  /// notification service). Resolves against the current platform locale.
  static AppLocalizations strings() {
    final device = WidgetsBinding.instance.platformDispatcher.locale;
    return lookupAppLocalizations(resolve(device));
  }
}
