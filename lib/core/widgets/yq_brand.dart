import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../gen/assets.gen.dart';
import '../theme/yq_spacing.dart';

/// Brand artwork from `assets/images/` (SVG; see design/brand/README.md).
/// Light/dark follows the theme and en/ar the locale; none of it mirrors in RTL.

bool _isArabic(BuildContext context) => Localizations.localeOf(context).languageCode == 'ar';

bool _isDark(BuildContext context, bool? onDark) =>
    onDark ?? Theme.of(context).brightness == Brightness.dark;

/// The speech-bubble brand mark (light/dark variants).
class YqBrandMark extends StatelessWidget {
  const YqBrandMark({super.key, required this.size, this.onDark});

  final double size;

  /// Force the dark-background variant (e.g. on the night splash).
  final bool? onDark;

  @override
  Widget build(BuildContext context) {
    final splash = Assets.branding.png.splash;
    return (_isDark(context, onDark) ? splash.splashMarkDark : splash.splashMarkLight).image(
      width: size,
      height: size,
      fit: BoxFit.contain,
      excludeFromSemantics: true,
    );
  }
}

/// The Lalezar "yalla QUIZ" / "يلا كويز" wordmark.
///
/// [height] is the English height; the Arabic artwork is a touch shorter
/// (26.75 vs 27.25 at its design size) and scales by the same ratio, so a
/// splash at 51 shows Arabic at 50, as the brand README specifies.
class YqWordmark extends StatelessWidget {
  const YqWordmark({super.key, required this.height, this.onDark});

  final double height;

  /// Force the variant for a dark (true) or light (false) background.
  final bool? onDark;

  static const double _arToEnHeight = 26.75 / 27.25;

  @override
  Widget build(BuildContext context) {
    final images = Assets.images;
    final dark = _isDark(context, onDark);
    final ar = _isArabic(context);
    final path = ar
        ? (dark ? images.wordmarkArDark : images.wordmarkArLight)
        : (dark ? images.wordmarkEnDark : images.wordmarkEnLight);
    return SvgPicture.asset(
      path,
      height: ar ? height * _arToEnHeight : height,
      semanticsLabel: 'app.title'.tr(),
    );
  }
}

/// The brand mark (44) followed by the wordmark (40): the big-screen top bar
/// (14–19).
class YqBrandRow extends StatelessWidget {
  const YqBrandRow({super.key});

  static const double _markSize = 44;
  static const double _wordmarkHeight = 40;

  @override
  Widget build(BuildContext context) => const Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      YqBrandMark(size: _markSize),
      SizedBox(width: YqSpace.x3),
      YqWordmark(height: _wordmarkHeight),
    ],
  );
}

/// The home hero illustration (answer shapes on a star) for the `inverse`
/// card: fitted into its slot, never mirrored in RTL.
class YqHeroIllustration extends StatelessWidget {
  const YqHeroIllustration({super.key});

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    _isDark(context, null) ? Assets.images.heroDark : Assets.images.heroLight,
    fit: BoxFit.contain,
    excludeFromSemantics: true,
  );
}

/// The Lalezar "Yalla!" / "يلا!" artwork for the countdown (07). Shown at its
/// design size, scaled down only where it doesn't fit (it's 336.75 wide in
/// English). The artwork is already tilted −4°; the countdown animates on top.
class YqYallaArtwork extends StatelessWidget {
  const YqYallaArtwork({super.key, required this.semanticsLabel});

  final String semanticsLabel;

  @override
  Widget build(BuildContext context) => FittedBox(
    fit: BoxFit.scaleDown,
    child: SvgPicture.asset(
      _isArabic(context) ? Assets.images.yallaAr : Assets.images.yallaEn,
      semanticsLabel: semanticsLabel,
    ),
  );
}
