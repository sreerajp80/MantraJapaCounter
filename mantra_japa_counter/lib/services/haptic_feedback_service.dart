import 'package:flutter/services.dart';

/// Native bridge for completion sound and vibration that play regardless of
/// the device's silent / DND / ringer mode.
///
/// Mirrors the original Kotlin app: ToneGenerator for the built-in mala beep,
/// and VibrationEffect with USAGE_ALARM attributes for vibration. Errors are
/// always swallowed — feedback is best-effort and must never break a count.
class HapticFeedbackService {
  static const _channel =
      MethodChannel('com.sreerajp.mantrajapacounter/haptic');

  /// Built-in mala-completion beep — a 100ms DTMF tone at max volume on the
  /// notification stream. No audio asset is shipped; ToneGenerator synthesises
  /// it natively.
  Future<void> playMalaTone() async {
    try {
      await _channel.invokeMethod<void>('playMalaTone');
    } catch (_) {}
  }

  /// 250ms single-pulse vibration at max amplitude (where supported) with
  /// USAGE_ALARM — plays in silent / DND mode.
  Future<void> vibrateMala() async {
    try {
      await _channel.invokeMethod<void>('vibrateMala');
    } catch (_) {}
  }

  /// Three-pulse vibration (220ms / 90ms / 220ms / 90ms / 220ms) at max
  /// amplitude with USAGE_ALARM — plays in silent / DND mode. Used when
  /// the daily goal is reached.
  Future<void> vibrateDailyGoal() async {
    try {
      await _channel.invokeMethod<void>('vibrateDailyGoal');
    } catch (_) {}
  }
}
