import 'package:flutter/widgets.dart';

import '../theme/yq_colors.dart';
import '../theme/yq_spacing.dart';
import '../theme/yq_typography.dart';
import '../utils/numbers.dart';
import 'yq_ltr.dart';

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

/// Score pill: `surface` with a 1.5 `line` border, `numeric` 15/900.
class YqScorePill extends StatelessWidget {
  const YqScorePill({super.key, required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: YqSpace.x4, vertical: YqSpace.x2),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: YqRadius.all(YqRadius.pill),
        border: Border.all(color: c.line, width: 1.5),
      ),
      child: YqNumberText(
        formatScore(score),
        style: context.yqText.numeric.copyWith(fontSize: 15, color: c.ink),
      ),
    );
  }
}
