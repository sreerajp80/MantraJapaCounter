import 'package:flutter/material.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/l10n/sa_material_localizations.dart';

export 'package:mantra_japa_counter/l10n/sa_material_localizations.dart';

/// Locale policy:
/// - By default, the app follows the system language.
/// - If the system language is Malayalam ('ml') -> Malayalam.
/// - If the system language is Sanskrit ('sa') -> Sanskrit.
/// - Anything else -> English fallback.
/// - Users can also explicitly choose English, Malayalam, or Sanskrit in-app.
class LocaleConfig {
  LocaleConfig._();

  static const Locale english = Locale('en');
  static const Locale malayalam = Locale('ml');
  static const Locale sanskrit = Locale('sa');

  static const List<Locale> supportedLocales = [english, malayalam, sanskrit];

  /// Currently active locale cached for context-free lookups.
  static Locale? activeLocale;

  /// Maps an arbitrary device locale onto one of the supported locales.
  /// Malayalam -> ml, Sanskrit -> sa, any other -> en.
  static Locale resolve(Locale? deviceLocale) {
    final code = deviceLocale?.languageCode.toLowerCase();
    if (code == 'ml') return malayalam;
    if (code == 'sa') return sanskrit;
    return english;
  }

  /// Resolves the app locale taking into account an explicit user preference.
  /// If [languageCode] is null or 'system', adheres to [deviceLocale].
  static Locale resolveAppLocale({
    required String? languageCode,
    required Locale? deviceLocale,
  }) {
    final code = languageCode?.toLowerCase();
    if (code == 'en') return english;
    if (code == 'ml') return malayalam;
    if (code == 'sa') return sanskrit;
    return resolve(deviceLocale);
  }

  /// [MaterialApp.localeResolutionCallback] implementation. Honors the device
  /// locale when supported (ml, sa), otherwise English.
  static Locale localeResolution(
    Locale? deviceLocale,
    Iterable<Locale> supported,
  ) => resolve(deviceLocale);

  /// Context-free lookup for code that runs outside the widget tree (e.g. the
  /// notification service).
  static AppLocalizations strings([Locale? locale]) {
    if (locale != null) return lookupAppLocalizations(locale);
    if (activeLocale != null) return lookupAppLocalizations(activeLocale!);
    final device = WidgetsBinding.instance.platformDispatcher.locale;
    return lookupAppLocalizations(resolve(device));
  }
}

/// Backwards-compatible aliases for Sanskrit delegates
typedef FallbackMaterialLocalizationsDelegate = SaMaterialLocalizationsDelegate;
typedef FallbackCupertinoLocalizationsDelegate =
    SaCupertinoLocalizationsDelegate;
