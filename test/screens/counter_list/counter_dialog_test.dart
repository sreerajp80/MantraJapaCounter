import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mantra_japa_counter/core/locale/locale_config.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/models/counter.dart';
import 'package:mantra_japa_counter/screens/counter_list/counter_dialog.dart';

void main() {
  late List<int> savedMalaSizes;

  setUp(() => savedMalaSizes = []);

  Future<AppLocalizations> pumpDialog(
    WidgetTester tester, {
    Counter? existing,
  }) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: LocaleConfig.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: CounterDialog(
            existing: existing,
            onSave: (name, startDate, init, step, goal, daily, malaSize) =>
                savedMalaSizes.add(malaSize),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return AppLocalizations.of(tester.element(find.byType(CounterDialog)));
  }

  /// Text fields in dialog order: name, initial, step, goal, daily, mala.
  Finder field(int index) => find.byType(TextField).at(index);

  Future<void> save(WidgetTester tester, AppLocalizations l) async {
    await tester.tap(find.text(l.create));
    await tester.pumpAndSettle();
  }

  testWidgets('new counter saves the default mala count of 108', (
    tester,
  ) async {
    final l = await pumpDialog(tester);
    await tester.enterText(field(0), 'Gayatri');
    await save(tester, l);
    expect(savedMalaSizes, [108]);
  });

  testWidgets('"No mala count" saves 0', (tester) async {
    final l = await pumpDialog(tester);
    await tester.enterText(field(0), 'Gayatri');
    await tester.tap(find.text(l.noMalaCountLabel));
    await tester.pumpAndSettle();
    await save(tester, l);
    expect(savedMalaSizes, [0]);
  });

  testWidgets('mala count below 1 shows an error', (tester) async {
    final l = await pumpDialog(tester);
    await tester.enterText(field(0), 'Gayatri');
    await tester.enterText(field(5), '0');
    await save(tester, l);
    expect(find.text(l.malaSizeTooSmall), findsOneWidget);
    expect(savedMalaSizes, isEmpty);
  });

  testWidgets('mala count below the step shows an error', (tester) async {
    final l = await pumpDialog(tester);
    await tester.enterText(field(0), 'Gayatri');
    await tester.enterText(field(2), '3');
    await tester.enterText(field(5), '2');
    await save(tester, l);
    expect(find.text(l.malaSizeBelowStep), findsOneWidget);
    expect(savedMalaSizes, isEmpty);
  });

  testWidgets('mala count above the daily goal shows an error', (tester) async {
    final l = await pumpDialog(tester);
    await tester.enterText(field(0), 'Gayatri');
    await tester.enterText(field(4), '5');
    await save(tester, l);
    expect(find.text(l.malaSizeExceedsDaily), findsOneWidget);
    expect(savedMalaSizes, isEmpty);
  });

  testWidgets('mala count above the lifetime goal shows an error', (
    tester,
  ) async {
    final l = await pumpDialog(tester);
    await tester.enterText(field(0), 'Gayatri');
    await tester.enterText(field(3), '50');
    await save(tester, l);
    expect(find.text(l.malaSizeExceedsLifetime), findsOneWidget);
    expect(savedMalaSizes, isEmpty);
  });

  testWidgets('a valid custom mala count is saved', (tester) async {
    final l = await pumpDialog(tester);
    await tester.enterText(field(0), 'Gayatri');
    await tester.enterText(field(4), '5');
    await tester.enterText(field(5), '5');
    await save(tester, l);
    expect(savedMalaSizes, [5]);
  });

  testWidgets('number fields turn off suggestions; name field keeps them', (
    tester,
  ) async {
    await pumpDialog(tester);
    final name = tester.widget<TextField>(field(0));
    expect(name.enableSuggestions, isTrue);
    for (var i = 1; i <= 5; i++) {
      final f = tester.widget<TextField>(field(i));
      expect(f.enableSuggestions, isFalse, reason: 'field $i');
      expect(f.autocorrect, isFalse, reason: 'field $i');
    }
  });

  testWidgets('number fields drop non-digit characters', (tester) async {
    final l = await pumpDialog(tester);
    await tester.enterText(field(0), 'Gayatri');
    await tester.enterText(field(4), '-1.5');
    await tester.enterText(field(5), '1,5');
    expect(tester.widget<TextField>(field(4)).controller!.text, '15');
    await save(tester, l);
    expect(savedMalaSizes, [15]);
  });
}
