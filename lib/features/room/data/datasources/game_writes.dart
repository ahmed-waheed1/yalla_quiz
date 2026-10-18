import 'package:firebase_database/firebase_database.dart';

import '../../domain/entities/game_command.dart';

/// The multi-path update (relative to `rooms/{code}`) for each phase change.
/// Each one is applied atomically; `database.rules.json` checks it.
Map<String, Object?> gameCommandUpdate(GameCommand command) => switch (command) {
  StartGame(:final questionIds) => {
    'status': 'countdown',
    'phaseStartedAt': ServerValue.timestamp,
    'questionIds': questionIds,
    for (final id in questionIds) 'usedQuestionIds/$id': true,
    'currentQuestionIndex': 0,
    'scoredQuestionIndex': null,
    'answers': null,
  },
  StartQuestion(:final index) => {
    'status': 'question',
    'currentQuestionIndex': index,
    'questionStartedAt': ServerValue.timestamp,
    'phaseStartedAt': ServerValue.timestamp,
  },
  RevealQuestion(:final index, :final scores) => {
    'status': 'reveal',
    'phaseStartedAt': ServerValue.timestamp,
    'scoredQuestionIndex': index,
    for (final e in scores.entries) ...{
      'players/${e.key}/score': e.value.score,
      'players/${e.key}/streak': e.value.streak,
      'players/${e.key}/lastPoints': e.value.lastPoints,
    },
  },
  ShowLeaderboard() => {'status': 'leaderboard', 'phaseStartedAt': ServerValue.timestamp},
  FinishGame() => {'status': 'finished', 'phaseStartedAt': ServerValue.timestamp},
  PlayAgain(:final keep, :final prune) => {
    'status': 'lobby',
    'currentQuestionIndex': 0,
    'questionIds': null,
    'scoredQuestionIndex': null,
    'answers': null,
    'questionStartedAt': null,
    'phaseStartedAt': null,
    for (final uid in keep) ...{
      'players/$uid/score': 0,
      'players/$uid/streak': 0,
      'players/$uid/lastPoints': 0,
    },
    for (final uid in prune) 'players/$uid': null,
  },
};
