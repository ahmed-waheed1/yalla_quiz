import 'package:flutter/material.dart';

import '../theme/yq_colors.dart';
import '../theme/yq_spacing.dart';
import '../theme/yq_typography.dart';
import 'yq_answer_shape.dart';
import 'yq_pressable.dart';

enum YqAnswerState { idle, locked, dimmed, timeUp }

/// Answer option [index] (a1–a4): shape icon + label on the answer colour
/// with a stomp shadow. `locked` sinks, gets a 3 `ink` outline and a lock
/// pill; `dimmed` fades to 0.4; `timeUp` greys out.
class YqAnswerButton extends StatelessWidget {
  const YqAnswerButton({
    super.key,
    required this.index,
    required this.label,
    required this.state,
    required this.lockedLabel,
    this.onPressed,
  });

  final int index;
  final String label;
  final YqAnswerState state;

  /// "Locked in", shown in the pill on the locked answer.
  final String lockedLabel;
  final VoidCallback? onPressed;

  static const double _padding = 16;
  static const double _shapeSize = 26;
  static const double _gap = 14;
  static const double _labelSize = 19;
  static const double _pressTravel = 4;
  static const double _outline = 3;
  static const double _outlineGap = 3;
  static const double _dimmedOpacity = 0.4;
  static const double _lockIconSize = 13;
  static const double _lockTextSize = 12;
  static const double _lockedPop = 1.03;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final style = c.answers[index];
    final reduced = MediaQuery.disableAnimationsOf(context);
    final locked = state == YqAnswerState.locked;
    final timeUp = state == YqAnswerState.timeUp;
    final fill = timeUp ? c.surfaceAlt : style.fill;
    final onFill = timeUp ? c.inkMuted : style.onFill;
    final duration = reduced ? YqMotion.reducedFade : YqMotion.base;

    return AnimatedOpacity(
      opacity: state == YqAnswerState.dimmed ? _dimmedOpacity : 1,
      duration: reduced ? YqMotion.reducedFade : YqMotion.fast,
      child: YqPressable(
        onPressed: state == YqAnswerState.idle ? onPressed : null,
        semanticLabel: label,
        builder: (context, pressed) {
          final sunk = locked || (pressed && onPressed != null);
          return TweenAnimationBuilder<double>(
            // Locking in pops 1.03 → 1 (snap).
            key: ValueKey(locked),
            tween: Tween(begin: locked && !reduced ? _lockedPop : 1, end: 1),
            duration: duration,
            curve: YqMotion.snap,
            builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
            child: AnimatedContainer(
              duration: YqMotion.instant,
              transform: Matrix4.translationValues(0, sunk ? _pressTravel : 0, 0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // The lock outline sits 3 outside the button.
                  PositionedDirectional(
                    start: -(_outline + _outlineGap),
                    top: -(_outline + _outlineGap),
                    end: -(_outline + _outlineGap),
                    bottom: -(_outline + _outlineGap),
                    child: IgnorePointer(
                      child: AnimatedOpacity(
                        opacity: locked ? 1 : 0,
                        duration: duration,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: YqRadius.all(YqRadius.lg + _outline + _outlineGap),
                            border: Border.all(color: c.ink, width: _outline),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _body(context, style, fill, onFill, locked, pressed, reduced, duration),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _body(
    BuildContext context,
    YqAnswerStyle style,
    Color fill,
    Color onFill,
    bool locked,
    bool pressed,
    bool reduced,
    Duration duration,
  ) {
    final t = context.yqText;
    return AnimatedContainer(
      duration: duration,
      constraints: const BoxConstraints(minHeight: YqSpace.answerHeight),
      padding: const EdgeInsetsDirectional.symmetric(horizontal: _padding, vertical: YqSpace.x3),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: YqRadius.all(YqRadius.lg),
        boxShadow: state == YqAnswerState.idle
            ? YqElevation.stomp(style.deep, pressed: pressed)
            : null,
      ),
      child: Row(
        children: [
          YqAnswerShapeIcon(shape: style.shape, size: _shapeSize, color: onFill),
          const SizedBox(width: _gap),
          Expanded(
            child: Text(
              label,
              style: t.button.copyWith(fontSize: _labelSize, color: onFill),
            ),
          ),
          if (locked) ...[
            const SizedBox(width: YqSpace.x2),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: reduced ? 0 : 1, end: 0),
              duration: duration,
              curve: YqMotion.snap,
              builder: (context, offset, child) {
                final dir = Directionality.of(context) == TextDirection.rtl ? -1 : 1;
                return FractionalTranslation(
                  translation: Offset(offset * dir, 0),
                  child: Opacity(opacity: (1 - offset).clamp(0.0, 1.0), child: child),
                );
              },
              child: _LockPill(
                label: lockedLabel,
                iconSize: _lockIconSize,
                textSize: _lockTextSize,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LockPill extends StatelessWidget {
  const _LockPill({required this.label, required this.iconSize, required this.textSize});

  final String label;
  final double iconSize;
  final double textSize;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsetsDirectional.symmetric(horizontal: YqSpace.x3, vertical: 6),
    decoration: BoxDecoration(
      color: YqColors.brandNightDeep,
      borderRadius: YqRadius.all(YqRadius.pill),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.lock_outline_rounded, size: iconSize, color: YqColors.brandSand),
        const SizedBox(width: YqSpace.x1),
        Text(
          label,
          style: context.yqText.label.copyWith(
            fontSize: textSize,
            fontWeight: FontWeight.w800,
            color: YqColors.brandSand,
          ),
        ),
      ],
    ),
  );
}
