import 'package:flutter/widgets.dart';

import '../../../../core/theme/yq_colors.dart';
import '../../../../core/widgets/yq_glyph.dart';

/// Colour tile + glyph for each question category (from the Create room design).
class CategoryStyle {
  const CategoryStyle(this.fill, this.onFill, this.glyph);

  final Color fill;
  final Color onFill;
  final YqGlyph glyph;

  static CategoryStyle of(String id) {
    final a = YqColors.answerStyles;
    return switch (id) {
      'movies_tv' => CategoryStyle(a[3].fill, a[3].onFill, YqGlyph.square),
      'football' => CategoryStyle(a[1].fill, a[1].onFill, YqGlyph.diamond),
      'music' => CategoryStyle(a[2].fill, a[2].onFill, YqGlyph.circle),
      'geography' => const CategoryStyle(YqColors.brandCoral, YqColors.brandNight, YqGlyph.star),
      'food' => CategoryStyle(YqColors.brandNight, a[2].fill, YqGlyph.circle),
      _ => CategoryStyle(a[0].fill, a[0].onFill, YqGlyph.triangle),
    };
  }
}
