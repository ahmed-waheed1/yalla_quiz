// Yalla Quiz — typography.
// One family for both scripts: Cairo (Google Fonts, OFL). Weights used: 500, 600, 700, 800, 900.
// Arabic keeps the SAME sizes as Latin but gets taller line-heights.
// The wordmark/logo uses Lalezar — only as an image/asset, never for UI text.
//
// Add Cairo to pubspec.yaml (bundled assets recommended over runtime fetching):
//   flutter:
//     fonts:
//       - family: Cairo
//         fonts:
//           - asset: assets/fonts/Cairo-Medium.ttf     # 500
//             weight: 500
//           - asset: assets/fonts/Cairo-SemiBold.ttf   # 600
//             weight: 600
//           - asset: assets/fonts/Cairo-Bold.ttf       # 700
//             weight: 700
//           - asset: assets/fonts/Cairo-ExtraBold.ttf  # 800
//             weight: 800
//           - asset: assets/fonts/Cairo-Black.ttf      # 900
//             weight: 900
//
// Numbers (scores, timer, room code, "4/10") always use Western digits 0-9 and
// tabular figures in BOTH locales, and are laid out LTR (wrap with
// Directionality(textDirection: TextDirection.ltr) or use [YqTypography.numeric]).
//
// Usage:
//   Text('Start game', style: context.yqText.button)
//   ThemeData(extensions: [YqTypography.forLocale(locale)])


import 'package:flutter/material.dart';

const String kYqFontFamily = 'Cairo';

/// Line-heights per script. Latin first, Arabic second.
class YqLineHeights {
  const YqLineHeights({
    required this.display,
    required this.headline,
    required this.title,
    required this.question,
    required this.titleSm,
    required this.button,
    required this.body,
    required this.caption,
  });

  final double display, headline, title, question, titleSm, button, body, caption;

  static const latin = YqLineHeights(
    display: 1.05,
    headline: 1.15,
    title: 1.25,
    question: 1.30,
    titleSm: 1.30,
    button: 1.20,
    body: 1.45,
    caption: 1.40,
  );

  static const arabic = YqLineHeights(
    display: 1.30,
    headline: 1.35,
    title: 1.50,
    question: 1.60,
    titleSm: 1.55,
    button: 1.40,
    body: 1.75,
    caption: 1.70,
  );
}

@immutable
class YqTypography extends ThemeExtension<YqTypography> {
  const YqTypography({
    required this.display,
    required this.headline,
    required this.title,
    required this.question,
    required this.titleSm,
    required this.button,
    required this.label,
    required this.body,
    required this.caption,
    required this.code,
    required this.timer,
    required this.numeric,
    required this.hostQuestion,
    required this.hostAnswer,
    required this.hostTimer,
  });

  /// 64 / 900 — countdown digits, big room code on splash moments.
  final TextStyle display;

  /// 32 / 900 — screen heroes ("Got a code?", winner line).
  final TextStyle headline;

  /// 24 / 800 — screen titles, result banners.
  final TextStyle title;

  /// 22 / 800 — the question text on phone (designs use 22–23).
  final TextStyle question;

  /// 18 / 800 — app-bar titles, section headers, list names.
  final TextStyle titleSm;

  /// 18 / 800 — buttons and answer buttons (answers use 19).
  final TextStyle button;

  /// 14 / 800 — field labels, small section labels, chips.
  final TextStyle label;

  /// 16 / 500 — paragraphs, helper text.
  final TextStyle body;

  /// 13 / 600 — meta lines, counts, hints (use inkMuted).
  final TextStyle caption;

  /// 34 / 900, letter-spacing 0.08em — room code "K7XP2Q". Always LTR.
  final TextStyle code;

  /// 34 / 900 tabular — seconds inside the phone timer ring.
  final TextStyle timer;

  /// 15 / 900 tabular — scores, "4/10", counts. Always LTR.
  final TextStyle numeric;

  /// 50 / 900 — question on the host big screen (tablet 834). Desktop: 64.
  final TextStyle hostQuestion;

  /// 36 / 900 — answer tiles on the host big screen. Desktop: 42.
  final TextStyle hostAnswer;

  /// 68 / 900 tabular — host timer digits. Desktop: 80.
  final TextStyle hostTimer;

  static const List<FontFeature> _tabular = [FontFeature.tabularFigures()];

  static TextStyle _s(double size, FontWeight w, double height, {double? letterSpacing, bool tabular = false}) =>
      TextStyle(
        fontFamily: kYqFontFamily,
        fontSize: size,
        fontWeight: w,
        height: height,
        letterSpacing: letterSpacing,
        fontFeatures: tabular ? _tabular : null,
        leadingDistribution: TextLeadingDistribution.even,
      );

  factory YqTypography.fromHeights(YqLineHeights h) => YqTypography(
        display: _s(64, FontWeight.w900, h.display, tabular: true),
        headline: _s(32, FontWeight.w900, h.headline),
        title: _s(24, FontWeight.w800, h.title),
        question: _s(22, FontWeight.w800, h.question),
        titleSm: _s(18, FontWeight.w800, h.titleSm),
        button: _s(18, FontWeight.w800, h.button),
        label: _s(14, FontWeight.w800, h.titleSm),
        body: _s(16, FontWeight.w500, h.body),
        caption: _s(13, FontWeight.w600, h.caption),
        // Code + numbers are Latin glyphs in both locales → Latin line-height.
        code: _s(34, FontWeight.w900, 1.1, letterSpacing: 34 * 0.08, tabular: true),
        timer: _s(34, FontWeight.w900, 1.0, tabular: true),
        numeric: _s(15, FontWeight.w900, 1.2, tabular: true),
        hostQuestion: _s(50, FontWeight.w900, h == YqLineHeights.arabic ? 1.5 : 1.2),
        hostAnswer: _s(36, FontWeight.w900, h.title),
        hostTimer: _s(68, FontWeight.w900, 1.0, tabular: true),
      );

  static final YqTypography latin = YqTypography.fromHeights(YqLineHeights.latin);
  static final YqTypography arabic = YqTypography.fromHeights(YqLineHeights.arabic);

  /// Pick by locale: Arabic heights for `ar`, Latin otherwise.
  static YqTypography forLocale(Locale locale) => locale.languageCode == 'ar' ? arabic : latin;

  /// Material TextTheme mapped from the brand styles (for stock widgets).
  TextTheme toTextTheme(Color ink, Color inkMuted) => TextTheme(
        displayLarge: display.copyWith(color: ink),
        headlineMedium: headline.copyWith(color: ink),
        titleLarge: title.copyWith(color: ink),
        titleMedium: titleSm.copyWith(color: ink),
        labelLarge: button.copyWith(color: ink),
        labelMedium: label.copyWith(color: ink),
        bodyLarge: body.copyWith(color: ink),
        bodyMedium: body.copyWith(color: ink, fontSize: 15),
        bodySmall: caption.copyWith(color: inkMuted),
      );

  @override
  YqTypography copyWith({
    TextStyle? display,
    TextStyle? headline,
    TextStyle? title,
    TextStyle? question,
    TextStyle? titleSm,
    TextStyle? button,
    TextStyle? label,
    TextStyle? body,
    TextStyle? caption,
    TextStyle? code,
    TextStyle? timer,
    TextStyle? numeric,
    TextStyle? hostQuestion,
    TextStyle? hostAnswer,
    TextStyle? hostTimer,
  }) {
    return YqTypography(
      display: display ?? this.display,
      headline: headline ?? this.headline,
      title: title ?? this.title,
      question: question ?? this.question,
      titleSm: titleSm ?? this.titleSm,
      button: button ?? this.button,
      label: label ?? this.label,
      body: body ?? this.body,
      caption: caption ?? this.caption,
      code: code ?? this.code,
      timer: timer ?? this.timer,
      numeric: numeric ?? this.numeric,
      hostQuestion: hostQuestion ?? this.hostQuestion,
      hostAnswer: hostAnswer ?? this.hostAnswer,
      hostTimer: hostTimer ?? this.hostTimer,
    );
  }

  @override
  YqTypography lerp(ThemeExtension<YqTypography>? other, double t) {
    if (other is! YqTypography) return this;
    TextStyle l(TextStyle a, TextStyle b) => TextStyle.lerp(a, b, t)!;
    return YqTypography(
      display: l(display, other.display),
      headline: l(headline, other.headline),
      title: l(title, other.title),
      question: l(question, other.question),
      titleSm: l(titleSm, other.titleSm),
      button: l(button, other.button),
      label: l(label, other.label),
      body: l(body, other.body),
      caption: l(caption, other.caption),
      code: l(code, other.code),
      timer: l(timer, other.timer),
      numeric: l(numeric, other.numeric),
      hostQuestion: l(hostQuestion, other.hostQuestion),
      hostAnswer: l(hostAnswer, other.hostAnswer),
      hostTimer: l(hostTimer, other.hostTimer),
    );
  }
}

extension YqTypographyContext on BuildContext {
  YqTypography get yqText => Theme.of(this).extension<YqTypography>()!;
}
