import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/yq_colors.dart';
import '../theme/yq_spacing.dart';
import '../theme/yq_typography.dart';

/// Pill toast: `ink` fill with `bg` text (high contrast in both themes, as in
/// the design canvas; `inverse` is the night panel colour and would sink into
/// a dark screen), `modal` shadow, 24 above the bottom inset, auto-hides after
/// 2.4 s.
abstract final class YqToast {
  static const Duration _visibleFor = Duration(milliseconds: 2400);
  static OverlayEntry? _current;
  static Timer? _timer;

  static void show(BuildContext context, String message) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;
    _dismiss();
    final entry = OverlayEntry(builder: (_) => _ToastView(message: message));
    _current = entry;
    overlay.insert(entry);
    _timer = Timer(_visibleFor, _dismiss);
  }

  static void _dismiss() {
    _timer?.cancel();
    _timer = null;
    _current?.remove();
    _current = null;
  }
}

class _ToastView extends StatelessWidget {
  const _ToastView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final bottom = MediaQuery.paddingOf(context).bottom + YqSpace.x6;
    final reduced = MediaQuery.disableAnimationsOf(context);
    return PositionedDirectional(
      start: YqSpace.gutter,
      end: YqSpace.gutter,
      bottom: bottom,
      child: IgnorePointer(
        child: Material(
          type: MaterialType.transparency,
          child: Semantics(
            liveRegion: true,
            child: Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: reduced ? YqMotion.reducedFade : YqMotion.base,
                curve: YqMotion.out,
                builder: (context, v, child) => Opacity(
                  opacity: v,
                  child: Transform.translate(
                    offset: Offset(0, reduced ? 0 : 12 * (1 - v)),
                    child: child,
                  ),
                ),
                child: Container(
                  constraints: const BoxConstraints(minHeight: YqSpace.minTouch),
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: YqSpace.x6,
                    vertical: YqSpace.x3,
                  ),
                  decoration: BoxDecoration(
                    color: c.ink,
                    borderRadius: YqRadius.all(YqRadius.pill),
                    boxShadow: context.yqElevation.modal,
                  ),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: context.yqText.label.copyWith(fontSize: 15, color: c.bg),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
