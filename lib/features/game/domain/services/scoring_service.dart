import '../../../room/domain/entities/game_command.dart';
import '../../../room/domain/entities/room.dart';

/// All scoring. Pure Dart with no Flutter or Firebase, so it can move to a
/// Cloud Function later.
///
/// `points = correct ? 500 + 500 * timeLeft / duration : 0`, with `timeLeft`
/// floored at 0. The streak counts consecutive correct answers; it is shown as
/// a badge and adds no points.
class ScoringService {
  const ScoringService();

  static const int basePoints = 500;
  static const int speedPoints = 500;
  static const int maxPoints = basePoints + speedPoints;

  int points({
    required bool correct,
    required int answeredAt,
    required int questionStartedAt,
    required int durationMs,
  }) {
    if (!correct) return 0;
    final timeLeft = (durationMs - (answeredAt - questionStartedAt)).clamp(0, durationMs);
    return basePoints + (speedPoints * timeLeft / durationMs).round();
  }

  /// New totals for every contestant in [room] after question [index], whose
  /// correct option is [correctOption]. Players who didn't answer get 0 and
  /// lose their streak. Spectators aren't scored.
  Map<String, PlayerScore> scoreQuestion(Room room, int index, int correctOption) {
    final answers = room.answersFor(index);
    return {
      for (final p in room.contestants) p.uid: _score(room, p, answers[p.uid], correctOption),
    };
  }

  PlayerScore _score(Room room, RoomPlayer player, PlayerAnswer? answer, int correctOption) {
    final correct = answer != null && answer.option == correctOption;
    final earned = answer == null
        ? 0
        : points(
            correct: correct,
            answeredAt: answer.answeredAt,
            questionStartedAt: room.questionStartedAt ?? 0,
            durationMs: room.settings.timePerQuestion * 1000,
          );
    return PlayerScore(
      score: player.score + earned,
      streak: correct ? player.streak + 1 : 0,
      lastPoints: earned,
    );
  }
}
