import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:yalla_quiz/features/game/presentation/cubit/game_cubit.dart';
import 'package:yalla_quiz/features/room/domain/entities/game_command.dart';
import 'package:yalla_quiz/features/room/domain/entities/room.dart';

import '../../helpers/fake_clock.dart';
import '../../helpers/fake_game_server.dart';
import '../../helpers/fakes.dart';

/// Full games through the real cubits, engine and driver, on a fake server
/// clock. FakeQuestionRepository's correct option is always 0.
class _Game {
  _Game({List<RoomPlayer>? players, int timePerQuestion = 10}) {
    server = FakeGameServer(
      clock,
      sampleRoom(
        hostId: 'host',
        players:
            players ??
            [
              player('host', 'Nour', 0, joinedAt: 1),
              player('a', 'Omar', 1, joinedAt: 2),
              player('b', 'Salma', 2, joinedAt: 3),
            ],
      ).copyWith(
        settings: RoomSettings(
          category: 'general',
          questionCount: 5,
          timePerQuestion: timePerQuestion,
        ),
      ),
    );
    server.listen((room) {
      if (room.status != _statuses.lastOrNull?.$1 ||
          room.currentQuestionIndex != _statuses.lastOrNull?.$3) {
        _statuses.add((room.status, clock.nowMs(), room.currentQuestionIndex));
      }
    });
    for (final p in server.room.players) {
      join(p.uid);
    }
  }

  final clock = FakeClock();
  late final FakeGameServer server;
  final Map<String, GameCubit> cubits = {};
  final List<(RoomStatus, int, int)> _statuses = [];

  /// Status changes as (status, server time, question index).
  List<(RoomStatus, int, int)> get timeline => List.unmodifiable(_statuses);

  GameCubit join(String uid) {
    final cubit = GameCubit(
      code: 'K7XP2Q',
      rooms: server.client(uid),
      questions: FakeQuestionRepository(),
      clock: clock,
      scheduler: clock,
      random: Random(uid.hashCode),
    );
    cubits[uid] = cubit;
    server.listen((room) => cubit.onRoom(room, uid));
    return cubit;
  }

  /// The device goes away (app killed / offline) and RTDB marks it disconnected.
  Future<void> drop(String uid) async {
    await cubits.remove(uid)!.close();
    server.edit(
      (r) => r.copyWith(
        players: [for (final p in r.players) p.uid == uid ? p.copyWith(connected: false) : p],
      ),
    );
  }

  void claimHost(String uid) => server.edit((r) => r.copyWith(hostId: uid));

  Room get room => server.room;
  int get now => clock.nowMs();

  Future<void> start() async {
    await FakeClock.flush();
    await cubits['host']!.startGame();
    await FakeClock.flush();
  }

  Future<void> close() async {
    for (final c in cubits.values) {
      await c.close();
    }
  }
}

void main() {
  test('a full 5-question game with early advance, scoring and the right timings', () async {
    final game = _Game();
    await game.start();
    final t0 = game.now;
    expect(game.room.status, RoomStatus.countdown);
    expect(game.room.questionIds.toSet(), hasLength(5));

    await game.clock.advanceMs(4000);
    for (var q = 0; q < 5; q++) {
      expect(game.room.status, RoomStatus.question, reason: 'q$q');
      expect(game.room.currentQuestionIndex, q);
      // Everyone answers 2 s in: host right, a wrong, b right but slower.
      await game.clock.advanceMs(2000);
      expect(game.cubits['host']!.answer(0), isTrue);
      expect(game.cubits['a']!.answer(1), isTrue);
      await game.clock.advanceMs(1000);
      expect(game.cubits['b']!.answer(0), isTrue);
      await game.clock.advanceMs(0);
      expect(game.room.status, RoomStatus.reveal, reason: 'early advance on q$q');
      await game.clock.advanceMs(3600);
      if (q < 4) {
        expect(game.room.status, RoomStatus.leaderboard);
        await game.clock.advanceMs(5000);
      }
    }
    expect(game.room.status, RoomStatus.finished);

    // Timeline: countdown 4 s, question until the last answer (3 s),
    // reveal 3.6 s, leaderboard 5 s; the last reveal goes to finished.
    final expected = <(RoomStatus, int, int)>[(RoomStatus.countdown, t0, 0)];
    var t = t0 + 4000;
    for (var q = 0; q < 5; q++) {
      expected
        ..add((RoomStatus.question, t, q))
        ..add((RoomStatus.reveal, t + 3000, q));
      t += 3000 + 3600;
      if (q < 4) {
        expected.add((RoomStatus.leaderboard, t, q));
        t += 5000;
      }
    }
    expected.add((RoomStatus.finished, t, 4));
    expect(game.timeline.skip(1), expected); // skip the initial lobby

    // Answering 2 s into 10 leaves 8 s → 900; 3 s → 850.
    expect(game.room.player('host')!.score, 5 * 900);
    expect(game.room.player('host')!.streak, 5);
    expect(game.room.player('a')!.score, 0);
    expect(game.room.player('a')!.streak, 0);
    expect(game.room.player('b')!.score, 5 * 850);
    expect(game.server.rejected, isEmpty);
    expect(game.server.applied.whereType<RevealQuestion>().map((c) => c.index), [0, 1, 2, 3, 4]);
    await game.close();
  });

  test('a question nobody answers ends at time + 1 s grace', () async {
    final game = _Game();
    await game.start();
    await game.clock.advanceMs(4000);
    final started = game.room.questionStartedAt!;
    await game.clock.advanceMs(10999);
    expect(game.room.status, RoomStatus.question);
    await game.clock.advanceMs(1);
    expect(game.room.status, RoomStatus.reveal);
    expect(game.room.phaseStartedAt, started + 11000);
    expect(game.room.players.every((p) => p.lastPoints == 0 && p.streak == 0), isTrue);
    await game.close();
  });

  test(
    'the client stops answers when its timer hits 0; the server takes the grace second',
    () async {
      final game = _Game();
      await game.start();
      await game.clock.advanceMs(4000 + 10001);
      expect(game.cubits['a']!.answer(0), isFalse);
      expect(game.room.answersFor(0), isEmpty);
      await game.close();
    },
  );

  test('scoring the same question twice is rejected and scores do not double', () async {
    final game = _Game();
    await game.start();
    await game.clock.advanceMs(4000 + 1000);
    for (final uid in ['host', 'a', 'b']) {
      game.cubits[uid]!.answer(0);
    }
    await game.clock.advanceMs(0);
    expect(game.room.status, RoomStatus.reveal);
    final scored = {for (final p in game.room.players) p.uid: p.score};
    final reveal = game.server.applied.whereType<RevealQuestion>().single;

    // A replay of the same write (a timer firing twice, a stale host).
    final again = await game.server.client('host').runGameCommand(code: 'K7XP2Q', command: reveal);
    expect(again.isLeft(), isTrue);
    expect({for (final p in game.room.players) p.uid: p.score}, scored);
    await game.close();
  });

  test('two host devices (e.g. an app restart) drive each phase exactly once', () async {
    final game = _Game();
    game.join('host'); // a second cubit for the same uid
    await game.start();
    await game.clock.advanceMs(60000);
    await game.clock.advanceMs(60000);
    expect(game.room.status, RoomStatus.finished);
    expect(game.server.applied.whereType<StartQuestion>().map((c) => c.index), [0, 1, 2, 3, 4]);
    expect(game.server.applied.whereType<RevealQuestion>().map((c) => c.index), [0, 1, 2, 3, 4]);
    await game.close();
  });

  test('host drops mid-question: the successor resumes, scoring it once', () async {
    final game = _Game();
    await game.start();
    await game.clock.advanceMs(4000); // question 0
    await game.clock.advanceMs(1000);
    game.cubits['host']!.answer(0); // host answers, then disappears
    game.cubits['a']!.answer(0);
    await FakeClock.flush();
    await game.drop('host');
    expect(game.room.status, RoomStatus.question);

    // Nobody drives while the host is gone; "a" claims after the 10 s grace.
    await game.clock.advanceMs(10000);
    expect(game.room.status, RoomStatus.question);
    game.claimHost('a');
    await game.clock.advanceMs(0);

    expect(game.room.status, RoomStatus.reveal);
    expect(game.room.player('host')!.score, 950); // answered at 1 s before dropping
    expect(game.room.player('a')!.score, 950);
    expect(game.room.player('b')!.score, 0);

    await game.clock.advanceMs(120000);
    expect(game.room.status, RoomStatus.finished);
    expect(game.server.applied.whereType<RevealQuestion>().map((c) => c.index), [0, 1, 2, 3, 4]);
    expect(game.room.player('host')!.score, 950);
    await game.close();
  });

  test('host drops during reveal: the successor moves on without rescoring', () async {
    final game = _Game();
    await game.start();
    await game.clock.advanceMs(4000 + 1000);
    for (final uid in ['host', 'a', 'b']) {
      game.cubits[uid]!.answer(0);
    }
    await game.clock.advanceMs(0);
    expect(game.room.status, RoomStatus.reveal);
    await game.drop('host');
    await game.clock.advanceMs(10000);
    game.claimHost('a');
    await game.clock.advanceMs(0);

    expect(game.room.status, RoomStatus.leaderboard);
    expect(game.server.applied.whereType<RevealQuestion>(), hasLength(1));
    expect(game.room.player('a')!.score, 950);
    await game.close();
  });

  test('a host that comes back after the takeover stops driving', () async {
    final game = _Game();
    await game.start();
    await game.clock.advanceMs(4000);
    game.claimHost('a'); // as if the host had been away long enough
    await game.clock.advanceMs(120000);
    expect(game.room.status, RoomStatus.finished);
    expect(game.server.rejected, isEmpty);
    await game.close();
  });

  test('a reconnecting player rejoins the current phase with their score', () async {
    final game = _Game();
    await game.start();
    await game.clock.advanceMs(4000 + 1000);
    for (final uid in ['host', 'a', 'b']) {
      game.cubits[uid]!.answer(0);
    }
    await game.clock.advanceMs(3600 + 5000); // question 1 running
    await game.drop('b');
    await game.clock.advanceMs(2000);
    game.server.edit(
      (r) => r.copyWith(
        players: [for (final p in r.players) p.uid == 'b' ? p.copyWith(connected: true) : p],
      ),
    );
    final b = game.join('b');
    await FakeClock.flush();
    expect(b.state.room!.status, RoomStatus.question);
    expect(b.state.room!.currentQuestionIndex, 1);
    expect(b.state.me!.score, 950);
    expect(b.answer(0), isTrue);
    await game.close();
  });

  test('a spectator host is not waited for, cannot answer and is not scored', () async {
    final game = _Game(
      players: [
        player('host', 'Nour', 0, joinedAt: 1).copyWith(spectator: true),
        player('a', 'Omar', 1, joinedAt: 2),
        player('b', 'Salma', 2, joinedAt: 3),
      ],
    );
    await game.start();
    await game.clock.advanceMs(4000 + 1000);
    expect(game.cubits['host']!.answer(0), isFalse);
    game.cubits['a']!.answer(0);
    game.cubits['b']!.answer(2);
    await game.clock.advanceMs(0);
    expect(game.room.status, RoomStatus.reveal);
    final reveal = game.server.applied.whereType<RevealQuestion>().single;
    expect(reveal.scores.keys, unorderedEquals(['a', 'b']));
    expect(game.room.player('host')!.score, 0);
    await game.close();
  });

  test('play again: scores reset, dropped players pruned, no repeated questions', () async {
    final game = _Game();
    await game.start();
    final firstIds = game.room.questionIds.toSet();
    await game.drop('b');
    await game.clock.advanceMs(200000);
    expect(game.room.status, RoomStatus.finished);

    await game.cubits['a']!.playAgain();
    expect(game.cubits['a']!.state.rematch, isTrue);
    expect(game.room.status, RoomStatus.finished);

    await game.cubits['host']!.playAgain();
    await FakeClock.flush();
    expect(game.room.status, RoomStatus.lobby);
    expect(game.room.players.map((p) => p.uid), ['host', 'a']);
    expect(game.room.players.every((p) => p.score == 0 && p.streak == 0), isTrue);
    expect(game.room.usedQuestionIds, firstIds);
    expect(game.cubits['a']!.state.rematch, isFalse);

    await game.cubits['host']!.startGame();
    await FakeClock.flush();
    expect(game.room.status, RoomStatus.countdown);
    expect(game.room.questionIds.toSet().intersection(firstIds), isEmpty);
    await game.close();
  });

  test('only a host with 2+ contestants can start', () async {
    final game = _Game(
      players: [
        player('host', 'Nour', 0, joinedAt: 1).copyWith(spectator: true),
        player('a', 'Omar', 1, joinedAt: 2),
      ],
    );
    await game.cubits['a']!.startGame();
    await game.start();
    expect(game.room.status, RoomStatus.lobby);
    await game.close();
  });
}
