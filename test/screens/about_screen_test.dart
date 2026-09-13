import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mantra_japa_counter/core/config/config_service.dart';
import 'package:mantra_japa_counter/core/flavor/flavor_config.dart';
import 'package:mantra_japa_counter/core/locale/locale_config.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/screens/about_screen.dart';
import 'package:mantra_japa_counter/core/utils/build_date.g.dart';
import 'package:mantra_japa_counter/widgets/made_with_love.dart';
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

  testWidgets('AboutScreen renders localized details in Sanskrit', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    PackageInfo.setMockInitialValues(
      appName: 'SreerajP MantraJapa Counter',
      packageName: 'com.sreerajp.mantrajapacounter',
      version: '6.11.0',
      buildNumber: '23',
      buildSignature: '',
    );

    final configService = ConfigService(
      loadAsset: (path) async => '''
      {
        "appName": "SreerajP MantraJapa Counter",
        "description": {
          "en": "Offline-first application for tracking mantra recitation practice with customizable counters and session history.",
          "ml": "അനുയോജ്യമായ കൗണ്ടറുകളും സെഷൻ നാൾവഴിയും ഉപയോഗിച്ച് മന്ത്രജപ സാധന ട്രാക്ക് ചെയ്യാനുള്ള ഓഫ്‌ലൈൻ ആപ്പ്.",
          "sa": "अनुकूलनीयगणकैः सत्रेतिहासैश्च सह मन्त्रजपसाधनायाः अनुसरणे अन्तर्जालरहितः अनुप्रयोगः।"
        },
        "version": "6.11.0",
        "build": "23",
        "details": {
          "author": {
            "en": "Sreeraj P",
            "ml": "ശ്രീരാജ് പി",
            "sa": "श्रीराज् पि"
          },
          "email": "sreerajp@zohomail.in",
          "license": {
            "en": "All libraries used are open source.",
            "ml": "ഉപയോഗിച്ചിരിക്കുന്ന എല്ലാ ലൈബ്രറികളും ഓപ്പൺ സോഴ്സ് ആണ്.",
            "sa": "सर्वे प्रयुक्ताः तन्त्रांशग्रन्थालयाः विवृतस्रोतांसि (open-source) सन्ति।"
          },
          "aiUsed": {
            "en": "Google Gemini / Anthropic Claude",
            "ml": "ഗൂഗിൾ ജെമിനി / ആന്ത്രോപിക് ക്ലോഡ്",
            "sa": "गूगल जेमिनी / एन्थ्रोपिक क्लाउड"
          },
          "ideUsed": {
            "en": "VS Code / Antigravity IDE",
            "ml": "വിഎസ് കോഡ് / ആന്റിഗ്രാവിറ്റി ഐഡിഇ",
            "sa": "वीएस कोड / एन्टीग्रैविटी आईडीई"
          }
        }
      }
      ''',
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('sa'),
        localizationsDelegates: const [
          FallbackMaterialLocalizationsDelegate(),
          FallbackCupertinoLocalizationsDelegate(),
          ...AppLocalizations.localizationsDelegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: AboutScreen(configService: configService),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('विषयपरिचयः'), findsOneWidget);
    expect(find.text('मन्त्रजपगणकः'), findsOneWidget);
    expect(
      find.text(
        'अनुकूलनीयगणकैः सत्रेतिहासैश्च सह मन्त्रजपसाधनायाः अनुसरणे अन्तर्जालरहितः अनुप्रयोगः।',
      ),
      findsOneWidget,
    );
    expect(find.text('लेखकः'), findsOneWidget);
    expect(find.text('श्रीराज् पि'), findsOneWidget);
    expect(find.text('विद्युत्पत्रम्'), findsOneWidget);
    expect(find.text('sreerajp@zohomail.in'), findsOneWidget);
    expect(find.text('अनुज्ञापत्रम्'), findsOneWidget);
    expect(
      find.text(
        'सर्वे प्रयुक्ताः तन्त्रांशग्रन्थालयाः विवृतस्रोतांसि (open-source) सन्ति।',
      ),
      findsOneWidget,
    );
    expect(find.text('प्रयुक्ता कृत्रिमबुद्धिः'), findsOneWidget);
    expect(find.text('गूगल जेमिनी / एन्थ्रोपिक क्लाउड'), findsOneWidget);
    expect(find.text('प्रयुक्तं विकाससाधनम्'), findsOneWidget);
    expect(find.text('वीएस कोड / एन्टीग्रैविटी आईडीई'), findsOneWidget);
    expect(find.byType(MadeWithLove), findsOneWidget);
  });

  testWidgets('AboutScreen renders localized details in Malayalam', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    PackageInfo.setMockInitialValues(
      appName: 'SreerajP MantraJapa Counter',
      packageName: 'com.sreerajp.mantrajapacounter',
      version: '6.11.0',
      buildNumber: '23',
      buildSignature: '',
    );

    final configService = ConfigService(
      loadAsset: (path) async => '''
      {
        "appName": "SreerajP MantraJapa Counter",
        "description": {
          "en": "Offline-first application for tracking mantra recitation practice with customizable counters and session history.",
          "ml": "അനുയോജ്യമായ കൗണ്ടറുകളും സെഷൻ നാൾവഴിയും ഉപയോഗിച്ച് മന്ത്രജപ സാധന ട്രാക്ക് ചെയ്യാനുള്ള ഓഫ്‌ലൈൻ ആപ്പ്.",
          "sa": "अनुकूलनीयगणकैः सत्रेतिहासैश्च सह मन्त्रजपसाधनायाः अनुसरणे अन्तर्जालरहितः अनुप्रयोगः।"
        },
        "version": "6.11.0",
        "build": "23",
        "details": {
          "author": {
            "en": "Sreeraj P",
            "ml": "ശ്രീരാജ് പി",
            "sa": "श्रीराज् पि"
          },
          "email": "sreerajp@zohomail.in",
          "license": {
            "en": "All libraries used are open source.",
            "ml": "ഉപയോഗിച്ചിരിക്കുന്ന എല്ലാ ലൈബ്രറികളും ഓപ്പൺ സോഴ്സ് ആണ്.",
            "sa": "सर्वे प्रयुक्ताः तन्त्रांशग्रन्थालयाः विवृतस्रोतांसि (open-source) सन्ति।"
          },
          "aiUsed": {
            "en": "Google Gemini / Anthropic Claude",
            "ml": "ഗൂഗിൾ ജെമിനി / ആന്ത്രോപിക് ക്ലോഡ്",
            "sa": "गूगल जेमिनी / एन्थ्रोपिक क्लाउड"
          },
          "ideUsed": {
            "en": "VS Code / Antigravity IDE",
            "ml": "വിഎസ് കോഡ് / ആന്റിഗ്രാവിറ്റി ഐഡിഇ",
            "sa": "वीएस कोड / एन्टीग्रैविटी आईडीई"
          }
        }
      }
      ''',
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ml'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: AboutScreen(configService: configService),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('ആപ്പിനെക്കുറിച്ച്'), findsOneWidget);
    expect(find.text('മന്ത്ര ജപ കൗണ്ടർ'), findsOneWidget);
    expect(find.text('രചയിതാവ്'), findsOneWidget);
    expect(find.text('ശ്രീരാജ് പി'), findsOneWidget);
    expect(find.text('ഇമെയിൽ'), findsOneWidget);
    expect(find.text('sreerajp@zohomail.in'), findsOneWidget);
    expect(find.text('ലൈസൻസ്'), findsOneWidget);
    expect(
      find.text('ഉപയോഗിച്ചിരിക്കുന്ന എല്ലാ ലൈബ്രറികളും ഓപ്പൺ സോഴ്സ് ആണ്.'),
      findsOneWidget,
    );
    expect(find.text('ഉപയോഗിച്ച AI'), findsOneWidget);
    expect(find.text('ഗൂഗിൾ ജെമിനി / ആന്ത്രോപിക് ക്ലോഡ്'), findsOneWidget);
    expect(find.text('ഉപയോഗിച്ച IDE'), findsOneWidget);
    expect(find.text('വിഎസ് കോഡ് / ആന്റിഗ്രാവിറ്റി ഐഡിഇ'), findsOneWidget);
    expect(find.byType(MadeWithLove), findsOneWidget);
  });

  testWidgets('AboutScreen renders DEV badge when flavor is dev', (
    tester,
  ) async {
    PackageInfo.setMockInitialValues(
      appName: 'SreerajP MantraJapa Counter',
      packageName: 'com.sreerajp.mantrajapacounter',
      version: '6.11.0',
      buildNumber: '23',
      buildSignature: '',
    );
    AppFlavorConfig.setFlavorForTesting(AppFlavor.dev);
    addTearDown(() => AppFlavorConfig.setFlavorForTesting(AppFlavor.prod));

    final configService = ConfigService(
      loadAsset: (path) async => '''
      {
        "appName": "SreerajP MantraJapa Counter",
        "description": "Dev flavor test",
        "version": "6.11.0",
        "build": "23",
        "details": {}
      }
      ''',
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('sa'),
        localizationsDelegates: const [
          FallbackMaterialLocalizationsDelegate(),
          FallbackCupertinoLocalizationsDelegate(),
          ...AppLocalizations.localizationsDelegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: AboutScreen(configService: configService),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('मन्त्रजपगणकः'), findsOneWidget);
    expect(find.text('DEV'), findsOneWidget);
  });

  testWidgets('AboutScreen does not render DEV badge when flavor is prod', (
    tester,
  ) async {
    PackageInfo.setMockInitialValues(
      appName: 'SreerajP MantraJapa Counter',
      packageName: 'com.sreerajp.mantrajapacounter',
      version: '6.11.0',
      buildNumber: '23',
      buildSignature: '',
    );
    AppFlavorConfig.setFlavorForTesting(AppFlavor.prod);

    final configService = ConfigService(
      loadAsset: (path) async => '''
      {
        "appName": "SreerajP MantraJapa Counter",
        "description": "Prod flavor test",
        "version": "6.11.0",
        "build": "23",
        "details": {}
      }
      ''',
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('sa'),
        localizationsDelegates: const [
          FallbackMaterialLocalizationsDelegate(),
          FallbackCupertinoLocalizationsDelegate(),
          ...AppLocalizations.localizationsDelegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: AboutScreen(configService: configService),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('मन्त्रजपगणकः'), findsOneWidget);
    expect(find.text('DEV'), findsNothing);
  });
}
