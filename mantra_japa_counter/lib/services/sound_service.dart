import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

/// One entry in the device's notification ringtone list.
class RingtoneOption {
  final String title;
  final String uri;
  const RingtoneOption({required this.title, required this.uri});
}

/// Plays the configured notification tone for completion events.
///
/// Decoupled from `NotificationService` because Android caches the sound URI
/// inside a notification channel at creation time, so a single channel can't
/// adapt to user-picked tones. Playing audio directly side-steps that.
///
/// All paths route through `USAGE_ALARM` / `STREAM_ALARM` and ask the native
/// side to temporarily boost the alarm volume so completion tones remain
/// audible in silent / DND / very-low-volume modes:
///   * `null` URI → native `RingtoneManager` plays the system default
///     notification tone (the alias `content://settings/system/notification_sound`
///     does not resolve through ExoPlayer); native side applies USAGE_ALARM
///     attrs and the volume boost.
///   * `content://...` URI (a device ringtone picked from the system list) →
///     same native `RingtoneManager` path with the same boost.
///   * Anything else (a real file path picked via `file_picker`) →
///     `audioplayers` `DeviceFileSource` configured with alarm usage, with a
///     paired native boost call so the file is loud enough to hear.
class SoundService {
  static const _channel =
      MethodChannel('com.sreerajp.mantrajapacounter/haptic');

  final AudioPlayer _player = AudioPlayer();

  SoundService() {
    _player.setReleaseMode(ReleaseMode.stop);
    _player.setAudioContext(
      AudioContext(
        android: const AudioContextAndroid(
          contentType: AndroidContentType.sonification,
          usageType: AndroidUsageType.alarm,
          audioFocus: AndroidAudioFocus.gainTransient,
        ),
        iOS: AudioContextIOS(),
      ),
    );
  }

  /// Plays the user's configured tone, or the device default when [uri] is null.
  /// Errors are swallowed — a failed tone must never break a counting session.
  Future<void> playTone(String? uri) async {
    try {
      await _player.stop();
      if (uri == null) {
        await _channel.invokeMethod<void>('previewDefaultNotificationTone');
      } else if (uri.startsWith('content://')) {
        await _channel.invokeMethod<void>('playRingtoneUri', {'uri': uri});
      } else {
        // Native side boosts STREAM_ALARM volume; the audioplayers context
        // above routes the file through USAGE_ALARM so the boost applies.
        // Boost has a built-in auto-restore timer so we don't need to pair
        // it with an explicit restore for arbitrary-length user files.
        try {
          await _channel.invokeMethod<void>('boostAlarmVolume');
        } catch (_) {}
        await _player.play(DeviceFileSource(uri));
      }
    } catch (_) {
      // Tone playback is best-effort; the counter must keep working.
    }
  }

  /// Returns the list of device notification ringtones for the picker UI.
  Future<List<RingtoneOption>> listNotificationRingtones() async {
    try {
      final raw = await _channel
          .invokeMethod<List<dynamic>>('listNotificationRingtones');
      if (raw == null) return const [];
      return raw
          .whereType<Map>()
          .map((m) => RingtoneOption(
                title: (m['title'] as String?) ?? '',
                uri: (m['uri'] as String?) ?? '',
              ))
          .where((r) => r.uri.isNotEmpty && r.title.isNotEmpty)
          .toList(growable: false);
    } catch (_) {
      return const [];
    }
  }

  Future<void> dispose() async {
    try {
      await _channel.invokeMethod<void>('stopPreviewTone');
    } catch (_) {}
    try {
      await _channel.invokeMethod<void>('restoreAlarmVolume');
    } catch (_) {}
    await _player.dispose();
  }
}
