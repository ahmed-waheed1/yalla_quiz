import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/prefs_keys.dart';
import '../../../../core/utils/failure.dart';
import '../../domain/entities/player_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Either<Failure, Option<PlayerProfile>> load() {
    final raw = _prefs.getString(PrefsKeys.profile);
    if (raw == null) return right(none());
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return right(some(ProfileModel.fromJson(json).toEntity()));
    } on Object catch (e) {
      return left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> save(PlayerProfile profile) async {
    try {
      final raw = jsonEncode(ProfileModel.fromEntity(profile).toJson());
      await _prefs.setString(PrefsKeys.profile, raw);
      return right(unit);
    } on Object catch (e) {
      return left(UnexpectedFailure(e.toString()));
    }
  }
}
