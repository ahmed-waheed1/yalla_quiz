import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_profile.freezed.dart';

/// The local player's name and avatar. Lives on the device, not in RTDB.
@freezed
abstract class PlayerProfile with _$PlayerProfile {
  const factory PlayerProfile({
    required String name,
    required int avatarSeed,
  }) = _PlayerProfile;
}
