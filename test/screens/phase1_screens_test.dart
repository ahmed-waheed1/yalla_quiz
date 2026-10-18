import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yalla_quiz/core/utils/failure.dart';
import 'package:yalla_quiz/features/home/presentation/pages/home_page.dart';
import 'package:yalla_quiz/features/home/presentation/pages/splash_page.dart';
import 'package:yalla_quiz/features/lobby/presentation/pages/lobby_page.dart';
import 'package:yalla_quiz/features/profile/presentation/pages/profile_setup_page.dart';
import 'package:yalla_quiz/features/room/presentation/pages/create_room_page.dart';
import 'package:yalla_quiz/features/room/presentation/pages/join_room_page.dart';
import 'package:yalla_quiz/features/room/presentation/pages/scan_code_page.dart';
import 'package:yalla_quiz/features/settings/presentation/pages/settings_page.dart';

import '../helpers/fakes.dart';
import '../helpers/pump_app.dart';

/// Renders every Phase 1 screen and state in light and dark, English and
/// Arabic, and fails on any FlutterError (missing ancestors, layout overflow,
/// build exceptions).
void main() {
  setUpAll(initTestEnvironment);

  final hostRoom = sampleRoom(hostId: kMyUid, players: [
    player(kMyUid, 'Nour', 0, joinedAt: 1),
    player('omar', 'Omar', 1, joinedAt: 2),
    player('salma', 'Salma', 2, joinedAt: 3, connected: false),
    player('youssef', 'Youssef', 3, joinedAt: 4),
  ]);
  final hostAloneRoom = sampleRoom(hostId: kMyUid, players: [player(kMyUid, 'Nour', 0)]);
  final playerRoom = sampleRoom(hostId: 'nour', players: [
    player('nour', 'Nour', 0, joinedAt: 1),
    player(kMyUid, 'Omar', 1, joinedAt: 2),
    player('salma', 'Salma', 2, joinedAt: 3),
    player('youssef', 'Youssef', 3, joinedAt: 4),
    player('mariam', 'Mariam', 4, joinedAt: 5),
  ]);
  final fullRoom = sampleRoom(hostId: kMyUid, players: [
    for (var i = 0; i < 8; i++)
      player(i == 0 ? kMyUid : 'p$i', ['Nour', 'Omar', 'Salma', 'Youssef', 'Mariam', 'Karim', 'Laila', 'Hamza'][i], i, joinedAt: i),
  ]);

  Future<void> enterCode(WidgetTester tester, String code) async {
    await tester.enterText(find.byType(TextField), code);
    await settle(tester, const Duration(milliseconds: 800));
  }

  final cases = <_Case>[
    _Case('splash', (_) => const SplashPage(), profile: false, settleFor: const Duration(seconds: 3)),
    _Case('home', (_) => const HomePage(), expectKey: 'home.create'),
    _Case('profile setup (first launch)', (_) => const ProfileSetupPage(next: '/home'),
        profile: false, expectKey: 'profile.name_label'),
    _Case('profile setup (edit)', (_) => const ProfileSetupPage(), expectKey: 'profile.pick_title'),
    _Case('create room', (_) => const CreateRoomPage(), expectKey: 'create.go'),
    _Case('join room (empty)', (_) => const JoinRoomPage(), expectKey: 'join.head'),
    _Case('join room (typing)', (_) => const JoinRoomPage(),
        interact: (t) => enterCode(t, 'k7x'), expectKey: 'join.scan'),
    _Case('join room (complete)', (_) => const JoinRoomPage(), room: hostRoom,
        interact: (t) => enterCode(t, 'K7XP2Q')),
    _Case('join room (error: invalid)', (_) => const JoinRoomPage(),
        joinFailure: const RoomNotFoundFailure(),
        interact: (t) => enterCode(t, 'ZZZZZZ'), expectKey: 'join.invalid_title'),
    _Case('join room (error: full)', (_) => const JoinRoomPage(),
        joinFailure: const RoomFullFailure(8),
        interact: (t) => enterCode(t, 'K7XP2Q'), expectKey: 'join.full_body'),
    _Case('join room (error: started)', (_) => const JoinRoomPage(),
        joinFailure: const GameStartedFailure(),
        interact: (t) => enterCode(t, 'K7XP2Q'), expectKey: 'join.started_title'),
    _Case('join room (error: offline toast)', (_) => const JoinRoomPage(),
        joinFailure: const NetworkFailure(),
        interact: (t) => enterCode(t, 'K7XP2Q'), expectKey: 'common.error_network',
        settleFor: const Duration(seconds: 3)),
    _Case('join room (invite link)', (_) => const JoinRoomPage(initialCode: 'K7XP2Q')),
    _Case('scan code', (_) => const ScanCodePage(), expectKey: 'scan.hint'),
    _Case('settings', (_) => const SettingsPage(), expectKey: 'settings.language_hint'),
    _Case('lobby phone (host, 4 players)', (_) => const LobbyPage(code: 'K7XP2Q'),
        room: hostRoom, expectKey: 'lobby.start'),
    _Case('lobby phone (host alone)', (_) => const LobbyPage(code: 'K7XP2Q'),
        room: hostAloneRoom, expectKey: 'lobby.need_two'),
    _Case('lobby phone (player waiting)', (_) => const LobbyPage(code: 'K7XP2Q'),
        room: playerRoom, expectKey: 'lobby.wait_host'),
    _Case('lobby phone (full room)', (_) => const LobbyPage(code: 'K7XP2Q'), room: fullRoom),
    _Case('lobby tablet (host)', (_) => const LobbyPage(code: 'K7XP2Q'),
        room: hostRoom, size: kTablet, expectKey: 'lobby.room_chip'),
    _Case('lobby tablet (host alone)', (_) => const LobbyPage(code: 'K7XP2Q'),
        room: hostAloneRoom, size: kTablet, expectKey: 'lobby.need_two'),
    _Case('lobby tablet (player waiting)', (_) => const LobbyPage(code: 'K7XP2Q'),
        room: playerRoom, size: kTablet, expectKey: 'lobby.wait_host'),
    _Case('lobby tablet (full room)', (_) => const LobbyPage(code: 'K7XP2Q'),
        room: fullRoom, size: kTablet),
  ];

  for (final brightness in Brightness.values) {
    for (final locale in const [Locale('en'), Locale('ar')]) {
      group('${brightness.name} ${locale.languageCode}', () {
        for (final c in cases) {
          testWidgets(c.name, (tester) async {
            registerFakes(
              profile: c.profile ? kNour : null,
              rooms: FakeRoomRepository(room: c.room, joinFailure: c.joinFailure),
            );
            final recorder = FlutterErrorRecorder()..start();
            addTearDown(recorder.stop);

            await pumpScreen(
              tester,
              c.build(tester),
              locale: locale,
              size: c.size,
              brightness: brightness,
            );
            expect(Theme.of(tester.element(find.byType(Navigator).first)).brightness, brightness);
            if (c.interact != null) await c.interact!(tester);
            final key = c.expectKey;
            if (key != null) expect(find.text(key.tr()), findsWidgets, reason: key);
            await settle(tester, c.settleFor);

            expect(
              recorder.errors.map((e) => e.exceptionAsString()).toList(),
              isEmpty,
              reason: 'FlutterErrors while rendering ${c.name} '
                  '(${brightness.name}, ${locale.languageCode})',
            );
            expect(tester.takeException(), isNull);

            // Unmount and let pending timers (toasts, debounces) run out.
            await tester.pumpWidget(const SizedBox.shrink());
            await settle(tester, const Duration(seconds: 3));
          });
        }
      });
    }
  }
}

class _Case {
  _Case(
    this.name,
    this.build, {
    this.profile = true,
    this.room,
    this.joinFailure,
    this.interact,
    this.expectKey,
    this.size = kPhone,
    this.settleFor = const Duration(seconds: 1),
  });

  final String name;
  final Widget Function(WidgetTester tester) build;
  final bool profile;
  final dynamic room;
  final Failure? joinFailure;
  final Future<void> Function(WidgetTester tester)? interact;
  final String? expectKey;
  final Size size;
  final Duration settleFor;
}
