import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Controls this app's window brightness.
///
/// [setAppBrightness] applies the user's brightness setting to the app window
/// only; the phone's system brightness is never changed.
///
/// Send mode (Optical Sync) keeps the screen on at the normal brightness.
/// While it is on, [setSendBrightness] can make the screen brighter for the
/// receiving camera. Turning send mode off drops that boost and brings back
/// the user's brightness setting. Failures are ignored: the app still works
/// without it.
class ScreenService {
  const ScreenService({this.channel = _defaultChannel});

  static const MethodChannel _defaultChannel = MethodChannel(
    'com.sreerajp.mantrajapacounter/screen',
  );

  final MethodChannel channel;

  Future<void> setSendMode(bool on) async {
    try {
      await channel.invokeMethod<void>('setSendMode', <String, dynamic>{
        'on': on,
      });
    } on MissingPluginException catch (_) {
      // No native side (tests, other platforms): nothing to do.
    } on PlatformException catch (e) {
      debugPrint('ScreenService: send mode failed (${e.code})');
    }
  }

  /// Sets the app window brightness, from 0.0 (dimmest) to 1.0 (full).
  /// A negative value follows the system brightness.
  Future<void> setAppBrightness(double value) async {
    try {
      await channel.invokeMethod<void>('setAppBrightness', <String, dynamic>{
        'value': value,
      });
    } on MissingPluginException catch (_) {
      // No native side (tests, other platforms): nothing to do.
    } on PlatformException catch (e) {
      debugPrint('ScreenService: brightness failed (${e.code})');
    }
  }

  /// Sets the window brightness while sending, from 0.0 to 1.0. A negative
  /// value goes back to the normal brightness. Has no effect when send mode
  /// is off.
  Future<void> setSendBrightness(double value) async {
    try {
      await channel.invokeMethod<void>('setSendBrightness', <String, dynamic>{
        'value': value,
      });
    } on MissingPluginException catch (_) {
      // No native side (tests, other platforms): nothing to do.
    } on PlatformException catch (e) {
      debugPrint('ScreenService: send brightness failed (${e.code})');
    }
  }

  /// The normal screen brightness, from 0.0 to 1.0. Returns [fallback] when
  /// it cannot be read.
  Future<double> getCurrentBrightness({double fallback = 0.5}) async {
    try {
      final value = await channel.invokeMethod<double>('getCurrentBrightness');
      return (value ?? fallback).clamp(0.0, 1.0);
    } on MissingPluginException catch (_) {
      return fallback;
    } on PlatformException catch (e) {
      debugPrint('ScreenService: read brightness failed (${e.code})');
      return fallback;
    }
  }
}
