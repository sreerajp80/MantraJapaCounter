import 'dart:async';

import 'package:material_ui/material_ui.dart';
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
import 'package:mantra_japa_counter/providers/current_day_provider.dart';
import 'package:mantra_japa_counter/providers/settings_provider.dart';
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

class MantraJapaCounterApp extends ConsumerStatefulWidget {
  const MantraJapaCounterApp({super.key});

  @override
  ConsumerState<MantraJapaCounterApp> createState() =>
      _MantraJapaCounterAppState();
}

class _MantraJapaCounterAppState extends ConsumerState<MantraJapaCounterApp>
    with WidgetsBindingObserver {
  Timer? _midnightTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scheduleMidnightRefresh();
  }

  @override
  void dispose() {
    _midnightTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // The date may have changed while the app was in the background.
      ref.read(currentDayProvider.notifier).refresh();
      _scheduleMidnightRefresh();
    }
  }

  /// Refreshes the current day just after the next local midnight, so
  /// "today" numbers reset even when the app stays open.
  void _scheduleMidnightRefresh() {
    _midnightTimer?.cancel();
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    _midnightTimer = Timer(
      nextMidnight.difference(now) + const Duration(seconds: 1),
      () {
        if (!mounted) return;
        ref.read(currentDayProvider.notifier).refresh();
        _scheduleMidnightRefresh();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsNotifierProvider);
    final selectedCode = settings.languageCode;
    final explicitLocale = (selectedCode == null || selectedCode == 'system')
        ? null
        : Locale(selectedCode);

    // Keep LocaleConfig cached activeLocale updated for context-free lookups
    if (explicitLocale != null) {
      LocaleConfig.activeLocale = explicitLocale;
    } else {
      final device = WidgetsBinding.instance.platformDispatcher.locale;
      LocaleConfig.activeLocale = LocaleConfig.resolve(device);
    }

    return MaterialApp.router(
      onGenerateTitle: (context) {
        final title = AppLocalizations.of(context).appTitle;
        return AppFlavorConfig.isDev ? '$title Dev' : title;
      },
      theme: AppTheme.light(),
      themeMode: ThemeMode.light,
      locale: explicitLocale,
      localizationsDelegates: LocaleConfig.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: LocaleConfig.localeResolution,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: AppFlavorConfig.isDev,
    );
  }
}
