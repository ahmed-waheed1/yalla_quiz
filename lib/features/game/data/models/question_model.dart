import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/question.dart';

part 'question_model.freezed.dart';
part 'question_model.g.dart';

@freezed
abstract class LocalizedQuestionModel with _$LocalizedQuestionModel {
  const factory LocalizedQuestionModel({
    required String q,
    required List<String> options,
  }) = _LocalizedQuestionModel;

  factory LocalizedQuestionModel.fromJson(Map<String, dynamic> json) =>
      _$LocalizedQuestionModelFromJson(json);
}

@freezed
abstract class QuestionModel with _$QuestionModel {
  const QuestionModel._();

  const factory QuestionModel({
    required String id,
    required LocalizedQuestionModel en,
    required LocalizedQuestionModel ar,
    required int answer,
  }) = _QuestionModel;

  factory QuestionModel.fromJson(Map<String, dynamic> json) => _$QuestionModelFromJson(json);

  Question toEntity(String category) => Question(
        id: id,
        category: category,
        en: LocalizedQuestion(text: en.q, options: en.options),
        ar: LocalizedQuestion(text: ar.q, options: ar.options),
        answer: answer,
      );
}
