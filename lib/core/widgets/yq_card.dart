import 'package:flutter/widgets.dart';

import '../theme/yq_colors.dart';
import '../theme/yq_spacing.dart';

/// Radius `xl`, `surface` fill, 1.5 `line` border; [elevated] adds `card` shadow.
class YqCard extends StatelessWidget {
  const YqCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsetsDirectional.all(YqSpace.x4),
    this.elevated = false,
    this.radius = YqRadius.xl,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool elevated;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: YqRadius.all(radius),
        border: Border.all(color: c.line, width: 1.5),
        boxShadow: elevated ? context.yqElevation.card : null,
      ),
      child: child,
    );
  }
}
