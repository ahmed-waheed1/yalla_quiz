import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/player_profile.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
abstract class ProfileModel with _$ProfileModel {
  const ProfileModel._();

  const factory ProfileModel({
    required String name,
    required int avatarSeed,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);

  factory ProfileModel.fromEntity(PlayerProfile p) =>
      ProfileModel(name: p.name, avatarSeed: p.avatarSeed);

  PlayerProfile toEntity() => PlayerProfile(name: name, avatarSeed: avatarSeed);
}
