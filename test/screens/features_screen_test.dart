import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/screens/features_screen.dart';

void main() {
  testWidgets('FeaturesScreen renders categories and feature highlights', (
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
        home: FeaturesScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Features'), findsWidgets);
    expect(find.text('SreerajP MantraJapa Counter Features'), findsOneWidget);
    expect(find.text('Sacred Japa & Mala Counting'), findsOneWidget);
    expect(find.text('Optical Air-Gap Sync & Data Safety'), findsOneWidget);
    expect(find.text('Practice Insights & History'), findsOneWidget);
    expect(find.text('Temple Aesthetics, Audio & Haptics'), findsOneWidget);
    expect(find.text('Privacy & Offline-First Core'), findsOneWidget);
    expect(find.text('108 Mala Beads Calculation'), findsOneWidget);
  });
}
