@Tags(['golden'])
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mantra_japa_counter/providers/app_providers.dart';
import 'package:mantra_japa_counter/repositories/settings_repository.dart';
import 'package:mantra_japa_counter/screens/settings/settings_screen.dart';

import '../helpers/fake_japa_counter_repository.dart';
import '../helpers/golden_helpers.dart';

void main() {
  setUpAll(loadAppFonts);

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpSettings(WidgetTester tester, Locale locale) async {
    setGoldenSurface(tester);
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(
            SettingsRepository(prefs),
          ),
          japaCounterRepositoryProvider.overrideWithValue(
            FakeJapaCounterRepository(),
          ),
        ],
        child: goldenApp(const SettingsScreen(), locale: locale),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('SettingsScreen — English', (tester) async {
    await pumpSettings(tester, const Locale('en'));
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/settings_screen_en.png'),
    );
  });

  testWidgets('SettingsScreen — Malayalam', (tester) async {
    await pumpSettings(tester, const Locale('ml'));
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/settings_screen_ml.png'),
    );
  });
}
