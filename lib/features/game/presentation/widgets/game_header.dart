import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/yq_colors.dart';
import '../../../../core/theme/yq_spacing.dart';
import '../../../../core/theme/yq_typography.dart';
import '../../../../core/widgets/yq_brand.dart';
import '../../../../core/widgets/yq_chip.dart';
import '../../../../core/widgets/yq_ltr.dart';

/// Phone game header: "Question 4 of 10", optional progress segments, and
/// the score pill at the end.
class GameHeader extends StatelessWidget {
  const GameHeader({
    super.key,
    required this.index,
    required this.count,
    required this.score,
    this.showProgress = true,
  });

  final int index;
  final int count;
  final int? score;
  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final t = context.yqText;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'game.question_of'.tr(args: ['${index + 1}', '$count']),
                style: t.label.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: c.inkMuted,
                ),
              ),
              if (showProgress) ...[
                const SizedBox(height: YqSpace.x2),
                GameProgressSegments(index: index, count: count),
              ],
            ],
          ),
        ),
        if (score != null) ...[const SizedBox(width: YqSpace.x4), YqScorePill(score: score!)],
      ],
    );
  }
}

/// One segment per question: past `ink`, current `primary`, future
/// `surfaceAlt`. Fills from the start edge.
class GameProgressSegments extends StatelessWidget {
  const GameProgressSegments({super.key, required this.index, required this.count});

  final int index;
  final int count;

  static const double _height = 8;
  static const double _radius = 4;
  static const double _gap = 4;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    return Semantics(
      label: 'game.question_of'.tr(args: ['${index + 1}', '$count']),
      child: ExcludeSemantics(
        child: Row(
          children: [
            for (var i = 0; i < count; i++) ...[
              if (i > 0) const SizedBox(width: _gap),
              Expanded(
                child: Container(
                  height: _height,
                  decoration: BoxDecoration(
                    color: i < index
                        ? c.ink
                        : i == index
                        ? c.primary
                        : c.surfaceAlt,
                    borderRadius: YqRadius.all(_radius),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Host big-screen top bar: wordmark at the start, "Room K7XP2Q" and an
/// optional "4/10" chip at the end.
class HostTopBar extends StatelessWidget {
  const HostTopBar({super.key, required this.code, this.progress, this.leading});

  final String code;

  /// "4/10" while a question is on.
  final String? progress;
  final Widget? leading;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      if (leading != null) ...[leading!, const SizedBox(width: YqSpace.x4)],
      const YqBrandRow(),
      const Spacer(),
      _HostChip(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'lobby.room_chip'.tr(),
              style: context.yqText.label.copyWith(fontSize: 15, color: context.yqColors.inkMuted),
            ),
            const SizedBox(width: YqSpace.x3),
            YqNumberText(
              code,
              style: context.yqText.code.copyWith(fontSize: 17, color: context.yqColors.ink),
            ),
          ],
        ),
      ),
      if (progress != null) ...[
        const SizedBox(width: YqSpace.x3),
        _HostChip(
          child: YqNumberText(
            progress!,
            style: context.yqText.numeric.copyWith(fontSize: 17, color: context.yqColors.ink),
          ),
        ),
      ],
    ],
  );
}

class _HostChip extends StatelessWidget {
  const _HostChip({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: YqSpace.x5, vertical: YqSpace.x3),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: YqRadius.all(YqRadius.pill),
        border: Border.all(color: c.line, width: 2),
      ),
      child: child,
    );
  }
}
