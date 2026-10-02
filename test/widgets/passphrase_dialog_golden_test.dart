@Tags(['golden'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:mantra_japa_counter/widgets/passphrase_dialog.dart';

import '../helpers/golden_helpers.dart';

void main() {
  setUpAll(loadAppFonts);

  testWidgets('Export passphrase dialog', (tester) async {
    setGoldenSurface(tester);
    await tester.pumpWidget(
      goldenApp(
        Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: TextButton(
                onPressed: () => showExportPassphraseDialog(context),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/passphrase_dialog_export.png'),
    );
  });
}
