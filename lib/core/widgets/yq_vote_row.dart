import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/yq_colors.dart';
import '../theme/yq_spacing.dart';
import '../theme/yq_typography.dart';
import 'yq_answer_shape.dart';
import 'yq_ltr.dart';

/// One option on the reveal (09): a vote bar filling from the start edge,
/// shape tile, label, a "You" pill on your pick and the vote count. The
/// correct row gets a `success` outline and check; your wrong pick a dashed
/// `danger` outline and ×; the rest fade to 0.6.
class YqVoteRow extends StatelessWidget {
  const YqVoteRow({
    super.key,
    required this.index,
    required this.label,
    required this.votes,
    required this.players,
    required this.youLabel,
    this.revealed = true,
    this.correct = false,
    this.mine = false,
    this.barDelay = Duration.zero,
  });

  final int index;
  final String label;
  final int votes;
  final int players;
  final String youLabel;

  /// False during the suspense hold: no outlines, badges or fading yet.
  final bool revealed;
  final bool correct;
  final bool mine;

  /// Bars grow in staggered.
  final Duration barDelay;

  static const double _height = 62;
  static const double _tile = 38;
  static const double _tileRadius = 12;
  static const double _shapeSize = 20;
  static const double _labelSize = 17;
  static const double _badge = 28;
  static const double _outline = 3;
  static const double _outlineGap = 2;
  static const double _barAlpha = 0.25;
  static const double _otherOpacity = 0.6;
  static const double _youSize = 12;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final t = context.yqText;
    final style = c.answers[index];
    final reduced = MediaQuery.disableAnimationsOf(context);
    final share = players == 0 ? 0.0 : (votes / players).clamp(0.0, 1.0);
    final wrongPick = revealed && mine && !correct;
    final faded = revealed && !correct && !mine;

    final row = Container(
      height: _height,
      decoration: BoxDecoration(color: c.surface, borderRadius: YqRadius.all(YqRadius.lg)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: _VoteBar(
              share: share,
              color: style.fill.withValues(alpha: _barAlpha),
              delay: reduced ? Duration.zero : barDelay,
              duration: reduced ? YqMotion.reducedFade : YqMotion.slow,
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: YqSpace.x3),
            child: Row(
              children: [
                Container(
                  width: _tile,
                  height: _tile,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: style.fill,
                    borderRadius: YqRadius.all(_tileRadius),
                  ),
                  child: YqAnswerShapeIcon(
                    shape: style.shape,
                    size: _shapeSize,
                    color: style.onFill,
                  ),
                ),
                const SizedBox(width: YqSpace.x3),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.button.copyWith(fontSize: _labelSize, color: c.ink),
                  ),
                ),
                if (mine) ...[
                  const SizedBox(width: YqSpace.x2),
                  Container(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: YqSpace.x2,
                      vertical: YqSpace.x1,
                    ),
                    decoration: BoxDecoration(
                      color: c.ink,
                      borderRadius: YqRadius.all(YqRadius.xs),
                    ),
                    child: Text(
                      youLabel,
                      style: t.label.copyWith(
                        fontSize: _youSize,
                        fontWeight: FontWeight.w800,
                        color: c.bg,
                      ),
                    ),
                  ),
                ],
                const SizedBox(width: YqSpace.x3),
                YqNumberText('$votes', style: t.numeric.copyWith(color: c.ink)),
                if (revealed && (correct || wrongPick)) ...[
                  const SizedBox(width: YqSpace.x3),
                  Container(
                    width: _badge,
                    height: _badge,
                    decoration: BoxDecoration(
                      color: correct ? c.success : c.danger,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      correct ? Icons.check_rounded : Icons.close_rounded,
                      size: _badge * 0.65,
                      color: c.bg,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    return AnimatedOpacity(
      opacity: faded ? _otherOpacity : 1,
      duration: reduced ? YqMotion.reducedFade : YqMotion.fast,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          row,
          if (revealed && (correct || wrongPick))
            PositionedDirectional(
              start: -(_outline + _outlineGap),
              top: -(_outline + _outlineGap),
              end: -(_outline + _outlineGap),
              bottom: -(_outline + _outlineGap),
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _OutlinePainter(
                    color: correct ? c.success : c.danger,
                    width: _outline,
                    radius: YqRadius.lg + _outline + _outlineGap,
                    dashed: !correct,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _VoteBar extends StatelessWidget {
  const _VoteBar({
    required this.share,
    required this.color,
    required this.delay,
    required this.duration,
  });

  final double share;
  final Color color;
  final Duration delay;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final total = delay + duration;
    final start = total.inMicroseconds == 0 ? 0.0 : delay.inMicroseconds / total.inMicroseconds;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: share),
      duration: total,
      curve: Interval(start, 1, curve: YqMotion.out),
      builder: (context, value, _) => FractionallySizedBox(
        alignment: AlignmentDirectional.centerStart,
        widthFactor: value,
        child: ColoredBox(color: color),
      ),
    );
  }
}

class _OutlinePainter extends CustomPainter {
  _OutlinePainter({
    required this.color,
    required this.width,
    required this.radius,
    required this.dashed,
  });

  final Color color;
  final double width;
  final double radius;
  final bool dashed;

  static const double _dash = 9;
  static const double _gap = 6;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(width / 2);
    final path = Path()..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;
    if (!dashed) {
      canvas.drawPath(path, paint);
      return;
    }
    for (final metric in path.computeMetrics()) {
      for (var d = 0.0; d < metric.length; d += _dash + _gap) {
        canvas.drawPath(metric.extractPath(d, math.min(d + _dash, metric.length)), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_OutlinePainter old) =>
      old.color != color || old.dashed != dashed || old.width != width;
}
