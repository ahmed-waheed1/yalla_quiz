import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/room.dart';

part 'room_model.freezed.dart';
part 'room_model.g.dart';

@freezed
abstract class RoomSettingsModel with _$RoomSettingsModel {
  const RoomSettingsModel._();

  const factory RoomSettingsModel({
    required String category,
    required int questionCount,
    required int timePerQuestion,
    required int maxPlayers,
  }) = _RoomSettingsModel;

  factory RoomSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$RoomSettingsModelFromJson(json);

  factory RoomSettingsModel.fromEntity(RoomSettings s) => RoomSettingsModel(
        category: s.category,
        questionCount: s.questionCount,
        timePerQuestion: s.timePerQuestion,
        maxPlayers: s.maxPlayers,
      );

  RoomSettings toEntity() => RoomSettings(
        category: category,
        questionCount: questionCount,
        timePerQuestion: timePerQuestion,
        maxPlayers: maxPlayers,
      );
}

@freezed
abstract class PlayerModel with _$PlayerModel {
  const PlayerModel._();

  const factory PlayerModel({
    required String name,
    required int avatarSeed,
    required int joinedAt,
    @Default(false) bool connected,
    @Default(0) int score,
    @Default(0) int streak,
    @Default(0) int lastPoints,
  }) = _PlayerModel;

  factory PlayerModel.fromJson(Map<String, dynamic> json) => _$PlayerModelFromJson(json);

  RoomPlayer toEntity(String uid) => RoomPlayer(
        uid: uid,
        name: name,
        avatarSeed: avatarSeed,
        joinedAt: joinedAt,
        connected: connected,
        score: score,
        streak: streak,
        lastPoints: lastPoints,
      );
}

/// `rooms/{code}` as stored in RTDB.
@freezed
abstract class RoomModel with _$RoomModel {
  const RoomModel._();

  const factory RoomModel({
    required String hostId,
    @JsonKey(unknownEnumValue: RoomStatus.lobby) required RoomStatus status,
    required int createdAt,
    required RoomSettingsModel settings,
    @Default(<String, PlayerModel>{}) Map<String, PlayerModel> players,
    @Default(<String>[]) List<String> questionIds,
    @Default(0) int currentQuestionIndex,
    int? questionStartedAt,
    int? phaseStartedAt,
  }) = _RoomModel;

  factory RoomModel.fromJson(Map<String, dynamic> json) => _$RoomModelFromJson(json);

  Room toEntity(String code) {
    final list = [for (final e in players.entries) e.value.toEntity(e.key)]
      ..sort((a, b) {
        final byTime = a.joinedAt.compareTo(b.joinedAt);
        return byTime != 0 ? byTime : a.uid.compareTo(b.uid);
      });
    return Room(
      code: code,
      hostId: hostId,
      status: status,
      createdAt: createdAt,
      settings: settings.toEntity(),
      players: list,
      questionIds: questionIds,
      currentQuestionIndex: currentQuestionIndex,
      questionStartedAt: questionStartedAt,
      phaseStartedAt: phaseStartedAt,
    );
  }
}
