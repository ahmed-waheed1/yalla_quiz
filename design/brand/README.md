# Yalla Quiz — brand image assets

Drop `assets/images/` into the Flutter project.
- SVGs are the primary format. All text is converted to outlines (Lalezar wordmark, Cairo Black pill text), and the files contain no fonts, bitmaps or hidden layers.
- Background is transparent and tightly cropped.
- The `width`/`height` of each SVG is its intended display size in dp.
- PNGs in `2.0x/` are the fallback. Flutter picks them up automatically as the 2× variant of `assets/images/<name>.png`.

```yaml
# pubspec.yaml
dependencies:
  flutter_svg: ^2.0.10
flutter:
  assets:
    - assets/images/
```

```dart
SvgPicture.asset('assets/images/wordmark_en_light.svg', height: 27)   // vector
Image.asset('assets/images/wordmark_en_light.png', height: 27)         // PNG fallback (uses 2.0x/)
```

| File | Size (dp) | Where it's used | Background it sits on |
|---|---|---|---|
| `wordmark_en_light` | 105.5 × 27.25 | Home app bar (EN), start-aligned | light `bg` #FFF6EC |
| `wordmark_en_dark` | 105.5 × 27.25 | Home app bar (EN, dark theme). Splash: scale to height 51 (≈199 wide) | dark `bg` #140A2B / night #1E0F3D |
| `wordmark_ar_light` | 69.5 × 26.75 | Home app bar (AR) | light `bg` |
| `wordmark_ar_dark` | 69.5 × 26.75 | Home app bar (AR, dark theme). Splash: scale to height 50 (≈131 wide) | dark `bg` / night |
| `lockup_light` | 248.75 × 88.75 | Bilingual lockup: About, onboarding, share cards. Minimum width 160 | light surfaces |
| `lockup_dark` | 249.75 × 88.75 | Same, on dark (the icon tile has a 2dp `line` ring) | dark surfaces |
| `hero_light` | 263 × 190 | 02 Home hero card illustration. The card is night #1E0F3D in the light theme | card `inverse` #1E0F3D |
| `hero_dark` | 263 × 190 | Same, dark theme (star in #3D2C66) | card `inverse` #2E1D52 |
| `yalla_en` | 336.75 × 116.75 | 07 Get ready, final "Yalla!" frame, centred, above the subline | `primary` flood #FF5A36 |
| `yalla_ar` | 156.25 × 123.25 | 07 Get ready, "يلا!" frame, centred | `primary` flood #FF5A36 |

**Usage notes**
- **Wordmark:** keep clear space on every side equal to the pill's height. Don't recolour the pill: coral #FF5A36 with night #1E0F3D text works on both themes.
- **Hero:** in the design it sits inside a 295-wide card area (card padding 20). Show it at 263 × 190 centred, or `BoxFit.contain` into that slot. Never mirror it in RTL.
- **Yalla artwork:** it is already tilted −4°. The countdown animation adds its own rotate (−8° → 0°) and scale (0 → 1.15 → 1) on top. It is always night text on coral, so there's one version per language and no light/dark variants.
- **Arabic shaping:** the Arabic text is shaped as connected script, with the "!" at the end of the line (the left side).
