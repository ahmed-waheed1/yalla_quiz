// Yalla Quiz — avatar presets from the designer's profile-setup source
// (design/app/yalla_quiz_design.html, "Profile setup"). Not a designer file:
// it only collects the avatar artwork data so widgets never hardcode colours.
//
// Each avatar is drawn on a 48 × 48 canvas: a [bg] circle, one [shape] path in
// [shapeColor] rotated [rotation]° around the centre, and a 4.5 dot in
// [dotColor] at [dot].

import 'package:flutter/material.dart';

import 'yq_colors.dart';

@immutable
class YqAvatarPreset {
  const YqAvatarPreset({
    required this.bg,
    required this.shapeColor,
    required this.dotColor,
    required this.shape,
    required this.rotation,
    required this.dot,
  });

  final Color bg;
  final Color shapeColor;
  final Color dotColor;

  /// SVG path data in the 48 × 48 box.
  final String shape;

  /// Degrees, clockwise, around (24, 24).
  final double rotation;
  final Offset dot;
}

abstract final class YqAvatarPalette {
  static const double canvas = 48;
  static const double dotRadius = 4.5;

  static final Color _indigo = YqColors.answerStyles[0].fill;
  static final Color _teal = YqColors.answerStyles[1].fill;
  static final Color _sun = YqColors.answerStyles[2].fill;
  static final Color _rose = YqColors.answerStyles[3].fill;

  static final List<YqAvatarPreset> presets = [
    const YqAvatarPreset(
      bg: YqColors.brandCoral,
      shapeColor: YqColors.brandNight,
      dotColor: YqColors.brandSaffron,
      shape: 'M10 34V24a14 14 0 0128 0v10h-7V24a7 7 0 00-14 0v10z',
      rotation: 0,
      dot: Offset(24, 29),
    ),
    YqAvatarPreset(
      bg: _indigo,
      shapeColor: _sun,
      dotColor: YqColors.brandSand,
      shape: 'M8 24a16 16 0 0132 0z',
      rotation: -30,
      dot: const Offset(30, 32),
    ),
    YqAvatarPreset(
      bg: _teal,
      shapeColor: YqColors.brandNight,
      dotColor: YqColors.brandCoral,
      shape: 'M24 9l15 26H9z',
      rotation: 0,
      dot: const Offset(24, 26),
    ),
    YqAvatarPreset(
      bg: _sun,
      shapeColor: _rose,
      dotColor: YqColors.brandNight,
      shape: 'M10 38C10 20 20 10 38 10C38 28 28 38 10 38z',
      rotation: 0,
      dot: const Offset(24, 24),
    ),
    YqAvatarPreset(
      bg: YqColors.dark.surfaceAlt,
      shapeColor: YqColors.brandCoral,
      dotColor: _teal,
      shape: 'M24 8l16 16-16 16L8 24z',
      rotation: 0,
      dot: const Offset(24, 24),
    ),
    YqAvatarPreset(
      bg: _rose,
      shapeColor: YqColors.brandSand,
      dotColor: _indigo,
      shape: 'M8 24a8 8 0 1016 0a8 8 0 10-16 0M24 24a8 8 0 1016 0a8 8 0 10-16 0',
      rotation: 45,
      dot: const Offset(36, 12),
    ),
    YqAvatarPreset(
      bg: _peach,
      shapeColor: _indigo,
      dotColor: YqColors.brandCoral,
      shape: 'M14 14h20v20H14z',
      rotation: 20,
      dot: const Offset(34, 34),
    ),
    YqAvatarPreset(
      bg: YqColors.brandNight,
      shapeColor: _teal,
      dotColor: _sun,
      shape: 'M8 24a16 16 0 0132 0z',
      rotation: 180,
      dot: const Offset(24, 14),
    ),
  ];

  /// Ghost tile ("Joining…"), pulses 0.4 ↔ 0.9 opacity every 1.4 s.
  static const YqAvatarPreset ghost = YqAvatarPreset(
    bg: Color(0xFF9C8DB3),
    shapeColor: Color(0xFFC9BCDA),
    dotColor: Color(0xFF9C8DB3),
    shape: 'M8 24a16 16 0 0132 0z',
    rotation: 0,
    dot: Offset(24, 24),
  );

  static const Color _peach = Color(0xFFFFE7D6);
}
