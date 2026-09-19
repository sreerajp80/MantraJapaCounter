import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/providers/counting_provider.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';
import 'package:mantra_japa_counter/providers/settings_provider.dart';
import 'package:mantra_japa_counter/core/utils/mala.dart';
import 'package:mantra_japa_counter/widgets/temple_decorations.dart';
import 'package:mantra_japa_counter/widgets/temple_mala_circle.dart';

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
    Future.microtask(() {
      ref.read(countingNotifierProvider(widget.counterId).notifier).init();
      final settings = ref.read(settingsNotifierProvider);
      if (settings.dndEnabled) {
        ref.read(dndServiceProvider).setDndEnabled(true);
      }
    });
  }

  @override
  void dispose() {
    ref.read(dndServiceProvider).restoreDnd();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      ref.read(countingNotifierProvider(widget.counterId).notifier).onPause();
      ref.read(dndServiceProvider).restoreDnd();
    } else if (state == AppLifecycleState.resumed) {
      ref.read(countingNotifierProvider(widget.counterId).notifier).onResume();
      final settings = ref.read(settingsNotifierProvider);
      if (settings.dndEnabled) {
        ref.read(dndServiceProvider).setDndEnabled(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final countingState = ref.watch(countingNotifierProvider(widget.counterId));
    final session = countingState.session;
    final settings = ref.watch(settingsNotifierProvider);
    final isDimmed = settings.dimmedChantingMode;

    if (session == null) {
      return Scaffold(
        backgroundColor: isDimmed ? const Color(0xFF0D0A07) : TempleColors.bg,
        body: const Center(child: CircularProgressIndicator()),
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
        backgroundColor: isDimmed ? const Color(0xFF0D0A07) : TempleColors.bg,
        body: SafeArea(
          child: Column(
            children: [
              _topBar(context, isDimmed: isDimmed),
              _mantraTitle(session.counterName, isDimmed: isDimmed),
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
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isDimmed
                                        ? const Color(0xFF14100B)
                                        : TempleColors.cardSoft,
                                  ),
                                ),
                                TempleMedallion(
                                  size: medallion,
                                  color: isDailyGoalReached
                                      ? TempleColors.vermillionDeep
                                      : (isDimmed
                                            ? TempleColors.sandal
                                            : TempleColors.vermillion),
                                  opacity: isDailyGoalReached
                                      ? 0.45
                                      : (isDimmed ? 0.20 : 0.28),
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
                                    isDimmed: isDimmed,
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
                isDimmed: isDimmed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Top bar ───────────────────────────────────────────────────────────────
  Widget _topBar(BuildContext context, {required bool isDimmed}) {
    final l = AppLocalizations.of(context);
    final backBg = isDimmed ? const Color(0xFF1E1912) : TempleColors.card;
    final backBorder = isDimmed ? const Color(0xFF2E261C) : TempleColors.line;
    final iconColor = isDimmed ? TempleColors.sandal : TempleColors.ink;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            color: backBg,
            shape: StadiumBorder(side: BorderSide(color: backBorder)),
            child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: () => _saveAndExit(context),
              child: SizedBox(
                width: 64,
                height: 44,
                child: Center(
                  child: Icon(Icons.arrow_back, size: 22, color: iconColor),
                ),
              ),
            ),
          ),
          _SessionDurationPill(counterId: widget.counterId, isDimmed: isDimmed),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                color: backBg,
                shape: CircleBorder(side: BorderSide(color: backBorder)),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    ref
                        .read(settingsNotifierProvider.notifier)
                        .setDimmedChantingMode(!isDimmed);
                  },
                  child: SizedBox(
                    width: 38,
                    height: 38,
                    child: Center(
                      child: Icon(
                        isDimmed
                            ? Icons.nightlight_round
                            : Icons.nightlight_outlined,
                        size: 18,
                        color: iconColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                tooltip: l.more,
                onSelected: (v) => _onMenu(context, v),
                offset: const Offset(0, 44),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: backBg,
                    border: Border.fromBorderSide(
                      BorderSide(color: backBorder),
                    ),
                  ),
                  child: Center(
                    child: Icon(Icons.more_vert, size: 18, color: iconColor),
                  ),
                ),
                itemBuilder: (_) => [
                  PopupMenuItem(value: 'history', child: Text(l.history)),
                  PopupMenuItem(value: 'about', child: Text(l.menuAbout)),
                  PopupMenuItem(
                    value: 'reset_session',
                    child: Text(l.resetSession),
                  ),
                  PopupMenuItem(
                    value: 'reset_counter',
                    child: Text(l.resetCounter),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mantraTitle(String name, {required bool isDimmed}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 4),
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: Center(
              child: TempleArch(
                width: 200,
                height: 36,
                opacity: isDimmed ? 0.35 : 0.25,
                color: isDimmed ? TempleColors.sandal : TempleColors.vermillion,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            name,
            textAlign: TextAlign.center,
            style: AppTheme.mal(
              fontSize: 22,
              height: 1.2,
              color: isDimmed ? const Color(0xFFF5E6CC) : TempleColors.ink,
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
    required bool isDimmed,
  }) {
    final l = AppLocalizations.of(context);
    final countColor = isDimmed ? const Color(0xFFF5E6CC) : TempleColors.ink;
    final subColor = isDimmed ? TempleColors.sandal : TempleColors.ink;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          sessionInMala.toString(),
          style: AppTheme.serif(
            fontSize: 96,
            height: 0.85,
            letterSpacing: -3,
            color: countColor,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l.ofOneHundredEight,
          style: AppTheme.serif(fontSize: 14, color: subColor),
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
                  ? l.lifetimeGoalCaps
                  : isDailyGoalReached
                  ? l.dailyGoalCaps
                  : l.beadsRemainCaps(beadsRemaining),
              style: AppTheme.sans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: (isLifetimeGoalReached || isDailyGoalReached)
                    ? TempleColors.vermillionDeep
                    : subColor,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        if (sessionMalas > 0) ...[
          const SizedBox(height: 6),
          Text(
            l.malaThisSession(sessionMalas),
            style: AppTheme.serif(
              fontSize: 11,
              color: isDimmed
                  ? TempleColors.sandal
                  : TempleColors.vermillionDeep,
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
    ref.read(countingNotifierProvider(widget.counterId).notifier).decrement();
    final vibrationEnabled = ref
        .read(settingsNotifierProvider)
        .vibrationEnabled;
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
    required bool isDimmed,
  }) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
      child: Column(
        children: [
          _FooterStat(
            label: l.footerLifetime,
            chants: counterGoal > 0
                ? '$lifetimeTotal/$counterGoal'
                : '$lifetimeTotal',
            malas: counterGoal > 0
                ? '${malaForCount(lifetimeTotal)}/${malaForCount(counterGoal)}'
                : '${malaForCount(lifetimeTotal)}',
            isDimmed: isDimmed,
          ),
          const SizedBox(height: 6),
          _FooterStat(
            label: l.footerDaily,
            chants: dailyGoal > 0 ? '$todayTotal/$dailyGoal' : '$todayTotal',
            malas: dailyGoal > 0
                ? '${malaForCount(todayTotal)}/${malaForCount(dailyGoal)}'
                : '${malaForCount(todayTotal)}',
            highlighted: isDailyGoalReached,
            isDimmed: isDimmed,
          ),
          const SizedBox(height: 6),
          _FooterStat(
            label: l.footerSession,
            chants: '$sessionTotal',
            malas: '${malaForCount(sessionTotal)}',
            isDimmed: isDimmed,
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
    ref.read(dndServiceProvider).restoreDnd();
    await ref
        .read(countingNotifierProvider(widget.counterId).notifier)
        .completeSession();
    if (context.mounted) context.pop();
  }

  void _confirmResetSession(BuildContext context) {
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.resetSessionTitle),
        content: Text(l.resetSessionMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref
                  .read(countingNotifierProvider(widget.counterId).notifier)
                  .resetSession();
            },
            child: Text(
              l.reset,
              style: const TextStyle(color: TempleColors.vermillionDeep),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmResetCounter(BuildContext context) {
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.resetCounterTitle),
        content: Text(l.resetCounterMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref
                  .read(countingNotifierProvider(widget.counterId).notifier)
                  .resetCounter();
            },
            child: Text(
              l.resetAll,
              style: const TextStyle(color: TempleColors.vermillionDeep),
            ),
          ),
        ],
      ),
    );
  }
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

/// Isolated duration pill widget that ticks its own 1-second timer without
/// triggering a rebuild of the main counting screen.
class _SessionDurationPill extends ConsumerStatefulWidget {
  final String counterId;
  final bool isDimmed;

  const _SessionDurationPill({required this.counterId, required this.isDimmed});

  @override
  ConsumerState<_SessionDurationPill> createState() =>
      _SessionDurationPillState();
}

class _SessionDurationPillState extends ConsumerState<_SessionDurationPill>
    with WidgetsBindingObserver {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startTimerIfNeeded();
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _stopTimer();
    } else if (state == AppLifecycleState.resumed) {
      _startTimerIfNeeded();
    }
  }

  void _startTimerIfNeeded() {
    final session = ref
        .read(countingNotifierProvider(widget.counterId))
        .session;
    if (session != null && !session.isPaused) {
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
      });
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(
      countingNotifierProvider(widget.counterId).select((s) => s.session),
    );
    final isPaused = session?.isPaused ?? false;
    final durationMs = session?.duration ?? 0;

    if (isPaused && _timer != null) {
      _stopTimer();
    } else if (!isPaused && _timer == null) {
      _startTimerIfNeeded();
    }

    final l = AppLocalizations.of(context);
    final timeStr = _formatTime(durationMs);

    final bgColor = widget.isDimmed
        ? const Color(0xFF1E1912)
        : TempleColors.cardSoft;
    final borderColor = widget.isDimmed
        ? const Color(0xFF2E261C)
        : TempleColors.sandal.withValues(alpha: 0.33);
    final textColor = widget.isDimmed
        ? TempleColors.sandal
        : TempleColors.vermillion;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isPaused)
            Icon(Icons.pause_circle_filled, size: 14, color: textColor)
          else
            TempleDiyaIcon(size: 14, color: textColor),
          const SizedBox(width: 6),
          Text(
            isPaused ? l.pausedWithTime(timeStr) : timeStr,
            style: AppTheme.sans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: textColor,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterStat extends StatelessWidget {
  final String label;
  final String chants;
  final String malas;
  final bool highlighted;
  final bool isDimmed;

  const _FooterStat({
    required this.label,
    required this.chants,
    required this.malas,
    this.highlighted = false,
    this.isDimmed = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = highlighted
        ? (isDimmed ? TempleColors.vermillionDeep : TempleColors.vermillion)
        : (isDimmed ? const Color(0xFF16120D) : TempleColors.card);
    final borderColor = highlighted
        ? TempleColors.vermillion
        : (isDimmed
              ? const Color(0xFF2E261C)
              : TempleColors.sandal.withValues(alpha: 0.45));
    final shadowColor = isDimmed
        ? Colors.transparent
        : (highlighted ? TempleColors.vermillionDeep : TempleColors.sandal);
    final textColor = highlighted
        ? TempleColors.bg
        : (isDimmed ? const Color(0xFFE8D9B8) : TempleColors.ink);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: isDimmed
            ? null
            : [
                BoxShadow(
                  color: shadowColor.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
                BoxShadow(
                  color: shadowColor.withValues(alpha: 0.18),
                  blurRadius: 4,
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
              fontStyle: FontStyle.normal,
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
              fontStyle: FontStyle.normal,
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
