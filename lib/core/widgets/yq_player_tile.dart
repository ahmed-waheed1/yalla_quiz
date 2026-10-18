import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../theme/yq_colors.dart';
import '../theme/yq_spacing.dart';
import '../theme/yq_typography.dart';
import 'yq_avatar.dart';
import 'yq_glyph.dart';

/// Player tile for the lobby grids. Phone: 92 tall, avatar 44, name 13/800.
/// Host big screen: pass the bigger [height], [avatarSize] and [nameSize].
class YqPlayerTile extends StatelessWidget {
  const YqPlayerTile({
    super.key,
    required this.name,
    required this.avatarSeed,
    this.nameSuffix,
    this.host = false,
    this.you = false,
    this.connected = true,
    this.height = 92,
    this.avatarSize = 44,
    this.nameSize = 13,
    this.badgeSize = 22,
  }) : joining = false;

  const YqPlayerTile.joining({
    super.key,
    required this.name,
    this.height = 92,
    this.avatarSize = 44,
    this.nameSize = 13,
    this.badgeSize = 22,
  })  : avatarSeed = 0,
        nameSuffix = null,
        host = false,
        you = false,
        connected = true,
        joining = true;

  final String name;

  /// Kept visible when the name is ellipsized, e.g. " (You)".
  final String? nameSuffix;
  final int avatarSeed;
  final bool host;
  final bool you;
  final bool joining;

  /// Disconnected players are dimmed until they come back.
  final bool connected;
  final double height;
  final double avatarSize;
  final double nameSize;
  final double badgeSize;

  static const double _radius = 20;
  static const double _disconnectedOpacity = 0.4;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final t = context.yqText;
    final nameStyle = t.label.copyWith(
      fontSize: nameSize,
      height: 1.3,
      color: joining ? c.inkMuted : c.ink,
    );

    final tile = Container(
      height: height,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: YqSpace.x1),
      decoration: BoxDecoration(
        color: joining ? c.surface.withValues(alpha: 0.5) : c.surface,
        borderRadius: YqRadius.all(_radius),
        border: Border.all(
          color: you ? c.primary : c.line,
          width: you ? 3 : (joining ? 2 : 1.5),
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                joining
                    ? YqAvatar.ghost(size: avatarSize)
                    : YqAvatar(seed: avatarSeed, size: avatarSize),
                SizedBox(height: avatarSize * 0.12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: nameStyle),
                    ),
                    if (nameSuffix != null) Text(nameSuffix!, maxLines: 1, style: nameStyle),
                  ],
                ),
              ],
            ),
          ),
          if (host)
            PositionedDirectional(
              top: 6,
              end: 6,
              child: Tooltip(
                message: 'lobby.host'.tr(),
                child: Container(
                  width: badgeSize,
                  height: badgeSize,
                  decoration: BoxDecoration(
                    color: c.accent,
                    borderRadius: YqRadius.all(YqRadius.xs),
                  ),
                  alignment: Alignment.center,
                  child: YqGlyphIcon(
                    YqGlyph.crown,
                    size: badgeSize * 0.6,
                    color: YqColors.brandNight,
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    return AnimatedOpacity(
      opacity: connected ? 1 : _disconnectedOpacity,
      duration: YqMotion.fast,
      child: tile,
    );
  }
}
