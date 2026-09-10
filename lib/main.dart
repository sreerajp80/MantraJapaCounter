import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mantra_japa_counter/core/constants/app_constants.dart';
import 'package:mantra_japa_counter/core/flavor/flavor_config.dart';
import 'package:mantra_japa_counter/core/locale/locale_config.dart';
import 'package:mantra_japa_counter/core/routing/router.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';
import 'package:mantra_japa_counter/repositories/japa_counter_repository.dart';
import 'package:mantra_japa_counter/repositories/settings_repository.dart';
import 'package:mantra_japa_counter/services/notification_service.dart';
import 'package:mantra_japa_counter/services/session_recovery_service.dart';

void main() async {
  // Step 1 — binding must be first
  WidgetsFlutterBinding.ensureInitialized();

  // Step 2 — lock portrait before any frames render
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Step 3 — open the database (schema version from AppConstants; migrations
  // in JapaCounterRepository run automatically when the version is bumped)
  final dbPath = p.join(await getDatabasesPath(), AppConstants.dbName);
  final db = await openDatabase(
    dbPath,
    version: AppConstants.dbVersion,
    onCreate: JapaCounterRepository.onCreate,
    onUpgrade: JapaCounterRepository.onUpgrade,
    onConfigure: (db) async {
      await db.execute('PRAGMA foreign_keys = ON');
    },
    onOpen: (db) async {
      await db.rawQuery('PRAGMA journal_mode = WAL');
    },
  );

  // Step 4 — SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Step 5 — load flavor from --dart-define
  AppFlavorConfig.init();

  // Step 6 — initialise local notifications
  final notifPlugin = FlutterLocalNotificationsPlugin();
  await NotificationService.initialize(notifPlugin);

  // Step 7 — recover any abandoned session before UI mounts
  final settingsRepo = SettingsRepository(prefs);
  final japaRepo = JapaCounterRepository(db);
  await SessionRecoveryService(japaRepo, settingsRepo).recoverIfNeeded();

  // Step 8 — run app inside ProviderScope with infrastructure overrides
  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        sharedPreferencesProvider.overrideWithValue(prefs),
        notificationsPluginProvider.overrideWithValue(notifPlugin),
      ],
      child: const MantraJapaCounterApp(),
    ),
  );
}

class MantraJapaCounterApp extends ConsumerWidget {
  const MantraJapaCounterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: AppFlavorConfig.appName,
      theme: AppTheme.light(),
      themeMode: ThemeMode.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: LocaleConfig.localeResolution,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: AppFlavorConfig.isDev,
    );
  }
}
