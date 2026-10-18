import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yalla_quiz/core/di/injection.dart';
import 'package:yalla_quiz/core/services/auth_service.dart';
import 'package:yalla_quiz/core/services/haptics.dart';
import 'package:yalla_quiz/core/theme/yq_theme.dart';
import 'package:yalla_quiz/core/theme/yq_typography.dart';
import 'package:yalla_quiz/features/game/domain/repositories/question_repository.dart';
import 'package:yalla_quiz/features/profile/domain/entities/player_profile.dart';
import 'package:yalla_quiz/features/profile/domain/repositories/profile_repository.dart';
import 'package:yalla_quiz/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:yalla_quiz/features/room/domain/repositories/room_repository.dart';
import 'package:yalla_quiz/features/settings/domain/repositories/settings_repository.dart';
import 'package:yalla_quiz/features/settings/presentation/cubit/settings_cubit.dart';

import 'fakes.dart';

const Size kPhone = Size(375, 812);
const Size kTablet = Size(834, 1194);

const PlayerProfile kNour = PlayerProfile(name: 'Nour', avatarSeed: 0);

Future<void> initTestEnvironment() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();
  await _loadCairo();
}

/// Tests render with a placeholder font unless real fonts are loaded; load
/// Cairo so text widths (and overflow checks) match the device.
Future<void> _loadCairo() async {
  final loader = FontLoader(kYqFontFamily);
  for (final weight in const ['Medium', 'SemiBold', 'Bold', 'ExtraBold', 'Black']) {
    final bytes = File('assets/fonts/Cairo-$weight.ttf').readAsBytesSync();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await loader.load();
}

/// Registers fakes in get_it (replacing whatever is there).
void registerFakes({
  PlayerProfile? profile = kNour,
  FakeRoomRepository? rooms,
  FakeQuestionRepository? questions,
}) {
  getIt.reset(dispose: false);
  getIt
    ..registerSingleton<Haptics>(Haptics())
    ..registerSingleton<AuthService>(FakeAuthService())
    ..registerSingleton<ProfileRepository>(FakeProfileRepository(profile))
    ..registerSingleton<SettingsRepository>(FakeSettingsRepository())
    ..registerSingleton<QuestionRepository>(questions ?? FakeQuestionRepository())
    ..registerSingleton<RoomRepository>(rooms ?? FakeRoomRepository())
    ..registerSingleton<ProfileCubit>(ProfileCubit(getIt())..load())
    ..registerSingleton<SettingsCubit>(SettingsCubit(getIt(), getIt()));
}

/// Collects every FlutterError (layout overflow, missing ancestors, …) so a
/// test can assert there were none, on top of flutter_test's own reporting.
class FlutterErrorRecorder {
  final List<FlutterErrorDetails> errors = [];
  void Function(FlutterErrorDetails)? _previous;

  void start() {
    _previous = FlutterError.onError;
    FlutterError.onError = (details) {
      errors.add(details);
      _previous?.call(details);
    };
  }

  void stop() => FlutterError.onError = _previous;
}

/// Pumps [page] inside the real app shell: easy_localization, YqTheme,
/// ScreenUtil and a GoRouter, at [size] in [locale].
Future<void> pumpScreen(
  WidgetTester tester,
  Widget page, {
  required Locale locale,
  Size size = kPhone,
  Brightness brightness = Brightness.light,
}) async {
  // Pages navigate (splash → home, lobby → home …); land on a blank page.
  final router = GoRouter(
    initialLocation: '/test',
    errorBuilder: (_, _) => const SizedBox.shrink(),
    routes: [
      GoRoute(path: '/', builder: (_, _) => const SizedBox.shrink()),
      GoRoute(path: '/test', builder: (_, _) => page),
    ],
  );
  addTearDown(router.dispose);
  await pumpRouterApp(tester, router, locale: locale, size: size, brightness: brightness);
}

/// Pumps the app shell around [router] (the real one or a test one).
Future<void> pumpRouterApp(
  WidgetTester tester,
  GoRouter router, {
  required Locale locale,
  Size size = kPhone,
  bool disableAnimations = false,
  Brightness brightness = Brightness.light,
}) async {
  tester.view.physicalSize = size * 2;
  tester.view.devicePixelRatio = 2;
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      FakeAccessibilityFeatures(disableAnimations: disableAnimations);
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);

  await tester.runAsync(() async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        startLocale: locale,
        saveLocale: false,
        useOnlyLangCode: true,
        ignorePluralRules: false,
        child: Builder(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<ProfileCubit>()),
              BlocProvider.value(value: getIt<SettingsCubit>()),
            ],
            child: ScreenUtilInit(
              designSize: kPhone,
              builder: (context, _) => MaterialApp.router(
                routerConfig: router,
                locale: context.locale,
                supportedLocales: context.supportedLocales,
                localizationsDelegates: context.localizationDelegates,
                theme: YqTheme.build(Brightness.light, context.locale),
                darkTheme: YqTheme.build(Brightness.dark, context.locale),
                themeMode: brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
              ),
            ),
          ),
        ),
      ),
    );
    // Translations load from the asset bundle asynchronously.
    await Future<void>.delayed(const Duration(milliseconds: 300));
  });
  await settle(tester);
}

/// Pumps frames for a while. Screens have endless animations (live dot,
/// ghost pulse, spinners), so pumpAndSettle would never return.
Future<void> settle(WidgetTester tester, [Duration total = const Duration(seconds: 2)]) async {
  const step = Duration(milliseconds: 50);
  for (var t = Duration.zero; t < total; t += step) {
    await tester.pump(step);
  }
}
