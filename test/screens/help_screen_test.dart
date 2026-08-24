import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/screens/help/help_home_screen.dart';
import 'package:mantra_japa_counter/screens/help/counting_help_screen.dart';
import 'package:mantra_japa_counter/screens/help/mala_math_help_screen.dart';
import 'package:mantra_japa_counter/screens/help/optical_sync_help_screen.dart';
import 'package:mantra_japa_counter/screens/help/sound_haptics_help_screen.dart';
import 'package:mantra_japa_counter/screens/help/backup_help_screen.dart';
import 'package:mantra_japa_counter/screens/help/privacy_offline_help_screen.dart';
import 'package:mantra_japa_counter/screens/help/faq_help_screen.dart';

void main() {
  testWidgets('HelpHomeScreen renders topic cards', (tester) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: HelpHomeScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Help & User Guides'), findsWidgets);
    expect(find.text('Counting & Meditation Practice'), findsOneWidget);
    expect(find.text('Counting & Gestures Guide'), findsOneWidget);
    expect(find.text('108 Mala Math & Goals'), findsOneWidget);
    expect(find.text('Optical Air-Gap Sync'), findsOneWidget);
    expect(find.text('JSON Backup & Restore'), findsOneWidget);
  });

  testWidgets('CountingHelpScreen renders sections and bullets', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: CountingHelpScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Counting & Gestures Guide'), findsWidgets);
    expect(find.text('How to Count'), findsOneWidget);
    expect(find.text('Undoing an Accidental Count'), findsOneWidget);
  });

  testWidgets('MalaMathHelpScreen renders calculations', (tester) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MalaMathHelpScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('108 Mala Math & Goals'), findsWidgets);
    expect(find.text('108 Beads Calculation'), findsOneWidget);
  });

  testWidgets('OpticalSyncHelpScreen renders air-gap instructions', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: OpticalSyncHelpScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Optical Air-Gap Sync'), findsWidgets);
    expect(find.text('How to Transfer'), findsOneWidget);
  });

  testWidgets('SoundHapticsHelpScreen renders audio help', (tester) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SoundHapticsHelpScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Sound & Vibration Settings'), findsWidgets);
  });

  testWidgets('BackupHelpScreen renders backup help', (tester) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BackupHelpScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('JSON Backup & Restore'), findsWidgets);
  });

  testWidgets('PrivacyOfflineHelpScreen renders privacy details', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: PrivacyOfflineHelpScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Privacy & Offline-First Core'), findsWidgets);
  });

  testWidgets('FaqHelpScreen renders FAQ items', (tester) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: FaqHelpScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('FAQs & Troubleshooting'), findsWidgets);
  });
}
