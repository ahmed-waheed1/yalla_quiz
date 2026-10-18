import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yalla_quiz/features/lobby/presentation/pages/lobby_page.dart';
import 'package:yalla_quiz/features/room/domain/entities/room.dart';

import '../../helpers/fakes.dart';
import '../../helpers/pump_app.dart';

/// The screen stays on from the countdown to the final results, and the
/// wake lock is released in the lobby and when the room page goes away.
void main() {
  setUpAll(initTestEnvironment);

  Room room(RoomStatus status) =>
      sampleRoom(
        hostId: 'nour',
        players: [player('nour', 'Nour', 0, joinedAt: 1), player(kMyUid, 'Omar', 1, joinedAt: 2)],
      ).copyWith(
        status: status,
        questionIds: [for (var i = 0; i < 10; i++) 'general_$i'],
        phaseStartedAt: 0,
        questionStartedAt: 0,
      );

  Future<FakeScreenAwake> pumpRoom(WidgetTester tester, Room r) async {
    final awake = FakeScreenAwake();
    registerFakes(
      rooms: FakeRoomRepository(room: r),
      screenAwake: awake,
    );
    await pumpScreen(tester, const LobbyPage(code: 'K7XP2Q'), locale: const Locale('en'));
    return awake;
  }

  for (final status in [
    RoomStatus.countdown,
    RoomStatus.question,
    RoomStatus.reveal,
    RoomStatus.leaderboard,
    RoomStatus.finished,
  ]) {
    testWidgets('on during ${status.name}, released on leaving', (tester) async {
      final awake = await pumpRoom(tester, room(status));
      expect(awake.on, isTrue);
      await tester.pumpWidget(const SizedBox.shrink());
      await settle(tester, const Duration(seconds: 3));
      expect(awake.calls.last, isFalse);
    });
  }

  testWidgets('released when a player waits in the lobby after Play again', (tester) async {
    final awake = await pumpRoom(tester, room(RoomStatus.finished));
    expect(awake.on, isTrue);
    await tester.tap(find.text('game.play_again'.tr()));
    await settle(tester, const Duration(milliseconds: 600));
    expect(find.text('lobby.wait_host'.tr()), findsOneWidget);
    expect(awake.on, isFalse);
    await tester.pumpWidget(const SizedBox.shrink());
    await settle(tester, const Duration(seconds: 3));
  });

  testWidgets('off in the lobby', (tester) async {
    final awake = await pumpRoom(tester, room(RoomStatus.lobby));
    expect(awake.calls, isEmpty);
    await tester.pumpWidget(const SizedBox.shrink());
    await settle(tester, const Duration(seconds: 3));
  });
}
