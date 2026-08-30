import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mantra_japa_counter/core/config/config_service.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/screens/about_screen.dart';
import 'package:mantra_japa_counter/utils/build_date.g.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  testWidgets('AboutScreen renders app details and dynamic build date', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    PackageInfo.setMockInitialValues(
      appName: 'Mantra Test Counter',
      packageName: 'com.sreerajp.mantrajapacounter',
      version: '6.10.3',
      buildNumber: '20',
      buildSignature: '',
    );

    final customConfigService = ConfigService(
      loadAsset: (path) async => '''
      {
        "appName": "Mantra Test Counter",
        "description": "Test description for mantra counter",
        "version": "6.10.3",
        "build": "20",
        "details": {
          "Author": "Sreeraj P",
          "License": "Open Source"
        }
      }
      ''',
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: AboutScreen(configService: customConfigService),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('About'), findsOneWidget);
    expect(find.text('Mantra Test Counter'), findsOneWidget);
    expect(find.text('Version 6.10.3+20'), findsOneWidget);
    expect(find.text('Build date: $kBuildDate'), findsOneWidget);
    expect(find.text('Test description for mantra counter'), findsOneWidget);
    expect(find.text('Author'), findsOneWidget);
    expect(find.text('Sreeraj P'), findsOneWidget);
    expect(find.text('License'), findsOneWidget);
    expect(find.text('Open Source'), findsOneWidget);
  });
}
