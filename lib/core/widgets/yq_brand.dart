import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';
import '../theme/yq_typography.dart';

/// The speech-bubble brand mark (light/dark variants).
class YqBrandMark extends StatelessWidget {
  const YqBrandMark({super.key, required this.size, this.onDark});

  final double size;

  /// Force the dark-background variant (e.g. on the night splash).
  final bool? onDark;

  @override
  Widget build(BuildContext context) {
    final dark = onDark ?? Theme.of(context).brightness == Brightness.dark;
    final splash = Assets.branding.png.splash;
    return (dark ? splash.splashMarkDark : splash.splashMarkLight).image(
      width: size,
      height: size,
      fit: BoxFit.contain,
      excludeFromSemantics: true,
    );
  }
}

/// The Lalezar "yalla QUIZ" wordmark artwork.
///
/// Placeholder: the artwork isn't exported yet, so this shows the brand mark.
/// When `assets/images/wordmark*.png|svg` lands, swap the body here only.
class YqWordmark extends StatelessWidget {
  const YqWordmark({super.key, required this.height, this.onDark});

  final double height;
  final bool? onDark;

  @override
  Widget build(BuildContext context) => YqBrandMark(size: height, onDark: onDark);
}

/// Placeholder for the home hero illustration (answer shapes on a star).
/// Swap for the SVG once it's exported to `assets/images/`.
class YqHeroIllustration extends StatelessWidget {
  const YqHeroIllustration({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) => Center(child: YqBrandMark(size: height, onDark: true));
}

/// The Lalezar "Yalla!" / "يلا!" artwork for the countdown (07).
///
/// Placeholder: until the artwork is exported to `assets/images/`, this sets
/// [label] in Cairo Black at the artwork's height. Swap the body here only.
class YqYallaArtwork extends StatelessWidget {
  const YqYallaArtwork({super.key, required this.label, required this.height, required this.color});

  final String label;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    child: FittedBox(
      child: Text(
        label,
        style: context.yqText.display.copyWith(
          fontWeight: FontWeight.w900,
          fontSize: height,
          height: 1,
          color: color,
        ),
      ),
    ),
  );
}
