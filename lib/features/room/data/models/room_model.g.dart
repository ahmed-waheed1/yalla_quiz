// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoomSettingsModel _$RoomSettingsModelFromJson(Map<String, dynamic> json) =>
    _RoomSettingsModel(
      category: json['category'] as String,
      questionCount: (json['questionCount'] as num).toInt(),
      timePerQuestion: (json['timePerQuestion'] as num).toInt(),
      maxPlayers: (json['maxPlayers'] as num).toInt(),
    );

Map<String, dynamic> _$RoomSettingsModelToJson(_RoomSettingsModel instance) =>
    <String, dynamic>{
      'category': instance.category,
      'questionCount': instance.questionCount,
      'timePerQuestion': instance.timePerQuestion,
      'maxPlayers': instance.maxPlayers,
    };

_PlayerModel _$PlayerModelFromJson(Map<String, dynamic> json) => _PlayerModel(
  name: json['name'] as String,
  avatarSeed: (json['avatarSeed'] as num).toInt(),
  joinedAt: (json['joinedAt'] as num).toInt(),
  connected: json['connected'] as bool? ?? false,
  score: (json['score'] as num?)?.toInt() ?? 0,
  streak: (json['streak'] as num?)?.toInt() ?? 0,
  lastPoints: (json['lastPoints'] as num?)?.toInt() ?? 0,
  spectator: json['spectator'] as bool? ?? false,
);

Map<String, dynamic> _$PlayerModelToJson(_PlayerModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'avatarSeed': instance.avatarSeed,
      'joinedAt': instance.joinedAt,
      'connected': instance.connected,
      'score': instance.score,
      'streak': instance.streak,
      'lastPoints': instance.lastPoints,
      'spectator': instance.spectator,
    };

_AnswerModel _$AnswerModelFromJson(Map<String, dynamic> json) => _AnswerModel(
  option: (json['option'] as num).toInt(),
  answeredAt: (json['answeredAt'] as num).toInt(),
);

Map<String, dynamic> _$AnswerModelToJson(_AnswerModel instance) =>
    <String, dynamic>{
      'option': instance.option,
      'answeredAt': instance.answeredAt,
    };

_RoomModel _$RoomModelFromJson(Map<String, dynamic> json) => _RoomModel(
  hostId: json['hostId'] as String,
  status: $enumDecode(
    _$RoomStatusEnumMap,
    json['status'],
    unknownValue: RoomStatus.lobby,
  ),
  createdAt: (json['createdAt'] as num).toInt(),
  settings: RoomSettingsModel.fromJson(
    json['settings'] as Map<String, dynamic>,
  ),
  players:
      (json['players'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, PlayerModel.fromJson(e as Map<String, dynamic>)),
      ) ??
      const <String, PlayerModel>{},
  questionIds:
      (json['questionIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  currentQuestionIndex: (json['currentQuestionIndex'] as num?)?.toInt() ?? 0,
  questionStartedAt: (json['questionStartedAt'] as num?)?.toInt(),
  phaseStartedAt: (json['phaseStartedAt'] as num?)?.toInt(),
  scoredQuestionIndex: (json['scoredQuestionIndex'] as num?)?.toInt(),
  usedQuestionIds: json['usedQuestionIds'] == null
      ? const <String>{}
      : _usedIdsFromJson(json['usedQuestionIds']),
  answers: json['answers'] == null
      ? const <int, Map<String, AnswerModel>>{}
      : _answersFromJson(json['answers']),
);

Map<String, dynamic> _$RoomModelToJson(_RoomModel instance) =>
    <String, dynamic>{
      'hostId': instance.hostId,
      'status': _$RoomStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt,
      'settings': instance.settings,
      'players': instance.players,
      'questionIds': instance.questionIds,
      'currentQuestionIndex': instance.currentQuestionIndex,
      'questionStartedAt': instance.questionStartedAt,
      'phaseStartedAt': instance.phaseStartedAt,
      'scoredQuestionIndex': instance.scoredQuestionIndex,
      'usedQuestionIds': _usedIdsToJson(instance.usedQuestionIds),
      'answers': _answersToJson(instance.answers),
    };

const _$RoomStatusEnumMap = {
  RoomStatus.lobby: 'lobby',
  RoomStatus.countdown: 'countdown',
  RoomStatus.question: 'question',
  RoomStatus.reveal: 'reveal',
  RoomStatus.leaderboard: 'leaderboard',
  RoomStatus.finished: 'finished',
};
