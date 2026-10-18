import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/log.dart';
import '../../../../core/utils/room_code.dart';
import '../../../profile/domain/entities/player_profile.dart';
import '../../domain/entities/game_command.dart';
import '../../domain/entities/room.dart';
import '../../domain/repositories/room_repository.dart';
import '../datasources/room_remote_data_source.dart';

class RoomRepositoryImpl implements RoomRepository {
  RoomRepositoryImpl(this._remote, this._auth);

  final RoomRemoteDataSource _remote;
  final AuthService _auth;

  static Failure _map(Object error) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return PermissionFailure(error.message);
        case 'network-error':
        case 'network-request-failed':
        case 'unavailable':
        case 'disconnected':
          return const NetworkFailure();
      }
    }
    log.e('Room operation failed', error: error);
    return UnexpectedFailure(error.toString());
  }

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() run) async {
    try {
      return right(await run());
    } on Object catch (e) {
      return left(_map(e));
    }
  }

  @override
  Future<Either<Failure, String>> currentUid() => _guard(_auth.ensureSignedIn);

  @override
  Future<Either<Failure, String>> createRoom({
    required RoomSettings settings,
    required PlayerProfile profile,
    bool spectator = false,
  }) => _guard(() async {
    final uid = await _auth.ensureSignedIn();
    // A taken (fresh) code is rejected by the rules; try another one.
    Object? lastError;
    for (var attempt = 0; attempt < RoomRules.createAttempts; attempt++) {
      final code = RoomCode.generate();
      try {
        await _remote.createRoom(
          code: code,
          uid: uid,
          settings: settings,
          profile: profile,
          spectator: spectator,
        );
        return code;
      } on FirebaseException catch (e) {
        if (e.code != 'permission-denied') rethrow;
        lastError = e;
      }
    }
    throw lastError!;
  });

  @override
  Future<Either<Failure, Unit>> joinRoom({
    required String code,
    required PlayerProfile profile,
  }) async {
    try {
      final uid = await _auth.ensureSignedIn();
      final room = await _remote.fetchRoom(code);
      if (room == null) return left(const RoomNotFoundFailure());
      if (room.players.containsKey(uid)) {
        await _remote.rejoin(code, uid, profile);
        return right(unit);
      }
      if (room.status != RoomStatus.lobby) return left(const GameStartedFailure());
      // Client-side cap: a rare race can let a 9th player in (accepted).
      if (room.players.length >= room.settings.maxPlayers) {
        return left(RoomFullFailure(room.settings.maxPlayers));
      }
      await _remote.addPlayer(code, uid, profile);
      return right(unit);
    } on Object catch (e) {
      return left(_map(e));
    }
  }

  @override
  Stream<Either<Failure, Option<Room>>> watchRoom(String code) => _remote
      .watchRoom(code)
      .transform(
        StreamTransformer.fromHandlers(
          handleData: (model, sink) =>
              sink.add(right(Option.fromNullable(model).map((m) => m.toEntity(code)))),
          handleError: (error, _, sink) => sink.add(left(_map(error))),
        ),
      );

  @override
  Stream<bool> maintainPresence(String code) async* {
    final uid = await _auth.ensureSignedIn();
    yield* _remote.maintainPresence(code, uid);
  }

  @override
  Future<Either<Failure, Unit>> runGameCommand({
    required String code,
    required GameCommand command,
  }) => _guard(() async {
    await _remote.runGameCommand(code, command);
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> submitAnswer({
    required String code,
    required int questionIndex,
    required int option,
  }) => _guard(() async {
    final uid = await _auth.ensureSignedIn();
    await _remote.submitAnswer(code, uid, questionIndex, option);
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> claimHost({required String code, required String previousHostId}) =>
      _guard(() async {
        final uid = await _auth.ensureSignedIn();
        await _remote.claimHost(code, uid, previousHostId);
        return unit;
      });

  @override
  Future<Either<Failure, Unit>> leaveRoom({
    required String code,
    required bool isHost,
    String? successorUid,
  }) => _guard(() async {
    final uid = await _auth.ensureSignedIn();
    await _remote.leave(code, uid, isHost: isHost, successorUid: successorUid);
    return unit;
  });
}
