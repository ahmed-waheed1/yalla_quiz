// Yalla Quiz — colour tokens.
// Source of truth: design-tokens.json (same values). Drop into lib/core/theme/.
//
// Usage:
//   final c = context.yqColors;          // see extension at the bottom
//   Container(color: c.surface)
//   YqAnswerStyle a = c.answers[0];      // a1 triangle … a4 square

import 'package:flutter/material.dart';

/// The four answer-option shapes. Shape + colour + position — never colour alone.
enum YqAnswerShape { triangle, diamond, circle, square }

/// One answer option's look. Identical in light and dark themes.
@immutable
class YqAnswerStyle {
  const YqAnswerStyle({
    required this.fill,
    required this.onFill,
    required this.deep,
    required this.shape,
  });

  /// Button background.
  final Color fill;

  /// Text + shape icon on [fill]. Contrast ≥ 5:1 for all four.
  final Color onFill;

  /// The hard "stomp" shadow under the button (offset 0,5 — drops to 0,1 on press).
  final Color deep;

  final YqAnswerShape shape;

  static YqAnswerStyle lerp(YqAnswerStyle a, YqAnswerStyle b, double t) => YqAnswerStyle(
        fill: Color.lerp(a.fill, b.fill, t)!,
        onFill: Color.lerp(a.onFill, b.onFill, t)!,
        deep: Color.lerp(a.deep, b.deep, t)!,
        shape: t < 0.5 ? a.shape : b.shape,
      );
}

@immutable
class YqColors extends ThemeExtension<YqColors> {
  const YqColors({
    required this.bg,
    required this.bgPattern,
    required this.surface,
    required this.surfaceAlt,
    required this.ink,
    required this.inkMuted,
    required this.line,
    required this.primary,
    required this.primaryDeep,
    required this.onPrimary,
    required this.inverse,
    required this.onInverse,
    required this.inverse2,
    required this.accent,
    required this.success,
    required this.successSoft,
    required this.danger,
    required this.dangerSoft,
    required this.warning,
    required this.warningSoft,
    required this.focus,
    required this.scrim,
    required this.podiumSilver,
    required this.timerCalm,
    required this.timerWarn,
    required this.timerPanic,
    required this.answers,
  });

  /// Screen ground. Painted with a 24px dot grid in [bgPattern] (dot radius 1.6).
  final Color bg;
  final Color bgPattern;

  /// Cards, tiles, inputs, list rows.
  final Color surface;

  /// Chips, segmented-control track, timer track, disabled fills.
  final Color surfaceAlt;

  /// Primary text + icons.
  final Color ink;

  /// Secondary text (≥ 7:1 on bg).
  final Color inkMuted;

  /// 1.5px outlines and dividers.
  final Color line;

  /// "Yalla coral" — main CTA, speech bubble, selected rings.
  final Color primary;

  /// Stomp shadow under primary buttons / pressed state.
  final Color primaryDeep;

  /// Text on primary (5.7:1). Note: dark text, not white.
  final Color onPrimary;

  /// Night panels (home hero card, selected segment, toasts).
  final Color inverse;
  final Color onInverse;

  /// Secondary night tone: star motif, Android 12 splash icon circle.
  final Color inverse2;

  /// Celebration: crown, host badge, rank #1, spark.
  final Color accent;

  final Color success;
  final Color successSoft;
  final Color danger;
  final Color dangerSoft;
  final Color warning;
  final Color warningSoft;

  /// 3px keyboard focus ring.
  final Color focus;

  /// Modal backdrop.
  final Color scrim;

  /// 2nd place podium block.
  final Color podiumSilver;

  /// Timer ring: > 50% left.
  final Color timerCalm;

  /// Timer ring: ≤ 50% left.
  final Color timerWarn;

  /// Timer ring: ≤ 5 s left (also pulses).
  final Color timerPanic;

  /// a1 triangle · a2 diamond · a3 circle · a4 square.
  final List<YqAnswerStyle> answers;

  // ---- Brand constants (theme-independent) ---------------------------------
  static const Color brandCoral = Color(0xFFFF5A36);
  static const Color brandSaffron = Color(0xFFFFB321);
  static const Color brandNight = Color(0xFF1E0F3D);
  static const Color brandSand = Color(0xFFFFF6EC);
  static const Color brandNightDeep = Color(0xFF140A2B);
  static const Color brandNight2 = Color(0xFF2A1A4F);

  /// Answer options — same in both themes.
  static const List<YqAnswerStyle> answerStyles = [
    YqAnswerStyle(fill: Color(0xFF3A2FD6), onFill: Color(0xFFFFFFFF), deep: Color(0xFF241A9A), shape: YqAnswerShape.triangle), // a1 indigo, 8.2:1
    YqAnswerStyle(fill: Color(0xFF19C2A8), onFill: Color(0xFF140A2B), deep: Color(0xFF0E8572), shape: YqAnswerShape.diamond), // a2 teal, 8.4:1
    YqAnswerStyle(fill: Color(0xFFFFD23F), onFill: Color(0xFF140A2B), deep: Color(0xFFC79A10), shape: YqAnswerShape.circle), // a3 sun, 13:1
    YqAnswerStyle(fill: Color(0xFFE8457F), onFill: Color(0xFF140A2B), deep: Color(0xFFA8245A), shape: YqAnswerShape.square), // a4 rose, 5.1:1
  ];

  static const YqColors light = YqColors(
    bg: Color(0xFFFFF6EC),
    bgPattern: Color(0xFFF1E2D2),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFFBEADB),
    ink: Color(0xFF1E0F3D),
    inkMuted: Color(0xFF5B4D73),
    line: Color(0xFFEAD9C8),
    primary: Color(0xFFFF5A36),
    primaryDeep: Color(0xFFC93A1A),
    onPrimary: Color(0xFF1E0F3D),
    inverse: Color(0xFF1E0F3D),
    onInverse: Color(0xFFFFF6EC),
    inverse2: Color(0xFF2A1A4F),
    accent: Color(0xFFFFB321),
    success: Color(0xFF0B7A54),
    successSoft: Color(0xFFD7F3E6),
    danger: Color(0xFFC81E4A),
    dangerSoft: Color(0xFFFBDDE5),
    warning: Color(0xFF9A5B00),
    warningSoft: Color(0xFFFFEFC7),
    focus: Color(0xFF3A2FD6),
    scrim: Color(0x8C1E0F3D),
    podiumSilver: Color(0xFFD9CFE6),
    timerCalm: Color(0xFF0B7A54),
    timerWarn: Color(0xFF9A5B00),
    timerPanic: Color(0xFFC81E4A),
    answers: answerStyles,
  );

  static const YqColors dark = YqColors(
    bg: Color(0xFF140A2B),
    bgPattern: Color(0xFF22163F),
    surface: Color(0xFF22143F),
    surfaceAlt: Color(0xFF2E1D52),
    ink: Color(0xFFFFF3E6),
    inkMuted: Color(0xFFC2B6D9),
    line: Color(0xFF3D2C66),
    primary: Color(0xFFFF6A45),
    primaryDeep: Color(0xFFB8381A),
    onPrimary: Color(0xFF1E0F3D),
    inverse: Color(0xFF2E1D52),
    onInverse: Color(0xFFFFF3E6),
    inverse2: Color(0xFF3D2C66),
    accent: Color(0xFFFFC24D),
    success: Color(0xFF3DDC97),
    successSoft: Color(0xFF123A2E),
    danger: Color(0xFFFF7090),
    dangerSoft: Color(0xFF4A1630),
    warning: Color(0xFFFFD23F),
    warningSoft: Color(0xFF3D3112),
    focus: Color(0xFF9C94FF),
    scrim: Color(0xA0000000),
    podiumSilver: Color(0xFFC2B6D9),
    timerCalm: Color(0xFF3DDC97),
    timerWarn: Color(0xFFFFD23F),
    timerPanic: Color(0xFFFF7090),
    answers: answerStyles,
  );

  /// Timer ring colour for a given fraction of time remaining (1.0 → 0.0).
  Color timerColor(double remainingFraction, {required int secondsLeft}) {
    if (secondsLeft <= 5) return timerPanic;
    if (remainingFraction <= 0.5) return timerWarn;
    return timerCalm;
  }

  @override
  YqColors copyWith({
    Color? bg,
    Color? bgPattern,
    Color? surface,
    Color? surfaceAlt,
    Color? ink,
    Color? inkMuted,
    Color? line,
    Color? primary,
    Color? primaryDeep,
    Color? onPrimary,
    Color? inverse,
    Color? onInverse,
    Color? inverse2,
    Color? accent,
    Color? success,
    Color? successSoft,
    Color? danger,
    Color? dangerSoft,
    Color? warning,
    Color? warningSoft,
    Color? focus,
    Color? scrim,
    Color? podiumSilver,
    Color? timerCalm,
    Color? timerWarn,
    Color? timerPanic,
    List<YqAnswerStyle>? answers,
  }) {
    return YqColors(
      bg: bg ?? this.bg,
      bgPattern: bgPattern ?? this.bgPattern,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      ink: ink ?? this.ink,
      inkMuted: inkMuted ?? this.inkMuted,
      line: line ?? this.line,
      primary: primary ?? this.primary,
      primaryDeep: primaryDeep ?? this.primaryDeep,
      onPrimary: onPrimary ?? this.onPrimary,
      inverse: inverse ?? this.inverse,
      onInverse: onInverse ?? this.onInverse,
      inverse2: inverse2 ?? this.inverse2,
      accent: accent ?? this.accent,
      success: success ?? this.success,
      successSoft: successSoft ?? this.successSoft,
      danger: danger ?? this.danger,
      dangerSoft: dangerSoft ?? this.dangerSoft,
      warning: warning ?? this.warning,
      warningSoft: warningSoft ?? this.warningSoft,
      focus: focus ?? this.focus,
      scrim: scrim ?? this.scrim,
      podiumSilver: podiumSilver ?? this.podiumSilver,
      timerCalm: timerCalm ?? this.timerCalm,
      timerWarn: timerWarn ?? this.timerWarn,
      timerPanic: timerPanic ?? this.timerPanic,
      answers: answers ?? this.answers,
    );
  }

  @override
  YqColors lerp(ThemeExtension<YqColors>? other, double t) {
    if (other is! YqColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return YqColors(
      bg: l(bg, other.bg),
      bgPattern: l(bgPattern, other.bgPattern),
      surface: l(surface, other.surface),
      surfaceAlt: l(surfaceAlt, other.surfaceAlt),
      ink: l(ink, other.ink),
      inkMuted: l(inkMuted, other.inkMuted),
      line: l(line, other.line),
      primary: l(primary, other.primary),
      primaryDeep: l(primaryDeep, other.primaryDeep),
      onPrimary: l(onPrimary, other.onPrimary),
      inverse: l(inverse, other.inverse),
      onInverse: l(onInverse, other.onInverse),
      inverse2: l(inverse2, other.inverse2),
      accent: l(accent, other.accent),
      success: l(success, other.success),
      successSoft: l(successSoft, other.successSoft),
      danger: l(danger, other.danger),
      dangerSoft: l(dangerSoft, other.dangerSoft),
      warning: l(warning, other.warning),
      warningSoft: l(warningSoft, other.warningSoft),
      focus: l(focus, other.focus),
      scrim: l(scrim, other.scrim),
      podiumSilver: l(podiumSilver, other.podiumSilver),
      timerCalm: l(timerCalm, other.timerCalm),
      timerWarn: l(timerWarn, other.timerWarn),
      timerPanic: l(timerPanic, other.timerPanic),
      answers: List<YqAnswerStyle>.generate(
        answers.length,
        (i) => YqAnswerStyle.lerp(answers[i], other.answers[i], t),
      ),
    );
  }
}

extension YqColorsContext on BuildContext {
  YqColors get yqColors => Theme.of(this).extension<YqColors>()!;
}
