import 'package:flutter/material.dart';

import '../../../../core/theme/yq_colors.dart';
import '../../../../core/theme/yq_spacing.dart';
import '../../../../core/theme/yq_typography.dart';
import '../../../../core/widgets/yq_glyph.dart';
import '../../../../core/widgets/yq_pressable.dart';
import 'category_style.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.id,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String id;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  static const double _height = 52;
  static const double _tile = 30;
  static const double _tileRadius = 10;
  static const double _glyph = 16;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final style = CategoryStyle.of(id);
    return Semantics(
      selected: selected,
      child: YqPressable(
        onPressed: onTap,
        semanticLabel: label,
        focusRadius: YqRadius.md,
        builder: (context, pressed) => AnimatedContainer(
          duration: YqMotion.fast,
          height: _height,
          padding: const EdgeInsetsDirectional.symmetric(horizontal: YqSpace.x3),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: YqRadius.all(YqRadius.md),
            border: Border.all(color: selected ? c.primary : c.line, width: selected ? 3 : 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: _tile,
                height: _tile,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: style.fill, borderRadius: YqRadius.all(_tileRadius)),
                child: YqGlyphIcon(style.glyph, size: _glyph, color: style.onFill),
              ),
              const SizedBox(width: YqSpace.x3),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    label,
                    maxLines: 1,
                    style: context.yqText.label.copyWith(fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
