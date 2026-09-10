import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/models/counter.dart';
import 'package:mantra_japa_counter/models/counter_status.dart';
import 'package:mantra_japa_counter/models/japa_session.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';
import 'package:mantra_japa_counter/repositories/settings_repository.dart';
import 'package:mantra_japa_counter/screens/counter_list/counter_list_screen.dart';
import 'package:mantra_japa_counter/widgets/counter_card.dart';

import '../helpers/fake_japa_counter_repository.dart';

const _shiva = Counter(
  id: 'c1',
  name: 'Om Namah Shivaya',
  goal: 1080,
  dailyGoal: 108,
  startDate: 1000,
  createdAt: 2000,
);

const _gayatri = Counter(
  id: 'c2',
  name: 'Gayatri Mantra',
  startDate: 1000,
  createdAt: 1000,
);

void main() {
  late FakeJapaCounterRepository repo;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repo = FakeJapaCounterRepository();
  });

  Future<void> pumpList(WidgetTester tester) async {
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
          home: CounterListScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  TextField fieldLabelled(WidgetTester tester, String label) =>
      tester.widget<TextField>(find.widgetWithText(TextField, label));

  Future<void> openOptionsFor(WidgetTester tester, String name) async {
    await tester.longPress(find.widgetWithText(CounterCard, name));
    await tester.pumpAndSettle();
  }

  testWidgets('shows the empty state when there are no counters', (
    tester,
  ) async {
    await pumpList(tester);

    expect(find.text('Mantra Counters'), findsOneWidget);
    expect(find.text('No counters yet'), findsOneWidget);
    expect(find.byType(CounterCard), findsNothing);
  });

  testWidgets('shows one card per counter and the today summary', (
    tester,
  ) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    repo = FakeJapaCounterRepository(
      counters: const [_shiva, _gayatri],
      sessions: [
        JapaSession(
          id: 's1',
          counterId: 'c1',
          counterName: _shiva.name,
          count: 216,
          malas: 2,
          chants: 0,
          timestamp: now,
          duration: 60000,
        ),
      ],
    );
    await pumpList(tester);

    expect(find.byType(CounterCard), findsNWidgets(2));
    expect(find.text('Om Namah Shivaya'), findsOneWidget);
    expect(find.text('Gayatri Mantra'), findsOneWidget);
    expect(find.text('No counters yet'), findsNothing);

    // Today pill: 216 chants, 2 malas, 1 counter used today.
    expect(find.text('CHANTS'), findsOneWidget);
    expect(find.text('MALAS'), findsOneWidget);
    expect(find.text('ACTIVE'), findsOneWidget);
    expect(find.text('216'), findsWidgets);
  });

  testWidgets('add dialog checks goals and then creates the counter', (
    tester,
  ) async {
    await pumpList(tester);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('New Counter'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'Counter name *'),
      'Hare Krishna',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Lifetime goal (0 = none)'),
      '100',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Daily goal (0 = none)'),
      '200',
    );
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(find.text('Daily goal cannot exceed lifetime goal'), findsOneWidget);
    expect(repo.counters, isEmpty);

    await tester.enterText(
      find.widgetWithText(TextField, 'Daily goal (0 = none)'),
      '50',
    );
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(find.text('New Counter'), findsNothing);
    expect(repo.counters, hasLength(1));
    expect(repo.counters.single.name, 'Hare Krishna');
    expect(repo.counters.single.goal, 100);
    expect(repo.counters.single.dailyGoal, 50);
    expect(find.widgetWithText(CounterCard, 'Hare Krishna'), findsOneWidget);
  });

  testWidgets('header menu opens the import / export dialog', (tester) async {
    await pumpList(tester);

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    expect(find.text('Import / Export'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);

    await tester.tap(find.text('Import / Export'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Export backs up'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Export'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Import'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Export backs up'), findsNothing);
  });

  testWidgets('long-press opens the options sheet', (tester) async {
    repo = FakeJapaCounterRepository(counters: const [_shiva]);
    await pumpList(tester);

    await openOptionsFor(tester, 'Om Namah Shivaya');

    expect(find.text('About counter'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('Lock counter'), findsOneWidget);
    expect(find.text('Disable (success)'), findsOneWidget);
    expect(find.text('Disable (not completed)'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
  });

  testWidgets('Edit opens the dialog filled in with the counter', (
    tester,
  ) async {
    repo = FakeJapaCounterRepository(counters: const [_shiva]);
    await pumpList(tester);

    await openOptionsFor(tester, 'Om Namah Shivaya');
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Counter'), findsOneWidget);
    expect(
      fieldLabelled(tester, 'Counter name *').controller!.text,
      'Om Namah Shivaya',
    );
    expect(
      fieldLabelled(tester, 'Lifetime goal (0 = none)').controller!.text,
      '1080',
    );
    expect(
      fieldLabelled(tester, 'Daily goal (0 = none)').controller!.text,
      '108',
    );
  });

  testWidgets('Delete asks first and then removes the counter', (tester) async {
    repo = FakeJapaCounterRepository(counters: const [_shiva]);
    await pumpList(tester);

    await openOptionsFor(tester, 'Om Namah Shivaya');
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Delete counter?'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(repo.counters, isEmpty);
    expect(find.text('No counters yet'), findsOneWidget);
  });

  testWidgets('Disable (success) asks for a reason and disables the counter', (
    tester,
  ) async {
    repo = FakeJapaCounterRepository(counters: const [_shiva]);
    await pumpList(tester);

    await openOptionsFor(tester, 'Om Namah Shivaya');
    await tester.tap(find.text('Disable (success)'));
    await tester.pumpAndSettle();

    expect(find.text('Disable as completed?'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'Reason (optional)'),
      '  Vow completed  ',
    );
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    expect(find.text('Disable as completed?'), findsNothing);
    final updated = repo.counters.single;
    expect(updated.status, CounterStatus.disabledSuccess);
    expect(updated.disabledReason, 'Vow completed');
    expect(updated.disabledAt, isNotNull);
  });
}
