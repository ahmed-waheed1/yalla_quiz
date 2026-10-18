import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yalla_quiz/core/theme/yq_colors.dart';
import 'package:yalla_quiz/features/home/presentation/pages/splash_page.dart';

/// WCAG 2.x contrast ratio between two opaque colours.
double contrast(Color a, Color b) {
  double lum(Color c) {
    double ch(double v) => v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
    return 0.2126 * ch(c.r) + 0.7152 * ch(c.g) + 0.0722 * ch(c.b);
  }

  final l1 = lum(a), l2 = lum(b);
  return (math.max(l1, l2) + 0.05) / (math.min(l1, l2) + 0.05);
}

const double _text = 4.5; // WCAG AA, normal text
const double _ui = 3; // WCAG AA, non-text (state indicators, icons, borders that carry meaning)

/// Colour pairs the shared components rely on, checked in light and dark.
final Map<String, (Color, Color, double) Function(YqColors)> _pairs = {
  'segmented: selected text on pill (bg on ink)': (c) => (c.bg, c.ink, _text),
  'segmented: selected pill vs track (ink vs surfaceAlt)': (c) => (c.ink, c.surfaceAlt, _ui),
  'segmented: unselected text (inkMuted on surfaceAlt)': (c) => (c.inkMuted, c.surfaceAlt, _text),
  'toast: text (bg on ink)': (c) => (c.bg, c.ink, _text),
  'toast: pill vs screen (ink vs bg)': (c) => (c.ink, c.bg, _ui),
  'primary button: label (onPrimary on primary)': (c) => (c.onPrimary, c.primary, _text),
  'secondary button: label (ink on surface)': (c) => (c.ink, c.surface, _text),
  'secondary button: border vs screen (ink vs bg)': (c) => (c.ink, c.bg, _ui),
  'disabled button: label (inkMuted on surfaceAlt)': (c) => (c.inkMuted, c.surfaceAlt, _text),
  'icon button: inverse panel icon (onInverse on inverse)': (c) => (c.onInverse, c.inverse, _text),
  'home hero: text (onInverse on inverse)': (c) => (c.onInverse, c.inverse, _text),
  'avatar picker: check badge (onPrimary on primary)': (c) => (c.onPrimary, c.primary, _ui),
  'code input: glyph (ink on surface)': (c) => (c.ink, c.surface, _text),
  'code input: filled border (ink vs surface)': (c) => (c.ink, c.surface, _ui),
  'code input: focus border (focus vs surface)': (c) => (c.focus, c.surface, _ui),
  'code input: error border (danger vs dangerSoft)': (c) => (c.danger, c.dangerSoft, _ui),
  'player tile: "you" ring (primary vs surface)': (c) => (c.primary, c.surface, _ui),
  'player tile: name (ink on surface)': (c) => (c.ink, c.surface, _text),
  'host badge: crown (brandNight on accent)': (c) => (YqColors.brandNight, c.accent, _ui),
  'category chip: selected ring (primary vs surface)': (c) => (c.primary, c.surface, _ui),
  'card: secondary text (inkMuted on surface)': (c) => (c.inkMuted, c.surface, _text),
  'meta pill: text (inkMuted on surfaceAlt)': (c) => (c.inkMuted, c.surfaceAlt, _text),
  'banner danger: title (ink on dangerSoft)': (c) => (c.ink, c.dangerSoft, _text),
  'banner danger: body (inkMuted on dangerSoft)': (c) => (c.inkMuted, c.dangerSoft, _text),
  'banner danger: icon/border (danger vs dangerSoft)': (c) => (c.danger, c.dangerSoft, _ui),
  'banner warning: body (inkMuted on warningSoft)': (c) => (c.inkMuted, c.warningSoft, _text),
  'banner success: body (inkMuted on successSoft)': (c) => (c.inkMuted, c.successSoft, _text),
  'switch: on track vs card (success vs surface)': (c) => (c.success, c.surface, _ui),
  'switch: on thumb vs track (surface vs success)': (c) => (c.surface, c.success, _ui),
  'screen: muted text (inkMuted on bg)': (c) => (c.inkMuted, c.bg, _text),
  // 20/700 is large text, so 3:1 applies.
  'splash: tagline on bg': (c) => (SplashPage.taglineColor(c, _brightnessOf(c)), c.bg, _ui),
};

Brightness _brightnessOf(YqColors c) =>
    identical(c, YqColors.dark) ? Brightness.dark : Brightness.light;

void main() {
  test('splash background equals the native splash colours', () {
    // flutter_native_splash.yaml: color #FFF6EC, color_dark #140A2B.
    expect(YqColors.light.bg, const Color(0xFFFFF6EC));
    expect(YqColors.dark.bg, const Color(0xFF140A2B));
  });

  for (final (name, colors) in [('light', YqColors.light), ('dark', YqColors.dark)]) {
    group(name, () {
      for (final MapEntry(key: label, value: pair) in _pairs.entries) {
        test(label, () {
          final (fg, bg, min) = pair(colors);
          final ratio = contrast(fg, bg);
          expect(ratio, greaterThanOrEqualTo(min), reason: '${ratio.toStringAsFixed(2)}:1');
        });
      }
    });
  }

  test('regression: dark inverse equals surfaceAlt, so it must not mark selection', () {
    expect(YqColors.dark.inverse, YqColors.dark.surfaceAlt);
  });
}
