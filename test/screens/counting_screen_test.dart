import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mantra_japa_counter/core/locale/locale_config.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/models/counter.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';
import 'package:mantra_japa_counter/providers/counting_provider.dart';
import 'package:mantra_japa_counter/repositories/settings_repository.dart';
import 'package:mantra_japa_counter/screens/counting_screen.dart';
import 'package:mantra_japa_counter/services/notification_service.dart';
import 'package:mantra_japa_counter/services/sound_service.dart';
import 'package:mantra_japa_counter/widgets/temple_mala_circle.dart';

import '../helpers/fake_japa_counter_repository.dart';

class _FakeNotifications implements NotificationService {
  @override
  dynamic noSuchMethod(Invocation invocation) => Future<void>.value();
}

class _FakeSound implements SoundService {
  @override
  dynamic noSuchMethod(Invocation invocation) => Future<void>.value();
}

const _counter = Counter(
  id: 'c1',
  name: 'Om Namah Shivaya',
  startDate: 1000,
  createdAt: 1000,
);

void main() {
  late FakeJapaCounterRepository repo;
  late SettingsRepository settings;
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    settings = SettingsRepository(await SharedPreferences.getInstance());
    repo = FakeJapaCounterRepository(counters: [_counter]);
  });

  /// Opens the counting screen on top of a plain "list" page, so leaving the
  /// screen has somewhere to go back to.
  Future<void> pumpCounting(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    container = ProviderContainer(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(settings),
        japaCounterRepositoryProvider.overrideWithValue(repo),
        notificationServiceProvider.overrideWithValue(_FakeNotifications()),
        soundServiceProvider.overrideWithValue(_FakeSound()),
      ],
    );

    final router = GoRouter(
      initialLocation: '/count',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const Scaffold(body: Text('list page')),
          routes: [
            GoRoute(
              path: 'count',
              builder: (_, _) => const CountingScreen(counterId: 'c1'),
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: LocaleConfig.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  /// Removes the screen and its providers so their timers stop before the
  /// test ends.
  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    container.dispose();
    await tester.pump(const Duration(seconds: 1));
  }

  int sessionCount() =>
      container.read(countingNotifierProvider('c1')).session?.tapCount ?? -1;

  Future<void> tapMala(WidgetTester tester, int times) async {
    for (var i = 0; i < times; i++) {
      await tester.tap(find.byType(TempleMalaCircle));
      await tester.pump(const Duration(milliseconds: 400));
    }
  }

  testWidgets('shows the counter name and starts at zero', (tester) async {
    await pumpCounting(tester);

    expect(find.text(_counter.name), findsOneWidget);
    expect(sessionCount(), 0);

    await unmount(tester);
  });

  testWidgets('a tap on the mala adds one count and saves the row', (
    tester,
  ) async {
    await pumpCounting(tester);

    await tapMala(tester, 3);

    expect(sessionCount(), 3);
    // The first tap writes the session row right away.
    expect(repo.sessions, hasLength(1));
    expect(repo.sessions.single.counterId, 'c1');

    await unmount(tester);
  });

  testWidgets('a two-finger swipe takes one count back', (tester) async {
    await pumpCounting(tester);
    await tapMala(tester, 2);

    final centre = tester.getCenter(find.byType(TempleMalaCircle));
    final a = await tester.startGesture(centre + const Offset(-20, 0));
    final b = await tester.startGesture(
      centre + const Offset(20, 0),
      pointer: 2,
    );
    await a.moveBy(const Offset(80, 0));
    await b.moveBy(const Offset(80, 0));
    await a.up();
    await b.up();
    await tester.pump(const Duration(milliseconds: 400));

    expect(sessionCount(), 1);

    await unmount(tester);
  });

  testWidgets('the back button saves every tap and leaves the screen', (
    tester,
  ) async {
    await pumpCounting(tester);
    await tapMala(tester, 4);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('list page'), findsOneWidget);
    expect(repo.sessions.single.count, 4);
    // Stopped mid-mala, so the session is kept paused to resume later.
    final saved = settings.getActiveSession('c1');
    expect(saved?.tapCount, 4);
    expect(saved?.isPaused, isTrue);

    await unmount(tester);
  });

  testWidgets('leaving the app saves taps not yet written', (tester) async {
    await pumpCounting(tester);
    await tapMala(tester, 3);
    // Only the first tap is written at once; the rest wait for a batch.
    expect(repo.sessions.single.count, 1);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump(const Duration(milliseconds: 100));

    expect(repo.sessions.single.count, 3);
    expect(settings.getActiveSession('c1')?.tapCount, 3);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await unmount(tester);
  });
}
