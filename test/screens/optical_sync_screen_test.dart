import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:mantra_japa_counter/core/locale/locale_config.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/models/counter.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';
import 'package:mantra_japa_counter/screens/optical_sync_screen.dart';
import 'package:mantra_japa_counter/widgets/counter_selection_sheet.dart';
import 'package:mantra_japa_counter/widgets/qr_camera_view.dart';

import '../helpers/fake_japa_counter_repository.dart';

const _counter = Counter(
  id: 'c1',
  name: 'Om Namah Shivaya',
  startDate: 1000,
  createdAt: 1000,
);

void main() {
  final l = lookupAppLocalizations(const Locale('en'));

  Future<void> pumpSync(
    WidgetTester tester, {
    required bool send,
    List<Counter> counters = const [_counter],
  }) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          japaCounterRepositoryProvider.overrideWithValue(
            FakeJapaCounterRepository(counters: counters),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: LocaleConfig.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: OpticalSyncScreen(isTransmitter: send),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
  }

  /// Removes the screen so the frame timer stops before the test ends.
  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }

  group('send', () {
    testWidgets('asks which counters to send before showing a code', (
      tester,
    ) async {
      await pumpSync(tester, send: true);

      expect(find.text(l.opticalSendTitle), findsOneWidget);
      expect(find.byType(CounterSelectionSheet), findsOneWidget);
      expect(find.byType(QrImageView), findsNothing);

      await unmount(tester);
    });

    testWidgets('shows moving QR codes after counters are chosen', (
      tester,
    ) async {
      await pumpSync(tester, send: true);

      if (find.text(l.selectAll).evaluate().isNotEmpty) {
        await tester.tap(find.text(l.selectAll));
        await tester.pump();
      }
      await tester.tap(find.text(l.continueAction));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(CounterSelectionSheet), findsNothing);
      expect(find.byType(QrImageView), findsOneWidget);
      expect(find.text('8 FPS'), findsOneWidget);

      await unmount(tester);
    });

    testWidgets('with no counters it says so and shows no code', (
      tester,
    ) async {
      await pumpSync(tester, send: true, counters: const []);

      expect(find.byType(CounterSelectionSheet), findsNothing);
      expect(find.text(l.noCountersSelected), findsOneWidget);
      expect(find.byType(QrImageView), findsNothing);

      await unmount(tester);
    });
  });

  group('receive', () {
    testWidgets('shows progress and the camera area', (tester) async {
      await pumpSync(tester, send: false);

      expect(find.text(l.opticalReceiveTitle), findsOneWidget);
      expect(find.text(l.opticalAlignCamera), findsOneWidget);
      expect(find.text('0%'), findsOneWidget);
      expect(find.byType(QrCameraView), findsOneWidget);
      // Tests do not run on Android, so the camera is never started.
      expect(find.text(l.opticalCameraUnavailable), findsOneWidget);

      await unmount(tester);
    });
  });
}
