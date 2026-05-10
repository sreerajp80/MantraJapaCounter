import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../config/theme.dart';
import '../providers/counting_provider.dart';
import '../providers/app_providers.dart';
import '../providers/settings_provider.dart';
import '../utils/mala.dart';
import '../widgets/temple_decorations.dart';
import '../widgets/temple_mala_circle.dart';

/// Active counting screen — Temple variation.
///
/// Taps inside the bead circle increment the count; taps elsewhere are
/// inert. The mala (108 beads, drawn as 27 segments × 4 beads) is sized
/// responsively to the available space, with the live session count
/// displayed in EB Garamond italic at the centre.
class CountingScreen extends ConsumerStatefulWidget {
  final String counterId;
  const CountingScreen({super.key, required this.counterId});

  @override
  ConsumerState<CountingScreen> createState() => _CountingScreenState();
}

class _CountingScreenState extends ConsumerState<CountingScreen>
    with WidgetsBindingObserver {
  late Timer _displayTimer;

  // Two-finger horizontal swipe across the medallion fires one decrement per
  // gesture sequence. Pointers are tracked manually via Listener so we can
  // distinguish a single-finger tap (count up) from a multi-finger swipe.
  final Map<int, Offset> _activePointers = {};
  bool _swipeDecrementFired = false;
  static const double _swipeThresholdPx = 40;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(
      () =>
          ref.read(countingNotifierProvider(widget.counterId).notifier).init(),
    );
    // Force a rebuild every 1s so the timer pill ticks per-second.
    // The displayed value is read from `session.duration` in build, which
    // is pause-aware, so this no-ops cleanly while paused.
    _displayTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _displayTimer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      ref.read(countingNotifierProvider(widget.counterId).notifier).onPause();
    }
  }

  @override
  Widget build(BuildContext context) {
    final countingState = ref.watch(countingNotifierProvider(widget.counterId));
    final session = countingState.session;

    if (session == null) {
      return const Scaffold(
        backgroundColor: TempleColors.bg,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final counterAsync = ref.watch(_counterProvider(widget.counterId));
    final counter = counterAsync.value;

    // Live totals: state.lifetimeTotal already includes initialCount + DB SUM
    // (which itself includes this session up to lastDbWrittenCount). Adding
    // unflushedCount picks up the taps that haven't been persisted yet.
    final lifetimeWithSession = countingState.liveLifetimeTotal;
    final todayWithSession = countingState.liveTodayTotal;
    final isLifetimeGoalReached =
        counter?.isLifetimeGoalAchieved(lifetimeWithSession) ?? false;
    final isDailyGoalReached =
        counter?.isDailyGoalAchieved(todayWithSession) ?? false;

    final sessionMalas = session.tapCount ~/ 108;
    final sessionInMala = session.tapCount - sessionMalas * 108;
    final beadsRemaining = 108 - sessionInMala;

    return PopScope(
      // System back (gesture or hardware) must flush pending taps before
      // popping — otherwise the counter card on the list screen reads a
      // stale total from the DB. See _saveAndExit / completeSession.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _saveAndExit(context);
      },
      child: Scaffold(
      backgroundColor: TempleColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(
              context,
              durationMs: session.duration,
              isPaused: session.isPaused,
            ),
            _mantraTitle(session.counterName),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final available = math.min(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );
                  final medallion = (available * 0.98).clamp(240.0, 520.0);
                  final mala = medallion / 1.14;
                  final tapRadius = mala / 2;
                  final center = Offset(medallion / 2, medallion / 2);
                  return Center(
                    child: SizedBox(
                      width: medallion,
                      height: medallion,
                      child: Listener(
                        behavior: HitTestBehavior.translucent,
                        onPointerDown: (event) {
                          _activePointers[event.pointer] = event.position;
                        },
                        onPointerMove: _onPointerMove,
                        onPointerUp: _onPointerEnd,
                        onPointerCancel: _onPointerEnd,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapUp: (details) {
                            if ((details.localPosition - center).distance <=
                                tapRadius) {
                              ref
                                  .read(
                                    countingNotifierProvider(
                                      widget.counterId,
                                    ).notifier,
                                  )
                                  .tap();
                            }
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: medallion,
                                height: medallion,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: TempleColors.cardSoft,
                                ),
                              ),
                              TempleMedallion(
                                size: medallion,
                                color: isDailyGoalReached
                                    ? TempleColors.vermillionDeep
                                    : TempleColors.vermillion,
                                opacity: isDailyGoalReached ? 0.45 : 0.28,
                              ),
                              TempleMalaCircle(
                                count: sessionInMala,
                                goal: 108,
                                diameter: medallion,
                                goalReached: isDailyGoalReached,
                                child: _centerNumber(
                                  sessionInMala: sessionInMala,
                                  sessionMalas: sessionMalas,
                                  beadsRemaining: beadsRemaining,
                                  isLifetimeGoalReached:
                                      isLifetimeGoalReached,
                                  isDailyGoalReached: isDailyGoalReached,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            _footer(
              lifetimeTotal: lifetimeWithSession,
              todayTotal: todayWithSession,
              sessionTotal: session.tapCount,
              counterGoal: counter?.goal ?? 0,
              dailyGoal: counter?.dailyGoal ?? 0,
              isDailyGoalReached: isDailyGoalReached,
            ),
          ],
        ),
      ),
      ),
    );
  }

  // ── Top bar ───────────────────────────────────────────────────────────────
  Widget _topBar(
    BuildContext context, {
    required int durationMs,
    required bool isPaused,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TempleIconButton(
            onTap: () => _saveAndExit(context),
            child: const Icon(
              Icons.arrow_back,
              size: 18,
              color: TempleColors.ink,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: TempleColors.cardSoft,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: TempleColors.sandal.withValues(alpha: 0.33),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isPaused)
                  const Icon(
                    Icons.pause_circle_filled,
                    size: 14,
                    color: TempleColors.vermillion,
                  )
                else
                  const TempleDiyaIcon(
                    size: 14,
                    color: TempleColors.vermillion,
                  ),
                const SizedBox(width: 6),
                Text(
                  isPaused
                      ? 'PAUSED · ${_formatTime(durationMs)}'
                      : _formatTime(durationMs),
                  style: AppTheme.sans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: TempleColors.vermillion,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'More',
            onSelected: (v) => _onMenu(context, v),
            offset: const Offset(0, 44),
            child: Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: TempleColors.card,
                border: Border.fromBorderSide(
                  BorderSide(color: TempleColors.line),
                ),
              ),
              child: const Center(
                child: Icon(Icons.more_vert, size: 18, color: TempleColors.ink),
              ),
            ),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'history', child: Text('History')),
              PopupMenuItem(value: 'about', child: Text('About')),
              PopupMenuItem(
                value: 'reset_session',
                child: Text('Reset session'),
              ),
              PopupMenuItem(
                value: 'reset_counter',
                child: Text('Reset counter'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mantraTitle(String name) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 4),
      child: Column(
        children: [
          const SizedBox(
            height: 40,
            child: Center(
              child: TempleArch(
                width: 200,
                height: 36,
                color: TempleColors.vermillion,
                opacity: 0.25,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            name,
            textAlign: TextAlign.center,
            style: AppTheme.mal(
              fontSize: 22,
              color: TempleColors.ink,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _centerNumber({
    required int sessionInMala,
    required int sessionMalas,
    required int beadsRemaining,
    required bool isLifetimeGoalReached,
    required bool isDailyGoalReached,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          sessionInMala.toString(),
          style: AppTheme.serif(
            fontSize: 96,
            fontWeight: FontWeight.w500,
            color: TempleColors.ink,
            height: 0.85,
            letterSpacing: -3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'of one hundred eight',
          style: AppTheme.serif(
            fontSize: 14,
            color: TempleColors.ink,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isLifetimeGoalReached || isDailyGoalReached)
                    ? TempleColors.vermillion
                    : TempleColors.tulsi,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              isLifetimeGoalReached
                  ? 'LIFETIME GOAL'
                  : isDailyGoalReached
                  ? 'DAILY GOAL'
                  : '$beadsRemaining BEADS REMAIN',
              style: AppTheme.sans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: (isLifetimeGoalReached || isDailyGoalReached)
                    ? TempleColors.vermillionDeep
                    : TempleColors.ink,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        if (sessionMalas > 0) ...[
          const SizedBox(height: 6),
          Text(
            '+$sessionMalas mala this session',
            style: AppTheme.serif(
              fontSize: 11,
              color: TempleColors.sandal,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  // Two-finger horizontal swipe across the medallion = decrement once.
  // The Listener tracks pointers manually so a single-finger tap (handled by
  // the inner GestureDetector's onTapUp) can be cleanly distinguished from a
  // multi-finger swipe.
  void _onPointerMove(PointerMoveEvent event) {
    if (_swipeDecrementFired || _activePointers.length < 2) return;
    final start = _activePointers[event.pointer];
    if (start == null) return;
    if ((event.position.dx - start.dx).abs() < _swipeThresholdPx) return;

    _swipeDecrementFired = true;
    ref
        .read(countingNotifierProvider(widget.counterId).notifier)
        .decrement();
    final vibrationEnabled =
        ref.read(settingsNotifierProvider).vibrationEnabled;
    if (vibrationEnabled) {
      HapticFeedback.mediumImpact();
    }
  }

  void _onPointerEnd(PointerEvent event) {
    _activePointers.remove(event.pointer);
    if (_activePointers.isEmpty) {
      _swipeDecrementFired = false;
    }
  }

  Widget _footer({
    required int lifetimeTotal,
    required int todayTotal,
    required int sessionTotal,
    required int counterGoal,
    required int dailyGoal,
    required bool isDailyGoalReached,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
      child: Column(
        children: [
          _FooterStat(
            label: 'Lifetime',
            chants: counterGoal > 0
                ? '$lifetimeTotal/$counterGoal'
                : '$lifetimeTotal',
            malas: counterGoal > 0
                ? '${malaForCount(lifetimeTotal)}/${malaForCount(counterGoal)}'
                : '${malaForCount(lifetimeTotal)}',
          ),
          const SizedBox(height: 6),
          _FooterStat(
            label: 'Daily',
            chants: dailyGoal > 0
                ? '$todayTotal/$dailyGoal'
                : '$todayTotal',
            malas: dailyGoal > 0
                ? '${malaForCount(todayTotal)}/${malaForCount(dailyGoal)}'
                : '${malaForCount(todayTotal)}',
            highlighted: isDailyGoalReached,
          ),
          const SizedBox(height: 6),
          _FooterStat(
            label: 'Session',
            chants: '$sessionTotal',
            malas: '${malaForCount(sessionTotal)}',
          ),
        ],
      ),
    );
  }

  // ── Menu / dialogs ────────────────────────────────────────────────────────
  void _onMenu(BuildContext context, String action) {
    switch (action) {
      case 'history':
        context.push('/history?counterId=${widget.counterId}');
      case 'about':
        context.push('/counter/${widget.counterId}');
      case 'reset_session':
        _confirmResetSession(context);
      case 'reset_counter':
        _confirmResetCounter(context);
    }
  }

  Future<void> _saveAndExit(BuildContext context) async {
    await ref
        .read(countingNotifierProvider(widget.counterId).notifier)
        .completeSession();
    if (context.mounted) context.pop();
  }

  void _confirmResetSession(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reset session?'),
        content: const Text(
          'Current session will be discarded and the counter reset to 0.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref
                  .read(countingNotifierProvider(widget.counterId).notifier)
                  .resetSession();
            },
            child: const Text(
              'Reset',
              style: TextStyle(color: TempleColors.vermillionDeep),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmResetCounter(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reset counter?'),
        content: const Text(
          'All history for this counter will be deleted. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref
                  .read(countingNotifierProvider(widget.counterId).notifier)
                  .resetCounter();
            },
            child: const Text(
              'Reset all',
              style: TextStyle(color: TempleColors.vermillionDeep),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int ms) {
    final secs = ms ~/ 1000;
    final mins = secs ~/ 60;
    final hours = mins ~/ 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${(mins % 60).toString().padLeft(2, '0')}:${(secs % 60).toString().padLeft(2, '0')}';
    }
    return '${mins.toString().padLeft(2, '0')}:${(secs % 60).toString().padLeft(2, '0')}';
  }
}

class _FooterStat extends StatelessWidget {
  final String label;
  final String chants;
  final String malas;
  final bool highlighted;

  const _FooterStat({
    required this.label,
    required this.chants,
    required this.malas,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor =
        highlighted ? TempleColors.vermillion : TempleColors.card;
    final borderColor = highlighted
        ? TempleColors.vermillionDeep
        : TempleColors.sandal.withValues(alpha: 0.45);
    final shadowColor = highlighted
        ? TempleColors.vermillionDeep
        : TempleColors.sandal;
    final textColor = highlighted ? TempleColors.bg : TempleColors.ink;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.35),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.18),
            blurRadius: 4,
            spreadRadius: 0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTheme.eyebrow(
              fontSize: 9,
              letterSpacing: 1.5,
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _row(
                    chants,
                    'c',
                    fontSize: 18,
                    valueColor: textColor,
                    suffixColor: textColor,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _row(
                    malas,
                    'm',
                    fontSize: 14,
                    valueColor: textColor,
                    suffixColor: textColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(
    String value,
    String suffix, {
    required double fontSize,
    required Color valueColor,
    required Color suffixColor,
  }) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: value,
            style: AppTheme.serif(
              fontSize: fontSize,
              color: valueColor,
              fontWeight: FontWeight.w600,
              height: 1,
            ),
          ),
          const WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: SizedBox(width: 3),
          ),
          TextSpan(
            text: suffix,
            style: AppTheme.serif(
              fontSize: fontSize * 0.78,
              color: suffixColor,
              fontWeight: FontWeight.w600,
              height: 1,
            ),
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.fade,
      softWrap: false,
    );
  }
}

// Provider for a single counter (used in CountingScreen for goal info)
final _counterProvider = FutureProvider.autoDispose.family((
  ref,
  String counterId,
) async {
  final repo = ref.watch(japaCounterRepositoryProvider);
  return repo.getCounterById(counterId);
});
