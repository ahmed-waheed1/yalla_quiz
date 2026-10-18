import 'package:flutter/widgets.dart';

import '../theme/yq_colors.dart';
import '../theme/yq_spacing.dart';
import '../theme/yq_typography.dart';

/// Meta pill: `surfaceAlt`, `label` 13 in `inkMuted`.
class YqMetaPill extends StatelessWidget {
  const YqMetaPill(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: YqSpace.x3, vertical: 6),
      decoration: BoxDecoration(color: c.surfaceAlt, borderRadius: YqRadius.all(YqRadius.pill)),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.yqText.label.copyWith(fontSize: 13, color: c.inkMuted),
      ),
    );
  }
}
