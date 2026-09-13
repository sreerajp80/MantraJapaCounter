import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mantra_japa_counter/core/constants/app_constants.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/models/counter.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';
import 'package:mantra_japa_counter/providers/settings_provider.dart';
import 'package:mantra_japa_counter/repositories/settings_repository.dart';
import 'package:mantra_japa_counter/screens/settings/settings_screen.dart';

import '../helpers/fake_japa_counter_repository.dart';

void main() {
  late FakeJapaCounterRepository repo;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repo = FakeJapaCounterRepository();
  });

  Future<void> pumpSettings(WidgetTester tester) async {
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
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  AppSettings settingsOf(WidgetTester tester) {
    final container = ProviderScope.containerOf(
      tester.element(find.byType(SettingsScreen)),
    );
    return container.read(settingsNotifierProvider);
  }

  Future<void> scrollTo(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders navigation cards and sections', (tester) async {
    await pumpSettings(tester);

    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Features'), findsOneWidget);
    expect(find.text('Help & User Guides'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Daily goal'), findsOneWidget);
    expect(find.text('Mala completion'), findsOneWidget);
    expect(find.text('Stillness'), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);

    await scrollTo(tester, find.text('Data Backup & Optical Sync'));
    expect(find.text('Data Backup & Optical Sync'), findsOneWidget);
  });

  testWidgets(
    'tapping language row opens picker and selecting Sanskrit updates languageCode',
    (tester) async {
      await pumpSettings(tester);
      expect(settingsOf(tester).languageCode, isNull);

      await tester.tap(find.text('App language'));
      await tester.pumpAndSettle();

      expect(find.text('Select language'), findsOneWidget);
      expect(find.text('Sanskrit'), findsOneWidget);
      expect(find.text('Malayalam'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('System default'), findsAtLeastNWidgets(1));

      await tester.tap(find.text('Sanskrit'));
      await tester.pumpAndSettle();

      expect(find.text('Select language'), findsNothing);
      expect(settingsOf(tester).languageCode, equals('sa'));
    },
  );

  testWidgets('tapping the vibration row flips the setting', (tester) async {
    await pumpSettings(tester);
    expect(settingsOf(tester).vibrationEnabled, isTrue);

    await tester.tap(find.text('Vibration'));
    await tester.pumpAndSettle();
    expect(settingsOf(tester).vibrationEnabled, isFalse);

    await tester.tap(find.text('Vibration'));
    await tester.pumpAndSettle();
    expect(settingsOf(tester).vibrationEnabled, isTrue);
  });

  testWidgets('"use system" resets a brightness override', (tester) async {
    SharedPreferences.setMockInitialValues({
      AppConstants.prefsBrightnessKey: 0.7,
    });
    await pumpSettings(tester);

    expect(find.text('Override active'), findsOneWidget);
    expect(find.text('70'), findsOneWidget);

    await tester.tap(find.text('use system'));
    await tester.pumpAndSettle();

    expect(find.text('Following system'), findsOneWidget);
    expect(settingsOf(tester).screenBrightness, -1.0);
  });

  testWidgets('clear-all card asks first and Cancel deletes nothing', (
    tester,
  ) async {
    repo = FakeJapaCounterRepository(
      counters: const [
        Counter(id: 'c1', name: 'Om', startDate: 1000, createdAt: 1000),
      ],
    );
    await pumpSettings(tester);

    await scrollTo(tester, find.text('Clear all data'));
    await tester.tap(find.text('Clear all data'));
    await tester.pumpAndSettle();

    expect(find.text('Clear all data?'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Clear all data?'), findsNothing);
    expect(repo.counters, hasLength(1));
  });
}
