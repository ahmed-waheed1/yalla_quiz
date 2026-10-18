import 'package:freezed_annotation/freezed_annotation.dart';

part 'question.freezed.dart';

@freezed
abstract class LocalizedQuestion with _$LocalizedQuestion {
  const factory LocalizedQuestion({
    required String text,
    required List<String> options,
  }) = _LocalizedQuestion;
}

/// A trivia question with English and Arabic text. Each player sees it in
/// their own app language.
@freezed
abstract class Question with _$Question {
  const Question._();

  const factory Question({
    required String id,
    required String category,
    required LocalizedQuestion en,
    required LocalizedQuestion ar,
    required int answer,
  }) = _Question;

  LocalizedQuestion forLanguage(String languageCode) => languageCode == 'ar' ? ar : en;
}
