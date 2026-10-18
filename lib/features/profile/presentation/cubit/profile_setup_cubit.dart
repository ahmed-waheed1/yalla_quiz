import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/player_profile.dart';
import 'profile_cubit.dart';

part 'profile_setup_cubit.freezed.dart';

@freezed
abstract class ProfileSetupState with _$ProfileSetupState {
  const ProfileSetupState._();

  const factory ProfileSetupState({
    required String name,
    required int avatarSeed,
    @Default(0) int shuffleCount,
    @Default(false) bool saving,
    @Default(false) bool failed,
  }) = _ProfileSetupState;

  String get trimmedName => name.trim();

  bool get canSubmit =>
      !saving && trimmedName.isNotEmpty && trimmedName.length <= RoomRules.nameMaxLength;
}

class ProfileSetupCubit extends Cubit<ProfileSetupState> {
  ProfileSetupCubit(this._profiles, {Random? random})
    : _random = random ?? Random(),
      super(
        ProfileSetupState(
          name: _profiles.state?.name ?? '',
          avatarSeed: _profiles.state?.avatarSeed ?? 0,
        ),
      );

  final ProfileCubit _profiles;
  final Random _random;

  void nameChanged(String value) => emit(state.copyWith(name: value, failed: false));

  void avatarPicked(int seed) => emit(state.copyWith(avatarSeed: seed));

  void shuffle() {
    var next = state.avatarSeed;
    while (next == state.avatarSeed) {
      next = _random.nextInt(RoomRules.avatarCount);
    }
    emit(state.copyWith(avatarSeed: next, shuffleCount: state.shuffleCount + 1));
  }

  /// Saves the profile; returns true on success.
  Future<bool> submit() async {
    if (!state.canSubmit) return false;
    emit(state.copyWith(saving: true, failed: false));
    final result = await _profiles.save(
      PlayerProfile(name: state.trimmedName, avatarSeed: state.avatarSeed),
    );
    final ok = result.isRight();
    emit(state.copyWith(saving: false, failed: !ok));
    return ok;
  }
}
