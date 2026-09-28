import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Controls this app's window brightness.
///
/// [setAppBrightness] applies the user's brightness setting to the app window
/// only; the phone's system brightness is never changed.
///
/// Send mode (Optical Sync) sets the window to 75% brightness and keeps the
/// screen on, so the receiving camera sees a bright, steady code. Turning it
/// off brings back the user's brightness setting. Failures are ignored: the
/// app still works without it.
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
}
