import 'package:flutter_test/flutter_test.dart';
import 'package:yalla_quiz/core/constants/app_constants.dart';
import 'package:yalla_quiz/features/game/domain/services/game_engine.dart';
import 'package:yalla_quiz/features/room/domain/entities/game_command.dart';
import 'package:yalla_quiz/features/room/domain/entities/room.dart';

import '../../helpers/fakes.dart';

void main() {
  const engine = GameEngine();
  const t0 = 50000;
  int? key(String _) => 0;

  Room room(RoomStatus status, {int index = 0, Map<String, PlayerAnswer> answers = const {}}) =>
      sampleRoom(
        hostId: 'host',
        players: [
          player('host', 'Nour', 0),
          player('a', 'Omar', 1),
          player('b', 'Salma', 2, connected: false),
        ],
      ).copyWith(
        status: status,
        settings: const RoomSettings(category: 'general', questionCount: 5, timePerQuestion: 10),
        questionIds: [for (var i = 0; i < 5; i++) 'general_$i'],
        currentQuestionIndex: index,
        phaseStartedAt: t0,
        questionStartedAt: t0,
        scoredQuestionIndex: status == RoomStatus.question ? index - 1 : index,
        answers: {index: answers},
      );

  test('lobby and finished wait for the host', () {
    expect(engine.next(room(RoomStatus.lobby), key), isNull);
    expect(engine.next(room(RoomStatus.finished, index: 4), key), isNull);
  });

  test('countdown → question 0 after 4 s', () {
    final step = engine.next(room(RoomStatus.countdown), key)!;
    expect(step.dueAt, t0 + 4000);
    expect((step.command as StartQuestion).index, 0);
  });

  test('question → reveal when time + grace run out', () {
    final step = engine.next(room(RoomStatus.question, index: 2), key)!;
    expect(step.dueAt, t0 + 10000 + GameTiming.answerGrace.inMilliseconds);
    final reveal = step.command as RevealQuestion;
    expect(reveal.index, 2);
    expect(reveal.scores.keys, unorderedEquals(['host', 'a', 'b']));
  });

  test('early advance once every connected contestant has answered', () {
    final partial = room(
      RoomStatus.question,
      index: 1,
      answers: {'host': const PlayerAnswer(option: 0, answeredAt: t0 + 1000)},
    );
    expect(engine.next(partial, key)!.dueAt, t0 + 11000);

    // "b" is disconnected, so the room doesn't wait for them.
    final everyone = room(
      RoomStatus.question,
      index: 1,
      answers: {
        'host': const PlayerAnswer(option: 0, answeredAt: t0 + 1000),
        'a': const PlayerAnswer(option: 3, answeredAt: t0 + 2000),
      },
    );
    expect(engine.next(everyone, key)!.dueAt, t0);
  });

  test('a spectator host is neither waited for nor scored', () {
    final r =
        room(
          RoomStatus.question,
          answers: {'a': const PlayerAnswer(option: 0, answeredAt: t0 + 1000)},
        ).copyWith(
          players: [player('host', 'Nour', 0).copyWith(spectator: true), player('a', 'Omar', 1)],
        );
    final step = engine.next(r, key)!;
    expect(step.dueAt, t0);
    expect((step.command as RevealQuestion).scores.keys, ['a']);
  });

  test('a scored question is not scored again', () {
    final r = room(RoomStatus.question, index: 2).copyWith(scoredQuestionIndex: 2);
    expect(engine.next(r, key), isNull);
  });

  test('waits for the answer key before scoring', () {
    expect(engine.next(room(RoomStatus.question), (_) => null), isNull);
  });

  test('reveal → leaderboard after 3.6 s, or finished after the last question', () {
    final mid = engine.next(room(RoomStatus.reveal, index: 3), key)!;
    expect(mid.dueAt, t0 + 3600);
    expect(mid.command, isA<ShowLeaderboard>());
    final last = engine.next(room(RoomStatus.reveal, index: 4), key)!;
    expect(last.command, isA<FinishGame>());
  });

  test('leaderboard → next question after 5 s', () {
    final step = engine.next(room(RoomStatus.leaderboard, index: 1), key)!;
    expect(step.dueAt, t0 + 5000);
    expect((step.command as StartQuestion).index, 2);
  });
}
