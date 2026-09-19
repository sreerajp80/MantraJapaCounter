import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/screens/help/tutorial_help_screen.dart';

void main() {
  testWidgets('TutorialHelpScreen renders all 7 steps with advice', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: TutorialHelpScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('App Tutorial'), findsNWidgets(2));
    expect(find.text('01'), findsOneWidget);
    expect(find.text('02'), findsOneWidget);
    expect(find.text('03'), findsOneWidget);
    expect(find.text('04'), findsOneWidget);
    expect(find.text('05'), findsOneWidget);
    expect(find.text('06'), findsOneWidget);
    expect(find.text('07'), findsOneWidget);

    expect(find.text('1. Create Your First Counter'), findsOneWidget);
    expect(find.text('2. Sacred Fullscreen Counting'), findsOneWidget);
    expect(find.text('3. 108 Beads Mala System'), findsOneWidget);
    expect(find.text('4. Daily & Lifetime Milestones'), findsOneWidget);
    expect(find.text('5. Locking & Archiving'), findsOneWidget);
    expect(find.text('6. Air-Gapped Optical QR Sync'), findsOneWidget);
    expect(find.text('7. Encrypted Backups'), findsOneWidget);
  });
}
