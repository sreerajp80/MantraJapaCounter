import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mantra_japa_counter/core/locale/locale_config.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';
import 'package:mantra_japa_counter/providers/settings_provider.dart';
import 'package:mantra_japa_counter/repositories/settings_repository.dart';
import 'package:mantra_japa_counter/screens/settings/sound_settings_screen.dart';

import '../helpers/fake_japa_counter_repository.dart';
import '../helpers/fake_notification_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late FakeJapaCounterRepository repo;
  late FakeNotificationService notifications;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repo = FakeJapaCounterRepository();
    notifications = FakeNotificationService();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('xyz.luan/audioplayers.global'),
          (call) async => null,
        );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('xyz.luan/audioplayers'),
          (call) async => null,
        );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('com.sreerajp.mantrajapacounter/haptic'),
          (call) async {
            if (call.method == 'listNotificationRingtones') {
              return [
                {'title': 'System Bell', 'uri': 'content://media/1'},
              ];
            }
            return null;
          },
        );
  });

  Future<void> pumpSoundSettings(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(
            SettingsRepository(prefs),
          ),
          japaCounterRepositoryProvider.overrideWithValue(repo),
          notificationServiceProvider.overrideWithValue(notifications),
          timeZoneServiceProvider.overrideWithValue(
            const FakeTimeZoneService(),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: LocaleConfig.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SoundSettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'SoundSettingsScreen displays daily and lifetime goal sound options',
    (tester) async {
      await pumpSoundSettings(tester);

      expect(find.text('Sound & Haptics'), findsOneWidget);
      expect(find.text('Mala completion'), findsOneWidget);
      expect(find.text('Daily goal'), findsOneWidget);
      expect(find.text('LIFETIME GOAL'), findsOneWidget);
      expect(find.text('Lifetime goal tone'), findsOneWidget);

      // Tap lifetime goal tone to open custom sound picker
      await tester.tap(find.text('Lifetime goal tone'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      // Verify sacred choices are displayed in the sheet
      expect(find.text('Sacred Shankha'), findsOneWidget);
      expect(find.text('Temple Bronze Bell'), findsWidgets);
      expect(find.text('Tibetan Singing Bowl'), findsOneWidget);
      expect(find.text('Synthesized Tone'), findsOneWidget);
      expect(find.text('Browse audio file…'), findsOneWidget);

      // Select Sacred Shankha
      await tester.tap(find.text('Sacred Shankha'));
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(SoundSettingsScreen)),
      );
      final settings = container.read(settingsNotifierProvider);
      expect(settings.lifetimeSoundUri, equals('sacred:shankha'));
    },
  );

  testWidgets('tap vibration switch is off, warns about battery, and saves', (
    tester,
  ) async {
    await pumpSoundSettings(tester);
    await tester.scrollUntilVisible(
      find.text('Vibrate on each tap'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Uses extra battery in long sessions'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.battery_alert_outlined), findsOneWidget);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(SoundSettingsScreen)),
    );
    expect(container.read(settingsNotifierProvider).tapVibrationEnabled, false);

    await tester.tap(find.text('Vibrate on each tap'));
    await tester.pumpAndSettle();
    expect(container.read(settingsNotifierProvider).tapVibrationEnabled, true);
  });

  group('daily reminder', () {
    Future<void> scrollToReminder(WidgetTester tester) async {
      await tester.scrollUntilVisible(
        find.text('Reminder time'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
    }

    testWidgets('shows the switch and the time row, off at 6:00 AM', (
      tester,
    ) async {
      await pumpSoundSettings(tester);
      await scrollToReminder(tester);

      expect(find.text('Practice reminder'), findsOneWidget);
      expect(find.text('Daily reminder'), findsOneWidget);
      expect(find.text('Reminder time'), findsOneWidget);
      expect(find.text('6:00 AM'), findsOneWidget);
    });

    testWidgets('the time row does nothing while the switch is off', (
      tester,
    ) async {
      await pumpSoundSettings(tester);
      await scrollToReminder(tester);

      await tester.tap(find.text('Reminder time'));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets('turning it on schedules and enables the time row', (
      tester,
    ) async {
      await pumpSoundSettings(tester);
      await scrollToReminder(tester);

      await tester.tap(find.text('Daily reminder'));
      await tester.pumpAndSettle();
      expect(notifications.scheduled.single.minutes, 360);

      await tester.tap(find.text('Reminder time'));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('a refused permission keeps it off and explains why', (
      tester,
    ) async {
      notifications.permissionGranted = false;
      await pumpSoundSettings(tester);
      await scrollToReminder(tester);

      await tester.tap(find.text('Daily reminder'));
      await tester.pumpAndSettle();

      expect(notifications.scheduled, isEmpty);
      expect(
        find.textContaining('Notifications are not allowed'),
        findsOneWidget,
      );
    });
  });
}
