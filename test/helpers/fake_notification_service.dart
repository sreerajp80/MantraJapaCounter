import 'dart:ui' show Locale;

import 'package:mantra_japa_counter/services/notification_service.dart';
import 'package:mantra_japa_counter/services/time_zone_service.dart';

/// Records daily reminder calls instead of reaching the platform.
class FakeNotificationService implements NotificationService {
  FakeNotificationService({this.permissionGranted = true});

  bool permissionGranted;
  int permissionRequests = 0;
  final scheduled =
      <({int minutes, String timeZoneId, String? languageCode})>[];
  int cancelReminderCalls = 0;

  @override
  Future<bool> requestPermissionIfNeeded() async {
    permissionRequests++;
    return permissionGranted;
  }

  @override
  Future<void> scheduleDailyReminder({
    required int minutesAfterMidnight,
    required String timeZoneId,
    Locale? locale,
  }) async {
    scheduled.add((
      minutes: minutesAfterMidnight,
      timeZoneId: timeZoneId,
      languageCode: locale?.languageCode,
    ));
  }

  @override
  Future<void> cancelDailyReminder() async => cancelReminderCalls++;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(invocation.memberName.toString());
}

/// Returns a fixed time-zone name.
class FakeTimeZoneService extends TimeZoneService {
  const FakeTimeZoneService([this.id = 'Asia/Kolkata']);

  final String id;

  @override
  Future<String> getTimeZoneId() async => id;
}
