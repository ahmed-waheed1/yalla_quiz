import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/splash_page.dart';
import '../../features/lobby/presentation/pages/lobby_page.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/profile/presentation/pages/profile_setup_page.dart';
import '../../features/room/presentation/pages/create_room_page.dart';
import '../../features/room/presentation/pages/join_room_page.dart';
import '../../features/room/presentation/pages/scan_code_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../di/injection.dart';
import '../theme/yq_spacing.dart';
import '../utils/room_code.dart';
import 'routes.dart';

GoRouter buildRouter() => GoRouter(
      initialLocation: Routes.splash,
      redirect: (context, state) {
        // Anything that needs a player (rooms, an invite link opened cold)
        // goes through profile setup first.
        final needsProfile = state.matchedLocation == Routes.createRoom ||
            state.matchedLocation == Routes.joinRoom ||
            state.matchedLocation.startsWith('/lobby/');
        if (needsProfile && getIt<ProfileCubit>().state == null) {
          return Routes.profileThen(state.uri.toString());
        }
        return null;
      },
      routes: [
        GoRoute(path: Routes.splash, builder: (_, _) => const SplashPage()),
        GoRoute(path: Routes.home, pageBuilder: (_, state) => _fade(state, const HomePage())),
        GoRoute(
          path: Routes.profile,
          builder: (_, state) => ProfileSetupPage(next: state.uri.queryParameters['next']),
        ),
        GoRoute(path: Routes.settings, builder: (_, _) => const SettingsPage()),
        GoRoute(path: Routes.createRoom, builder: (_, _) => const CreateRoomPage()),
        GoRoute(
          path: Routes.joinRoom,
          builder: (_, state) {
            final code = state.uri.queryParameters['code'];
            return JoinRoomPage(initialCode: code == null ? null : RoomCode.sanitize(code));
          },
        ),
        GoRoute(path: Routes.scan, builder: (_, _) => const ScanCodePage()),
        GoRoute(
          path: Routes.lobby,
          pageBuilder: (_, state) => _fade(
            state,
            LobbyPage(code: RoomCode.sanitize(state.pathParameters['code'] ?? '')),
          ),
        ),
      ],
    );

CustomTransitionPage<void> _fade(GoRouterState state, Widget child) => CustomTransitionPage(
      key: state.pageKey,
      transitionDuration: YqMotion.base,
      child: child,
      transitionsBuilder: (_, animation, _, child) =>
          FadeTransition(opacity: CurvedAnimation(parent: animation, curve: YqMotion.out), child: child),
    );
