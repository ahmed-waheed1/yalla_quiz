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
import '../../../../core/widgets/yq_brand.dart';
import '../../../../core/widgets/yq_dot_grid.dart';
import '../../../../core/widgets/yq_ltr.dart';
import '../../../home/presentation/widgets/night_star.dart';
import '../../../room/domain/entities/room.dart';
import '../game_feedback.dart';
import 'game_time.dart';

/// 07 Get ready: 3, 2, 1 (a second each), then "Yalla!" until question 1.
class GetReadyView extends StatelessWidget {
  const GetReadyView({super.key, required this.room, required this.feedback});

  final Room room;
  final GameFeedback feedback;

  /// 3, 2, 1, then 0 for "Yalla!".
  static int digitAt(int elapsedMs) => elapsedMs < 0 ? 3 : math.max(0, 3 - elapsedMs ~/ 1000);

  @override
  Widget build(BuildContext context) {
    final start = room.phaseStartedAt ?? 0;
    return GameTimeSelector<int>(
      select: (now) => digitAt(now - start),
      onChange: (_, digit) => digit == 0 ? feedback.yalla() : feedback.countdownDigit(),
      builder: (context, digit) => AnimatedSwitcher(
        duration: MediaQuery.disableAnimationsOf(context) ? YqMotion.reducedFade : YqMotion.fast,
        child: digit == 0
            ? const _YallaPanel(key: ValueKey('yalla'))
            : _Digits(key: const ValueKey('digits'), room: room, digit: digit),
      ),
    );
  }
}

class _Digits extends StatelessWidget {
  const _Digits({super.key, required this.room, required this.digit});

  final Room room;
  final int digit;

  static const double _top = 128;
  static const double _ring = 240;
  static const double _ringRadius = 104;
  static const double _ringStroke = 16;
  static const double _digitSize = 136;
  static const double _avatar = 36;
  static const double _metaSize = 15;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final t = context.yqText;
    final reduced = MediaQuery.disableAnimationsOf(context);
    final players = room.contestants.where((p) => p.connected).toList();
    final start = room.phaseStartedAt ?? 0;
    final insets = MediaQuery.paddingOf(context);

    return YqDotGridBackground(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Breakpoints.phoneContentMaxWidth),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              YqSpace.gutter,
              _top.shrinkH,
              YqSpace.gutter,
              math.max(YqSpace.x10, insets.bottom + YqSpace.x4),
            ),
            child: Column(
              children: [
                Text(
                  'game.get_ready'.tr(),
                  textAlign: TextAlign.center,
                  style: t.headline.copyWith(fontSize: 34, color: c.ink),
                ),
                const SizedBox(height: YqSpace.x2),
                Text(
                  'game.get_ready_meta'.tr(
                    args: ['1', '${room.settings.questionCount}'],
                    namedArgs: {'category': 'categories.${room.settings.category}'.tr()},
                  ),
                  textAlign: TextAlign.center,
                  style: t.label.copyWith(
                    fontSize: _metaSize,
                    fontWeight: FontWeight.w700,
                    color: c.inkMuted,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: FittedBox(
                      child: SizedBox.square(
                        dimension: _ring * 1.25,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (!reduced) _Shockwave(key: ValueKey(digit), color: c.primary),
                            GameTimeSelector<double>(
                              select: (now) =>
                                  (1 - ((now - start) / 3000)).clamp(0.0, 1.0).toDouble(),
                              builder: (context, fraction) => CustomPaint(
                                size: const Size.square(_ring),
                                painter: _CountdownRingPainter(
                                  fraction: fraction,
                                  radius: _ringRadius,
                                  stroke: _ringStroke,
                                  track: c.surfaceAlt,
                                  fill: c.surface,
                                  arc: c.primary,
                                  rtl: Directionality.of(context) == TextDirection.rtl,
                                ),
                              ),
                            ),
                            _Digit(digit: digit, size: _digitSize, color: c.ink),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                YqAvatarStack(seeds: [for (final p in players) p.avatarSeed], size: _avatar),
                const SizedBox(height: YqSpace.x3),
                Text(
                  'game.players_ready'.plural(players.length),
                  textAlign: TextAlign.center,
                  style: t.label.copyWith(
                    fontSize: _metaSize,
                    fontWeight: FontWeight.w800,
                    color: c.inkMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The digit enters at 2.2× with a fade (300 ms, `snap`), and the previous
/// one exits to 0.6 (200 ms).
class _Digit extends StatelessWidget {
  const _Digit({required this.digit, required this.size, required this.color});

  final int digit;
  final double size;
  final Color color;

  static const double _enterScale = 2.2;
  static const double _exitScale = 0.6;
  static const Duration _enter = Duration(milliseconds: 300);
  static const Duration _exit = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    final key = ValueKey(digit);
    return AnimatedSwitcher(
      duration: reduced ? YqMotion.reducedFade : _enter,
      reverseDuration: reduced ? YqMotion.reducedFade : _exit,
      switchInCurve: YqMotion.snap,
      transitionBuilder: (child, animation) {
        if (reduced) return FadeTransition(opacity: animation, child: child);
        final entering = child.key == key;
        final scale = entering
            ? Tween(begin: _enterScale, end: 1.0).animate(animation)
            : Tween(begin: _exitScale, end: 1.0).animate(animation);
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: scale, child: child),
        );
      },
      child: YqNumberText(
        '$digit',
        key: key,
        style: context.yqText.timer.copyWith(fontSize: size, height: 1, color: color),
      ),
    );
  }
}

/// A faint ring expanding 0.7 → 1.5 and fading, once per digit.
class _Shockwave extends StatelessWidget {
  const _Shockwave({super.key, required this.color});

  final Color color;

  static const double _size = 240;
  static const double _stroke = 3;
  static const double _alpha = 0.3;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: const Duration(milliseconds: 900),
    curve: YqMotion.out,
    builder: (context, v, _) => Transform.scale(
      scale: 0.7 + 0.8 * v,
      child: Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: color.withValues(alpha: _alpha * (1 - v)),
            width: _stroke,
          ),
        ),
      ),
    ),
  );
}

class _CountdownRingPainter extends CustomPainter {
  _CountdownRingPainter({
    required this.fraction,
    required this.radius,
    required this.stroke,
    required this.track,
    required this.fill,
    required this.arc,
    required this.rtl,
  });

  final double fraction;
  final double radius;
  final double stroke;
  final Color track;
  final Color fill;
  final Color arc;
  final bool rtl;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    canvas
      ..drawCircle(center, radius, Paint()..color = fill)
      ..drawCircle(
        center,
        radius,
        Paint()
          ..color = track
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke,
      );
    if (fraction <= 0) return;
    final sweep = 2 * math.pi * fraction;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      rtl ? -sweep : sweep,
      false,
      Paint()
        ..color = arc
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );
  }

  @override
  bool shouldRepaint(_CountdownRingPainter old) =>
      old.fraction != fraction || old.arc != arc || old.track != track || old.rtl != rtl;
}

/// "Yalla!": full-bleed `primary` with the answer shapes and a 14 % night
/// star; the artwork spins and pops in (400 ms) as the flood fills.
class _YallaPanel extends StatelessWidget {
  const _YallaPanel({super.key});

  static const double _enterAngle = -8 * math.pi / 180;
  static const double _starAlpha = 0.14;
  static const double _starSize = 360;
  static const double _shapeSize = 96;
  static const double _subSize = 20;
  static const Duration _pop = Duration(milliseconds: 400);

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final reduced = MediaQuery.disableAnimationsOf(context);
    final night = YqColors.brandNight;
    return ColoredBox(
      color: c.primary,
      child: Stack(
        children: [
          for (final (i, align, angle) in const [
            (0, AlignmentDirectional(-0.8, -0.6), 0.3),
            (2, AlignmentDirectional(0.75, -0.62), 0.0),
            (1, AlignmentDirectional(-0.72, 0.62), 0.0),
            (3, AlignmentDirectional(0.75, 0.6), 0.28),
          ])
            Align(
              alignment: align,
              child: Transform.rotate(
                angle: angle,
                child: YqAnswerShapeIcon(
                  shape: c.answers[i].shape,
                  size: _shapeSize,
                  color: c.answers[i].fill,
                ),
              ),
            ),
          Center(
            child: NightStar(
              size: _starSize,
              color: night.withValues(alpha: _starAlpha),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: YqSpace.gutter),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: reduced ? 1 : 0, end: 1),
                    duration: reduced ? YqMotion.reducedFade : _pop,
                    builder: (context, v, child) {
                      // 0 → 1.15 → 1 and −8° → 0°, on top of the artwork's own −4° tilt.
                      final scale = v < 0.7 ? v / 0.7 * 1.15 : 1.15 - (v - 0.7) / 0.3 * 0.15;
                      return Opacity(
                        opacity: v.clamp(0.0, 1.0),
                        child: Transform.rotate(
                          angle: _enterAngle * (1 - v),
                          child: Transform.scale(scale: scale, child: child),
                        ),
                      );
                    },
                    child: YqYallaArtwork(semanticsLabel: 'game.yalla'.tr()),
                  ),
                  const SizedBox(height: YqSpace.x6),
                  Text(
                    'game.yalla_sub'.tr(),
                    textAlign: TextAlign.center,
                    style: context.yqText.titleSm.copyWith(
                      fontSize: _subSize,
                      fontWeight: FontWeight.w800,
                      color: night,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
