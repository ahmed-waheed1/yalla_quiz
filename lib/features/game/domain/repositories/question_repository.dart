import 'package:fpdart/fpdart.dart';

import '../../../../core/utils/failure.dart';
import '../entities/question.dart';

abstract interface class QuestionRepository {
  /// Category ids that have a question file (`assets/questions/<id>.json`).
  Future<Either<Failure, List<String>>> categories();

  Future<Either<Failure, List<Question>>> questions(String category);
}
