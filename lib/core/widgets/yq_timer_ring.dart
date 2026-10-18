import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/yq_colors.dart';
import '../theme/yq_typography.dart';
import 'yq_ltr.dart';

/// Ring dimensions: phone 96 (radius 40, stroke 9) or host 176 (stroke 16).
class YqTimerRingSize {
  const YqTimerRingSize({required this.size, required this.radius, required this.stroke});

  final double size;
  final double radius;
  final double stroke;

  static const YqTimerRingSize phone = YqTimerRingSize(size: 96, radius: 40, stroke: 9);
  static const YqTimerRingSize host = YqTimerRingSize(size: 176, radius: 72, stroke: 16);
  static const YqTimerRingSize desktop = YqTimerRingSize(size: 200, radius: 82, stroke: 18);
}

/// Countdown ring. Rebuild it as time passes (the caller ticks): it draws the
/// remaining fraction from 12 o'clock, `timerCalm` above 50 %, `timerWarn` at
/// or below, `timerPanic` in the last 5 s (pulsing to 1.08 once a second),
/// `inkMuted` at 0. Drains counter-clockwise in RTL; the number never flips.
class YqTimerRing extends StatelessWidget {
  const YqTimerRing({
    super.key,
    required this.remainingMs,
    required this.totalMs,
    this.dimensions = YqTimerRingSize.phone,
    this.numberStyle,
  });

  final int remainingMs;
  final int totalMs;
  final YqTimerRingSize dimensions;

  /// Defaults to `timer` (34/900); hosts pass `hostTimer`.
  final TextStyle? numberStyle;

  static const int panicMs = 5000;
  static const double _pulseScale = 1.08;

  /// Whole seconds shown: 14.2 s left shows 15, 0 shows 0.
  static int secondsLeft(int remainingMs) => (math.max(0, remainingMs) / 1000).ceil();

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final remaining = remainingMs.clamp(0, totalMs);
    final fraction = totalMs == 0 ? 0.0 : remaining / totalMs;
    final color = remaining <= 0
        ? c.inkMuted
        : remaining <= panicMs
        ? c.timerPanic
        : fraction <= 0.5
        ? c.timerWarn
        : c.timerCalm;

    // Pulse in the panic window: up at each whole second, back down by half.
    var scale = 1.0;
    if (remaining > 0 && remaining <= panicMs && !MediaQuery.disableAnimationsOf(context)) {
      final intoSecond = 1 - (remaining % 1000) / 1000;
      scale = 1 + (_pulseScale - 1) * math.max(0, 1 - intoSecond * 2);
    }

    final rtl = Directionality.of(context) == TextDirection.rtl;
    final d = dimensions;
    return Semantics(
      label: '${secondsLeft(remaining)}',
      liveRegion: remaining <= panicMs,
      child: Transform.scale(
        scale: scale,
        child: SizedBox.square(
          dimension: d.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.flip(
                flipX: rtl,
                child: CustomPaint(
                  size: Size.square(d.size),
                  painter: _RingPainter(
                    fraction: fraction,
                    radius: d.radius,
                    stroke: d.stroke,
                    track: c.surfaceAlt,
                    fill: c.surface,
                    arc: color,
                  ),
                ),
              ),
              YqNumberText(
                '${secondsLeft(remaining)}',
                style: (numberStyle ?? context.yqText.timer).copyWith(color: c.ink),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.fraction,
    required this.radius,
    required this.stroke,
    required this.track,
    required this.fill,
    required this.arc,
  });

  final double fraction;
  final double radius;
  final double stroke;
  final Color track;
  final Color fill;
  final Color arc;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    canvas
      ..drawCircle(center, radius - stroke / 2, Paint()..color = fill)
      ..drawCircle(
        center,
        radius,
        Paint()
          ..color = track
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke,
      );
    if (fraction <= 0) return;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * fraction,
      false,
      Paint()
        ..color = arc
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.fraction != fraction || old.arc != arc || old.track != track || old.fill != fill;
}
