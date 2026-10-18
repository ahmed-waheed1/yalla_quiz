# Yalla Quiz — Flutter dev handoff

| Path | What |
|---|---|
| `lib/core/theme/yq_colors.dart` | `YqColors` ThemeExtension: every colour token, light + dark, 4 answer styles, timer colours |
| `lib/core/theme/yq_typography.dart` | `YqTypography` ThemeExtension: Cairo styles with Latin vs Arabic line heights, `forLocale()` |
| `lib/core/theme/yq_spacing.dart` | `YqSpace`, `YqRadius`, `YqElevation` (stomp/card/modal shadows), `YqMotion` (durations + curves) |
| `lib/core/theme/yq_theme.dart` | `YqTheme.build(brightness, locale)` wires it all into `ThemeData` (optional) |
| `design-tokens.json` | The same values as plain JSON |
| `screens.md` | Per-screen spec: components, tokens, spacing, animation |
| `screens/phone/` | 26 screens/states × EN + AR, 375×812 @2x (750×1624), light theme |
| `screens/tablet/` | 6 host big-screen screens × EN + AR, 834×1194 @2x (1668×2388) |

Setup: add the Cairo font (weights 500–900) to `pubspec.yaml` as shown at the top of `yq_typography.dart`, then:

```dart
MaterialApp(
  locale: locale,
  supportedLocales: const [Locale('en'), Locale('ar')],
  theme: YqTheme.build(Brightness.light, locale),
  darkTheme: YqTheme.build(Brightness.dark, locale),
)
// in widgets:
final c = context.yqColors;  final t = context.yqText;  final e = context.yqElevation;
```

PNG names: `NN_screen_state_lang.png`. NN is the flow order: 01 splash … 13 error states, 14–19 host screens.
