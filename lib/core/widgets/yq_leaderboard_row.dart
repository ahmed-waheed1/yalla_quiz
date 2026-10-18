import 'package:flutter/material.dart';

import '../theme/yq_colors.dart';
import '../theme/yq_spacing.dart';
import '../theme/yq_typography.dart';
import '../utils/numbers.dart';
import 'yq_avatar.dart';
import 'yq_ltr.dart';

/// Sizes for [YqLeaderboardRow]: phone (60 tall) or host big screen (96).
class YqLeaderboardRowSize {
  const YqLeaderboardRowSize({
    required this.height,
    required this.badge,
    required this.badgeRadius,
    required this.avatar,
    required this.nameSize,
    required this.scoreSize,
    required this.scoreWidth,
    required this.chipWidth,
  });

  final double height;
  final double badge;
  final double badgeRadius;
  final double avatar;
  final double nameSize;
  final double scoreSize;
  final double scoreWidth;
  final double chipWidth;

  static const YqLeaderboardRowSize phone = YqLeaderboardRowSize(
    height: 60,
    badge: 30,
    badgeRadius: 10,
    avatar: 38,
    nameSize: 16,
    scoreSize: 17,
    scoreWidth: 62,
    chipWidth: 44,
  );

  static const YqLeaderboardRowSize host = YqLeaderboardRowSize(
    height: 96,
    badge: 48,
    badgeRadius: 14,
    avatar: 62,
    nameSize: 28,
    scoreSize: 28,
    scoreWidth: 120,
    chipWidth: 72,
  );
}

/// Rank badge, avatar, name, movement chip (arrow + number, never colour
/// alone) and score. #1 `accent`, #2–3 `ink`, the rest `surfaceAlt`. The
/// player's own row has a 3 `primary` ring.
class YqLeaderboardRow extends StatelessWidget {
  const YqLeaderboardRow({
    super.key,
    required this.rank,
    required this.name,
    required this.avatarSeed,
    required this.score,
    this.delta,
    this.you = false,
    this.showDelta = true,
    this.dimensions = YqLeaderboardRowSize.phone,
  });

  final int rank;

  /// Already includes " · You" for the player's own row.
  final String name;
  final int avatarSeed;
  final int score;

  /// Places climbed (+) or dropped (−); null hides the chip.
  final int? delta;
  final bool you;
  final bool showDelta;
  final YqLeaderboardRowSize dimensions;

  static const double _youRing = 3;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final t = context.yqText;
    final d = dimensions;
    final (Color badgeFill, Color badgeText) = switch (rank) {
      1 => (c.accent, YqColors.brandNight),
      2 || 3 => (c.ink, c.bg),
      _ => (c.surfaceAlt, c.ink),
    };
    return Container(
      height: d.height,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: YqSpace.x3 + 2),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: YqRadius.all(YqRadius.lg),
        border: Border.all(color: you ? c.primary : c.line, width: you ? _youRing : 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: d.badge,
            height: d.badge,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: badgeFill, borderRadius: YqRadius.all(d.badgeRadius)),
            child: YqNumberText(
              '$rank',
              style: t.numeric.copyWith(fontSize: d.badge * 0.5, color: badgeText),
            ),
          ),
          const SizedBox(width: YqSpace.x3),
          YqAvatar(seed: avatarSeed, size: d.avatar),
          const SizedBox(width: YqSpace.x3),
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: t.titleSm.copyWith(fontSize: d.nameSize, color: c.ink),
            ),
          ),
          if (showDelta && delta != null) ...[
            const SizedBox(width: YqSpace.x2),
            YqDeltaChip(delta: delta!, width: d.chipWidth, textSize: d.nameSize * 0.8),
          ],
          SizedBox(
            width: d.scoreWidth,
            child: YqNumberText(
              formatScore(score),
              textAlign: TextAlign.end,
              style: t.numeric.copyWith(fontSize: d.scoreSize, color: c.ink),
            ),
          ),
        ],
      ),
    );
  }
}

/// Movement chip: "↑ 2" on `successSoft`, "↓ 1" on `dangerSoft`, "–" on
/// `surfaceAlt`.
class YqDeltaChip extends StatelessWidget {
  const YqDeltaChip({super.key, required this.delta, this.width = 44, this.textSize = 13});

  final int delta;
  final double width;
  final double textSize;

  /// How far the "down" text moves from `danger` toward `ink`: enough for
  /// 4.5:1 on `dangerSoft` (4.72:1 in light), visually the same red.
  static const double _downInkBlend = 0.05;

  /// Text and arrow colour on the "down" chip.
  static Color downColor(YqColors c) => Color.lerp(c.danger, c.ink, _downInkBlend)!;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final (Color fill, Color fg) = delta > 0
        ? (c.successSoft, c.success)
        : delta < 0
        ? (c.dangerSoft, downColor(c))
        : (c.surfaceAlt, c.inkMuted);
    return Container(
      width: width,
      padding: const EdgeInsetsDirectional.symmetric(vertical: YqSpace.x1),
      decoration: BoxDecoration(color: fill, borderRadius: YqRadius.all(YqRadius.pill)),
      child: YqLtr(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (delta == 0)
              Icon(Icons.remove_rounded, size: textSize * 1.1, color: fg)
            else ...[
              Icon(
                delta > 0 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                size: textSize * 1.1,
                color: fg,
              ),
              Text(
                '${delta.abs()}',
                style: context.yqText.numeric.copyWith(fontSize: textSize, color: fg),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
