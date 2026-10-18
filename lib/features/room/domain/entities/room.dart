import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/app_constants.dart';

part 'room.freezed.dart';

enum RoomStatus { lobby, countdown, question, reveal, leaderboard, finished }

@freezed
abstract class RoomSettings with _$RoomSettings {
  const RoomSettings._();

  const factory RoomSettings({
    required String category,
    @Default(RoomRules.defaultQuestionCount) int questionCount,
    @Default(RoomRules.defaultTimePerQuestion) int timePerQuestion,
    @Default(RoomRules.maxPlayers) int maxPlayers,
  }) = _RoomSettings;

  /// Rough game length for the "about N min" summary.
  int get estimatedMinutes {
    final seconds = questionCount * (timePerQuestion + RoomRules.overheadSecondsPerQuestion);
    return (seconds / 60).round().clamp(1, 999);
  }
}

@freezed
abstract class RoomPlayer with _$RoomPlayer {
  const factory RoomPlayer({
    required String uid,
    required String name,
    required int avatarSeed,
    required int joinedAt,
    required bool connected,
    @Default(0) int score,
    @Default(0) int streak,
    @Default(0) int lastPoints,

    /// Hosts the game on a big screen: doesn't answer and isn't ranked.
    @Default(false) bool spectator,
  }) = _RoomPlayer;
}

/// A player's pick for one question. [answeredAt] is a server timestamp.
@freezed
abstract class PlayerAnswer with _$PlayerAnswer {
  const factory PlayerAnswer({
    required int option,
    required int answeredAt,
  }) = _PlayerAnswer;
}

@freezed
abstract class Room with _$Room {
  const Room._();

  const factory Room({
    required String code,
    required String hostId,
    required RoomStatus status,
    required int createdAt,
    required RoomSettings settings,

    /// Sorted by `joinedAt`, oldest first.
    required List<RoomPlayer> players,
    @Default(<String>[]) List<String> questionIds,
    @Default(0) int currentQuestionIndex,
    int? questionStartedAt,
    int? phaseStartedAt,

    /// The last question whose scores were written; guards against scoring twice.
    int? scoredQuestionIndex,

    /// Every question id this room has played, so "Play again" avoids repeats.
    @Default(<String>{}) Set<String> usedQuestionIds,

    /// Question index → player uid → answer.
    @Default(<int, Map<String, PlayerAnswer>>{}) Map<int, Map<String, PlayerAnswer>> answers,
  }) = _Room;

  RoomPlayer? player(String uid) {
    for (final p in players) {
      if (p.uid == uid) return p;
    }
    return null;
  }

  RoomPlayer? get host => player(hostId);

  bool isHost(String uid) => hostId == uid;

  bool get isFull => players.length >= settings.maxPlayers;

  /// Players who answer and are ranked (everyone but a big-screen host).
  List<RoomPlayer> get contestants => [for (final p in players) if (!p.spectator) p];

  bool get canStart => contestants.length >= RoomRules.minPlayersToStart;

  Map<String, PlayerAnswer> answersFor(int questionIndex) =>
      answers[questionIndex] ?? const <String, PlayerAnswer>{};
}
