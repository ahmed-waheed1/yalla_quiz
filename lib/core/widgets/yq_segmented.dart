import 'package:flutter/material.dart';

import '../di/injection.dart';
import '../services/haptics.dart';
import '../theme/yq_colors.dart';
import '../theme/yq_spacing.dart';
import '../theme/yq_typography.dart';
import 'yq_pressable.dart';

class YqSegment<T> {
  const YqSegment(this.value, this.label, {this.icon, this.ltrLabel = false});

  final T value;
  final String label;
  final IconData? icon;

  /// Lay the label out LTR (numbers such as "10" or "20 s").
  final bool ltrLabel;
}

/// Segmented control: `surfaceAlt` track, selected segment in `inverse`.
class YqSegmented<T> extends StatelessWidget {
  const YqSegmented({
    super.key,
    required this.segments,
    required this.value,
    required this.onChanged,
    this.semanticLabel,
  });

  final List<YqSegment<T>> segments;
  final T value;
  final ValueChanged<T> onChanged;
  final String? semanticLabel;

  static const double _segmentHeight = 48;
  static const double _segmentRadius = 14;
  static const double _gap = 4;
  static const double _iconSize = 18;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final t = context.yqText;
    return Semantics(
      label: semanticLabel,
      container: true,
      child: Container(
        padding: const EdgeInsetsDirectional.all(_gap),
        decoration: BoxDecoration(color: c.surfaceAlt, borderRadius: YqRadius.all(YqRadius.lg)),
        child: Row(
          children: [
            for (var i = 0; i < segments.length; i++) ...[
              if (i > 0) const SizedBox(width: _gap),
              Expanded(child: _segment(context, segments[i], c, t)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _segment(BuildContext context, YqSegment<T> s, YqColors c, YqTypography t) {
    final selected = s.value == value;
    final fg = selected ? c.onInverse : c.inkMuted;
    final label = Text(
      s.label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: t.label.copyWith(fontSize: 16, color: fg),
    );
    return Semantics(
      selected: selected,
      child: YqPressable(
        focusRadius: _segmentRadius,
        semanticLabel: s.label,
        onPressed: selected
            ? () {}
            : () {
                getIt<Haptics>().selection();
                onChanged(s.value);
              },
        builder: (context, _) => AnimatedContainer(
          duration: YqMotion.fast,
          curve: YqMotion.out,
          height: _segmentHeight,
          decoration: BoxDecoration(
            color: selected ? c.inverse : c.surfaceAlt.withValues(alpha: 0),
            borderRadius: YqRadius.all(_segmentRadius),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: context.yqElevation.shadowColor.withValues(alpha: 0.2),
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          alignment: AlignmentDirectional.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (s.icon != null) ...[
                Icon(s.icon, size: _iconSize, color: fg),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: s.ltrLabel
                    ? Directionality(textDirection: TextDirection.ltr, child: label)
                    : label,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
