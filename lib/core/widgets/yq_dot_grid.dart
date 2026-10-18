import 'package:flutter/widgets.dart';

import '../theme/yq_colors.dart';

/// Screen ground: `bg` with a 24 × 24 dot grid in `bgPattern` (dot radius 1.6).
class YqDotGridBackground extends StatelessWidget {
  const YqDotGridBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    return ColoredBox(
      color: c.bg,
      child: CustomPaint(
        painter: _DotGridPainter(c.bgPattern),
        child: child,
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  _DotGridPainter(this.color);

  final Color color;

  static const double _spacing = 24;
  static const double _radius = 1.6;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (var y = _spacing / 2; y < size.height; y += _spacing) {
      for (var x = _spacing / 2; x < size.width; x += _spacing) {
        canvas.drawCircle(Offset(x, y), _radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter oldDelegate) => oldDelegate.color != color;
}
