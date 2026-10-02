@Tags(['golden'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/widgets/temple_mala_circle.dart';

import '../helpers/golden_helpers.dart';

void main() {
  const boundaryKey = ValueKey('golden');

  setUpAll(loadAppFonts);

  Future<void> pumpCircle(
    WidgetTester tester, {
    required int count,
    bool goalReached = false,
  }) async {
    setGoldenSurface(tester);
    await tester.pumpWidget(
      goldenApp(
        Scaffold(
          body: Center(
            child: RepaintBoundary(
              key: boundaryKey,
              child: ColoredBox(
                color: TempleColors.bg,
                child: TempleMalaCircle(
                  count: count,
                  goal: 108,
                  goalReached: goalReached,
                  child: Text('$count', style: AppTheme.serif(fontSize: 64)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('TempleMalaCircle — empty', (tester) async {
    await pumpCircle(tester, count: 0);
    await expectLater(
      find.byKey(boundaryKey),
      matchesGoldenFile('goldens/temple_mala_circle_empty.png'),
    );
  });

  testWidgets('TempleMalaCircle — part filled', (tester) async {
    await pumpCircle(tester, count: 54);
    await expectLater(
      find.byKey(boundaryKey),
      matchesGoldenFile('goldens/temple_mala_circle_partial.png'),
    );
  });

  testWidgets('TempleMalaCircle — goal reached', (tester) async {
    await pumpCircle(tester, count: 108, goalReached: true);
    await expectLater(
      find.byKey(boundaryKey),
      matchesGoldenFile('goldens/temple_mala_circle_goal_reached.png'),
    );
  });
}
