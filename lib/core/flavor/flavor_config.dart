import 'package:flutter/foundation.dart';

/// Runtime flavor configuration. Flutter (>= 3.19) auto-populates the
/// `FLUTTER_APP_FLAVOR` dart-define from the `--flavor <flavor>` build arg.
enum AppFlavor { dev, prod }

class AppFlavorConfig {
  static AppFlavor _flavor = AppFlavor.prod;

  static void init() {
    const flavorStr = String.fromEnvironment(
      'FLUTTER_APP_FLAVOR',
      defaultValue: 'prod',
    );
    _flavor = flavorStr == 'dev' ? AppFlavor.dev : AppFlavor.prod;
  }

  @visibleForTesting
  static void setFlavorForTesting(AppFlavor flavor) {
    _flavor = flavor;
  }

  static AppFlavor get flavor => _flavor;

  static bool get isDev => _flavor == AppFlavor.dev;
  static bool get isProd => _flavor == AppFlavor.prod;

  static bool get enableVerboseLogging => _flavor == AppFlavor.dev;

  /// Added to the localized app name (`appName` in app_config.json,
  /// guideline.md §1.8). Never hard-code the app name itself here.
  static String get nameSuffix => _flavor == AppFlavor.dev ? ' Dev' : '';

  static String get packageId => _flavor == AppFlavor.dev
      ? 'com.sreerajp.mantrajapacounter.dev'
      : 'com.sreerajp.mantrajapacounter';
}
