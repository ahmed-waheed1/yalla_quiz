import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Filled brand glyphs from the design source, drawn in a 24 × 24 box.
enum YqGlyph {
  triangle('M12 3.5 L21.5 20 H2.5 Z'),
  diamond('M12 2 L22 12 L12 22 L2 12 Z'),
  circle('M3 12a9 9 0 1 0 18 0a9 9 0 1 0 -18 0'),
  square('M4 4h16v16H4z'),
  star(
    'M12 2l2.6 3.7 4.5.7-.7 4.5L22 12l-3.6 1.1.7 4.5-4.5.7L12 22l-2.6-3.7-4.5-.7.7-4.5L2 12l3.6-1.1-.7-4.5 4.5-.7z',
  ),
  crown('M3 8l4.5 4L12 5l4.5 7L21 8l-2 11H5z');

  const YqGlyph(this.path);

  final String path;
}

class YqGlyphIcon extends StatelessWidget {
  const YqGlyphIcon(this.glyph, {super.key, required this.size, required this.color});

  final YqGlyph glyph;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => SvgPicture.string(
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="${glyph.path}"/></svg>',
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        excludeFromSemantics: true,
      );
}
