import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mantra_japa_counter/core/locale/locale_config.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/screens/help/backup_help_screen.dart';
import 'package:mantra_japa_counter/screens/help/counters_help_screen.dart';
import 'package:mantra_japa_counter/screens/help/counting_help_screen.dart';
import 'package:mantra_japa_counter/screens/help/display_help_screen.dart';
import 'package:mantra_japa_counter/screens/help/faq_help_screen.dart';
import 'package:mantra_japa_counter/screens/help/help_home_screen.dart';
import 'package:mantra_japa_counter/screens/help/history_help_screen.dart';
import 'package:mantra_japa_counter/screens/help/mala_math_help_screen.dart';
import 'package:mantra_japa_counter/screens/help/optical_sync_help_screen.dart';
import 'package:mantra_japa_counter/screens/help/privacy_offline_help_screen.dart';
import 'package:mantra_japa_counter/screens/help/sound_haptics_help_screen.dart';
import 'package:mantra_japa_counter/screens/help/tutorial_help_screen.dart';

/// Every help screen must build in all three languages without errors.
void main() {
  const screens = <String, Widget>{
    'HelpHomeScreen': HelpHomeScreen(),
    'TutorialHelpScreen': TutorialHelpScreen(),
    'CountersHelpScreen': CountersHelpScreen(),
    'CountingHelpScreen': CountingHelpScreen(),
    'MalaMathHelpScreen': MalaMathHelpScreen(),
    'HistoryHelpScreen': HistoryHelpScreen(),
    'SoundHapticsHelpScreen': SoundHapticsHelpScreen(),
    'DisplayHelpScreen': DisplayHelpScreen(),
    'OpticalSyncHelpScreen': OpticalSyncHelpScreen(),
    'BackupHelpScreen': BackupHelpScreen(),
    'PrivacyOfflineHelpScreen': PrivacyOfflineHelpScreen(),
    'FaqHelpScreen': FaqHelpScreen(),
  };

  for (final locale in const ['en', 'ml', 'sa']) {
    for (final entry in screens.entries) {
      testWidgets('${entry.key} builds in "$locale"', (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(locale),
            localizationsDelegates: LocaleConfig.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: entry.value,
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.byType(ListView), findsOneWidget);
      });
    }
  }

  testWidgets('new help screens show their sections in English', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    Future<void> pump(Widget screen) => tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: LocaleConfig.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: screen,
      ),
    );

    await pump(const CountersHelpScreen());
    await tester.pumpAndSettle();
    expect(find.text('Creating a counter'), findsOneWidget);
    expect(find.text('Locked and disabled counters'), findsOneWidget);

    await pump(const HistoryHelpScreen());
    await tester.pumpAndSettle();
    expect(find.text('Sadhana Flow calendar'), findsOneWidget);

    await pump(const DisplayHelpScreen());
    await tester.pumpAndSettle();
    expect(find.text('Do Not Disturb'), findsOneWidget);
  });
}
