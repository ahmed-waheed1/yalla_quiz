import 'package:fpdart/fpdart.dart';

import '../../../../core/utils/failure.dart';
import '../../domain/entities/question.dart';
import '../../domain/repositories/question_repository.dart';
import '../datasources/question_asset_data_source.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  QuestionRepositoryImpl(this._source);

  final QuestionAssetDataSource _source;
  final Map<String, List<Question>> _cache = {};

  @override
  Future<Either<Failure, List<String>>> categories() async {
    try {
      return right(await _source.categories());
    } on Object catch (e) {
      return left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Question>>> questions(String category) async {
    final cached = _cache[category];
    if (cached != null) return right(cached);
    try {
      final models = await _source.questions(category);
      final questions = models.map((m) => m.toEntity(category)).toList();
      _cache[category] = questions;
      return right(questions);
    } on Object catch (e) {
      return left(UnexpectedFailure(e.toString()));
    }
  }
}
