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

  testWidgets('FeaturesScreen renders the catalogue in Malayalam', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('ml'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: FeaturesScreen(),
      ),
    );

    await tester.pumpAndSettle();

    // Category names and a feature title must come from app_ml.arb, proving the
    // catalogue is localized rather than hard-coded English.
    expect(find.text('പവിത്ര ജപവും മാല എണ്ണവും'), findsOneWidget);
    expect(find.text('108 മാല മണി കണക്ക്'), findsOneWidget);

    // The English strings must be gone in this locale.
    expect(find.text('Sacred Japa & Mala Counting'), findsNothing);
    expect(find.text('108 Mala Beads Calculation'), findsNothing);
  });
}
