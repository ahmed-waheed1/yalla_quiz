import 'package:flutter/material.dart';

import '../theme/yq_colors.dart';

class YqSpinner extends StatelessWidget {
  const YqSpinner({super.key, this.size = 22, this.color, this.strokeWidth = 3});

  final double size;
  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: CircularProgressIndicator(
      strokeWidth: strokeWidth,
      strokeCap: StrokeCap.round,
      color: color ?? context.yqColors.primary,
    ),
  );
}
