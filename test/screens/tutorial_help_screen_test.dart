import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mantra_japa_counter/core/locale/locale_config.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/screens/help/tutorial_help_screen.dart';

void main() {
  testWidgets('TutorialHelpScreen shows chapters and all 30 steps', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: LocaleConfig.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: TutorialHelpScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('App Tutorial'), findsNWidgets(2));
    expect(find.text('Getting started'), findsOneWidget);
    expect(find.text('01'), findsOneWidget);
    expect(find.text('Welcome'), findsOneWidget);

    final list = find.byType(Scrollable).first;
    for (final text in [
      'Your counters',
      'Lock a counter',
      'Undo a count',
      'Meru pause',
      'Sadhana Flow',
      'Restore from a file',
      'Privacy',
      '30',
      'Permissions',
    ]) {
      await tester.scrollUntilVisible(find.text(text), 300, scrollable: list);
      expect(find.text(text), findsOneWidget);
    }
  });
}
