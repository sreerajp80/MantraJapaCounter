import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../config/theme.dart';
import '../l10n/app_localizations.dart';
import '../models/counter.dart';
import '../models/counter_status.dart';
import '../providers/counters_provider.dart';
import '../providers/counter_stats_provider.dart';
import '../providers/app_providers.dart';
import '../widgets/counter_card.dart';
import '../widgets/temple_decorations.dart';

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
                child: _Header(
                  today: todayAsync,
                  onAdd: () => _showAddDialog(context, ref),
                  onMenu: (v) => _onMenu(context, ref, v),
                ),
              ),
              if (counters.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(),
                )
              else
                SliverList.builder(
                  itemCount: counters.length,
                  itemBuilder: (context, i) =>
                      _CounterCardWrapper(counter: counters[i]),
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
      builder: (_) => _CounterDialog(
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
      builder: (_) => _ImportExportDialog(ref: ref),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final AsyncValue<TodayAggregate> today;
  final VoidCallback onAdd;
  final void Function(String) onMenu;

  const _Header({
    required this.today,
    required this.onAdd,
    required this.onMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 18),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: TempleColors.line)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TempleIconButton(
                onTap: onAdd,
                child: const Icon(Icons.add, size: 18, color: TempleColors.ink),
              ),
              const TempleOmBadge(),
              _HeaderMenu(onMenu: onMenu),
            ],
          ),
          const SizedBox(height: 10),
          const TempleArch(width: 240, height: 50),
          Transform.translate(
            offset: const Offset(0, -4),
            child: Text(
              AppLocalizations.of(context).mantraCounters,
              style: AppTheme.serif(
                fontSize: 32,
                fontWeight: FontWeight.w500,
                color: TempleColors.ink,
                height: 1,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          today.when(
            loading: () => const SizedBox(height: 48),
            error: (_, _) => const SizedBox(height: 48),
            data: (t) => _TodaySummaryPill(today: t),
          ),
        ],
      ),
    );
  }
}

class _HeaderMenu extends StatelessWidget {
  final void Function(String) onMenu;
  const _HeaderMenu({required this.onMenu});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return PopupMenuButton<String>(
      onSelected: onMenu,
      tooltip: l.more,
      offset: const Offset(0, 44),
      child: Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: TempleColors.card,
          border: Border.fromBorderSide(BorderSide(color: TempleColors.line)),
        ),
        child: const Center(
          child: Icon(Icons.more_vert, size: 18, color: TempleColors.ink),
        ),
      ),
      itemBuilder: (_) => [
        PopupMenuItem(value: 'export', child: Text(l.menuImportExport)),
        PopupMenuItem(value: 'settings', child: Text(l.menuSettings)),
        PopupMenuItem(value: 'about', child: Text(l.menuAbout)),
      ],
    );
  }
}

class _TodaySummaryPill extends StatelessWidget {
  final TodayAggregate today;
  const _TodaySummaryPill({required this.today});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: TempleColors.cardSoft,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: TempleColors.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PillStat(
            value: today.chants.toString(),
            label: l.todayChants,
            color: TempleColors.vermillion,
          ),
          const _PillDivider(),
          _PillStat(
            value: today.malas.toString(),
            label: l.todayMalas,
            color: TempleColors.sandal,
          ),
          const _PillDivider(),
          _PillStat(
            value: today.counters.toString(),
            label: l.todayActive,
            color: TempleColors.tulsi,
          ),
        ],
      ),
    );
  }
}

class _PillStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _PillStat({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppTheme.serif(
              fontSize: 18,
              color: color,
              fontWeight: FontWeight.w500,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label.toUpperCase(),
            style: AppTheme.eyebrow(fontSize: 9, letterSpacing: 1.5),
          ),
        ],
      ),
    );
  }
}

class _PillDivider extends StatelessWidget {
  const _PillDivider();
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 28, color: TempleColors.line);
}

// ─── Empty state ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const TempleLotusIcon(size: 64, color: TempleColors.vermillion),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).noCountersYet,
            style: AppTheme.serif(fontSize: 22, color: TempleColors.ink),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).noCountersSubtitle,
            style: AppTheme.serif(
              fontSize: 13,
              color: TempleColors.ink3,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── Counter card wrapper with stats ─────────────────────────────────────────

class _CounterCardWrapper extends ConsumerWidget {
  final Counter counter;
  const _CounterCardWrapper({required this.counter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(counterStatsProvider(counter.id));

    return statsAsync.when(
      loading: () => CounterCard(
        counter: counter,
        totalCount: 0,
        todayCount: 0,
        onTap: () => context.push('/counting/${counter.id}'),
        onLongPress: () => _showOptions(context, ref),
        onToggleLock: () => ref
            .read(countersNotifierProvider.notifier)
            .toggleLock(counter.id),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (stats) => CounterCard(
        counter: counter,
        totalCount: stats.totalCount,
        todayCount: stats.todayCount,
        onTap: () => context.push('/counting/${counter.id}'),
        onLongPress: () => _showOptions(context, ref),
        onToggleLock: () => ref
            .read(countersNotifierProvider.notifier)
            .toggleLock(counter.id),
      ),
    );
  }

  void _showOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TempleColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: TempleColors.line),
      ),
      builder: (_) => _CounterOptionsSheet(counter: counter, ref: ref),
    );
  }
}

// ─── Options bottom sheet ─────────────────────────────────────────────────────

class _CounterOptionsSheet extends StatelessWidget {
  final Counter counter;
  final WidgetRef ref;
  const _CounterOptionsSheet({required this.counter, required this.ref});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: TempleColors.line,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(
              Icons.info_outline,
              color: TempleColors.vermillion,
            ),
            title: Text(l.aboutCounter),
            onTap: () {
              Navigator.pop(context);
              context.push('/counter/${counter.id}');
            },
          ),
          ListTile(
            leading: const Icon(Icons.history, color: TempleColors.vermillion),
            title: Text(l.history),
            onTap: () {
              Navigator.pop(context);
              context.push('/history?counterId=${counter.id}');
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit, color: TempleColors.vermillion),
            title: Text(l.edit),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (_) => _CounterDialog(
                  existing: counter,
                  onSave: (name, startDate, init, step, goal, daily) {
                    ref
                        .read(countersNotifierProvider.notifier)
                        .updateCounter(
                          counter.copyWith(
                            name: name,
                            startDate: startDate,
                            initialCount: init,
                            incrementStep: step,
                            goal: goal,
                            dailyGoal: daily,
                          ),
                        );
                  },
                ),
              );
            },
          ),
          if (counter.isActive) ...[
            ListTile(
              leading: Icon(
                counter.isLocked ? Icons.lock_open : Icons.lock_outline,
                color: TempleColors.vermillion,
              ),
              title: Text(counter.isLocked ? l.unlockCounter : l.lockCounter),
              onTap: () {
                Navigator.pop(context);
                ref
                    .read(countersNotifierProvider.notifier)
                    .toggleLock(counter.id);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.check_circle,
                color: TempleColors.tulsi,
              ),
              title: Text(l.disableSuccess),
              onTap: () {
                Navigator.pop(context);
                _confirmDisable(context, CounterStatus.disabledSuccess);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel, color: TempleColors.sandal),
              title: Text(l.disableFailure),
              onTap: () {
                Navigator.pop(context);
                _confirmDisable(context, CounterStatus.disabledFailure);
              },
            ),
          ],
          ListTile(
            leading: const Icon(
              Icons.delete,
              color: TempleColors.vermillionDeep,
            ),
            title: Text(
              l.delete,
              style: const TextStyle(color: TempleColors.vermillionDeep),
            ),
            onTap: () {
              Navigator.pop(context);
              _confirmDelete(context);
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.deleteCounterTitle),
        content: Text(l.deleteCounterMessage(counter.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref
                  .read(countersNotifierProvider.notifier)
                  .deleteCounter(counter.id);
            },
            child: Text(
              l.delete,
              style: const TextStyle(color: TempleColors.vermillionDeep),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDisable(BuildContext context, CounterStatus status) {
    final l = AppLocalizations.of(context);
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          status == CounterStatus.disabledSuccess
              ? l.disableAsCompletedTitle
              : l.disableCounterTitle,
        ),
        content: TextField(
          controller: reasonController,
          decoration: InputDecoration(
            labelText: l.reasonOptional,
            hintText: l.reasonHint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref
                  .read(countersNotifierProvider.notifier)
                  .disableCounter(
                    counter.id,
                    status,
                    reasonController.text.trim().isEmpty
                        ? null
                        : reasonController.text.trim(),
                  );
            },
            child: Text(l.confirm),
          ),
        ],
      ),
    );
  }
}

// ─── Add / Edit counter dialog ────────────────────────────────────────────────

class _CounterDialog extends StatefulWidget {
  final Counter? existing;
  final void Function(
    String name,
    int startDate,
    int init,
    int step,
    int goal,
    int daily,
  )
  onSave;

  const _CounterDialog({this.existing, required this.onSave});

  @override
  State<_CounterDialog> createState() => _CounterDialogState();
}

class _CounterDialogState extends State<_CounterDialog> {
  late final TextEditingController _name;
  late final TextEditingController _init;
  late final TextEditingController _step;
  late final TextEditingController _goal;
  late final TextEditingController _daily;
  late int _startDate;
  String? _dailyError;
  String? _stepError;

  @override
  void initState() {
    super.initState();
    final c = widget.existing;
    _name = TextEditingController(text: c?.name ?? '');
    _init = TextEditingController(text: (c?.initialCount ?? 0).toString());
    _step = TextEditingController(text: (c?.incrementStep ?? 1).toString());
    _goal = TextEditingController(text: (c?.goal ?? 0).toString());
    _daily = TextEditingController(text: (c?.dailyGoal ?? 0).toString());
    _startDate = c?.startDate ?? DateTime.now().millisecondsSinceEpoch;
  }

  @override
  void dispose() {
    _name.dispose();
    _init.dispose();
    _step.dispose();
    _goal.dispose();
    _daily.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isEdit = widget.existing != null;
    return AlertDialog(
      title: Text(isEdit ? l.editCounterTitle : l.newCounterTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _name,
              decoration: InputDecoration(labelText: l.counterNameLabel),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _init,
              decoration: InputDecoration(labelText: l.initialCountLabel),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _step,
              decoration: InputDecoration(
                labelText: l.incrementStepLabel,
                errorText: _stepError,
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) {
                if (_stepError != null) {
                  setState(() => _stepError = null);
                }
              },
            ),
            TextField(
              controller: _goal,
              decoration: InputDecoration(labelText: l.lifetimeGoalFieldLabel),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _daily,
              decoration: InputDecoration(
                labelText: l.dailyGoalFieldLabel,
                errorText: _dailyError,
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) {
                if (_dailyError != null || _stepError != null) {
                  setState(() {
                    _dailyError = null;
                    _stepError = null;
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(l.startDateLabel),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.fromMillisecondsSinceEpoch(
                        _startDate,
                      ),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        _startDate = picked.millisecondsSinceEpoch;
                      });
                    }
                  },
                  child: Text(
                    _formatDate(
                      DateTime.fromMillisecondsSinceEpoch(_startDate),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        TextButton(
          onPressed: () {
            final name = _name.text.trim();
            if (name.isEmpty) return;
            final goal = int.tryParse(_goal.text) ?? 0;
            final daily = int.tryParse(_daily.text) ?? 0;
            final step = int.tryParse(_step.text) ?? 1;
            if (goal > 0 && daily > goal) {
              setState(() {
                _dailyError = l.dailyExceedsLifetime;
              });
              return;
            }
            if (daily > 0 && step >= daily) {
              setState(() {
                _stepError = l.stepExceedsDaily;
              });
              return;
            }
            Navigator.pop(context);
            widget.onSave(
              name,
              _startDate,
              int.tryParse(_init.text) ?? 0,
              step,
              goal,
              daily,
            );
          },
          child: Text(isEdit ? l.save : l.create),
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}

// ─── Import / Export dialog ───────────────────────────────────────────────────

class _ImportExportDialog extends StatefulWidget {
  final WidgetRef ref;
  const _ImportExportDialog({required this.ref});

  @override
  State<_ImportExportDialog> createState() => _ImportExportDialogState();
}

class _ImportExportDialogState extends State<_ImportExportDialog> {
  bool _busy = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l.menuImportExport),
      content: _busy
          ? const SizedBox(
              height: 60,
              child: Center(child: CircularProgressIndicator()),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      _error!,
                      style: const TextStyle(
                        color: TempleColors.vermillionDeep,
                      ),
                    ),
                  ),
                Text(l.importExportBody),
              ],
            ),
      actions: _busy
          ? []
          : [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l.cancel),
              ),
              TextButton(onPressed: _doExport, child: Text(l.export)),
              TextButton(onPressed: _doImport, child: Text(l.import)),
            ],
    );
  }

  Future<void> _doExport() async {
    final l = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.ref.read(exportServiceProvider).exportAndShare();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() {
        _busy = false;
        _error = l.exportFailed('$e');
      });
    }
  }

  Future<void> _doImport() async {
    final l = AppLocalizations.of(context);
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result == null || result.files.single.path == null) return;

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final content = await File(result.files.single.path!).readAsString();
      await widget.ref.read(exportServiceProvider).importFromJson(content);
      widget.ref.invalidate(countersNotifierProvider);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.importSuccessful)));
      }
    } catch (e) {
      setState(() {
        _busy = false;
        _error = l.importFailed('$e');
      });
    }
  }
}
