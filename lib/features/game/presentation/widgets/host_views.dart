import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/yq_colors.dart';
import '../../../../core/theme/yq_spacing.dart';
import '../../../../core/theme/yq_typography.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/yq_answer_shape.dart';
import '../../../../core/widgets/yq_avatar_stack.dart';
import '../../../../core/widgets/yq_confetti.dart';
import '../../../../core/widgets/yq_dot_grid.dart';
import '../../../../core/widgets/yq_leaderboard_row.dart';
import '../../../../core/widgets/yq_ltr.dart';
import '../../../../core/widgets/yq_spinner.dart';
import '../../../../core/widgets/yq_timer_ring.dart';
import '../../../room/domain/entities/room.dart';
import '../../domain/services/standings.dart';
import '../cubit/game_cubit.dart';
import '../game_feedback.dart';
import 'final_results_view.dart';
import 'game_header.dart';
import 'game_time.dart';
import 'leaderboard_view.dart';
import 'question_view.dart';
import 'reveal_view.dart';

/// Host big-screen frame (14–19): gutter 40 (48 on desktop), brand top bar,
/// scrolling body, pinned footer.
class HostScaffold extends StatelessWidget {
  const HostScaffold({
    super.key,
    required this.size,
    required this.room,
    required this.body,
    this.progress,
    this.footer,
  });

  final ScreenSize size;
  final Room room;
  final Widget body;
  final String? progress;
  final Widget? footer;

  static const double _desktopGutter = 48;
  static const double _maxContentWidth = 1200;

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.paddingOf(context);
    final gutter = size == ScreenSize.desktop ? _desktopGutter : YqSpace.hostGutter;
    return YqDotGridBackground(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxContentWidth),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              gutter,
              math.max(YqSpace.x8, insets.top + YqSpace.x4),
              gutter,
              math.max(YqSpace.x10, insets.bottom + YqSpace.x4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HostTopBar(code: room.code, progress: progress),
                const SizedBox(height: YqSpace.x8),
                Expanded(child: SingleChildScrollView(child: body)),
                if (footer != null) ...[const SizedBox(height: YqSpace.x6), footer!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _progress(Room room) => 'game.progress'.tr(
  args: ['${room.currentQuestionIndex + 1}', '${room.settings.questionCount}'],
);

/// Tile sizes for the 2 × 2 answer grid (16, 17).
class _TileSpec {
  const _TileSpec({required this.height, required this.textSize});

  final double height;
  final double textSize;

  static const double radius = 28;
  static const double padding = 24;
  static const double icon = 56;
  static const double stomp = 8;
  static const double gap = 20;
}

/// 16 Host question: timer, meta, the question and four big tiles; players
/// answer on their phones.
class HostQuestionView extends StatelessWidget {
  const HostQuestionView({super.key, required this.state, required this.size});

  final GameState state;
  final ScreenSize size;

  static const double _questionMaxWidth = 700;
  static const double _desktopQuestionSize = 64;
  static const double _metaSize = 18;
  static const double _footerAvatar = 44;
  static const double _footerTextSize = 20;

  @override
  Widget build(BuildContext context) {
    final room = state.room!;
    final c = context.yqColors;
    final t = context.yqText;
    final question = state.currentQuestion?.forLanguage(context.locale.languageCode);
    final desktop = size == ScreenSize.desktop;
    final totalMs = room.settings.timePerQuestion * 1000;
    final answers = room.answersFor(room.currentQuestionIndex);
    final answered = [
      for (final p in room.contestants)
        if (answers.containsKey(p.uid)) p,
    ];
    final timer = GameTimeSelector<int>(
      select: (now) => questionRemainingMs(state, now),
      builder: (context, remaining) => YqTimerRing(
        remainingMs: remaining,
        totalMs: totalMs,
        dimensions: desktop ? YqTimerRingSize.desktop : YqTimerRingSize.host,
        numberStyle: t.hostTimer,
      ),
    );
    final meta = Text(
      '${'categories.${room.settings.category}'.tr()} · '
      '${'game.question_of'.tr(args: ['${room.currentQuestionIndex + 1}', '${room.settings.questionCount}'])}',
      textAlign: desktop ? TextAlign.start : TextAlign.center,
      style: t.label.copyWith(fontSize: _metaSize, fontWeight: FontWeight.w800, color: c.inkMuted),
    );

    return HostScaffold(
      size: size,
      room: room,
      progress: _progress(room),
      body: question == null
          ? const Center(child: YqSpinner())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (desktop)
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            meta,
                            const SizedBox(height: YqSpace.x3),
                            Text(
                              question.text,
                              style: t.hostQuestion.copyWith(
                                fontSize: _desktopQuestionSize,
                                color: c.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: YqSpace.x8),
                      timer,
                    ],
                  )
                else ...[
                  Center(child: timer),
                  const SizedBox(height: YqSpace.x6),
                  meta,
                  const SizedBox(height: YqSpace.x6),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: _questionMaxWidth),
                      child: Text(
                        question.text,
                        textAlign: TextAlign.center,
                        style: t.hostQuestion.copyWith(color: c.ink),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: YqSpace.x10),
                _TileGrid(
                  options: question.options,
                  spec: desktop
                      ? const _TileSpec(height: 168, textSize: 42)
                      : _TileSpec(height: 196, textSize: t.hostAnswer.fontSize ?? 36),
                ),
              ],
            ),
      footer: Row(
        children: [
          YqAvatarStack(seeds: [for (final p in answered) p.avatarSeed], size: _footerAvatar),
          const SizedBox(width: YqSpace.x3),
          YqNumberText(
            '${answered.length}/${room.contestants.length}',
            style: t.numeric.copyWith(fontSize: _footerTextSize, color: c.ink),
          ),
          const Spacer(),
          Text(
            'game.answer_on_phone'.tr(),
            style: t.titleSm.copyWith(fontSize: _footerTextSize, color: c.inkMuted),
          ),
        ],
      ),
    );
  }
}

/// 17 Host reveal: the question, the tiles with vote bars (the correct one
/// outlined and checked, the others at 35 %), and who answered fastest.
class HostRevealView extends StatelessWidget {
  const HostRevealView({super.key, required this.state, required this.size});

  final GameState state;
  final ScreenSize size;

  static const double _questionSize = 44;

  @override
  Widget build(BuildContext context) {
    final room = state.room!;
    final c = context.yqColors;
    final t = context.yqText;
    final full = state.currentQuestion;
    final question = full?.forLanguage(context.locale.languageCode);
    return GameTimeSelector<bool>(
      select: (now) => revealSuspenseOver(room, now),
      builder: (context, revealed) => HostScaffold(
        size: size,
        room: room,
        progress: _progress(room),
        body: question == null || full == null
            ? const Center(child: YqSpinner())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    question.text,
                    textAlign: TextAlign.center,
                    style: t.hostQuestion.copyWith(fontSize: _questionSize, color: c.ink),
                  ),
                  const SizedBox(height: YqSpace.x8),
                  _TileGrid(
                    options: question.options,
                    spec: _TileSpec(height: 220, textSize: t.hostAnswer.fontSize ?? 36),
                    correct: revealed ? full.answer : null,
                    votes: Standings.votes(room, room.currentQuestionIndex),
                    players: room.contestants.length,
                  ),
                ],
              ),
        footer: full == null
            ? null
            : AnimatedOpacity(
                opacity: revealed ? 1 : 0,
                duration: YqMotion.base,
                child: FastestBanner(
                  room: room,
                  correctOption: full.answer,
                  avatarSize: 64,
                  textSize: 26,
                  pointsSize: 44,
                  padding: 28,
                ),
              ),
      ),
    );
  }
}

class _TileGrid extends StatelessWidget {
  const _TileGrid({
    required this.options,
    required this.spec,
    this.correct,
    this.votes,
    this.players = 0,
  });

  final List<String> options;
  final _TileSpec spec;

  /// Set on the reveal: outline this one, fade the rest.
  final int? correct;

  /// Set on the reveal: votes per option.
  final List<int>? votes;
  final int players;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (var row = 0; row < 2; row++) ...[
        if (row > 0) const SizedBox(height: _TileSpec.gap),
        Row(
          children: [
            for (var col = 0; col < 2; col++) ...[
              if (col > 0) const SizedBox(width: _TileSpec.gap),
              Expanded(
                child: _HostTile(
                  index: row * 2 + col,
                  label: options[row * 2 + col],
                  spec: spec,
                  correct: correct == null ? null : correct == row * 2 + col,
                  votes: votes?[row * 2 + col],
                  players: players,
                ),
              ),
            ],
          ],
        ),
      ],
    ],
  );
}

class _HostTile extends StatelessWidget {
  const _HostTile({
    required this.index,
    required this.label,
    required this.spec,
    required this.correct,
    required this.votes,
    required this.players,
  });

  final int index;
  final String label;
  final _TileSpec spec;

  /// Null before the reveal.
  final bool? correct;
  final int? votes;
  final int players;

  static const double _outline = 6;
  static const double _outlineGap = 5;
  static const double _check = 52;
  static const double _barHeight = 14;
  static const double _otherOpacity = 0.35;
  static const double _trackAlpha = 0.2;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final t = context.yqText;
    final style = c.answers[index];
    final reduced = MediaQuery.disableAnimationsOf(context);
    final tile = Container(
      height: spec.height,
      padding: const EdgeInsetsDirectional.all(_TileSpec.padding),
      decoration: BoxDecoration(
        color: style.fill,
        borderRadius: YqRadius.all(_TileSpec.radius),
        boxShadow: [BoxShadow(color: style.deep, offset: const Offset(0, _TileSpec.stomp))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              YqAnswerShapeIcon(shape: style.shape, size: _TileSpec.icon, color: style.onFill),
              const Spacer(),
              if (correct ?? false)
                Container(
                  width: _check,
                  height: _check,
                  decoration: BoxDecoration(color: c.success, shape: BoxShape.circle),
                  child: Icon(Icons.check_rounded, size: _check * 0.6, color: c.bg),
                ),
            ],
          ),
          // The label takes what's left and ellipsizes rather than overflow.
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: t.hostAnswer.copyWith(fontSize: spec.textSize, color: style.onFill),
              ),
            ),
          ),
          if (votes != null) ...[
            const SizedBox(height: YqSpace.x4),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: YqRadius.all(_barHeight / 2),
                    child: SizedBox(
                      height: _barHeight,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Positioned.fill(
                            child: ColoredBox(color: style.onFill.withValues(alpha: _trackAlpha)),
                          ),
                          TweenAnimationBuilder<double>(
                            tween: Tween(
                              begin: 0,
                              end: players == 0 ? 0 : (votes! / players).clamp(0.0, 1.0),
                            ),
                            duration: reduced ? YqMotion.reducedFade : YqMotion.slow,
                            curve: YqMotion.out,
                            builder: (context, v, _) => FractionallySizedBox(
                              alignment: AlignmentDirectional.centerStart,
                              widthFactor: v,
                              child: ColoredBox(color: style.onFill),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: YqSpace.x4),
                YqNumberText(
                  '$votes',
                  style: t.numeric.copyWith(fontSize: 28, color: style.onFill),
                ),
              ],
            ),
          ],
        ],
      ),
    );
    if (correct == null) return tile;
    return AnimatedOpacity(
      opacity: correct! ? 1 : _otherOpacity,
      duration: reduced ? YqMotion.reducedFade : YqMotion.fast,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          tile,
          if (correct!)
            PositionedDirectional(
              start: -(_outline + _outlineGap),
              top: -(_outline + _outlineGap),
              end: -(_outline + _outlineGap),
              bottom: -(_outline + _outlineGap),
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: YqRadius.all(_TileSpec.radius + _outline + _outlineGap),
                    border: Border.all(color: c.success, width: _outline),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 18 Host leaderboard.
class HostLeaderboardView extends StatelessWidget {
  const HostLeaderboardView({
    super.key,
    required this.state,
    required this.size,
    required this.feedback,
  });

  final GameState state;
  final ScreenSize size;
  final GameFeedback feedback;

  static const double _titleSize = 56;
  static const double _metaSize = 22;

  @override
  Widget build(BuildContext context) {
    final room = state.room!;
    final c = context.yqColors;
    final t = context.yqText;
    return HostScaffold(
      size: size,
      room: room,
      progress: _progress(room),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'game.after_question'.tr(
              args: ['${room.currentQuestionIndex + 1}', '${room.settings.questionCount}'],
            ),
            style: t.label.copyWith(
              fontSize: _metaSize,
              fontWeight: FontWeight.w800,
              color: c.inkMuted,
            ),
          ),
          Text(
            'game.leaderboard'.tr(),
            style: t.title.copyWith(fontSize: _titleSize, color: c.ink),
          ),
          const SizedBox(height: YqSpace.x6),
          LeaderboardBoard(
            room: room,
            myUid: state.myUid,
            feedback: feedback,
            dimensions: YqLeaderboardRowSize.host,
            gap: YqSpace.x3,
          ),
        ],
      ),
      footer: PhaseCountdownFooter(
        phaseStartedAt: room.phaseStartedAt ?? 0,
        totalMs: GameTiming.leaderboard.inMilliseconds,
        label: (s) => 'game.next_question_in'.tr(args: ['${room.currentQuestionIndex + 2}', '$s']),
        textStyle: t.label.copyWith(
          fontSize: _metaSize,
          fontWeight: FontWeight.w800,
          color: c.inkMuted,
        ),
      ),
    );
  }
}

/// 19 Host final results: the podium at 1.45×, ranks 4–8, confetti.
class HostFinalResultsView extends StatelessWidget {
  const HostFinalResultsView({
    super.key,
    required this.state,
    required this.size,
    required this.feedback,
    required this.onHome,
  });

  final GameState state;
  final ScreenSize size;
  final GameFeedback feedback;
  final VoidCallback onHome;

  static const double _podiumScale = 1.45;
  static const double _rankingScale = 1.38;
  static const double _contentWidth = 760;
  static const double _buttonsWidth = 560;
  static const double _buttonHeight = 72;

  @override
  Widget build(BuildContext context) {
    final room = state.room!;
    final standings = Standings.of(room);
    return Stack(
      children: [
        HostScaffold(
          size: size,
          room: room,
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _contentWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FinalHeader(room: room, standings: standings, labelSize: 22, titleSize: 52),
                  const SizedBox(height: YqSpace.x8),
                  FinalPodium(standings: standings, feedback: feedback, scale: _podiumScale),
                  const SizedBox(height: YqSpace.x5),
                  FinalRanking(standings: standings, myUid: null, scale: _rankingScale),
                ],
              ),
            ),
          ),
          footer: Center(
            child: SizedBox(
              width: _buttonsWidth,
              child: FinalButtons(room: room, onHome: onHome, height: _buttonHeight),
            ),
          ),
        ),
        const Positioned.fill(child: YqConfetti(marginFraction: 0.14, pieces: 40)),
      ],
    );
  }
}
