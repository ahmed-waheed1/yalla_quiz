import 'package:flutter/widgets.dart';
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
import '../utils/room_code.dart';
import 'routes.dart';
import 'yq_transitions.dart';

GoRouter buildRouter() => GoRouter(
  initialLocation: Routes.splash,
  redirect: (context, state) {
    // Anything that needs a player (rooms, an invite link opened cold)
    // goes through profile setup first.
    final needsProfile =
        state.matchedLocation == Routes.createRoom ||
        state.matchedLocation == Routes.joinRoom ||
        state.matchedLocation.startsWith('/lobby/');
    if (needsProfile && getIt<ProfileCubit>().state == null) {
      return Routes.profileThen(state.uri.toString());
    }
    return null;
  },
  // Unknown paths (stale links, typos) go home rather than to an error page.
  onException: (_, _, router) => router.go(Routes.home),
  routes: [
    _route(Routes.splash, YqTransition.fade, (_) => const SplashPage()),
    _route(Routes.home, YqTransition.fade, (_) => const HomePage()),
    GoRoute(
      path: Routes.profile,
      pageBuilder: (_, state) {
        final next = state.uri.queryParameters['next'];
        // First launch replaces the stack (fade); editing is pushed (slide).
        return YqTransitions.page(
          state,
          ProfileSetupPage(next: next),
          next == null ? YqTransition.slide : YqTransition.fade,
        );
      },
    ),
    _route(Routes.settings, YqTransition.slide, (_) => const SettingsPage()),
    _route(Routes.createRoom, YqTransition.slide, (_) => const CreateRoomPage()),
    _route(Routes.joinRoom, YqTransition.slide, (state) {
      final code = state.uri.queryParameters['code'];
      return JoinRoomPage(initialCode: code == null ? null : RoomCode.sanitize(code));
    }),
    _route(Routes.scan, YqTransition.slide, (_) => const ScanCodePage()),
    _route(
      Routes.lobby,
      YqTransition.fade,
      (state) => LobbyPage(code: RoomCode.sanitize(state.pathParameters['code'] ?? '')),
    ),
  ],
);

GoRoute _route(String path, YqTransition transition, Widget Function(GoRouterState) build) =>
    GoRoute(
      path: path,
      pageBuilder: (_, state) => YqTransitions.page(state, build(state), transition),
    );
