import 'package:flutter/material.dart';
import 'package:mantra_japa_counter/models/counter.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';

/// A reusable bottom sheet showing counters with checkboxes.
///
/// Used before optical sync transmit (pick counters to export) and after
/// optical sync receive (pick counters to import). Also used in the
/// JSON file export/import flow.
class CounterSelectionSheet extends StatefulWidget {
  /// The counters to display.
  final List<Counter> counters;

  /// Optional title override. Falls back to localized default.
  final String? title;

  /// Optional subtitle override. Falls back to localized default.
  final String? subtitle;

  /// Called when the user confirms selection.
  final ValueChanged<List<String>> onConfirm;

  /// If true, all counters are pre-selected. Defaults to true.
  final bool allSelectedByDefault;

  const CounterSelectionSheet({
    super.key,
    required this.counters,
    required this.onConfirm,
    this.title,
    this.subtitle,
    this.allSelectedByDefault = true,
  });

  @override
  State<CounterSelectionSheet> createState() => _CounterSelectionSheetState();
}

class _CounterSelectionSheetState extends State<CounterSelectionSheet> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.allSelectedByDefault
        ? widget.counters.map((c) => c.id).toSet()
        : <String>{};
  }

  bool get _allSelected => _selected.length == widget.counters.length;

  void _toggleAll() {
    setState(() {
      if (_allSelected) {
        _selected.clear();
      } else {
        _selected = widget.counters.map((c) => c.id).toSet();
      }
    });
  }

  void _toggle(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else {
        _selected.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: const BoxDecoration(
        color: TempleColors.bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: TempleColors.ink3.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Title row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: TempleColors.sandal.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.checklist_rounded,
                  color: TempleColors.vermillion,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title ?? l.selectCountersTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: TempleColors.vermillion,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle ?? l.selectCountersSub,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: TempleColors.ink2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Select All / Deselect All
          InkWell(
            onTap: _toggleAll,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Row(
                children: [
                  Icon(
                    _allSelected
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: TempleColors.vermillion,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _allSelected ? l.deselectAll : l.selectAll,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TempleColors.vermillion,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    l.selectedCountersCount(_selected.length),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: TempleColors.ink3,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Divider(height: 1, color: TempleColors.line),
          const SizedBox(height: 4),
          // Counter list
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.counters.length,
              itemBuilder: (context, index) {
                final counter = widget.counters[index];
                final isSelected = _selected.contains(counter.id);
                return _CounterCheckTile(
                  counter: counter,
                  isSelected: isSelected,
                  onTap: () => _toggle(counter.id),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Continue button
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _selected.isEmpty
                  ? TempleColors.ink3.withValues(alpha: 0.3)
                  : TempleColors.vermillion,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.arrow_forward_rounded, size: 20),
            label: Text(
              l.continueAction,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onPressed: _selected.isEmpty
                ? null
                : () => widget.onConfirm(_selected.toList()),
          ),
          if (_selected.isEmpty) ...[
            const SizedBox(height: 6),
            Text(
              l.noCountersSelected,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: TempleColors.vermillionDeep,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CounterCheckTile extends StatelessWidget {
  final Counter counter;
  final bool isSelected;
  final VoidCallback onTap;

  const _CounterCheckTile({
    required this.counter,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isSelected
                    ? TempleColors.vermillion
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected
                      ? TempleColors.vermillion
                      : TempleColors.ink3,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    counter.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TempleColors.ink,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!counter.isActive)
                    Text(
                      counter.status.toDb(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: TempleColors.ink3,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              counter.isActive
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              size: 14,
              color: counter.isActive ? TempleColors.tulsi : TempleColors.ink3,
            ),
          ],
        ),
      ),
    );
  }
}
