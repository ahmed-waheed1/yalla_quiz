// Yalla Quiz — wires the token extensions into ThemeData.
//
//   MaterialApp(
//     locale: locale,
//     theme: YqTheme.build(Brightness.light, locale),
//     darkTheme: YqTheme.build(Brightness.dark, locale),
//     themeMode: themeMode, // Light / Dark / System from Settings
//   )
//
// Layout direction comes from the locale (ar → RTL). Use EdgeInsetsDirectional,
// AlignmentDirectional and Directionality-aware icons (back arrow, chevrons,
// progress, timer-ring direction) so screens mirror automatically.

import 'package:flutter/material.dart';

import 'yq_colors.dart';
import 'yq_spacing.dart';
import 'yq_typography.dart';

abstract final class YqTheme {
  static ThemeData build(Brightness brightness, Locale locale) {
    final isDark = brightness == Brightness.dark;
    final c = isDark ? YqColors.dark : YqColors.light;
    final t = YqTypography.forLocale(locale);

    final scheme = ColorScheme(
      brightness: brightness,
      primary: c.primary,
      onPrimary: c.onPrimary,
      secondary: c.accent,
      onSecondary: YqColors.brandNight,
      error: c.danger,
      onError: isDark ? YqColors.brandNightDeep : Colors.white,
      surface: c.surface,
      onSurface: c.ink,
      surfaceContainerHighest: c.surfaceAlt,
      onSurfaceVariant: c.inkMuted,
      outline: c.line,
      inverseSurface: c.inverse,
      onInverseSurface: c.onInverse,
      scrim: c.scrim,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: c.bg,
      fontFamily: kYqFontFamily,
      textTheme: t.toTextTheme(c.ink, c.inkMuted),
      splashFactory: NoSplash.splashFactory, // feedback comes from the stomp + scale instead
      extensions: <ThemeExtension<dynamic>>[
        c,
        t,
        isDark ? YqElevation.dark : YqElevation.light,
      ],
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: c.primary,
          foregroundColor: c.onPrimary,
          disabledBackgroundColor: c.surfaceAlt,
          disabledForegroundColor: c.inkMuted,
          minimumSize: const Size.fromHeight(YqSpace.buttonHeight),
          textStyle: t.button,
          shape: RoundedRectangleBorder(borderRadius: YqRadius.all(YqRadius.lg)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.ink,
          backgroundColor: c.surface,
          minimumSize: const Size.fromHeight(YqSpace.buttonHeight),
          textStyle: t.button,
          side: BorderSide(color: c.ink, width: 2.5),
          shape: RoundedRectangleBorder(borderRadius: YqRadius.all(YqRadius.lg)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surface,
        contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 18, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: YqRadius.all(YqRadius.lg),
          borderSide: BorderSide(color: c.line, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: YqRadius.all(YqRadius.lg),
          borderSide: BorderSide(color: c.focus, width: 3),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: YqRadius.all(YqRadius.lg),
          borderSide: BorderSide(color: c.danger, width: 2.5),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: c.inverse,
        contentTextStyle: t.label.copyWith(color: c.onInverse, fontSize: 15),
        behavior: SnackBarBehavior.floating,
        shape: const StadiumBorder(),
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.success : c.line,
        ),
        thumbColor: const WidgetStatePropertyAll(Colors.white),
      ),
    );
  }
}
