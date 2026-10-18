import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/yq_colors.dart';
import '../../../../core/theme/yq_spacing.dart';
import '../../../../core/theme/yq_typography.dart';
import '../../../../core/utils/numbers.dart';
import '../../../../core/widgets/yq_avatar.dart';
import '../../../../core/widgets/yq_button.dart';
import '../../../../core/widgets/yq_confetti.dart';
import '../../../../core/widgets/yq_glyph.dart';
import '../../../../core/widgets/yq_ltr.dart';
import '../../../../core/widgets/yq_scaffold.dart';
import '../../../room/domain/entities/room.dart';
import '../../domain/services/standings.dart';
import '../cubit/game_cubit.dart';
import '../game_feedback.dart';
import 'game_time.dart';

/// Podium timing: columns rise 3rd → 2nd → 1st (150 ms stagger, 600 ms
/// each, `back`), the crown lands, the ranking slides up, and the buttons
/// appear after 1.4 s so nobody taps away mid-celebration.
abstract final class _Timing {
  static const Duration stagger = Duration(milliseconds: 150);
  static const Duration rise = Duration(milliseconds: 600);
  static const Duration crown = Duration(milliseconds: 500);
  static const Duration crownAt = Duration(milliseconds: 900);
  static const Duration listAt = Duration(milliseconds: 1000);
  static const Duration buttonsAt = Duration(milliseconds: 1400);
}

/// 11 Final results (phone).
class FinalResultsView extends StatelessWidget {
  const FinalResultsView({
    super.key,
    required this.state,
    required this.feedback,
    required this.onHome,
  });

  final GameState state;
  final GameFeedback feedback;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    final room = state.room!;
    final standings = Standings.of(room);
    return Stack(
      children: [
        YqScaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: YqSpace.x1),
              FinalHeader(room: room, standings: standings),
              const SizedBox(height: YqSpace.x5 - 2),
              FinalPodium(standings: standings, feedback: feedback),
              const SizedBox(height: YqSpace.x3),
              FinalRanking(standings: standings, myUid: state.myUid),
            ],
          ),
          bottom: FinalButtons(room: room, onHome: onHome),
        ),
        const Positioned.fill(child: YqConfetti()),
      ],
    );
  }
}

/// "Game over · 10 questions" over "Nour takes the crown!".
class FinalHeader extends StatelessWidget {
  const FinalHeader({
    super.key,
    required this.room,
    required this.standings,
    this.labelSize = 14,
    this.titleSize = 28,
  });

  final Room room;
  final List<Standing> standings;
  final double labelSize;
  final double titleSize;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final t = context.yqText;
    return Column(
      children: [
        Text(
          'game.game_over'.plural(room.settings.questionCount),
          textAlign: TextAlign.center,
          style: t.label.copyWith(
            fontSize: labelSize,
            fontWeight: FontWeight.w800,
            color: c.inkMuted,
          ),
        ),
        if (standings.isNotEmpty)
          Text(
            'game.crown'.tr(args: [standings.first.player.name]),
            textAlign: TextAlign.center,
            style: t.title.copyWith(fontSize: titleSize, color: c.ink),
          ),
      ],
    );
  }
}

/// Three columns in visual order 2nd / 1st / 3rd (the row mirrors in RTL).
class FinalPodium extends StatelessWidget {
  const FinalPodium({super.key, required this.standings, required this.feedback, this.scale = 1});

  final List<Standing> standings;
  final GameFeedback feedback;
  final double scale;

  static const List<double> _avatar = [76, 60, 56];
  static const List<double> _block = [144, 104, 78];
  static const double _gap = 10;
  static const double _crown = 34;
  static const double _ring = 4;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final colors = [c.accent, c.podiumSilver, c.primary];
    final top = standings.take(3).toList();
    // Visual order: 2nd, 1st, 3rd.
    final order = [if (top.length > 1) 1, 0, if (top.length > 2) 2];
    final start = context.select<GameCubit, int>((g) => g.state.room?.phaseStartedAt ?? 0);
    return GameTimeSelector<bool>(
      select: (now) => now - start >= _Timing.crownAt.inMilliseconds,
      onChange: (_, landed) {
        if (landed) feedback.crown();
      },
      builder: (context, _) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final (i, place) in order.indexed) ...[
            if (i > 0) SizedBox(width: _gap * scale),
            Expanded(
              child: _Column(
                standing: top[place],
                place: place,
                color: colors[place],
                avatar: _avatar[place] * scale,
                block: _block[place] * scale,
                crown: place == 0 ? _crown * scale : null,
                ring: _ring * scale,
                scale: scale,
                // 3rd rises first, then 2nd, then 1st.
                delay: _Timing.stagger * (2 - place),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Column extends StatelessWidget {
  const _Column({
    required this.standing,
    required this.place,
    required this.color,
    required this.avatar,
    required this.block,
    required this.crown,
    required this.ring,
    required this.scale,
    required this.delay,
  });

  final Standing standing;
  final int place;
  final Color color;
  final double avatar;
  final double block;
  final double? crown;
  final double ring;
  final double scale;
  final Duration delay;

  static const double _blockTopRadius = 18;
  static const double _blockBottomRadius = 6;
  static const double _rankSize = 38;
  static const double _avatarDrop = 40;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final t = context.yqText;
    final reduced = MediaQuery.disableAnimationsOf(context);
    final p = standing.player;
    final total = reduced ? Duration.zero : delay + _Timing.rise;
    final startAt = total == Duration.zero ? 0.0 : delay.inMicroseconds / total.inMicroseconds;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: total,
      curve: Interval(startAt, 1),
      builder: (context, v, _) {
        final rise = YqMotion.back.transform(v);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (crown != null) _Crown(size: crown!),
            Opacity(
              opacity: v.clamp(0.0, 1.0),
              child: Transform.translate(
                // Avatars drop onto their columns.
                offset: Offset(0, -_avatarDrop * scale * (1 - v)),
                child: Container(
                  padding: EdgeInsetsDirectional.all(ring),
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  child: YqAvatar(seed: p.avatarSeed, size: avatar),
                ),
              ),
            ),
            SizedBox(height: YqSpace.x2 * scale),
            Text(
              p.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: t.titleSm.copyWith(fontSize: 15 * scale, color: c.ink),
            ),
            YqNumberText(
              formatScore(p.score),
              style: t.numeric.copyWith(
                fontSize: 13 * scale,
                fontWeight: FontWeight.w800,
                color: c.inkMuted,
              ),
            ),
            SizedBox(height: YqSpace.x2 * scale),
            SizedBox(
              height: block * rise.clamp(0.0, 1.2),
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadiusDirectional.vertical(
                    top: Radius.circular(_blockTopRadius * scale),
                    bottom: Radius.circular(_blockBottomRadius * scale),
                  ),
                ),
                child: ClipRect(
                  child: Align(
                    alignment: AlignmentDirectional.topCenter,
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(top: YqSpace.x3 * scale),
                      child: YqNumberText(
                        '${place + 1}',
                        style: t.numeric.copyWith(
                          fontSize: _rankSize * scale,
                          color: YqColors.brandNight,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Spins down onto #1.
class _Crown extends StatelessWidget {
  const _Crown({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    final total = reduced ? Duration.zero : _Timing.crownAt;
    final startAt = reduced
        ? 0.0
        : (_Timing.crownAt - _Timing.crown).inMicroseconds / _Timing.crownAt.inMicroseconds;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: total,
      curve: Interval(startAt, 1, curve: YqMotion.out),
      builder: (context, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(
          offset: Offset(0, -size * (1 - v)),
          child: Transform.rotate(angle: (1 - v) * 2 * math.pi, child: child),
        ),
      ),
      child: YqGlyphIcon(YqGlyph.crown, size: size, color: context.yqColors.accent),
    );
  }
}

/// Ranks 4–8 as compact rows, sliding up last.
class FinalRanking extends StatelessWidget {
  const FinalRanking({super.key, required this.standings, required this.myUid, this.scale = 1});

  final List<Standing> standings;
  final String? myUid;
  final double scale;

  static const double _height = 42;
  static const double _radius = 14;
  static const double _gap = 6;
  static const double _avatar = 28;
  static const double _rise = 24;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final t = context.yqText;
    final rest = standings.skip(3).toList();
    if (rest.isEmpty) return const SizedBox.shrink();
    final reduced = MediaQuery.disableAnimationsOf(context);
    final total = reduced ? Duration.zero : _Timing.listAt + YqMotion.base;
    final startAt = reduced ? 0.0 : _Timing.listAt.inMicroseconds / total.inMicroseconds;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: total,
      curve: Interval(startAt, 1, curve: YqMotion.out),
      builder: (context, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset(0, _rise * (1 - v)), child: child),
      ),
      child: Column(
        children: [
          for (final (i, s) in rest.indexed) ...[
            if (i > 0) SizedBox(height: _gap * scale),
            Container(
              height: _height * scale,
              padding: EdgeInsetsDirectional.symmetric(horizontal: YqSpace.x4 * scale),
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: YqRadius.all(_radius * scale),
                border: Border.all(
                  color: s.player.uid == myUid ? c.primary : c.line,
                  width: s.player.uid == myUid ? 3 : 1.5,
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: YqSpace.x6 * scale,
                    child: YqNumberText(
                      '${s.rank}',
                      style: t.numeric.copyWith(fontSize: 14 * scale, color: c.inkMuted),
                    ),
                  ),
                  SizedBox(width: YqSpace.x2 * scale),
                  YqAvatar(seed: s.player.avatarSeed, size: _avatar * scale),
                  SizedBox(width: YqSpace.x3 * scale),
                  Expanded(
                    child: Text(
                      s.player.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.titleSm.copyWith(fontSize: 15 * scale, color: c.ink),
                    ),
                  ),
                  YqNumberText(
                    formatScore(s.player.score),
                    style: t.numeric.copyWith(fontSize: 15 * scale, color: c.ink),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// "Home" (secondary, flex 1) and "Play again" (primary, flex 1.4), shown
/// after 1.4 s.
class FinalButtons extends StatelessWidget {
  const FinalButtons({super.key, required this.room, required this.onHome, this.height});

  final Room room;
  final VoidCallback onHome;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final start = room.phaseStartedAt ?? 0;
    final reduced = MediaQuery.disableAnimationsOf(context);
    return GameTimeSelector<bool>(
      select: (now) => now - start >= _Timing.buttonsAt.inMilliseconds,
      builder: (context, visible) => AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: reduced ? YqMotion.reducedFade : YqMotion.base,
        child: IgnorePointer(
          ignoring: !visible,
          child: Row(
            children: [
              Expanded(
                flex: 10,
                child: YqButton.secondary(
                  label: 'game.home'.tr(),
                  height: height ?? YqSpace.buttonHeight,
                  onPressed: onHome,
                ),
              ),
              const SizedBox(width: YqSpace.x3),
              Expanded(
                flex: 14,
                child: YqButton(
                  label: 'game.play_again'.tr(),
                  height: height ?? YqSpace.buttonHeight,
                  onPressed: () => context.read<GameCubit>().playAgain(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
