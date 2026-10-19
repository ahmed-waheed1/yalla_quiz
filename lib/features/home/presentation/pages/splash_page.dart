import 'dart:async';
import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/theme/yq_colors.dart';
import '../../../../core/theme/yq_spacing.dart';
import '../../../../core/theme/yq_typography.dart';
import '../../../../core/utils/log.dart';
import '../../../../core/widgets/yq_brand.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../widgets/night_star.dart';

/// 01 Splash: plays the intro once (~1.1 s) while signing in anonymously,
/// then routes to Home, or Profile setup on first launch.
///
/// Follows the system theme so the hand-off from the native splash is
/// seamless: `bg` ground (#FFF6EC light, #140A2B dark, the same colours as
/// flutter_native_splash) and the same light/dark brand mark.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  /// Tagline colour: `accent` on night as designed; on sand `accent` is only
  /// 1.68:1, so light uses `primaryDeep` (4.79:1).
  static Color taglineColor(YqColors c, Brightness brightness) =>
      brightness == Brightness.dark ? c.accent : c.primaryDeep;

  /// Star motif: `inverse2` on night as designed; the dot-grid tone on sand.
  static Color starColor(YqColors c, Brightness brightness) =>
      brightness == Brightness.dark ? c.inverse2 : c.bgPattern;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  static const Duration _intro = Duration(milliseconds: 1100);
  static const Duration _signInTimeout = Duration(seconds: 6);
  static const double _markSize = 180;
  static const double _markToWordmark = 18;

  /// English height; the Arabic wordmark scales to 50 (brand README).
  static const double _wordmarkHeight = 51;

  /// The wordmark rises this far as it fades in.
  static const double _wordmarkRise = 28;
  static const double _starSize = 620;

  late final AnimationController _introController = AnimationController(
    vsync: this,
    duration: _intro,
  );
  late final AnimationController _starController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 40),
  );
  late final AnimationController _dotsController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  Animation<double> _interval(double startMs, double endMs, Curve curve) => CurvedAnimation(
    parent: _introController,
    curve: Interval(startMs / 1100, endMs / 1100, curve: curve),
  );

  late final Animation<double> _mark = _interval(0, 220, YqMotion.snap);
  late final Animation<double> _wordmark = _interval(180, 360, YqMotion.out);
  late final Animation<double> _tagline = _interval(330, 480, YqMotion.out);

  @override
  void initState() {
    super.initState();
    _run();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _starController.stop();
      _dotsController.stop();
    } else {
      if (!_starController.isAnimating) _starController.repeat();
      if (!_dotsController.isAnimating) _dotsController.repeat();
    }
  }

  Future<void> _run() async {
    final signIn = getIt<AuthService>()
        .ensureSignedIn()
        .timeout(_signInTimeout)
        .then<void>(
          (_) {},
          onError: (Object e) => log.w('Anonymous sign-in failed at startup', error: e),
        );
    await Future.wait([_introController.forward().orCancel.catchError((_) {}), signIn]);
    if (!mounted) return;
    final hasProfile = getIt<ProfileCubit>().state != null;
    context.go(hasProfile ? Routes.home : Routes.profileThen(Routes.home));
  }

  @override
  void dispose() {
    _introController.dispose();
    _starController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final t = context.yqText;
    final brightness = Theme.of(context).brightness;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: brightness == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: c.bg,
        body: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            OverflowBox(
              maxWidth: _starSize,
              maxHeight: _starSize,
              child: RotationTransition(
                turns: _starController,
                child: Opacity(
                  opacity: 0.55,
                  child: NightStar(size: _starSize, color: SplashPage.starColor(c, brightness)),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _mark,
                  builder: (context, child) {
                    final v = _mark.value;
                    if (MediaQuery.disableAnimationsOf(context)) {
                      return Opacity(opacity: v.clamp(0, 1), child: child);
                    }
                    return Transform.rotate(
                      angle: (1 - v.clamp(0, 1)) * -14 * math.pi / 180,
                      child: Transform.scale(scale: v, child: child),
                    );
                  },
                  child: const YqBrandMark(size: _markSize),
                ),
                const SizedBox(height: _markToWordmark),
                AnimatedBuilder(
                  animation: _wordmark,
                  builder: (context, child) {
                    final v = _wordmark.value;
                    final rise = MediaQuery.disableAnimationsOf(context) ? 0.0 : 1 - v;
                    return Opacity(
                      opacity: v.clamp(0, 1),
                      child: Transform.translate(
                        offset: Offset(0, _wordmarkRise * rise),
                        child: child,
                      ),
                    );
                  },
                  child: const YqWordmark(height: _wordmarkHeight),
                ),
                const SizedBox(height: YqSpace.x8),
                FadeTransition(
                  opacity: _tagline,
                  child: Text(
                    'splash.tagline'.tr(),
                    style: t.titleSm.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: SplashPage.taglineColor(c, brightness),
                    ),
                  ),
                ),
              ],
            ),
            PositionedDirectional(
              bottom: 64,
              child: _LoadingDots(controller: _dotsController, color: c.primary),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingDots extends StatelessWidget {
  const _LoadingDots({required this.controller, required this.color});

  final AnimationController controller;
  final Color color;

  static const double _dot = 10;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (context, _) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 3; i++) ...[
          if (i > 0) const SizedBox(width: YqSpace.x2 + YqSpace.x3),
          Opacity(
            opacity: _opacityFor(i),
            child: Container(
              width: _dot,
              height: _dot,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ),
        ],
      ],
    ),
  );

  double _opacityFor(int i) {
    final phase = (controller.value * 3 - i) % 3;
    return phase < 1 ? 1 : 0.45;
  }
}
