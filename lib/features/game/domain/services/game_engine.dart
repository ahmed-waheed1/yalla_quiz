import '../../../../core/constants/app_constants.dart';
import '../../../room/domain/entities/game_command.dart';
import '../../../room/domain/entities/room.dart';
import 'scoring_service.dart';

/// The correct option for a question id, or null if it isn't loaded yet.
typedef AnswerKey = int? Function(String questionId);

/// What the host does next: run [command] once the server clock reaches [dueAt].
final class GameStep {
  const GameStep(this.dueAt, this.command);

  final int dueAt;
  final GameCommand command;
}

/// The phase state machine. Pure: given the room as it is in RTDB, it says
/// what the host writes next and when. Every decision comes from server
/// timestamps in the room, so a new host resumes exactly where the old one
/// stopped, and evaluating twice gives the same answer.
///
/// lobby → countdown → question → reveal → leaderboard → question … and
/// reveal → finished after the last question. The host starts the game and
/// "Play again" by hand; the engine drives everything in between.
class GameEngine {
  const GameEngine({this.scoring = const ScoringService()});

  final ScoringService scoring;

  GameStep? next(Room room, AnswerKey answerKey) {
    final index = room.currentQuestionIndex;
    final phaseStart = room.phaseStartedAt ?? 0;
    switch (room.status) {
      case RoomStatus.lobby || RoomStatus.finished:
        return null;
      case RoomStatus.countdown:
        return GameStep(phaseStart + GameTiming.countdown.inMilliseconds, const StartQuestion(0));
      case RoomStatus.question:
        // Already scored means the reveal write is in flight; nothing to do.
        if (room.scoredQuestionIndex == index || index >= room.questionIds.length) return null;
        final correct = answerKey(room.questionIds[index]);
        if (correct == null) return null;
        return GameStep(
          questionDueAt(room),
          RevealQuestion(index, scoring.scoreQuestion(room, index, correct)),
        );
      case RoomStatus.reveal:
        final last = index + 1 >= room.settings.questionCount;
        return GameStep(
          phaseStart + GameTiming.reveal.inMilliseconds,
          last ? FinishGame(index) : ShowLeaderboard(index),
        );
      case RoomStatus.leaderboard:
        return GameStep(
          phaseStart + GameTiming.leaderboard.inMilliseconds,
          StartQuestion(index + 1),
        );
    }
  }

  /// When the current question ends: as soon as every connected contestant
  /// has answered, otherwise when the time (plus the answer grace) runs out.
  static int questionDueAt(Room room) {
    final startedAt = room.questionStartedAt ?? 0;
    if (everyoneAnswered(room)) return startedAt;
    return questionEndsAt(room) + GameTiming.answerGrace.inMilliseconds;
  }

  /// When the timer shown to players reaches 0.
  static int questionEndsAt(Room room) =>
      (room.questionStartedAt ?? 0) + room.settings.timePerQuestion * 1000;

  static bool everyoneAnswered(Room room) {
    final connected = [
      for (final p in room.contestants)
        if (p.connected) p.uid,
    ];
    final answers = room.answersFor(room.currentQuestionIndex);
    return connected.isNotEmpty && connected.every(answers.containsKey);
  }
}
