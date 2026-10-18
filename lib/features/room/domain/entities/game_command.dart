/// A host-only write that moves the game to its next phase. Each one is a
/// single multi-path update; `database.rules.json` checks the transition.
sealed class GameCommand {
  const GameCommand();
}

/// lobby → countdown with the questions for this game.
final class StartGame extends GameCommand {
  const StartGame(this.questionIds);

  final List<String> questionIds;
}

/// countdown → question 0, or leaderboard → the next question.
final class StartQuestion extends GameCommand {
  const StartQuestion(this.index);

  final int index;
}

/// question → reveal, writing every contestant's score in the same update.
final class RevealQuestion extends GameCommand {
  const RevealQuestion(this.index, this.scores);

  final int index;

  /// Contestant uid → new totals.
  final Map<String, PlayerScore> scores;
}

/// reveal → leaderboard (every question but the last).
final class ShowLeaderboard extends GameCommand {
  const ShowLeaderboard(this.index);

  final int index;
}

/// reveal → finished (after the last question).
final class FinishGame extends GameCommand {
  const FinishGame(this.index);

  final int index;
}

/// finished → lobby: scores back to 0 for [keep], [prune] (disconnected
/// players) removed so the new lobby has no leftover tiles.
final class PlayAgain extends GameCommand {
  const PlayAgain({required this.keep, required this.prune});

  final List<String> keep;
  final List<String> prune;
}

/// A player's totals after a question is scored.
final class PlayerScore {
  const PlayerScore({required this.score, required this.streak, required this.lastPoints});

  final int score;
  final int streak;
  final int lastPoints;

  @override
  bool operator ==(Object other) =>
      other is PlayerScore &&
      other.score == score &&
      other.streak == streak &&
      other.lastPoints == lastPoints;

  @override
  int get hashCode => Object.hash(score, streak, lastPoints);

  @override
  String toString() => 'PlayerScore($score, streak $streak, +$lastPoints)';
}
