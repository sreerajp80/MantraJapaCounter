import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mantra_japa_counter/screens/counter_list/counter_list_screen.dart';
import 'package:mantra_japa_counter/screens/counting_screen.dart';
import 'package:mantra_japa_counter/screens/history/history_screen.dart';
import 'package:mantra_japa_counter/screens/about_counter_screen.dart';
import 'package:mantra_japa_counter/screens/settings/settings_screen.dart';
import 'package:mantra_japa_counter/screens/appearance_screen.dart';
import 'package:mantra_japa_counter/screens/features_screen.dart';
import 'package:mantra_japa_counter/screens/settings/sound_settings_screen.dart';
import 'package:mantra_japa_counter/screens/settings/display_settings_screen.dart';
import 'package:mantra_japa_counter/screens/settings/language_settings_screen.dart';
import 'package:mantra_japa_counter/screens/settings/backup_settings_screen.dart';
import 'package:mantra_japa_counter/screens/settings/permissions_screen.dart';
import 'package:mantra_japa_counter/screens/help/help_home_screen.dart';
import 'package:mantra_japa_counter/screens/help/tutorial_help_screen.dart';
import 'package:mantra_japa_counter/screens/help/counting_help_screen.dart';
import 'package:mantra_japa_counter/screens/help/mala_math_help_screen.dart';
import 'package:mantra_japa_counter/screens/help/optical_sync_help_screen.dart';
import 'package:mantra_japa_counter/screens/help/sound_haptics_help_screen.dart';
import 'package:mantra_japa_counter/screens/help/backup_help_screen.dart';
import 'package:mantra_japa_counter/screens/help/privacy_offline_help_screen.dart';
import 'package:mantra_japa_counter/screens/help/faq_help_screen.dart';
import 'package:mantra_japa_counter/screens/about_screen.dart';
import 'package:mantra_japa_counter/screens/optical_sync_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const CounterListScreen()),
    GoRoute(
      path: '/counting/:counterId',
      builder: (context, state) {
        final counterId = state.pathParameters['counterId']!;
        return CountingScreen(counterId: counterId);
      },
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) {
        final counterId = state.uri.queryParameters['counterId'];
        return HistoryScreen(filterCounterId: counterId);
      },
    ),
    GoRoute(
      path: '/counter/:counterId',
      builder: (context, state) {
        final counterId = state.pathParameters['counterId']!;
        return AboutCounterScreen(counterId: counterId);
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/settings/appearance',
      builder: (context, state) => const AppearanceScreen(),
    ),
    GoRoute(
      path: '/settings/features',
      builder: (context, state) => const FeaturesScreen(),
    ),
    GoRoute(
      path: '/settings/sound',
      builder: (context, state) => const SoundSettingsScreen(),
    ),
    GoRoute(
      path: '/settings/display',
      builder: (context, state) => const DisplaySettingsScreen(),
    ),
    GoRoute(
      path: '/settings/language',
      builder: (context, state) => const LanguageSettingsScreen(),
    ),
    GoRoute(
      path: '/settings/backup',
      builder: (context, state) => const BackupSettingsScreen(),
    ),
    GoRoute(
      path: '/settings/permissions',
      builder: (context, state) => const PermissionsScreen(),
    ),
    GoRoute(path: '/help', builder: (context, state) => const HelpHomeScreen()),
    GoRoute(
      path: '/help/tutorial',
      builder: (context, state) => const TutorialHelpScreen(),
    ),
    GoRoute(
      path: '/help/counting',
      builder: (context, state) => const CountingHelpScreen(),
    ),
    GoRoute(
      path: '/help/mala',
      builder: (context, state) => const MalaMathHelpScreen(),
    ),
    GoRoute(
      path: '/help/optical-sync',
      builder: (context, state) => const OpticalSyncHelpScreen(),
    ),
    GoRoute(
      path: '/help/sound-haptics',
      builder: (context, state) => const SoundHapticsHelpScreen(),
    ),
    GoRoute(
      path: '/help/backup',
      builder: (context, state) => const BackupHelpScreen(),
    ),
    GoRoute(
      path: '/help/privacy',
      builder: (context, state) => const PrivacyOfflineHelpScreen(),
    ),
    GoRoute(
      path: '/help/faqs',
      builder: (context, state) => const FaqHelpScreen(),
    ),
    GoRoute(path: '/about', builder: (context, state) => AboutScreen()),
    GoRoute(
      path: '/backup/optical-sync/transmit',
      builder: (context, state) => const OpticalSyncScreen(isTransmitter: true),
    ),
    GoRoute(
      path: '/backup/optical-sync/receive',
      builder: (context, state) =>
          const OpticalSyncScreen(isTransmitter: false),
    ),
  ],
  errorBuilder: (context, state) =>
      Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
);
