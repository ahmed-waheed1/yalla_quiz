import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/yq_colors.dart';
import '../../../../core/theme/yq_spacing.dart';
import '../../../../core/theme/yq_typography.dart';
import '../../../../core/widgets/yq_answer_button.dart';
import '../../../../core/widgets/yq_avatar_stack.dart';
import '../../../../core/widgets/yq_banner.dart';
import '../../../../core/widgets/yq_card.dart';
import '../../../../core/widgets/yq_ltr.dart';
import '../../../../core/widgets/yq_scaffold.dart';
import '../../../../core/widgets/yq_spinner.dart';
import '../../../../core/widgets/yq_timer_ring.dart';
import '../../domain/entities/question.dart';
import '../../domain/services/game_engine.dart';
import '../cubit/game_cubit.dart';
import '../game_feedback.dart';
import 'game_header.dart';
import 'game_time.dart';

/// Milliseconds left on the current question's timer (never negative).
int questionRemainingMs(GameState state, int now) =>
    (GameEngine.questionEndsAt(state.room!) - now).clamp(0, 1 << 31);

/// 08 Question (phone): header, timer ring, question card, four answers and
/// a footer for unanswered / locked in / time's up.
class QuestionView extends StatelessWidget {
  const QuestionView({super.key, required this.state, required this.feedback});

  final GameState state;
  final GameFeedback feedback;

  static const double _bottomPadding = 36;
  static const double _cardMinHeight = 124;
  static const double _cardPadding = 18;
  static const double _categorySize = 13;

  @override
  Widget build(BuildContext context) {
    final room = state.room!;
    final c = context.yqColors;
    final t = context.yqText;
    final question = state.currentQuestion?.forLanguage(context.locale.languageCode);
    final totalMs = room.settings.timePerQuestion * 1000;
    final index = room.currentQuestionIndex;
    final mine = state.myOption;

    return GameTimeSelector<bool>(
      select: (now) => questionRemainingMs(state, now) <= 0,
      onChange: (_, timeUp) {
        if (timeUp && mine == null && !state.isSpectator) feedback.timeUp();
      },
      builder: (context, timeUp) => YqScaffold(
        bottomPadding: _bottomPadding,
        appBar: GameHeader(
          index: index,
          count: room.settings.questionCount,
          score: state.isSpectator ? null : state.me?.score,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: YqSpace.x5 - 2),
            Center(
              child: GameTimeSelector<int>(
                select: (now) => questionRemainingMs(state, now),
                onChange: (previous, next) {
                  final before = YqTimerRing.secondsLeft(previous);
                  final after = YqTimerRing.secondsLeft(next);
                  final panic = after > 0 && after * 1000 <= YqTimerRing.panicMs;
                  if (after != before && panic && mine == null && !state.isSpectator) {
                    feedback.panicTick();
                  }
                },
                builder: (context, remaining) =>
                    YqTimerRing(remainingMs: remaining, totalMs: totalMs),
              ),
            ),
            const SizedBox(height: YqSpace.x3 + 2),
            if (question == null)
              const Center(child: YqSpinner())
            else ...[
              _FadeUp(
                key: ValueKey('q$index'),
                child: YqCard(
                  padding: const EdgeInsetsDirectional.all(_cardPadding),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: _cardMinHeight - _cardPadding * 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'categories.${room.settings.category}'.tr(),
                          style: t.label.copyWith(
                            fontSize: _categorySize,
                            fontWeight: FontWeight.w800,
                            color: c.inkMuted,
                          ),
                        ),
                        const SizedBox(height: YqSpace.x1),
                        Text(question.text, style: t.question.copyWith(color: c.ink)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: YqSpace.x5 - 2),
              _Answers(
                key: ValueKey('a$index'),
                question: question,
                mine: mine,
                timeUp: timeUp,
                enabled: !state.isSpectator,
                onAnswer: (i) {
                  if (context.read<GameCubit>().answer(i)) feedback.lockIn();
                },
              ),
            ],
          ],
        ),
        bottom: _Footer(state: state, mine: mine, timeUp: timeUp),
      ),
    );
  }
}

class _Answers extends StatelessWidget {
  const _Answers({
    super.key,
    required this.question,
    required this.mine,
    required this.timeUp,
    required this.enabled,
    required this.onAnswer,
  });

  final LocalizedQuestion question;
  final int? mine;
  final bool timeUp;
  final bool enabled;
  final ValueChanged<int> onAnswer;

  static const Duration _stagger = Duration(milliseconds: 60);

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (var i = 0; i < question.options.length; i++) ...[
        if (i > 0) const SizedBox(height: YqSpace.x3),
        _FadeUp(
          delay: _stagger * i,
          child: YqAnswerButton(
            index: i,
            label: question.options[i],
            lockedLabel: 'game.locked'.tr(),
            state: mine != null
                ? (mine == i ? YqAnswerState.locked : YqAnswerState.dimmed)
                : timeUp
                ? YqAnswerState.timeUp
                : YqAnswerState.idle,
            onPressed: enabled ? () => onAnswer(i) : null,
          ),
        ),
      ],
    ],
  );
}

class _Footer extends StatelessWidget {
  const _Footer({required this.state, required this.mine, required this.timeUp});

  final GameState state;
  final int? mine;
  final bool timeUp;

  static const double _statusHeight = 56;
  static const double _stackAvatar = 28;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final t = context.yqText;
    final room = state.room!;
    final answers = room.answersFor(room.currentQuestionIndex);
    final contestants = room.contestants;
    final answered = [
      for (final p in contestants)
        if (answers.containsKey(p.uid)) p,
    ];
    final count = '${answered.length}/${contestants.length}';

    if (!state.isSpectator && mine == null && timeUp) {
      return YqBanner(
        kind: YqBannerKind.danger,
        icon: const Icon(Icons.schedule_rounded),
        title: 'game.time_up'.tr(),
        body: 'game.time_up_body'.tr(),
      );
    }
    if (!state.isSpectator && mine != null) {
      return Semantics(
        liveRegion: true,
        child: Container(
          constraints: const BoxConstraints(minHeight: _statusHeight),
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: YqSpace.x4,
            vertical: YqSpace.x2,
          ),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: YqRadius.all(YqRadius.lg),
            border: Border.all(color: c.line, width: 1.5),
          ),
          child: Row(
            children: [
              YqAvatarStack(
                seeds: [for (final p in answered) p.avatarSeed],
                size: _stackAvatar,
                overlap: 10,
                ring: 2,
                maxCount: 5,
              ),
              const SizedBox(width: YqSpace.x3),
              Expanded(
                child: Text(
                  'game.locked_waiting'.tr(),
                  style: t.titleSm.copyWith(fontSize: 14, color: c.ink),
                ),
              ),
              const SizedBox(width: YqSpace.x2),
              YqNumberText(count, style: t.numeric.copyWith(color: c.ink)),
            ],
          ),
        ),
      );
    }
    return Row(
      children: [
        Expanded(
          child: Text(
            state.isSpectator ? 'game.answer_on_phone'.tr() : 'game.pick_answer'.tr(),
            style: t.titleSm.copyWith(fontSize: 15, color: c.ink),
          ),
        ),
        Text(
          'game.answered_count'.tr(args: ['${answered.length}', '${contestants.length}']),
          style: t.numeric.copyWith(fontSize: 15, color: c.inkMuted),
        ),
      ],
    );
  }
}

/// Enters with a 12 px fade-up (`base`), optionally after [delay].
class _FadeUp extends StatelessWidget {
  const _FadeUp({super.key, required this.child, this.delay = Duration.zero});

  final Widget child;
  final Duration delay;

  static const double _rise = 12;

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    final duration = reduced ? YqMotion.reducedFade : YqMotion.base + delay;
    final start = reduced || duration == Duration.zero
        ? 0.0
        : delay.inMicroseconds / duration.inMicroseconds;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: Interval(start, 1, curve: YqMotion.out),
      builder: (context, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset(0, reduced ? 0 : _rise * (1 - v)), child: child),
      ),
      child: child,
    );
  }
}
