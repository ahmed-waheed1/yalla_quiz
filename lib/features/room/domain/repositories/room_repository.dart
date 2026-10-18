import 'package:fpdart/fpdart.dart';

import '../../../../core/utils/failure.dart';
import '../../../profile/domain/entities/player_profile.dart';
import '../entities/game_command.dart';
import '../entities/room.dart';

abstract interface class RoomRepository {
  /// The signed-in player's uid (anonymous auth), signing in if needed.
  Future<Either<Failure, String>> currentUid();

  /// Creates a room with a fresh code and the caller as host. Returns the code.
  /// A [spectator] host runs the game on a big screen and doesn't play.
  Future<Either<Failure, String>> createRoom({
    required RoomSettings settings,
    required PlayerProfile profile,
    bool spectator = false,
  });

  /// Joins (or rejoins) a room. New players can only join while in the lobby;
  /// existing players can rejoin at any status and keep their score.
  Future<Either<Failure, Unit>> joinRoom({required String code, required PlayerProfile profile});

  /// Live room updates; emits `none()` when the room is deleted.
  Stream<Either<Failure, Option<Room>>> watchRoom(String code);

  /// Keeps `players/{uid}/connected` true (with an onDisconnect fallback) for
  /// as long as the stream is listened to. Emits the connection state.
  Stream<bool> maintainPresence(String code);

  /// Host only: applies one phase change atomically.
  Future<Either<Failure, Unit>> runGameCommand({
    required String code,
    required GameCommand command,
  });

  /// Locks in the caller's answer for question [questionIndex] (once).
  Future<Either<Failure, Unit>> submitAnswer({
    required String code,
    required int questionIndex,
    required int option,
  });

  /// Takes over as host if [previousHostId] is still the host (it's gone or
  /// disconnected). Atomic, so only one claimer wins.
  Future<Either<Failure, Unit>> claimHost({required String code, required String previousHostId});

  /// Leaves the room: a host hands over to [successorUid] or, if there is no
  /// one left, deletes the room.
  Future<Either<Failure, Unit>> leaveRoom({
    required String code,
    required bool isHost,
    String? successorUid,
  });
}
