import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mantra_japa_counter/repositories/japa_counter_repository.dart';
import 'package:mantra_japa_counter/repositories/settings_repository.dart';
import 'package:mantra_japa_counter/services/counting_service.dart';
import 'package:mantra_japa_counter/services/export_service.dart';
import 'package:mantra_japa_counter/services/haptic_feedback_service.dart';
import 'package:mantra_japa_counter/services/notification_service.dart';
import 'package:mantra_japa_counter/services/session_recovery_service.dart';
import 'package:mantra_japa_counter/services/sound_service.dart';

// ──────────────────────────── Infrastructure providers ──────────────────────
// These are overridden at the root ProviderScope in main.dart with the
// already-initialised instances.

final databaseProvider = Provider<Database>((ref) {
  throw UnimplementedError(
    'Override databaseProvider in main.dart ProviderScope',
  );
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'Override sharedPreferencesProvider in main.dart ProviderScope',
  );
});

final notificationsPluginProvider = Provider<FlutterLocalNotificationsPlugin>((
  ref,
) {
  throw UnimplementedError(
    'Override notificationsPluginProvider in main.dart ProviderScope',
  );
});

// ──────────────────────────── Repository providers ──────────────────────────

final japaCounterRepositoryProvider = Provider<JapaCounterRepository>((ref) {
  return JapaCounterRepository(ref.watch(databaseProvider));
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(sharedPreferencesProvider));
});

// ──────────────────────────── Service providers ──────────────────────────────

final countingServiceProvider = Provider<CountingService>((ref) {
  return CountingService(
    ref.watch(japaCounterRepositoryProvider),
    ref.watch(settingsRepositoryProvider),
  );
});

final exportServiceProvider = Provider<ExportService>((ref) {
  return ExportService(ref.watch(japaCounterRepositoryProvider));
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(ref.watch(notificationsPluginProvider));
});

final soundServiceProvider = Provider<SoundService>((ref) {
  final svc = SoundService();
  ref.onDispose(svc.dispose);
  return svc;
});

final hapticFeedbackServiceProvider = Provider<HapticFeedbackService>((ref) {
  return HapticFeedbackService();
});

final sessionRecoveryServiceProvider = Provider<SessionRecoveryService>((ref) {
  return SessionRecoveryService(
    ref.watch(japaCounterRepositoryProvider),
    ref.watch(settingsRepositoryProvider),
  );
});
