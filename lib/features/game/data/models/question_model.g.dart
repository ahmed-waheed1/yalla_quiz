// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LocalizedQuestionModel _$LocalizedQuestionModelFromJson(
  Map<String, dynamic> json,
) => _LocalizedQuestionModel(
  q: json['q'] as String,
  options: (json['options'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$LocalizedQuestionModelToJson(
  _LocalizedQuestionModel instance,
) => <String, dynamic>{'q': instance.q, 'options': instance.options};

_QuestionModel _$QuestionModelFromJson(Map<String, dynamic> json) =>
    _QuestionModel(
      id: json['id'] as String,
      en: LocalizedQuestionModel.fromJson(json['en'] as Map<String, dynamic>),
      ar: LocalizedQuestionModel.fromJson(json['ar'] as Map<String, dynamic>),
      answer: (json['answer'] as num).toInt(),
    );

Map<String, dynamic> _$QuestionModelToJson(_QuestionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'en': instance.en,
      'ar': instance.ar,
      'answer': instance.answer,
    };
