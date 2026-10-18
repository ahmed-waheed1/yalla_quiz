import 'package:fpdart/fpdart.dart';

import '../../../../core/utils/failure.dart';
import '../entities/player_profile.dart';

abstract interface class ProfileRepository {
  /// The saved profile, or `none()` on first launch.
  Either<Failure, Option<PlayerProfile>> load();

  Future<Either<Failure, Unit>> save(PlayerProfile profile);
}
