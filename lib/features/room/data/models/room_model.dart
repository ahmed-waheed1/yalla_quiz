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
    @Default(false) bool spectator,
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
        spectator: spectator,
      );
}

@freezed
abstract class AnswerModel with _$AnswerModel {
  const AnswerModel._();

  const factory AnswerModel({
    required int option,
    required int answeredAt,
  }) = _AnswerModel;

  factory AnswerModel.fromJson(Map<String, dynamic> json) => _$AnswerModelFromJson(json);

  PlayerAnswer toEntity() => PlayerAnswer(option: option, answeredAt: answeredAt);
}

/// `answers/{q}/{uid}`. RTDB returns integer-keyed nodes as a list (with
/// nulls for gaps) when the keys are dense, and as a map otherwise.
Map<int, Map<String, AnswerModel>> _answersFromJson(Object? json) {
  final byQuestion = <int, Map<String, AnswerModel>>{};
  void add(int? q, Object? perPlayer) {
    if (q == null || perPlayer is! Map) return;
    byQuestion[q] = {
      for (final e in perPlayer.entries)
        if (e.value is Map)
          e.key.toString(): AnswerModel.fromJson(Map<String, dynamic>.from(e.value as Map)),
    };
  }

  if (json is List) {
    for (var q = 0; q < json.length; q++) {
      add(q, json[q]);
    }
  } else if (json is Map) {
    for (final e in json.entries) {
      add(int.tryParse(e.key.toString()), e.value);
    }
  }
  return byQuestion;
}

Map<String, Object?> _answersToJson(Map<int, Map<String, AnswerModel>> answers) => {
      for (final e in answers.entries)
        '${e.key}': {for (final a in e.value.entries) a.key: a.value.toJson()},
    };

Set<String> _usedIdsFromJson(Object? json) => json is Map
    ? {for (final e in json.entries) if (e.value == true) e.key.toString()}
    : <String>{};

Map<String, bool> _usedIdsToJson(Set<String> ids) => {for (final id in ids) id: true};

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
    int? scoredQuestionIndex,
    @JsonKey(fromJson: _usedIdsFromJson, toJson: _usedIdsToJson)
    @Default(<String>{})
    Set<String> usedQuestionIds,
    @JsonKey(fromJson: _answersFromJson, toJson: _answersToJson)
    @Default(<int, Map<String, AnswerModel>>{})
    Map<int, Map<String, AnswerModel>> answers,
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
      scoredQuestionIndex: scoredQuestionIndex,
      usedQuestionIds: usedQuestionIds,
      answers: {
        for (final q in answers.entries)
          q.key: {for (final a in q.value.entries) a.key: a.value.toEntity()},
      },
    );
  }
}
