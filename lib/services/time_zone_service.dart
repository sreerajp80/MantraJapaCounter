import 'package:flutter/services.dart';
import 'package:mantra_japa_counter/core/logging/app_logger.dart';

/// Reads the phone's time-zone name (for example `Asia/Kolkata`) from the
/// native side, so the daily reminder fires at the right local time.
///
/// Uses the existing screen channel in `MainActivity.kt`; no extra plugin.
/// Falls back to `'UTC'` when the name cannot be read.
class TimeZoneService {
  const TimeZoneService({this.channel = _defaultChannel});

  static const MethodChannel _defaultChannel = MethodChannel(
    'com.sreerajp.mantrajapacounter/screen',
  );

  static const String fallbackTimeZoneId = 'UTC';

  final MethodChannel channel;

  Future<String> getTimeZoneId() async {
    try {
      final id = await channel.invokeMethod<String>('getTimeZoneId');
      return (id == null || id.isEmpty) ? fallbackTimeZoneId : id;
    } on MissingPluginException catch (_) {
      return fallbackTimeZoneId;
    } on PlatformException catch (e) {
      AppLogger.warning('TimeZoneService: read time zone failed (${e.code})');
      return fallbackTimeZoneId;
    }
  }
}
