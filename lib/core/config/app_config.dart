/// Typed values for the About screen, loaded from `assets/config/app_config.json`.
/// Changing About content is a config edit, not a code change.
class AppConfig {
  final String appName;
  final String description;
  final String version;
  final String build;
  final Map<String, String> details;

  const AppConfig({
    required this.appName,
    required this.description,
    required this.version,
    required this.build,
    this.details = const {},
  });

  /// Safe built-in value used when the config file is missing or malformed,
  /// so the app never crashes on a bad config.
  static const AppConfig fallback = AppConfig(
    appName: 'SreerajP MantraJapa Counter',
    description:
        'Offline-first application for tracking mantra recitation practice.',
    version: '0.0.0',
    build: '0',
    details: {'License': 'All libraries used are open source.'},
  );

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    String str(String key, String fallbackValue) {
      final value = json[key];
      return value is String ? value : fallbackValue;
    }

    Map<String, String> parseStringMap(String key) {
      final raw = json[key];
      if (raw is! Map) return const {};
      final out = <String, String>{};
      raw.forEach((k, v) {
        if (k is String && v is String) out[k] = v;
      });
      return out;
    }

    return AppConfig(
      appName: str('appName', fallback.appName),
      description: str('description', fallback.description),
      version: str('version', fallback.version),
      build: str('build', fallback.build),
      details: parseStringMap('details'),
    );
  }
}
