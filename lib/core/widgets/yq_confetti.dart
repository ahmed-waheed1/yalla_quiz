import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/yq_colors.dart';

/// Confetti of the four answer shapes and 8-point stars, kept to the side
/// margins so it never covers text. Plays once for [duration]; nothing under
/// reduced motion.
class YqConfetti extends StatefulWidget {
  const YqConfetti({
    super.key,
    this.duration = const Duration(seconds: 2),
    this.marginFraction = 0.16,
    this.pieces = 28,
    this.seed = 7,
  });

  final Duration duration;

  /// Width of each side band, as a fraction of the screen width.
  final double marginFraction;
  final int pieces;
  final int seed;

  @override
  State<YqConfetti> createState() => _YqConfettiState();
}

class _YqConfettiState extends State<YqConfetti> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final List<_Piece> _pieces = _Piece.scatter(widget.pieces, math.Random(widget.seed));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!MediaQuery.disableAnimationsOf(context) && !_controller.isAnimating) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return const SizedBox.expand();
    final c = context.yqColors;
    final colors = [for (final a in c.answers) a.fill, c.accent, c.primary];
    return IgnorePointer(
      child: ExcludeSemantics(
        child: CustomPaint(
          size: Size.infinite,
          painter: _ConfettiPainter(
            progress: _controller,
            pieces: _pieces,
            colors: colors,
            marginFraction: widget.marginFraction,
          ),
        ),
      ),
    );
  }
}

enum _Shape { triangle, diamond, circle, square, star }

class _Piece {
  _Piece(this.shape, this.side, this.x, this.y, this.fall, this.spin, this.size, this.color);

  final _Shape shape;

  /// 0 = start band, 1 = end band.
  final int side;

  /// Position inside the band (0–1) and start height (fraction of height).
  final double x;
  final double y;
  final double fall;
  final double spin;
  final double size;
  final int color;

  static List<_Piece> scatter(int count, math.Random r) => [
    for (var i = 0; i < count; i++)
      _Piece(
        _Shape.values[r.nextInt(_Shape.values.length)],
        i.isEven ? 0 : 1,
        r.nextDouble(),
        0.08 + r.nextDouble() * 0.35,
        0.12 + r.nextDouble() * 0.25,
        (r.nextDouble() - 0.5) * 6,
        7 + r.nextDouble() * 7,
        r.nextInt(6),
      ),
  ];
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({
    required this.progress,
    required this.pieces,
    required this.colors,
    required this.marginFraction,
  }) : super(repaint: progress);

  final Animation<double> progress;
  final List<_Piece> pieces;
  final List<Color> colors;
  final double marginFraction;

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress.value;
    if (t <= 0 || t >= 1) return;
    final band = size.width * marginFraction;
    final fade = t < 0.7 ? 1.0 : 1 - (t - 0.7) / 0.3;
    for (final p in pieces) {
      final x = p.side == 0 ? p.x * band : size.width - band + p.x * band;
      final y = (p.y + p.fall * Curves.easeIn.transform(t)) * size.height;
      final paint = Paint()..color = colors[p.color % colors.length].withValues(alpha: fade);
      canvas
        ..save()
        ..translate(x, y)
        ..rotate(p.spin * t);
      _draw(canvas, p.shape, p.size, paint);
      canvas.restore();
    }
  }

  static void _draw(Canvas canvas, _Shape shape, double s, Paint paint) {
    final h = s / 2;
    switch (shape) {
      case _Shape.circle:
        canvas.drawCircle(Offset.zero, h, paint);
      case _Shape.square:
        canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: s, height: s), paint);
      case _Shape.triangle:
        canvas.drawPath(
          Path()
            ..moveTo(0, -h)
            ..lineTo(h, h)
            ..lineTo(-h, h)
            ..close(),
          paint,
        );
      case _Shape.diamond:
        canvas.drawPath(
          Path()
            ..moveTo(0, -h)
            ..lineTo(h, 0)
            ..lineTo(0, h)
            ..lineTo(-h, 0)
            ..close(),
          paint,
        );
      case _Shape.star:
        // Two overlapping squares: the brand's 8-point star.
        final square = Rect.fromCenter(center: Offset.zero, width: s * 0.75, height: s * 0.75);
        canvas
          ..drawRect(square, paint)
          ..save()
          ..rotate(math.pi / 4)
          ..drawRect(square, paint)
          ..restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.colors != colors || old.pieces != pieces;
}
