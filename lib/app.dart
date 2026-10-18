import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/yq_theme.dart';
import 'features/profile/presentation/cubit/profile_cubit.dart';
import 'features/settings/domain/entities/app_settings.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';

class YallaQuizApp extends StatefulWidget {
  const YallaQuizApp({super.key});

  @override
  State<YallaQuizApp> createState() => _YallaQuizAppState();
}

class _YallaQuizAppState extends State<YallaQuizApp> {
  late final GoRouter _router = buildRouter();

  static const Size _designSize = Size(375, 812);

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<ProfileCubit>()),
        BlocProvider.value(value: getIt<SettingsCubit>()),
      ],
      child: ScreenUtilInit(
        designSize: _designSize,
        builder: (context, _) => BlocBuilder<SettingsCubit, AppSettings>(
          buildWhen: (a, b) => a.themeMode != b.themeMode,
          builder: (context, settings) => MaterialApp.router(
            onGenerateTitle: (_) => 'app.title'.tr(),
            debugShowCheckedModeBanner: false,
            routerConfig: _router,
            locale: locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            theme: YqTheme.build(Brightness.light, locale),
            darkTheme: YqTheme.build(Brightness.dark, locale),
            themeMode: switch (settings.themeMode) {
              AppThemeMode.light => ThemeMode.light,
              AppThemeMode.dark => ThemeMode.dark,
              AppThemeMode.system => ThemeMode.system,
            },
          ),
        ),
      ),
    );
  }
}
