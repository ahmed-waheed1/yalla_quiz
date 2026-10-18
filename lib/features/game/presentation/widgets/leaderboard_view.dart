import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/yq_colors.dart';
import '../../../../core/theme/yq_spacing.dart';
import '../../../../core/theme/yq_typography.dart';
import '../../../../core/widgets/yq_leaderboard_row.dart';
import '../../../../core/widgets/yq_scaffold.dart';
import '../../../room/domain/entities/room.dart';
import '../../domain/services/standings.dart';
import '../cubit/game_cubit.dart';
import '../game_feedback.dart';
import 'game_time.dart';
import 'reveal_view.dart';

/// 10 Leaderboard (phone).
class LeaderboardView extends StatelessWidget {
  const LeaderboardView({super.key, required this.state, required this.feedback});

  final GameState state;
  final GameFeedback feedback;

  static const double _bottomPadding = 36;

  @override
  Widget build(BuildContext context) {
    final room = state.room!;
    final c = context.yqColors;
    final t = context.yqText;
    final standings = Standings.of(room);
    final mine = standings.where((s) => s.player.uid == state.myUid).firstOrNull;
    return YqScaffold(
      bottomPadding: _bottomPadding,
      appBar: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'game.after_question'.tr(
                    args: ['${room.currentQuestionIndex + 1}', '${room.settings.questionCount}'],
                  ),
                  style: t.label.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: c.inkMuted,
                  ),
                ),
                Text('game.leaderboard'.tr(), style: t.title.copyWith(color: c.ink)),
              ],
            ),
          ),
          if (mine != null && mine.delta > 0) _ClimbedChip(places: mine.delta),
        ],
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.only(top: YqSpace.x4),
        child: LeaderboardBoard(
          room: room,
          myUid: state.myUid,
          feedback: feedback,
          dimensions: YqLeaderboardRowSize.phone,
          gap: YqSpace.x2,
        ),
      ),
      bottom: PhaseCountdownFooter(
        phaseStartedAt: room.phaseStartedAt ?? 0,
        totalMs: GameTiming.leaderboard.inMilliseconds,
        label: (s) => 'game.next_question_in'.tr(args: ['${room.currentQuestionIndex + 2}', '$s']),
      ),
    );
  }
}

class _ClimbedChip extends StatelessWidget {
  const _ClimbedChip({required this.places});

  final int places;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: YqSpace.x4, vertical: YqSpace.x2),
      decoration: BoxDecoration(color: c.successSoft, borderRadius: YqRadius.all(YqRadius.pill)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_upward_rounded, size: 16, color: c.success),
          const SizedBox(width: YqSpace.x1),
          Text(
            'game.climbed'.plural(places),
            style: context.yqText.label.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: c.success,
            ),
          ),
        ],
      ),
    );
  }
}

/// The ranked rows. They start in the previous order, move to their new
/// ranks after 300 ms (500 ms, `inOut`, climbers scale to 1.03 and draw on
/// top), and the movement chips pop in at 800 ms. Timed from
/// `phaseStartedAt`, so a device that reconnects mid-phase lands on the
/// right frame.
class LeaderboardBoard extends StatelessWidget {
  const LeaderboardBoard({
    super.key,
    required this.room,
    required this.myUid,
    required this.feedback,
    required this.dimensions,
    required this.gap,
  });

  final Room room;
  final String? myUid;
  final GameFeedback feedback;
  final YqLeaderboardRowSize dimensions;
  final double gap;

  static const int _moveAtMs = 300;
  static const int _chipsAtMs = 800;
  static const double _climbScale = 1.03;

  /// 0: previous order, 1: moving to the new order, 2: chips shown.
  static int stageAt(int elapsedMs) => elapsedMs < _moveAtMs
      ? 0
      : elapsedMs < _chipsAtMs
      ? 1
      : 2;

  @override
  Widget build(BuildContext context) {
    final standings = Standings.of(room);
    final step = dimensions.height + gap;
    final start = room.phaseStartedAt ?? 0;
    final reduced = MediaQuery.disableAnimationsOf(context);

    return GameTimeSelector<int>(
      select: (now) => reduced ? 2 : stageAt(now - start),
      onChange: (previous, stage) {
        if (stage == 1) feedback.leaderboard();
        if (stage == 2 && standings.any((s) => s.player.uid == myUid)) feedback.yourRow();
      },
      builder: (context, stage) {
        // Climbers last so they draw above the rows they pass.
        final ordered = [...standings]..sort((a, b) => a.delta.compareTo(b.delta));
        return SizedBox(
          height: standings.isEmpty ? 0 : step * standings.length - gap,
          child: Stack(
            children: [
              for (final s in ordered)
                AnimatedPositionedDirectional(
                  key: ValueKey(s.player.uid),
                  duration: reduced ? Duration.zero : YqMotion.slow,
                  curve: YqMotion.inOut,
                  start: 0,
                  end: 0,
                  top: step * ((stage == 0 ? s.previousRank : s.rank) - 1),
                  height: dimensions.height,
                  child: TweenAnimationBuilder<double>(
                    key: ValueKey('${s.player.uid}-$stage'),
                    tween: Tween(begin: 0, end: 1),
                    duration: stage == 1 && s.delta > 0 && !reduced ? YqMotion.slow : Duration.zero,
                    builder: (context, v, child) => Transform.scale(
                      // Up to 1.03 at mid-flight and back.
                      scale: 1 + (_climbScale - 1) * (1 - (2 * v - 1).abs()),
                      child: child,
                    ),
                    child: _Row(
                      standing: s,
                      you: s.player.uid == myUid,
                      showDelta: stage == 2,
                      pulse: stage == 2 && !reduced,
                      dimensions: dimensions,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.standing,
    required this.you,
    required this.showDelta,
    required this.pulse,
    required this.dimensions,
  });

  final Standing standing;
  final bool you;
  final bool showDelta;
  final bool pulse;
  final YqLeaderboardRowSize dimensions;

  static const double _pulseScale = 1.04;

  @override
  Widget build(BuildContext context) {
    final p = standing.player;
    Widget row = YqLeaderboardRow(
      rank: standing.rank,
      name: you ? 'game.you_suffix'.tr(args: [p.name]) : p.name,
      avatarSeed: p.avatarSeed,
      score: p.score,
      delta: standing.delta,
      you: you,
      showDelta: showDelta,
      dimensions: dimensions,
    );
    if (you && pulse) {
      row = TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: YqMotion.base * 2,
        builder: (context, v, child) =>
            Transform.scale(scale: 1 + (_pulseScale - 1) * (1 - (2 * v - 1).abs()), child: child),
        child: row,
      );
    }
    return row;
  }
}
