import 'package:flutter/material.dart';

import '../theme/yq_colors.dart';
import '../theme/yq_spacing.dart';
import '../theme/yq_typography.dart';

enum YqBannerKind { warning, success, danger }

/// Soft-fill banner / error card with a 1.5 border in the strong colour.
class YqBanner extends StatelessWidget {
  const YqBanner({
    super.key,
    required this.kind,
    required this.icon,
    required this.title,
    this.body,
    this.iconSize = 22,
    this.titleSize = 16,
    this.bodySize = 13,
  });

  final YqBannerKind kind;
  final Widget icon;
  final String title;
  final String? body;
  final double iconSize;
  final double titleSize;
  final double bodySize;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final t = context.yqText;
    final (Color soft, Color strong) = switch (kind) {
      YqBannerKind.warning => (c.warningSoft, c.warning),
      YqBannerKind.success => (c.successSoft, c.success),
      YqBannerKind.danger => (c.dangerSoft, c.danger),
    };
    return Semantics(
      liveRegion: true,
      child: Container(
        constraints: const BoxConstraints(minHeight: 56),
        padding: const EdgeInsetsDirectional.symmetric(horizontal: YqSpace.x4, vertical: YqSpace.x3),
        decoration: BoxDecoration(
          color: soft,
          borderRadius: YqRadius.all(YqRadius.lg),
          border: Border.all(color: strong, width: 1.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 2),
              child: IconTheme.merge(
                data: IconThemeData(color: strong, size: iconSize),
                child: icon,
              ),
            ),
            const SizedBox(width: YqSpace.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: t.titleSm.copyWith(fontSize: titleSize, color: c.ink)),
                  if (body != null)
                    Text(
                      body!,
                      style: t.caption.copyWith(fontSize: bodySize, color: c.inkMuted),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
