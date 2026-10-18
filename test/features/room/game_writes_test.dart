import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yalla_quiz/features/room/data/datasources/game_writes.dart';
import 'package:yalla_quiz/features/room/domain/entities/game_command.dart';

void main() {
  const ts = ServerValue.timestamp;

  test('start game writes questions, used ids and clears the last game', () {
    expect(gameCommandUpdate(const StartGame(['general_001', 'general_007'])), {
      'status': 'countdown',
      'phaseStartedAt': ts,
      'questionIds': ['general_001', 'general_007'],
      'usedQuestionIds/general_001': true,
      'usedQuestionIds/general_007': true,
      'currentQuestionIndex': 0,
      'scoredQuestionIndex': null,
      'answers': null,
    });
  });

  test('start question sets both timestamps', () {
    expect(gameCommandUpdate(const StartQuestion(3)), {
      'status': 'question',
      'currentQuestionIndex': 3,
      'questionStartedAt': ts,
      'phaseStartedAt': ts,
    });
  });

  test('reveal writes every score with the guard in one update', () {
    final update = gameCommandUpdate(
      const RevealQuestion(2, {
        'a': PlayerScore(score: 1850, streak: 3, lastPoints: 850),
        'b': PlayerScore(score: 700, streak: 0, lastPoints: 0),
      }),
    );
    expect(update, {
      'status': 'reveal',
      'phaseStartedAt': ts,
      'scoredQuestionIndex': 2,
      'players/a/score': 1850,
      'players/a/streak': 3,
      'players/a/lastPoints': 850,
      'players/b/score': 700,
      'players/b/streak': 0,
      'players/b/lastPoints': 0,
    });
  });

  test('leaderboard and finish', () {
    expect(gameCommandUpdate(const ShowLeaderboard(1)), {
      'status': 'leaderboard',
      'phaseStartedAt': ts,
    });
    expect(gameCommandUpdate(const FinishGame(4)), {'status': 'finished', 'phaseStartedAt': ts});
  });

  test('play again resets kept players and prunes dropped ones', () {
    expect(gameCommandUpdate(const PlayAgain(keep: ['host'], prune: ['gone'])), {
      'status': 'lobby',
      'currentQuestionIndex': 0,
      'questionIds': null,
      'scoredQuestionIndex': null,
      'answers': null,
      'questionStartedAt': null,
      'phaseStartedAt': null,
      'players/host/score': 0,
      'players/host/streak': 0,
      'players/host/lastPoints': 0,
      'players/gone': null,
    });
  });
}
