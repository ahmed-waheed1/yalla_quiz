import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/utils/failure.dart';
import '../../domain/entities/player_profile.dart';
import '../../domain/repositories/profile_repository.dart';

/// App-wide current profile (null until the player sets one up).
class ProfileCubit extends Cubit<PlayerProfile?> {
  ProfileCubit(this._repository) : super(null);

  final ProfileRepository _repository;

  void load() => emit(_repository.load().getOrElse((_) => none()).toNullable());

  Future<Either<Failure, Unit>> save(PlayerProfile profile) async {
    final result = await _repository.save(profile);
    if (result.isRight()) emit(profile);
    return result;
  }
}
