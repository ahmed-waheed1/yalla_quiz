import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/yq_colors.dart';
import '../theme/yq_spacing.dart';

/// Tap target with keyboard activation, a focus ring and a `pressed` flag for
/// the stomp press animation. No ink splash (feedback is the stomp + scale).
class YqPressable extends StatefulWidget {
  const YqPressable({
    super.key,
    required this.onPressed,
    required this.builder,
    this.semanticLabel,
    this.focusRadius = YqRadius.lg,
  });

  final VoidCallback? onPressed;
  final Widget Function(BuildContext context, bool pressed) builder;
  final String? semanticLabel;
  final double focusRadius;

  @override
  State<YqPressable> createState() => _YqPressableState();
}

class _YqPressableState extends State<YqPressable> {
  bool _pressed = false;
  bool _focused = false;

  bool get _enabled => widget.onPressed != null;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.semanticLabel,
      child: FocusableActionDetector(
        enabled: _enabled,
        mouseCursor: _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onShowFocusHighlight: (v) => setState(() => _focused = v),
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onPressed?.call();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: _enabled ? (_) => _setPressed(true) : null,
          onTapUp: _enabled ? (_) => _setPressed(false) : null,
          onTapCancel: _enabled ? () => _setPressed(false) : null,
          onTap: widget.onPressed,
          child: DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              borderRadius: YqRadius.all(widget.focusRadius),
              border: _focused ? Border.all(color: context.yqColors.focus, width: 3) : null,
            ),
            child: widget.builder(context, _pressed && _enabled),
          ),
        ),
      ),
    );
  }
}
