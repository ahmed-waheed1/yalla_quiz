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
  }) = _RoomPlayer;
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

  bool get canStart => players.length >= RoomRules.minPlayersToStart;
}
