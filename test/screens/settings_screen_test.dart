import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mantra_japa_counter/core/constants/app_constants.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/models/counter.dart';
import 'package:mantra_japa_counter/models/mala_sound.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';
import 'package:mantra_japa_counter/providers/settings_provider.dart';
import 'package:mantra_japa_counter/repositories/settings_repository.dart';
import 'package:mantra_japa_counter/screens/settings/settings_screen.dart';
import 'package:mantra_japa_counter/screens/settings/settings_tiles.dart';
import 'package:mantra_japa_counter/screens/settings/sound_settings_screen.dart';
import 'package:mantra_japa_counter/screens/settings/display_settings_screen.dart';
import 'package:mantra_japa_counter/screens/settings/language_settings_screen.dart';
import 'package:mantra_japa_counter/screens/settings/backup_settings_screen.dart';
import 'package:mantra_japa_counter/screens/settings/permissions_screen.dart';

import '../helpers/fake_japa_counter_repository.dart';

void main() {
  late FakeJapaCounterRepository repo;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repo = FakeJapaCounterRepository();
  });

  Future<void> pumpScreen(WidgetTester tester, Widget screen) async {
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
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: screen,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  AppSettings settingsOf(WidgetTester tester, Type screenType) {
    final container = ProviderScope.containerOf(
      tester.element(find.byType(screenType)),
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

  testWidgets('renders all settings cards on SettingsScreen', (tester) async {
    await pumpScreen(tester, const SettingsScreen());

    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Sound & Haptics'), findsOneWidget);
    expect(find.text('Display & Stillness'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Data Backup & Optical Sync'), findsOneWidget);
    expect(find.text('Features'), findsOneWidget);
    expect(find.text('Permissions'), findsOneWidget);
    expect(find.text('Help & User Guides'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
  });

  testWidgets('LanguageSettingsScreen: tapping Sanskrit updates languageCode', (
    tester,
  ) async {
    await pumpScreen(tester, const LanguageSettingsScreen());
    expect(settingsOf(tester, LanguageSettingsScreen).languageCode, isNull);

    expect(find.text('Sanskrit'), findsOneWidget);
    expect(find.text('Malayalam'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('System default'), findsAtLeastNWidgets(1));

    await tester.tap(find.text('Sanskrit'));
    await tester.pumpAndSettle();

    expect(
      settingsOf(tester, LanguageSettingsScreen).languageCode,
      equals('sa'),
    );
  });

  testWidgets(
    'SoundSettingsScreen: tapping mala sound opens picker and updates malaSound',
    (tester) async {
      await pumpScreen(tester, const SoundSettingsScreen());
      expect(
        settingsOf(tester, SoundSettingsScreen).malaSound,
        equals(MalaSound.templeBell),
      );

      await tester.tap(find.text('Mala sound'));
      await tester.pumpAndSettle();

      expect(find.text('Temple Bronze Bell'), findsWidgets);
      expect(find.text('Tibetan Singing Bowl'), findsOneWidget);
      expect(find.text('Synthesized Tone'), findsOneWidget);

      await tester.tap(find.text('Tibetan Singing Bowl'));
      await tester.pumpAndSettle();

      expect(
        settingsOf(tester, SoundSettingsScreen).malaSound,
        equals(MalaSound.singingBowl),
      );
    },
  );

  testWidgets('SoundSettingsScreen: tapping vibration row flips the setting', (
    tester,
  ) async {
    await pumpScreen(tester, const SoundSettingsScreen());
    expect(settingsOf(tester, SoundSettingsScreen).vibrationEnabled, isTrue);

    await tester.tap(find.widgetWithText(SettingsRow, 'Vibration'));
    await tester.pumpAndSettle();
    expect(settingsOf(tester, SoundSettingsScreen).vibrationEnabled, isFalse);

    await tester.tap(find.widgetWithText(SettingsRow, 'Vibration'));
    await tester.pumpAndSettle();
    expect(settingsOf(tester, SoundSettingsScreen).vibrationEnabled, isTrue);
  });

  testWidgets(
    'DisplaySettingsScreen: "use system" resets a brightness override',
    (tester) async {
      SharedPreferences.setMockInitialValues({
        AppConstants.prefsBrightnessKey: 0.7,
      });
      await pumpScreen(tester, const DisplaySettingsScreen());

      expect(find.text('Override active'), findsOneWidget);
      expect(find.text('70'), findsOneWidget);

      await tester.tap(find.text('use system'));
      await tester.pumpAndSettle();

      expect(find.text('Following system'), findsOneWidget);
      expect(settingsOf(tester, DisplaySettingsScreen).screenBrightness, -1.0);
    },
  );

  testWidgets(
    'BackupSettingsScreen: clear-all card asks first and Cancel deletes nothing',
    (tester) async {
      repo = FakeJapaCounterRepository(
        counters: const [
          Counter(id: 'c1', name: 'Om', startDate: 1000, createdAt: 1000),
        ],
      );
      await pumpScreen(tester, const BackupSettingsScreen());

      await scrollTo(tester, find.text('Clear all data?'));
      await tester.tap(find.text('Clear all data?'));
      await tester.pumpAndSettle();

      expect(find.text('Cancel'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(repo.counters, hasLength(1));
    },
  );

  testWidgets(
    'PermissionsScreen: renders explicit, implicit, and privacy sections',
    (tester) async {
      await pumpScreen(tester, const PermissionsScreen());

      expect(find.text('Explicit Permissions'), findsOneWidget);
      expect(find.text('Camera'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);

      expect(find.text('Implicit Permissions'), findsOneWidget);
      expect(find.text('Vibration'), findsOneWidget);
      expect(find.text('Audio Management'), findsOneWidget);

      expect(find.text('Zero-Trust Privacy Guarantee'), findsOneWidget);
      expect(find.text('Zero Internet Access'), findsOneWidget);
      expect(find.text('No Broad Storage Access'), findsOneWidget);
    },
  );
}
