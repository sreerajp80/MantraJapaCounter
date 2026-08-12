import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'config/flavor_config.dart';
import 'config/locale_config.dart';
import 'config/router.dart';
import 'config/theme.dart';
import 'l10n/app_localizations.dart';
import 'providers/app_providers.dart';
import 'repositories/japa_counter_repository.dart';
import 'repositories/settings_repository.dart';
import 'services/notification_service.dart';
import 'services/session_recovery_service.dart';

void main() async {
  // Step 1 — binding must be first
  WidgetsFlutterBinding.ensureInitialized();

  // Step 2 — lock portrait before any frames render
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Step 3 — open the database (schema v3, apply migrations if upgrading)
  final dbPath = p.join(await getDatabasesPath(), 'japa_counter.db');
  final db = await openDatabase(
    dbPath,
    version: 3,
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
