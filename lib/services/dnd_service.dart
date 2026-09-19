import 'package:flutter/services.dart';

/// Native bridge for Android Do Not Disturb (DND) mode.
///
/// Silences incoming notifications and phone alerts during active chanting
/// sessions so users are not interrupted and incoming heads-up banners do
/// not block the mala counting area.
class DndService {
  static const _channel = MethodChannel(
    'com.sreerajp.mantrajapacounter/haptic',
  );

  /// Checks if the app has been granted Do Not Disturb policy access.
  Future<bool> isDndAccessGranted() async {
    try {
      final granted = await _channel.invokeMethod<bool>('isDndAccessGranted');
      return granted ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Opens the system Android Do Not Disturb access settings page.
  Future<void> openDndSettings() async {
    try {
      await _channel.invokeMethod<void>('openDndSettings');
    } catch (_) {}
  }

  /// Enables or disables Do Not Disturb mode on the device.
  ///
  /// Returns true if successfully applied, false if permission was missing or failed.
  Future<bool> setDndEnabled(bool enabled) async {
    try {
      final success = await _channel.invokeMethod<bool>('setDndEnabled', {
        'enabled': enabled,
      });
      return success ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Restores the device's previous interruption filter.
  Future<void> restoreDnd() async {
    try {
      await _channel.invokeMethod<void>('restoreDnd');
    } catch (_) {}
  }
}
