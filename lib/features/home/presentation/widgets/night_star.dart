import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// The brand's 8-point star motif (two overlapping squares).
class NightStar extends StatelessWidget {
  const NightStar({super.key, required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _StarPainter(color));
}

class _StarPainter extends CustomPainter {
  _StarPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final center = size.center(Offset.zero);
    final side = size.width / math.sqrt2;
    final square = Rect.fromCenter(center: Offset.zero, width: side, height: side);
    final path = Path()..addRect(square);
    final rotated = path.transform(Matrix4.rotationZ(math.pi / 4).storage);
    canvas
      ..save()
      ..translate(center.dx, center.dy)
      ..drawPath(Path.combine(PathOperation.union, path, rotated), paint)
      ..restore();
  }

  @override
  bool shouldRepaint(_StarPainter oldDelegate) => oldDelegate.color != color;
}
