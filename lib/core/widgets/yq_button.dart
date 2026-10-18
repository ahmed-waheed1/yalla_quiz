import 'package:flutter/material.dart';

import '../theme/yq_colors.dart';
import '../theme/yq_spacing.dart';
import '../theme/yq_typography.dart';
import 'yq_pressable.dart';
import 'yq_spinner.dart';

enum YqButtonVariant { primary, secondary }

/// Primary / secondary button with the brand "stomp" shadow.
class YqButton extends StatelessWidget {
  const YqButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = YqButtonVariant.primary,
    this.icon,
    this.loading = false,
    this.height = YqSpace.buttonHeight,
    this.textStyle,
    this.iconAfterLabel = false,
  });

  const YqButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.height = YqSpace.buttonHeight,
    this.textStyle,
    this.iconAfterLabel = false,
  }) : variant = YqButtonVariant.secondary;

  final String label;
  final VoidCallback? onPressed;
  final YqButtonVariant variant;

  /// Icon widget (22). Use [YqDirectionalIcon] for arrows that mirror in RTL.
  final Widget? icon;
  final bool loading;
  final double height;
  final TextStyle? textStyle;

  /// Put the icon after the label (e.g. "Let's go →").
  final bool iconAfterLabel;

  static const double _iconSize = 22;
  static const double _iconGap = 10;
  static const double _pressTravel = 4;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final t = context.yqText;
    final enabled = onPressed != null && !loading;
    final disabled = onPressed == null;
    final primary = variant == YqButtonVariant.primary;

    final Color fill = disabled ? c.surfaceAlt : (primary ? c.primary : c.surface);
    final Color fg = disabled ? c.inkMuted : (primary ? c.onPrimary : c.ink);

    return YqPressable(
      onPressed: enabled ? onPressed : null,
      semanticLabel: label,
      builder: (context, pressed) {
        final List<BoxShadow> shadow = disabled
            ? const []
            : primary
            ? YqElevation.stomp(c.primaryDeep, pressed: pressed)
            : (pressed
                  ? YqElevation.stomp(c.ink, pressed: true)
                  : YqElevation.stompSecondary(c.ink));

        return AnimatedContainer(
          duration: YqMotion.instant,
          curve: YqMotion.out,
          height: height,
          transform: Matrix4.translationValues(0, pressed ? _pressTravel : 0, 0),
          decoration: BoxDecoration(
            color: fill,
            borderRadius: YqRadius.all(YqRadius.lg),
            border: !primary && !disabled ? Border.all(color: c.ink, width: 2.5) : null,
            boxShadow: shadow,
          ),
          padding: const EdgeInsetsDirectional.symmetric(horizontal: YqSpace.x4),
          child: IconTheme.merge(
            data: IconThemeData(color: fg, size: _iconSize),
            child: Builder(
              builder: (context) {
                final Widget? leading = loading ? YqSpinner(size: _iconSize, color: fg) : icon;
                final text = Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: (textStyle ?? t.button).copyWith(color: fg),
                  ),
                );
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (leading != null && !iconAfterLabel) ...[
                      leading,
                      const SizedBox(width: _iconGap),
                    ],
                    text,
                    if (leading != null && iconAfterLabel) ...[
                      const SizedBox(width: _iconGap),
                      leading,
                    ],
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

/// 48 × 48 square icon button (back, close, settings, shuffle).
class YqIconButton extends StatelessWidget {
  const YqIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.inverse = false,
    this.size = YqSpace.iconButton,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final String tooltip;

  /// Night fill (`inverse`) instead of `surface`, e.g. the avatar shuffle.
  final bool inverse;
  final double size;

  static const double _iconSize = 24;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    return Tooltip(
      message: tooltip,
      excludeFromSemantics: true,
      child: YqPressable(
        onPressed: onPressed,
        semanticLabel: tooltip,
        focusRadius: YqRadius.md,
        builder: (context, pressed) => AnimatedScale(
          scale: pressed ? 0.94 : 1,
          duration: YqMotion.instant,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: inverse ? c.inverse : c.surface,
              borderRadius: YqRadius.all(YqRadius.md),
              border: inverse ? null : Border.all(color: c.line, width: 1.5),
            ),
            child: IconTheme.merge(
              data: IconThemeData(color: inverse ? c.onInverse : c.ink, size: _iconSize),
              child: Center(child: icon),
            ),
          ),
        ),
      ),
    );
  }
}

/// Icon that mirrors in RTL. Use for icons that don't set `matchTextDirection`
/// (e.g. the "enter/join" arrow, the "host left" door).
class YqDirectionalIcon extends StatelessWidget {
  const YqDirectionalIcon(this.icon, {super.key, this.size, this.color});

  final IconData icon;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final child = Icon(icon, size: size, color: color);
    if (!rtl || icon.matchTextDirection) return child;
    return Transform.flip(flipX: true, child: child);
  }
}
