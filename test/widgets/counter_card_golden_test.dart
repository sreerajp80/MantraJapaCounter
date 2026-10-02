@Tags(['golden'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:mantra_japa_counter/models/counter.dart';
import 'package:mantra_japa_counter/widgets/counter_card.dart';

import '../helpers/golden_helpers.dart';

void main() {
  const boundaryKey = ValueKey('golden');

  setUpAll(loadAppFonts);

  Future<void> pumpCard(
    WidgetTester tester,
    Counter counter, {
    required int totalCount,
    required int todayCount,
    Locale locale = const Locale('en'),
  }) async {
    setGoldenSurface(tester);
    await tester.pumpWidget(
      goldenApp(
        Scaffold(
          // A ListView, like the counter list, so the card keeps its
          // natural height.
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              RepaintBoundary(
                key: boundaryKey,
                child: CounterCard(
                  counter: counter,
                  totalCount: totalCount,
                  todayCount: todayCount,
                  onTap: () {},
                  onLongPress: () {},
                  onToggleLock: () {},
                ),
              ),
            ],
          ),
        ),
        locale: locale,
      ),
    );
    await tester.pumpAndSettle();
  }

  const counter = Counter(
    id: 'golden-c1',
    name: 'Om Namah Shivaya',
    goal: 1080,
    dailyGoal: 108,
    startDate: 1000,
    createdAt: 1000,
  );

  testWidgets('CounterCard — normal', (tester) async {
    await pumpCard(tester, counter, totalCount: 432, todayCount: 54);
    await expectLater(
      find.byKey(boundaryKey),
      matchesGoldenFile('goldens/counter_card_normal.png'),
    );
  });

  testWidgets('CounterCard — locked', (tester) async {
    await pumpCard(
      tester,
      counter.copyWith(isLocked: true),
      totalCount: 432,
      todayCount: 54,
    );
    await expectLater(
      find.byKey(boundaryKey),
      matchesGoldenFile('goldens/counter_card_locked.png'),
    );
  });

  testWidgets('CounterCard — goal reached', (tester) async {
    await pumpCard(tester, counter, totalCount: 1080, todayCount: 108);
    await expectLater(
      find.byKey(boundaryKey),
      matchesGoldenFile('goldens/counter_card_goal_reached.png'),
    );
  });

  testWidgets('CounterCard — Malayalam', (tester) async {
    await pumpCard(
      tester,
      counter.copyWith(name: 'ഓം നമഃ ശിവായ'),
      totalCount: 432,
      todayCount: 54,
      locale: const Locale('ml'),
    );
    await expectLater(
      find.byKey(boundaryKey),
      matchesGoldenFile('goldens/counter_card_ml.png'),
    );
  });
}
