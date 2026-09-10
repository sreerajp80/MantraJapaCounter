import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/providers/counters_provider.dart';
import 'package:mantra_japa_counter/providers/counter_stats_provider.dart';
import 'package:mantra_japa_counter/widgets/counter_card.dart';
import 'package:mantra_japa_counter/screens/counter_list/counter_list_header.dart';
import 'package:mantra_japa_counter/screens/counter_list/counter_list_empty_state.dart';
import 'package:mantra_japa_counter/screens/counter_list/counter_list_item.dart';
import 'package:mantra_japa_counter/screens/counter_list/counter_dialog.dart';
import 'package:mantra_japa_counter/screens/counter_list/import_export_dialog.dart';

/// Home screen — Temple variation. Shows the devotional header, today
/// summary pill, and one [CounterCard] per counter.
class CounterListScreen extends ConsumerWidget {
  const CounterListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countersAsync = ref.watch(countersNotifierProvider);
    final todayAsync = ref.watch(todayAggregateProvider);

    return Scaffold(
      backgroundColor: TempleColors.bg,
      body: SafeArea(
        child: countersAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text(AppLocalizations.of(context).errorWithMessage('$e')),
          ),
          data: (counters) => CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: CounterListHeader(
                  today: todayAsync,
                  onAdd: () => _showAddDialog(context, ref),
                  onMenu: (v) => _onMenu(context, ref, v),
                ),
              ),
              if (counters.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: CounterListEmptyState(),
                )
              else
                SliverList.builder(
                  itemCount: counters.length,
                  itemBuilder: (context, i) =>
                      CounterListItem(counter: counters[i]),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 28)),
            ],
          ),
        ),
      ),
    );
  }

  void _onMenu(BuildContext context, WidgetRef ref, String v) {
    switch (v) {
      case 'export':
        _showImportExport(context, ref);
      case 'settings':
        context.push('/settings');
      case 'about':
        context.push('/about');
    }
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => CounterDialog(
        onSave: (name, startDate, init, step, goal, daily) {
          ref
              .read(countersNotifierProvider.notifier)
              .addCounter(
                name: name,
                startDate: startDate,
                initialCount: init,
                incrementStep: step,
                goal: goal,
                dailyGoal: daily,
              );
        },
      ),
    );
  }

  void _showImportExport(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => ImportExportDialog(ref: ref),
    );
  }
}
