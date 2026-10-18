import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../theme/yq_spacing.dart';

/// Route transitions. Every route uses one explicitly, because go_router 18
/// can't detect our MaterialApp (it looks for `material_ui`'s) and would
/// otherwise fall back to no transition.
enum YqTransition {
  /// In-flow navigation (Home → Create, Settings → Profile …): shared-axis
  /// slide from the end edge (mirrors in RTL) with a fade.
  slide,

  /// Context switches (Splash → Home, into / out of the Lobby): fade-through.
  fade,

  /// Hard cut, e.g. "Yalla!" → first question (screens.md 07).
  none,
}

abstract final class YqTransitions {
  /// Horizontal travel of the shared-axis slide.
  static const double _slideDistance = 30;

  /// Fade-through: the outgoing page is gone by this point, then the
  /// incoming one fades and scales in.
  static const double _fadeThroughSplit = 0.35;
  static const double _fadeThroughScale = 0.96;

  static Page<void> page(GoRouterState state, Widget child, YqTransition kind) {
    if (kind == YqTransition.none) return NoTransitionPage<void>(key: state.pageKey, child: child);
    return CustomTransitionPage<void>(
      key: state.pageKey,
      name: state.name,
      arguments: state.extra,
      transitionDuration: YqMotion.base,
      reverseTransitionDuration: YqMotion.base,
      child: child,
      transitionsBuilder: builderFor(kind),
    );
  }

  static RouteTransitionsBuilder builderFor(YqTransition kind) =>
      (context, animation, secondaryAnimation, child) {
        if (kind == YqTransition.none || MediaQuery.disableAnimationsOf(context)) return child;
        return switch (kind) {
          YqTransition.slide => _slide(context, animation, secondaryAnimation, child),
          _ => _fadeThrough(animation, secondaryAnimation, child),
        };
      };

  static Widget _slide(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // +1 = towards the end edge (right in LTR, left in RTL).
    final end = Directionality.of(context) == TextDirection.rtl ? -1.0 : 1.0;
    final incoming = animation.drive(CurveTween(curve: YqMotion.out));
    final outgoing = secondaryAnimation.drive(CurveTween(curve: YqMotion.out));
    return AnimatedBuilder(
      animation: Listenable.merge([incoming, outgoing]),
      child: child,
      builder: (context, child) {
        // Enters from the end edge; slides towards the start when covered.
        final dx =
            end * _slideDistance * (1 - incoming.value) - end * _slideDistance * outgoing.value;
        final opacity = (incoming.value * (1 - outgoing.value)).clamp(0.0, 1.0);
        return Opacity(
          opacity: opacity,
          child: Transform.translate(offset: Offset(dx, 0), child: child),
        );
      },
    );
  }

  static Widget _fadeThrough(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final fadeIn = animation.drive(
      CurveTween(curve: const Interval(_fadeThroughSplit, 1, curve: YqMotion.out)),
    );
    final fadeOut = secondaryAnimation.drive(
      CurveTween(curve: const Interval(0, _fadeThroughSplit, curve: YqMotion.out)),
    );
    return FadeTransition(
      opacity: ReverseAnimation(fadeOut),
      child: FadeTransition(
        opacity: fadeIn,
        child: ScaleTransition(
          scale: fadeIn.drive(Tween<double>(begin: _fadeThroughScale, end: 1)),
          child: child,
        ),
      ),
    );
  }
}
