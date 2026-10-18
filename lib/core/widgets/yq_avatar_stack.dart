import 'package:flutter/widgets.dart';

import '../theme/yq_colors.dart';
import 'yq_avatar.dart';

/// Overlapping avatars (later ones on top) with a `bg` ring that separates
/// them. Overlap follows the reading direction.
class YqAvatarStack extends StatelessWidget {
  const YqAvatarStack({
    super.key,
    required this.seeds,
    required this.size,
    this.overlap = 8,
    this.ring = 3,
    this.maxCount = 8,
  });

  final List<int> seeds;
  final double size;
  final double overlap;
  final double ring;
  final int maxCount;

  @override
  Widget build(BuildContext context) {
    final shown = seeds.take(maxCount).toList();
    if (shown.isEmpty) return SizedBox(height: size + ring * 2);
    final step = size + ring * 2 - overlap;
    final width = step * (shown.length - 1) + size + ring * 2;
    return SizedBox(
      width: width,
      height: size + ring * 2,
      child: Stack(
        children: [
          for (var i = 0; i < shown.length; i++)
            PositionedDirectional(
              start: step * i,
              top: 0,
              child: Container(
                padding: EdgeInsetsDirectional.all(ring),
                decoration: BoxDecoration(color: context.yqColors.bg, shape: BoxShape.circle),
                child: YqAvatar(seed: shown[i], size: size),
              ),
            ),
        ],
      ),
    );
  }
}
