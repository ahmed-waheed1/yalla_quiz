// Yalla Quiz — spacing, radii, elevation (shadows) and motion tokens.
//
// Usage:
//   Padding(padding: const EdgeInsets.all(YqSpace.x4))
//   BorderRadius.circular(YqRadius.lg)
//   BoxDecoration(boxShadow: context.yqElevation.stomp(context.yqColors.primaryDeep))
//
// Always use EdgeInsetsDirectional / AlignmentDirectional so RTL mirrors for free.

import 'package:flutter/material.dart';

/// 4-pt spacing scale.
abstract final class YqSpace {
  static const double x1 = 4; // icon gaps
  static const double x2 = 8; // tight stacks, tile grid gap
  static const double x3 = 12; // answer-button gap, row gap
  static const double x4 = 16; // card padding
  static const double x5 = 20; // phone screen gutter
  static const double x6 = 24; // section gap
  static const double x8 = 32; // hero gap
  static const double x10 = 40; // tablet gutter, bottom safe padding
  static const double x14 = 56; // top inset under the status bar

  /// Phone screen side padding.
  static const double gutter = x5;

  /// Host big screen (tablet 834) side padding. Desktop 1440: 48.
  static const double hostGutter = x10;

  /// Minimum touch target (WCAG / Material).
  static const double minTouch = 48;

  /// Primary/secondary button height.
  static const double buttonHeight = 58;

  /// Answer button height (phone).
  static const double answerHeight = 64;

  /// Icon button size (back, settings, close).
  static const double iconButton = 48;

  /// Room-code box (phone): 48 × 62, gap 7.
  static const Size codeBox = Size(48, 62);
  static const double codeBoxGap = 7;
}

/// Corner radii.
abstract final class YqRadius {
  static const double xs = 8; // badges, small chips
  static const double sm = 12; // code boxes, small buttons
  static const double md = 16; // icon buttons, banners
  static const double lg = 18; // buttons, answer buttons, list rows
  static const double xl = 24; // cards, player tiles, question card
  static const double xxl = 32; // sheets, hero cards (28 for result banners)
  static const double pill = 999; // chips, avatars, toasts

  static BorderRadius all(double r) => BorderRadius.all(Radius.circular(r));
}

/// Shadows. Buttons use a hard offset "stomp" (no blur) — the brand's tactile feel.
@immutable
class YqElevation extends ThemeExtension<YqElevation> {
  const YqElevation({required this.card, required this.modal, required this.shadowColor});

  /// e2 — cards, lobby code card.
  final List<BoxShadow> card;

  /// e3 — sheets, dialogs, toasts.
  final List<BoxShadow> modal;

  final Color shadowColor;

  /// e1 — "stomp": hard offset under buttons/answers. Pass the matching *deep* colour.
  /// Pressed state: offset 1 and translate the button down 4px.
  static List<BoxShadow> stomp(Color deep, {bool pressed = false}) =>
      [BoxShadow(color: deep, offset: Offset(0, pressed ? 1 : 5), blurRadius: 0)];

  /// Secondary button stomp (ink colour, offset 4).
  static List<BoxShadow> stompSecondary(Color ink) =>
      [BoxShadow(color: ink, offset: const Offset(0, 4), blurRadius: 0)];

  static const YqElevation light = YqElevation(
    shadowColor: Color(0xFF1E0F3D),
    card: [BoxShadow(color: Color(0x591E0F3D), offset: Offset(0, 12), blurRadius: 24, spreadRadius: -12)],
    modal: [BoxShadow(color: Color(0x801E0F3D), offset: Offset(0, 24), blurRadius: 48, spreadRadius: -16)],
  );

  /// Dark: shadows deepen to black; surfaces step lighter (surface → surfaceAlt) for depth.
  static const YqElevation dark = YqElevation(
    shadowColor: Color(0xFF000000),
    card: [BoxShadow(color: Color(0x80000000), offset: Offset(0, 12), blurRadius: 24, spreadRadius: -12)],
    modal: [BoxShadow(color: Color(0x99000000), offset: Offset(0, 24), blurRadius: 48, spreadRadius: -16)],
  );

  @override
  YqElevation copyWith({List<BoxShadow>? card, List<BoxShadow>? modal, Color? shadowColor}) => YqElevation(
        card: card ?? this.card,
        modal: modal ?? this.modal,
        shadowColor: shadowColor ?? this.shadowColor,
      );

  @override
  YqElevation lerp(ThemeExtension<YqElevation>? other, double t) {
    if (other is! YqElevation) return this;
    return YqElevation(
      card: BoxShadow.lerpList(card, other.card, t)!,
      modal: BoxShadow.lerpList(modal, other.modal, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
    );
  }
}

/// Motion tokens. Respect reduced motion: if MediaQuery.disableAnimationsOf(context)
/// is true, replace scale/slide/shake with a 120 ms fade and skip confetti.
abstract final class YqMotion {
  static const Duration instant = Duration(milliseconds: 80); // press feedback
  static const Duration fast = Duration(milliseconds: 160); // fades, dims
  static const Duration base = Duration(milliseconds: 240); // state changes
  static const Duration slow = Duration(milliseconds: 500); // reorder, vote bars
  static const Duration reveal = Duration(milliseconds: 600); // suspense hold before reveal
  static const Duration party = Duration(milliseconds: 1200); // podium, "Yalla!"
  static const Duration reducedFade = Duration(milliseconds: 120);

  /// Overshoot — lock-in, correct pop, countdown digits.
  static const Curve snap = Cubic(0.2, 0.9, 0.3, 1.3);

  /// Standard decelerate.
  static const Curve out = Cubic(0.2, 0.8, 0.2, 1.0);

  /// Leaderboard reorder.
  static const Curve inOut = Curves.easeInOutCubic;

  /// Podium columns.
  static const Curve back = Curves.easeOutBack;
}

extension YqElevationContext on BuildContext {
  YqElevation get yqElevation => Theme.of(this).extension<YqElevation>()!;
}
