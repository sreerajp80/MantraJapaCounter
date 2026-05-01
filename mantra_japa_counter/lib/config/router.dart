import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/counter_list_screen.dart';
import '../screens/counting_screen.dart';
import '../screens/history_screen.dart';
import '../screens/about_counter_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/help_screen.dart';
import '../screens/about_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const CounterListScreen(),
    ),
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
      path: '/help',
      builder: (context, state) => const HelpScreen(),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const AboutScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Page not found: ${state.uri}')),
  ),
);
