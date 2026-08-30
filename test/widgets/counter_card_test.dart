import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/models/counter.dart';
import 'package:mantra_japa_counter/widgets/counter_card.dart';

void main() {
  testWidgets('CounterCard displays lock icon and triggers onToggleLock', (
    tester,
  ) async {
    bool tapped = false;
    bool lockToggled = false;

    final counter = Counter(
      id: 'test-c1',
      name: 'Om Namah Shivaya',
      goal: 1080,
      dailyGoal: 108,
      startDate: 1000,
      createdAt: 1000,
      isLocked: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: CounterCard(
            counter: counter,
            totalCount: 216,
            todayCount: 108,
            onTap: () => tapped = true,
            onLongPress: () {},
            onToggleLock: () => lockToggled = true,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify unlocked lock icon is present
    expect(find.byIcon(Icons.lock_open_outlined), findsOneWidget);

    // Tap lock button
    await tester.tap(find.byIcon(Icons.lock_open_outlined));
    await tester.pump();
    expect(lockToggled, true);

    // Tap card body -> triggers onTap
    await tester.tap(find.text('Om Namah Shivaya'));
    await tester.pump();
    expect(tapped, true);
  });

  testWidgets(
    'CounterCard when locked displays Icons.lock and prevents onTap with notice',
    (tester) async {
      bool tapped = false;
      bool lockToggled = false;

      final lockedCounter = Counter(
        id: 'test-c2',
        name: 'Gayatri Mantra',
        goal: 1080,
        dailyGoal: 108,
        startDate: 1000,
        createdAt: 1000,
        isLocked: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: CounterCard(
              counter: lockedCounter,
              totalCount: 108,
              todayCount: 54,
              onTap: () => tapped = true,
              onLongPress: () {},
              onToggleLock: () => lockToggled = true,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify lock icon is present
      expect(find.byIcon(Icons.lock), findsOneWidget);

      // Tap card body -> does NOT call onTap, shows SnackBar notice
      await tester.tap(find.text('Gayatri Mantra'));
      await tester.pump();
      expect(tapped, false);
      expect(
        find.text('"Gayatri Mantra" is locked. Unlock to start chanting.'),
        findsOneWidget,
      );

      // Tap lock button
      await tester.tap(find.byIcon(Icons.lock));
      await tester.pump();
      expect(lockToggled, true);
    },
  );
}
