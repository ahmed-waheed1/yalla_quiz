// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsBrandingGen {
  const $AssetsBrandingGen();

  /// Directory path: assets/branding/png
  $AssetsBrandingPngGen get png => const $AssetsBrandingPngGen();
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/hero_dark.svg
  String get heroDark => 'assets/images/hero_dark.svg';

  /// File path: assets/images/hero_light.svg
  String get heroLight => 'assets/images/hero_light.svg';

  /// File path: assets/images/lockup_dark.svg
  String get lockupDark => 'assets/images/lockup_dark.svg';

  /// File path: assets/images/lockup_light.svg
  String get lockupLight => 'assets/images/lockup_light.svg';

  /// File path: assets/images/wordmark_ar_dark.svg
  String get wordmarkArDark => 'assets/images/wordmark_ar_dark.svg';

  /// File path: assets/images/wordmark_ar_light.svg
  String get wordmarkArLight => 'assets/images/wordmark_ar_light.svg';

  /// File path: assets/images/wordmark_en_dark.svg
  String get wordmarkEnDark => 'assets/images/wordmark_en_dark.svg';

  /// File path: assets/images/wordmark_en_light.svg
  String get wordmarkEnLight => 'assets/images/wordmark_en_light.svg';

  /// File path: assets/images/yalla_ar.svg
  String get yallaAr => 'assets/images/yalla_ar.svg';

  /// File path: assets/images/yalla_en.svg
  String get yallaEn => 'assets/images/yalla_en.svg';

  /// List of all assets
  List<String> get values => [
    heroDark,
    heroLight,
    lockupDark,
    lockupLight,
    wordmarkArDark,
    wordmarkArLight,
    wordmarkEnDark,
    wordmarkEnLight,
    yallaAr,
    yallaEn,
  ];
}

class $AssetsQuestionsGen {
  const $AssetsQuestionsGen();

  /// File path: assets/questions/food.json
  String get food => 'assets/questions/food.json';

  /// File path: assets/questions/general.json
  String get general => 'assets/questions/general.json';

  /// File path: assets/questions/geography.json
  String get geography => 'assets/questions/geography.json';

  /// List of all assets
  List<String> get values => [food, general, geography];
}

class $AssetsTranslationsGen {
  const $AssetsTranslationsGen();

  /// File path: assets/translations/ar.json
  String get ar => 'assets/translations/ar.json';

  /// File path: assets/translations/en.json
  String get en => 'assets/translations/en.json';

  /// List of all assets
  List<String> get values => [ar, en];
}

class $AssetsBrandingPngGen {
  const $AssetsBrandingPngGen();

  /// Directory path: assets/branding/png/splash
  $AssetsBrandingPngSplashGen get splash => const $AssetsBrandingPngSplashGen();

  /// File path: assets/branding/png/yalla_icon_1024.png
  AssetGenImage get yallaIcon1024 =>
      const AssetGenImage('assets/branding/png/yalla_icon_1024.png');

  /// File path: assets/branding/png/yalla_play_512.png
  AssetGenImage get yallaPlay512 =>
      const AssetGenImage('assets/branding/png/yalla_play_512.png');

  /// List of all assets
  List<AssetGenImage> get values => [yallaIcon1024, yallaPlay512];
}

class $AssetsBrandingPngSplashGen {
  const $AssetsBrandingPngSplashGen();

  /// File path: assets/branding/png/splash/splash_android12_dark.png
  AssetGenImage get splashAndroid12Dark => const AssetGenImage(
    'assets/branding/png/splash/splash_android12_dark.png',
  );

  /// File path: assets/branding/png/splash/splash_android12_light.png
  AssetGenImage get splashAndroid12Light => const AssetGenImage(
    'assets/branding/png/splash/splash_android12_light.png',
  );

  /// File path: assets/branding/png/splash/splash_mark_dark.png
  AssetGenImage get splashMarkDark =>
      const AssetGenImage('assets/branding/png/splash/splash_mark_dark.png');

  /// File path: assets/branding/png/splash/splash_mark_light.png
  AssetGenImage get splashMarkLight =>
      const AssetGenImage('assets/branding/png/splash/splash_mark_light.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    splashAndroid12Dark,
    splashAndroid12Light,
    splashMarkDark,
    splashMarkLight,
  ];
}

abstract final class Assets {
  static const $AssetsBrandingGen branding = $AssetsBrandingGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsQuestionsGen questions = $AssetsQuestionsGen();
  static const $AssetsTranslationsGen translations = $AssetsTranslationsGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
