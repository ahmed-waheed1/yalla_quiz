import 'package:flutter/widgets.dart';

import '../theme/yq_colors.dart';
import 'yq_glyph.dart';

/// The answer shape for option [index]: a1 triangle, a2 diamond, a3 circle,
/// a4 square. Never mirrored.
class YqAnswerShapeIcon extends StatelessWidget {
  const YqAnswerShapeIcon({
    super.key,
    required this.shape,
    required this.size,
    required this.color,
  });

  final YqAnswerShape shape;
  final double size;
  final Color color;

  static YqGlyph glyphFor(YqAnswerShape shape) => switch (shape) {
    YqAnswerShape.triangle => YqGlyph.triangle,
    YqAnswerShape.diamond => YqGlyph.diamond,
    YqAnswerShape.circle => YqGlyph.circle,
    YqAnswerShape.square => YqGlyph.square,
  };

  @override
  Widget build(BuildContext context) => YqGlyphIcon(glyphFor(shape), size: size, color: color);
}
