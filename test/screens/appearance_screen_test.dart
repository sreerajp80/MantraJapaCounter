import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';
import 'package:mantra_japa_counter/repositories/settings_repository.dart';
import 'package:mantra_japa_counter/screens/appearance_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('AppearanceScreen renders brightness controls and palette details', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final prefs = await SharedPreferences.getInstance();
    final settingsRepo = SettingsRepository(prefs);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(settingsRepo),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AppearanceScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Appearance'), findsWidgets);
    expect(find.text('Temple Devotional Theme'), findsOneWidget);
    expect(find.text('Screen Brightness & Stillness'), findsOneWidget);
    expect(find.text('Sacred Temple Palette'), findsOneWidget);
    expect(find.text('Typography & Scripts'), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);
  });
}
