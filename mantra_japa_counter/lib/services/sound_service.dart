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
/// Three playback paths:
///   * `null` URI → native `RingtoneManager` plays the system default
///     notification tone (the alias `content://settings/system/notification_sound`
///     does not resolve through ExoPlayer).
///   * `content://...` URI (a device ringtone picked from the system list) →
///     native `RingtoneManager.getRingtone(uri)`.
///   * Anything else (a real file path picked via `file_picker`) →
///     `audioplayers` `DeviceFileSource`.
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
          usageType: AndroidUsageType.notification,
          audioFocus: AndroidAudioFocus.none,
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
    await _player.dispose();
  }
}
