@Tags(['golden'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/widgets/goal_progress_bar.dart';

import '../helpers/golden_helpers.dart';

void main() {
  const boundaryKey = ValueKey('golden');

  setUpAll(loadAppFonts);

  // The bar draws white text, so it is shown on a dark background.
  Future<void> pumpBar(
    WidgetTester tester, {
    required int current,
    required int target,
  }) async {
    setGoldenSurface(tester);
    await tester.pumpWidget(
      goldenApp(
        Scaffold(
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              RepaintBoundary(
                key: boundaryKey,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: TempleColors.vermillionDeep,
                  child: GoalProgressBar(
                    label: 'Daily goal',
                    progress: (current / target).clamp(0.0, 1.0),
                    current: current,
                    target: target,
                    isComplete: current >= target,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('GoalProgressBar — in progress', (tester) async {
    await pumpBar(tester, current: 54, target: 108);
    await expectLater(
      find.byKey(boundaryKey),
      matchesGoldenFile('goldens/goal_progress_bar_progress.png'),
    );
  });

  testWidgets('GoalProgressBar — complete', (tester) async {
    await pumpBar(tester, current: 108, target: 108);
    await expectLater(
      find.byKey(boundaryKey),
      matchesGoldenFile('goldens/goal_progress_bar_complete.png'),
    );
  });
}
