import 'package:flutter_test/flutter_test.dart';
import 'package:yalla_quiz/features/game/domain/services/scoring_service.dart';
import 'package:yalla_quiz/features/room/domain/entities/game_command.dart';
import 'package:yalla_quiz/features/room/domain/entities/room.dart';

import '../../helpers/fakes.dart';

void main() {
  const scoring = ScoringService();
  const start = 10000;

  int points(int answeredAfterMs, {bool correct = true, int durationMs = 20000}) => scoring.points(
    correct: correct,
    answeredAt: start + answeredAfterMs,
    questionStartedAt: start,
    durationMs: durationMs,
  );

  group('points', () {
    test('500 + 500 * timeLeft / duration', () {
      expect(points(0), 1000);
      expect(points(6000), 850); // the 09 mock: 70 % of the time left
      expect(points(10000), 750);
      expect(points(20000), 500);
    });

    test('timeLeft is floored at 0 for answers in the grace second', () {
      expect(points(20900), 500);
    });

    test('wrong answers score 0', () {
      expect(points(0, correct: false), 0);
    });

    test('never above the lastPoints cap', () {
      expect(points(-500), ScoringService.maxPoints);
    });
  });

  group('scoreQuestion', () {
    Room room({Map<String, PlayerAnswer> answers = const {}}) =>
        sampleRoom(
          hostId: 'host',
          players: [
            player('host', 'Nour', 0).copyWith(spectator: true),
            player('a', 'Omar', 1).copyWith(score: 1000, streak: 2),
            player('b', 'Salma', 2).copyWith(score: 700, streak: 1),
            player('c', 'Karim', 3, connected: false).copyWith(score: 300, streak: 1),
          ],
        ).copyWith(
          status: RoomStatus.question,
          currentQuestionIndex: 3,
          questionStartedAt: start,
          settings: const RoomSettings(category: 'general', timePerQuestion: 20),
          answers: {3: answers},
        );

    test('adds points, extends or resets streaks, skips spectators', () {
      final scores = scoring.scoreQuestion(
        room(
          answers: {
            'a': const PlayerAnswer(option: 1, answeredAt: start + 6000),
            'b': const PlayerAnswer(option: 2, answeredAt: start + 1000),
          },
        ),
        3,
        1,
      );
      expect(scores, {
        'a': const PlayerScore(score: 1850, streak: 3, lastPoints: 850),
        'b': const PlayerScore(score: 700, streak: 0, lastPoints: 0),
        'c': const PlayerScore(score: 300, streak: 0, lastPoints: 0),
      });
    });

    test('is a pure function of the room (same input, same scores)', () {
      final r = room(answers: {'a': const PlayerAnswer(option: 1, answeredAt: start)});
      expect(scoring.scoreQuestion(r, 3, 1), scoring.scoreQuestion(r, 3, 1));
    });
  });
}
