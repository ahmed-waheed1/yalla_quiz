import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/yq_colors.dart';
import '../../../../core/theme/yq_spacing.dart';
import '../../../../core/theme/yq_typography.dart';
import '../../../../core/utils/numbers.dart';
import '../../../../core/widgets/yq_avatar.dart';
import '../../../../core/widgets/yq_ltr.dart';
import '../../../../core/widgets/yq_scaffold.dart';
import '../../../../core/widgets/yq_shake.dart';
import '../../../../core/widgets/yq_spinner.dart';
import '../../../../core/widgets/yq_vote_row.dart';
import '../../../room/domain/entities/room.dart';
import '../../domain/services/standings.dart';
import '../cubit/game_cubit.dart';
import '../game_feedback.dart';
import 'game_header.dart';
import 'game_time.dart';

/// Whether the 600 ms suspense hold at the start of a reveal is over.
bool revealSuspenseOver(Room room, int now) =>
    now - (room.phaseStartedAt ?? 0) >= YqMotion.reveal.inMilliseconds;

/// 09 Reveal (phone): result banner, the question, vote rows, and the
/// "Leaderboard in 3…" bar.
class RevealView extends StatelessWidget {
  const RevealView({super.key, required this.state, required this.feedback});

  final GameState state;
  final GameFeedback feedback;

  static const double _bottomPadding = 36;
  static const double _questionSize = 18;

  @override
  Widget build(BuildContext context) {
    final room = state.room!;
    final c = context.yqColors;
    final t = context.yqText;
    final full = state.currentQuestion;
    if (full == null) return const Center(child: YqSpinner());
    final question = full.forLanguage(context.locale.languageCode);
    final index = room.currentQuestionIndex;
    final mine = state.myOption;
    final votes = Standings.votes(room, index);
    final contestants = room.contestants.length;
    final me = state.me;

    return GameTimeSelector<bool>(
      select: (now) => revealSuspenseOver(room, now),
      onChange: (_, over) {
        if (!over || state.isSpectator || me == null) return;
        mine == full.answer ? feedback.correct() : feedback.wrong();
      },
      builder: (context, revealed) => YqScaffold(
        bottomPadding: _bottomPadding,
        appBar: GameHeader(
          index: index,
          count: room.settings.questionCount,
          score: state.isSpectator ? null : me?.score,
          showProgress: false,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: YqSpace.x3 + 2),
            _Reveal(
              revealed: revealed,
              child: state.isSpectator || me == null
                  ? FastestBanner(room: room, correctOption: full.answer)
                  : ResultBanner(
                      option: mine,
                      correctOption: full.answer,
                      correctLabel: question.options[full.answer],
                      player: me,
                      revealed: revealed,
                    ),
            ),
            const SizedBox(height: YqSpace.x5 - 2),
            Text(
              question.text,
              style: t.question.copyWith(fontSize: _questionSize, color: c.ink),
            ),
            const SizedBox(height: YqSpace.x3),
            for (var i = 0; i < question.options.length; i++) ...[
              if (i > 0) const SizedBox(height: YqSpace.x2 + 2),
              _VoteRowMotion(
                revealed: revealed,
                correct: i == full.answer,
                wrongPick: mine == i && i != full.answer,
                child: YqVoteRow(
                  index: i,
                  label: question.options[i],
                  votes: votes[i],
                  players: contestants,
                  youLabel: 'game.you'.tr(),
                  revealed: revealed,
                  correct: i == full.answer,
                  mine: mine == i,
                  barDelay: YqMotion.reveal + const Duration(milliseconds: 60) * i,
                ),
              ),
            ],
          ],
        ),
        bottom: PhaseCountdownFooter(
          phaseStartedAt: room.phaseStartedAt ?? 0,
          totalMs: GameTiming.reveal.inMilliseconds,
          barMs: GameTiming.reveal.inMilliseconds - YqMotion.reveal.inMilliseconds,
          label: (s) => index + 1 >= room.settings.questionCount
              ? 'game.results_in'.tr(args: ['$s'])
              : 'game.leaderboard_in'.tr(args: ['$s']),
        ),
      ),
    );
  }
}

/// Hidden during the suspense hold, then pops in.
class _Reveal extends StatelessWidget {
  const _Reveal({required this.revealed, required this.child});

  final bool revealed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    return AnimatedOpacity(
      opacity: revealed ? 1 : 0,
      duration: reduced ? YqMotion.reducedFade : YqMotion.base,
      child: AnimatedScale(
        scale: revealed || reduced ? 1 : 0.9,
        duration: YqMotion.base,
        curve: YqMotion.snap,
        child: child,
      ),
    );
  }
}

/// The correct row pops (1.08 → 1, `snap`); a wrong pick shakes.
class _VoteRowMotion extends StatelessWidget {
  const _VoteRowMotion({
    required this.revealed,
    required this.correct,
    required this.wrongPick,
    required this.child,
  });

  final bool revealed;
  final bool correct;
  final bool wrongPick;
  final Widget child;

  static const double _pop = 1.08;

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    Widget row = child;
    if (correct) {
      row = TweenAnimationBuilder<double>(
        key: ValueKey(revealed),
        tween: Tween(begin: revealed && !reduced ? _pop : 1, end: 1),
        duration: YqMotion.base,
        curve: YqMotion.snap,
        builder: (context, s, child) => Transform.scale(scale: s, child: child),
        child: row,
      );
    }
    if (wrongPick) row = YqShake(trigger: revealed ? 1 : 0, child: row);
    return row;
  }
}

/// The player's result: "Nailed it!" with the points, "So close!", or
/// "Time's up!" when they didn't answer.
class ResultBanner extends StatelessWidget {
  const ResultBanner({
    super.key,
    required this.option,
    required this.correctOption,
    required this.correctLabel,
    required this.player,
    required this.revealed,
  });

  final int? option;
  final int correctOption;
  final String correctLabel;
  final RoomPlayer player;
  final bool revealed;

  static const double _radius = 28;
  static const double _padding = 20;
  static const double _circle = 64;
  static const double _titleSize = 26;
  static const double _subSize = 13;
  static const double _pointsSize = 40;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final t = context.yqText;
    final correct = option == correctOption;
    final (Color soft, Color strong) = correct
        ? (c.successSoft, c.success)
        : (c.dangerSoft, c.danger);
    final title = correct
        ? 'game.correct_title'.tr()
        : option == null
        ? 'game.missed_title'.tr()
        : 'game.wrong_title'.tr();
    final sub = correct
        ? [
            'game.fast_bonus'.tr(),
            if (player.streak >= 2) 'game.streak'.tr(args: ['${player.streak}']),
          ].join(' · ')
        : [
            'game.it_was'.tr(args: [correctLabel]),
            if (option != null) 'game.streak_reset'.tr(),
          ].join(' · ');

    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsetsDirectional.all(_padding),
        decoration: BoxDecoration(
          color: soft,
          borderRadius: YqRadius.all(_radius),
          border: Border.all(color: strong, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: _circle,
              height: _circle,
              decoration: BoxDecoration(color: strong, shape: BoxShape.circle),
              child: Icon(
                correct ? Icons.check_rounded : Icons.close_rounded,
                size: _circle * 0.55,
                color: c.bg,
              ),
            ),
            const SizedBox(width: YqSpace.x4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: t.title.copyWith(fontSize: _titleSize, color: c.ink),
                  ),
                  Text(
                    sub,
                    style: t.caption.copyWith(
                      fontSize: _subSize,
                      fontWeight: FontWeight.w700,
                      color: c.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: YqSpace.x2),
            CountUpPoints(
              points: player.lastPoints,
              start: revealed,
              style: t.numeric.copyWith(fontSize: _pointsSize, color: strong),
            ),
          ],
        ),
      ),
    );
  }
}

/// "+850": counts up from 0 over 700 ms (`out`) and floats up 10 px once
/// [start] is true.
class CountUpPoints extends StatelessWidget {
  const CountUpPoints({super.key, required this.points, required this.start, required this.style});

  final int points;
  final bool start;
  final TextStyle style;

  static const Duration _duration = Duration(milliseconds: 700);
  static const double _float = 10;

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    return TweenAnimationBuilder<double>(
      key: ValueKey(start),
      tween: Tween(begin: start && !reduced ? 0 : 1, end: 1),
      duration: reduced ? YqMotion.reducedFade : _duration,
      curve: YqMotion.out,
      builder: (context, v, _) => Transform.translate(
        offset: Offset(0, reduced ? 0 : _float * (1 - v)),
        child: YqNumberText(formatPoints((points * v).round()), style: style),
      ),
    );
  }
}

/// Who answered right fastest (host / spectator view of the reveal).
class FastestBanner extends StatelessWidget {
  const FastestBanner({
    super.key,
    required this.room,
    required this.correctOption,
    this.avatarSize = 48,
    this.textSize = 18,
    this.pointsSize = 30,
    this.padding = 20,
  });

  final Room room;
  final int correctOption;
  final double avatarSize;
  final double textSize;
  final double pointsSize;
  final double padding;

  static const double _radius = 28;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final t = context.yqText;
    final fastest = Standings.fastestCorrect(room, room.currentQuestionIndex, correctOption);
    return Container(
      padding: EdgeInsetsDirectional.all(padding),
      decoration: BoxDecoration(
        color: fastest == null ? c.surfaceAlt : c.successSoft,
        borderRadius: YqRadius.all(_radius),
        border: Border.all(color: fastest == null ? c.line : c.success, width: 2),
      ),
      child: Row(
        children: [
          if (fastest != null) ...[
            YqAvatar(seed: fastest.$1.avatarSeed, size: avatarSize),
            SizedBox(width: math.max(YqSpace.x4, padding * 0.8)),
          ],
          Expanded(
            child: Text(
              fastest == null
                  ? 'game.nobody_right'.tr()
                  : 'game.fastest'.tr(args: [fastest.$1.name]),
              style: t.title.copyWith(fontSize: textSize, color: c.ink),
            ),
          ),
          if (fastest != null)
            YqNumberText(
              formatPoints(fastest.$2),
              style: t.numeric.copyWith(fontSize: pointsSize, color: c.success),
            ),
        ],
      ),
    );
  }
}

/// "Leaderboard in 3…" (or any [label]) with a 6 px bar that drains over the
/// last [barMs] of the phase.
class PhaseCountdownFooter extends StatelessWidget {
  const PhaseCountdownFooter({
    super.key,
    required this.phaseStartedAt,
    required this.totalMs,
    required this.label,
    this.barMs,
    this.textStyle,
  });

  final int phaseStartedAt;
  final int totalMs;
  final String Function(int seconds) label;

  /// Null hides the bar.
  final int? barMs;
  final TextStyle? textStyle;

  static const double _barHeight = 6;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final t = context.yqText;
    return GameTimeSelector<int>(
      // Quantised to 20 ms: smooth enough for the bar, cheap to rebuild.
      select: (now) => (phaseStartedAt + totalMs - now).clamp(0, totalMs) ~/ 20 * 20,
      builder: (context, remaining) {
        final seconds = math.max(1, (remaining / 1000).ceil());
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              label(seconds),
              textAlign: TextAlign.center,
              style:
                  textStyle ??
                  t.label.copyWith(fontSize: 15, fontWeight: FontWeight.w800, color: c.inkMuted),
            ),
            if (barMs != null) ...[
              const SizedBox(height: YqSpace.x3),
              ClipRRect(
                borderRadius: YqRadius.all(_barHeight / 2),
                child: SizedBox(
                  height: _barHeight,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned.fill(child: ColoredBox(color: c.surfaceAlt)),
                      FractionallySizedBox(
                        alignment: AlignmentDirectional.centerStart,
                        widthFactor: (remaining / barMs!).clamp(0.0, 1.0),
                        child: ColoredBox(color: c.primary),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
