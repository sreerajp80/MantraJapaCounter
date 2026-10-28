import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:mantra_japa_counter/core/flavor/flavor_config.dart';

/// Log levels (engineering standard §14.1), with `dart:developer` level numbers.
enum LogLevel {
  trace(300),
  debug(500),
  info(800),
  warning(900),
  error(1000),
  fatal(1200);

  const LogLevel(this.value);
  final int value;
}

/// The app's one logger (engineering standard §14). Use it instead of
/// `print` / `debugPrint`.
///
/// - Writes to the developer log only. There is no log file: the app is
///   offline and keeps nothing it does not need.
/// - `trace` and `debug` print nothing in prod builds.
/// - Only the error **type** is written, never its message, because a
///   message can hold user data (§14.3). Never pass counter names, counts,
///   notes or other private values in [message].
class AppLogger {
  AppLogger._();

  static const _name = 'MantraJapaCounter';

  /// Replaced in tests to capture what would be written.
  @visibleForTesting
  static void Function(String message, LogLevel level, StackTrace? stackTrace)
  sink = _developerLog;

  static void trace(String message) => _devOnly(message, LogLevel.trace);
  static void debug(String message) => _devOnly(message, LogLevel.debug);
  static void info(String message) => _write(message, LogLevel.info);

  static void warning(String message, {Object? error}) =>
      _write(_withType(message, error), LogLevel.warning);

  static void error(String message, {Object? error, StackTrace? stackTrace}) =>
      _write(_withType(message, error), LogLevel.error, stackTrace);

  static void fatal(String message, {Object? error, StackTrace? stackTrace}) =>
      _write(_withType(message, error), LogLevel.fatal, stackTrace);

  static void _devOnly(String message, LogLevel level) {
    if (AppFlavorConfig.enableVerboseLogging) _write(message, level);
  }

  static String _withType(String message, Object? error) =>
      error == null ? message : '$message (${error.runtimeType})';

  static void _write(String message, LogLevel level, [StackTrace? stackTrace]) {
    try {
      sink(message, level, stackTrace);
    } catch (_) {
      // Logging must never break the app.
    }
  }

  static void _developerLog(
    String message,
    LogLevel level,
    StackTrace? stackTrace,
  ) {
    developer.log(
      message,
      name: _name,
      level: level.value,
      stackTrace: stackTrace,
    );
  }
}
