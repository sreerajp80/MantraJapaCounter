import 'package:flutter/services.dart';

/// Native bridge for completion sound and vibration that play regardless of
/// the device's silent / DND / ringer mode.
///
/// Uses ToneGenerator for the built-in mala beep,
/// and VibrationEffect with USAGE_ALARM attributes for vibration. Errors are
/// always swallowed — feedback is best-effort and must never break a count.
///
/// Levels (`volume`, `strength`) are fractions from 0.1 to 1.0. The caller
/// passes them in; this service does not read settings.
class HapticFeedbackService {
  static const _channel = MethodChannel(
    'com.sreerajp.mantrajapacounter/haptic',
  );

  /// Built-in mala-completion beep — a 100ms DTMF tone on the alarm stream
  /// at the given [volume]. No audio asset is shipped; ToneGenerator
  /// synthesises it natively.
  Future<void> playMalaTone({double volume = 1.0}) async {
    try {
      await _channel.invokeMethod<void>('playMalaTone', {'volume': volume});
    } catch (_) {}
  }

  /// 250ms single-pulse vibration at the given [strength] (where supported)
  /// with USAGE_ALARM — plays in silent / DND mode.
  Future<void> vibrateMala({double strength = 1.0}) async {
    try {
      await _channel.invokeMethod<void>('vibrateMala', {'strength': strength});
    } catch (_) {}
  }

  /// Short "click" for one counted tap, at [strength]. Sent by the app
  /// (USAGE_ALARM), so silent mode and the phone's touch vibration setting
  /// don't stop it; the phone's own vibration levels still set the maximum.
  Future<void> tapPulse({double strength = 1.0}) async {
    try {
      await _channel.invokeMethod<void>('vibrateTap', {'strength': strength});
    } catch (_) {}
  }

  /// Two short clicks that confirm an undo, at [strength]. Same rules as
  /// [tapPulse].
  Future<void> undoPulse({double strength = 1.0}) async {
    try {
      await _channel.invokeMethod<void>('vibrateUndo', {'strength': strength});
    } catch (_) {}
  }

  /// Opens the phone's Sound & vibration settings, where the user can turn
  /// vibration on or raise its level. The app cannot change these itself.
  Future<void> openPhoneVibrationSettings() async {
    try {
      await _channel.invokeMethod<void>('openPhoneVibrationSettings');
    } catch (_) {}
  }

  /// Three-pulse vibration (220ms / 90ms / 220ms / 90ms / 220ms) at the
  /// given [strength] with USAGE_ALARM — plays in silent / DND mode. Used
  /// when a goal is reached.
  Future<void> vibrateDailyGoal({double strength = 1.0}) async {
    try {
      await _channel.invokeMethod<void>('vibrateDailyGoal', {
        'strength': strength,
      });
    } catch (_) {}
  }

  /// True when the phone can vibrate at different strengths. False on
  /// error, so the strength setting is hidden when unsure.
  Future<bool> hasAmplitudeControl() async {
    try {
      return await _channel.invokeMethod<bool>('hasAmplitudeControl') ?? false;
    } catch (_) {
      return false;
    }
  }
}
