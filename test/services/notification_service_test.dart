import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:mantra_japa_counter/core/constants/app_constants.dart';
import 'package:mantra_japa_counter/core/locale/locale_config.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/services/notification_service.dart';

/// Records `show` / `zonedSchedule` / `cancel` / `cancelAll` calls instead
/// of reaching the platform.
class _FakePlugin implements FlutterLocalNotificationsPlugin {
  final shown = <({int id, String? title, String? body, String? channel})>[];
  final scheduled =
      <
        ({
          int id,
          String? title,
          String? body,
          String? channel,
          tz.TZDateTime date,
          AndroidScheduleMode mode,
          DateTimeComponents? match,
        })
      >[];
  final cancelled = <int>[];
  int cancelAllCalls = 0;

  @override
  Future<void> zonedSchedule({
    required int id,
    required tz.TZDateTime scheduledDate,
    required NotificationDetails notificationDetails,
    required AndroidScheduleMode androidScheduleMode,
    String? title,
    String? body,
    String? payload,
    DateTimeComponents? matchDateTimeComponents,
  }) async {
    scheduled.add((
      id: id,
      title: title,
      body: body,
      channel: notificationDetails.android?.channelId,
      date: scheduledDate,
      mode: androidScheduleMode,
      match: matchDateTimeComponents,
    ));
  }

  @override
  Future<void> cancel({required int id, String? tag}) async =>
      cancelled.add(id);

  @override
  Future<void> show({
    required int id,
    String? title,
    String? body,
    NotificationDetails? notificationDetails,
    String? payload,
  }) async {
    shown.add((
      id: id,
      title: title,
      body: body,
      channel: notificationDetails?.android?.channelId,
    ));
  }

  @override
  Future<void> cancelAll() async => cancelAllCalls++;

  @override
  T? resolvePlatformSpecificImplementation<
    T extends FlutterLocalNotificationsPlatform
  >() => null;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(invocation.memberName.toString());
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakePlugin plugin;
  late NotificationService service;
  final en = lookupAppLocalizations(const Locale('en'));

  setUp(() {
    LocaleConfig.activeLocale = const Locale('en');
    plugin = _FakePlugin();
    service = NotificationService(plugin);
  });

  tearDown(() => LocaleConfig.activeLocale = null);

  test('daily goal alert uses the daily goal channel and strings', () async {
    await service.notifyDailyGoalReached();

    expect(plugin.shown, hasLength(1));
    final n = plugin.shown.single;
    expect(n.id, 1);
    expect(n.channel, AppConstants.dailyGoalChannelId);
    expect(n.title, en.notifDailyGoalTitle);
    expect(n.body, en.notifDailyGoalBody);
  });

  test('lifetime goal alert uses the lifetime goal channel', () async {
    await service.notifyLifetimeGoalReached();

    final n = plugin.shown.single;
    expect(n.id, 2);
    expect(n.channel, AppConstants.lifetimeGoalChannelId);
    expect(n.title, en.notifLifetimeGoalTitle);
    expect(n.body, en.notifLifetimeGoalBody);
  });

  test('alerts follow the active app language', () async {
    LocaleConfig.activeLocale = const Locale('ml');
    await service.notifyDailyGoalReached();

    final ml = lookupAppLocalizations(const Locale('ml'));
    expect(plugin.shown.single.title, ml.notifDailyGoalTitle);
  });

  test('cancelAll clears notifications', () async {
    await service.cancelAll();
    expect(plugin.cancelAllCalls, 1);
  });

  test('permission check passes when there is no Android plugin', () async {
    expect(await service.requestPermissionIfNeeded(), isTrue);
  });

  group('daily reminder', () {
    test('schedules a daily, inexact reminder on its own channel', () async {
      await service.scheduleDailyReminder(
        minutesAfterMidnight: 6 * 60 + 30,
        timeZoneId: 'Asia/Kolkata',
      );

      final n = plugin.scheduled.single;
      expect(n.id, AppConstants.dailyReminderNotificationId);
      expect(n.id, 3);
      expect(n.channel, AppConstants.dailyReminderChannelId);
      expect(n.mode, AndroidScheduleMode.inexactAllowWhileIdle);
      expect(n.match, DateTimeComponents.time);
      expect(n.title, en.notifDailyReminderTitle);
      expect(n.body, en.notifDailyReminderBody);
      expect(n.date.location.name, 'Asia/Kolkata');
      expect(n.date.hour, 6);
      expect(n.date.minute, 30);
      expect(n.date.isAfter(tz.TZDateTime.now(n.date.location)), isTrue);
    });

    test('uses the given language for the text', () async {
      await service.scheduleDailyReminder(
        minutesAfterMidnight: 360,
        timeZoneId: 'UTC',
        locale: const Locale('sa'),
      );

      final sa = lookupAppLocalizations(const Locale('sa'));
      expect(plugin.scheduled.single.title, sa.notifDailyReminderTitle);
    });

    test('falls back to UTC for an unknown time zone', () async {
      await service.scheduleDailyReminder(
        minutesAfterMidnight: 360,
        timeZoneId: 'Not/AZone',
      );
      expect(plugin.scheduled.single.date.location, tz.UTC);
    });

    test('accepts older time-zone names such as Asia/Calcutta', () {
      final location = NotificationService.reminderLocation('Asia/Calcutta');
      expect(location.name, 'Asia/Calcutta');
    });

    test('cancel removes only the reminder', () async {
      await service.cancelDailyReminder();
      expect(plugin.cancelled, [AppConstants.dailyReminderNotificationId]);
      expect(plugin.cancelAllCalls, 0);
    });

    test('next time is later today when the time has not passed', () {
      final utc = NotificationService.reminderLocation('UTC');
      final now = tz.TZDateTime(utc, 2026, 10, 22, 5);
      final next = NotificationService.nextReminderTime(now, 360);
      expect(next, tz.TZDateTime(utc, 2026, 10, 22, 6));
    });

    test('next time is tomorrow when the time has passed or is now', () {
      final utc = NotificationService.reminderLocation('UTC');
      final now = tz.TZDateTime(utc, 2026, 10, 31, 6);
      final next = NotificationService.nextReminderTime(now, 360);
      expect(next, tz.TZDateTime(utc, 2026, 11, 1, 6));
    });
  });
}
