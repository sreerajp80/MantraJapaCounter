/// Runtime flavor configuration. Flutter (>= 3.19) auto-populates the
/// `FLUTTER_APP_FLAVOR` dart-define from the `--flavor <flavor>` build arg.
enum AppFlavor { dev, prod }

class AppFlavorConfig {
  static AppFlavor _flavor = AppFlavor.prod;

  static void init() {
    const flavorStr = String.fromEnvironment('FLUTTER_APP_FLAVOR', defaultValue: 'prod');
    _flavor = flavorStr == 'dev' ? AppFlavor.dev : AppFlavor.prod;
  }

  static AppFlavor get flavor => _flavor;

  static bool get isDev => _flavor == AppFlavor.dev;
  static bool get isProd => _flavor == AppFlavor.prod;

  static bool get enableVerboseLogging => _flavor == AppFlavor.dev;

  static String get appName =>
      _flavor == AppFlavor.dev ? 'SreerajP MantraJapa Counter Dev' : 'SreerajP MantraJapa Counter';

  static String get packageId => _flavor == AppFlavor.dev
      ? 'com.sreerajp.mantrajapacounter.dev'
      : 'com.sreerajp.mantrajapacounter';
}
