import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/models/counter.dart';
import 'package:mantra_japa_counter/models/japa_session.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';
import 'package:mantra_japa_counter/repositories/settings_repository.dart';
import 'package:mantra_japa_counter/screens/history/history_screen.dart';
import 'package:mantra_japa_counter/widgets/temple_decorations.dart';

import '../helpers/fake_japa_counter_repository.dart';

const _shiva = Counter(
  id: 'c1',
  name: 'Om Namah Shivaya',
  goal: 1080,
  startDate: 1000,
  createdAt: 1000,
);

JapaSession _session(String id, DateTime at, int count) => JapaSession(
  id: id,
  counterId: _shiva.id,
  counterName: _shiva.name,
  count: count,
  malas: count ~/ 108,
  chants: count % 108,
  timestamp: at.millisecondsSinceEpoch,
  duration: 5 * 60000,
);

// Fixed past dates so no day is ever "Today".
final _sessions = [
  _session('s1', DateTime(2025, 1, 5, 6, 30), 108),
  _session('s2', DateTime(2025, 1, 5, 18, 15), 54),
  _session('s3', DateTime(2025, 1, 6, 7), 54),
];

void main() {
  late FakeJapaCounterRepository repo;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repo = FakeJapaCounterRepository();
  });

  Future<void> pumpHistory(WidgetTester tester, {String? counterId}) async {
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
          home: HistoryScreen(filterCounterId: counterId),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the empty state when there are no sessions', (
    tester,
  ) async {
    await pumpHistory(tester);

    expect(find.text('No sessions recorded yet.'), findsOneWidget);
    expect(find.text('RECENT OFFERINGS'), findsNothing);
  });

  testWidgets('lists one day group per day, newest first', (tester) async {
    repo = FakeJapaCounterRepository(
      counters: const [_shiva],
      sessions: _sessions,
    );
    await pumpHistory(tester);

    expect(find.text('All counters'), findsOneWidget);
    expect(find.text('216'), findsOneWidget); // lifetime total in the hero
    expect(find.text('CHANTS OFFERED · 2 DAYS'), findsOneWidget);
    expect(find.text('RECENT OFFERINGS'), findsOneWidget);
    expect(find.text('Jan 06, 2025'), findsOneWidget);
    expect(find.text('Jan 05, 2025'), findsOneWidget);
    expect(find.text('2 sessions'), findsOneWidget);
    expect(find.text('1 session'), findsOneWidget);

    final newer = tester.getTopLeft(find.text('Jan 06, 2025')).dy;
    final older = tester.getTopLeft(find.text('Jan 05, 2025')).dy;
    expect(newer, lessThan(older));
  });

  testWidgets('tapping a day expands and collapses its sessions', (
    tester,
  ) async {
    repo = FakeJapaCounterRepository(
      counters: const [_shiva],
      sessions: _sessions,
    );
    await pumpHistory(tester);

    expect(find.text('06:30'), findsNothing);

    await tester.tap(find.text('Jan 05, 2025'));
    await tester.pumpAndSettle();

    expect(find.text('06:30'), findsOneWidget);
    expect(find.text('18:15'), findsOneWidget);
    // Unfiltered history shows the counter name under each session.
    expect(find.text('Om Namah Shivaya'), findsNWidgets(2));

    await tester.tap(find.text('Jan 05, 2025'));
    await tester.pumpAndSettle();

    expect(find.text('06:30'), findsNothing);
  });

  testWidgets('deleting a session asks first and then removes it', (
    tester,
  ) async {
    repo = FakeJapaCounterRepository(
      counters: const [_shiva],
      sessions: _sessions,
    );
    await pumpHistory(tester);

    await tester.tap(find.text('Jan 06, 2025'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Delete session'));
    await tester.pumpAndSettle();

    expect(find.text('Delete session?'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(repo.sessions.map((s) => s.id), isNot(contains('s3')));
    expect(find.text('Jan 06, 2025'), findsNothing);
    expect(find.text('Jan 05, 2025'), findsOneWidget);
  });

  testWidgets('filtered view shows the counter hero and goal progress', (
    tester,
  ) async {
    repo = FakeJapaCounterRepository(
      counters: const [_shiva],
      sessions: _sessions,
    );
    await pumpHistory(tester, counterId: _shiva.id);

    expect(find.text('Om Namah Shivaya'), findsOneWidget);
    expect(find.text('a record of devotion'), findsOneWidget);
    expect(find.text('216'), findsOneWidget);
    expect(find.text('/ 1080'), findsOneWidget);
    expect(find.text('CHANTS OFFERED · 20% OF VOW'), findsOneWidget);
    expect(find.byType(TempleDiyaIcon), findsOneWidget);
    expect(find.text('All counters'), findsNothing);
  });
}
