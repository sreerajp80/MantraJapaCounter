import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mantra_japa_counter/core/locale/locale_config.dart';
import 'package:mantra_japa_counter/models/counter.dart';
import 'package:mantra_japa_counter/models/export_data.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';

import 'package:mantra_japa_counter/providers/optical_sync_provider.dart';

class OpticalSyncImportPreviewSheet extends ConsumerStatefulWidget {
  const OpticalSyncImportPreviewSheet({super.key});

  @override
  ConsumerState<OpticalSyncImportPreviewSheet> createState() =>
      _OpticalSyncImportPreviewSheetState();
}

class _OpticalSyncImportPreviewSheetState
    extends ConsumerState<OpticalSyncImportPreviewSheet> {
  late Set<String> _selectedIds;
  List<Counter>? _parsedCounters;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _parseCounters();
    }
  }

  void _parseCounters() {
    final receiveState = ref.read(opticalSyncReceiveProvider);
    if (receiveState.decodedJsonMap != null) {
      try {
        final data = ExportData.fromJson(receiveState.decodedJsonMap!);
        _parsedCounters = data.counters;
        _selectedIds = data.counters.map((c) => c.id).toSet();
      } catch (_) {
        _parsedCounters = [];
        _selectedIds = {};
      }
    } else {
      _parsedCounters = [];
      _selectedIds = {};
    }
  }

  bool get _allSelected =>
      _parsedCounters != null && _selectedIds.length == _parsedCounters!.length;

  void _toggleAll() {
    setState(() {
      if (_allSelected) {
        _selectedIds.clear();
      } else {
        _selectedIds = _parsedCounters!.map((c) => c.id).toSet();
      }
    });
  }

  void _toggle(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final receiveState = ref.watch(opticalSyncReceiveProvider);
    final theme = Theme.of(context);

    final counterCount = receiveState.counterCount;
    final sessionCount = receiveState.sessionCount;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      padding: const EdgeInsets.all(24.0),
      decoration: const BoxDecoration(
        color: TempleColors.bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: TempleColors.tulsi.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: TempleColors.tulsi,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.opticalStreamComplete,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: TempleColors.vermillion,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l.opticalStreamCompleteSub,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: TempleColors.ink2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: TempleColors.line),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatPill(
                  theme,
                  icon: Icons.auto_stories_outlined,
                  label: l.opticalStatCounters,
                  value: '$counterCount',
                ),
                Container(height: 36, width: 1, color: TempleColors.line),
                _buildStatPill(
                  theme,
                  icon: Icons.history,
                  label: l.opticalStatSessionLogs,
                  value: '$sessionCount',
                ),
              ],
            ),
          ),
          // ──── Selective Counter List ────
          if (_parsedCounters != null && _parsedCounters!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              l.opticalImportSelectHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: TempleColors.ink2,
              ),
            ),
            const SizedBox(height: 8),
            // Select All / Deselect All row
            InkWell(
              onTap: _toggleAll,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      _allSelected
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: TempleColors.vermillion,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _allSelected ? l.deselectAll : l.selectAll,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TempleColors.vermillion,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      l.selectedCountersCount(_selectedIds.length),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: TempleColors.ink3,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, color: TempleColors.line),
            // Counter checklist
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _parsedCounters!.length,
                itemBuilder: (context, index) {
                  final counter = _parsedCounters![index];
                  final isSelected = _selectedIds.contains(counter.id);
                  return InkWell(
                    onTap: () => _toggle(counter.id),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? TempleColors.vermillion
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: isSelected
                                    ? TempleColors.vermillion
                                    : TempleColors.ink3,
                                width: 1.5,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 14,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              counter.name,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: TempleColors.ink,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _selectedIds.isEmpty
                  ? TempleColors.ink3.withValues(alpha: 0.3)
                  : TempleColors.vermillion,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.download_done_rounded),
            label: Text(
              l.opticalImportRestore,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onPressed: _selectedIds.isEmpty
                ? null
                : () async {
                    // Set selected counter IDs before importing
                    ref
                        .read(opticalSyncReceiveProvider.notifier)
                        .setSelectedCounterIds(_selectedIds.toList());

                    final success = await ref
                        .read(opticalSyncReceiveProvider.notifier)
                        .importData();
                    if (context.mounted) {
                      context.pop(); // Close sheet
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l.opticalImportSuccess),
                            backgroundColor: TempleColors.tulsi,
                          ),
                        );
                        context.pop(); // Exit scanner screen
                      } else {
                        final receiveState = ref.read(
                          opticalSyncReceiveProvider,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              receiveState.errorMessage ??
                                  l.opticalImportFailed,
                            ),
                            backgroundColor: TempleColors.vermillion,
                          ),
                        );
                      }
                    }
                  },
          ),
          if (_selectedIds.isEmpty) ...[
            const SizedBox(height: 6),
            Text(
              l.noCountersSelected,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: TempleColors.vermillionDeep,
                fontSize: 12,
              ),
            ),
          ],
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              LocaleConfig.strings().cancel,
              style: const TextStyle(color: TempleColors.ink2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatPill(
    ThemeData theme, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: TempleColors.sandal),
            const SizedBox(width: 6),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: TempleColors.vermillion,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: TempleColors.ink3),
        ),
      ],
    );
  }
}
