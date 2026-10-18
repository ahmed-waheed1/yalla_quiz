import 'package:fpdart/fpdart.dart';

import '../../../../core/utils/failure.dart';
import '../entities/app_settings.dart';

abstract interface class SettingsRepository {
  AppSettings load();

  Future<Either<Failure, Unit>> save(AppSettings settings);
}
