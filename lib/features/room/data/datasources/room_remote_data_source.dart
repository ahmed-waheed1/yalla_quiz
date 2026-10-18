import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import '../../../../core/utils/json.dart';
import '../../../../core/utils/log.dart';
import '../../../profile/domain/entities/player_profile.dart';
import '../../domain/entities/room.dart';
import '../models/room_model.dart';

/// All RTDB access for `rooms/{code}`. Throws [FirebaseException]s; the
/// repository maps them to failures.
class RoomRemoteDataSource {
  RoomRemoteDataSource(this._db);

  final FirebaseDatabase _db;

  DatabaseReference _room(String code) => _db.ref('rooms/$code');
  DatabaseReference _player(String code, String uid) => _db.ref('rooms/$code/players/$uid');

  Map<String, Object?> _newPlayer(PlayerProfile profile) => {
    'name': profile.name,
    'avatarSeed': profile.avatarSeed,
    'joinedAt': ServerValue.timestamp,
    'connected': true,
    'score': 0,
  };

  /// Fails with `permission-denied` if a fresh room already uses [code].
  Future<void> createRoom({
    required String code,
    required String uid,
    required RoomSettings settings,
    required PlayerProfile profile,
  }) => _room(code).set({
    'hostId': uid,
    'status': RoomStatus.lobby.name,
    'createdAt': ServerValue.timestamp,
    'settings': RoomSettingsModel.fromEntity(settings).toJson(),
    'currentQuestionIndex': 0,
    'players': {uid: _newPlayer(profile)},
  });

  Future<RoomModel?> fetchRoom(String code) async {
    final snapshot = await _room(code).get();
    final json = jsonMapOrNull(snapshot.value);
    return json == null ? null : RoomModel.fromJson(json);
  }

  Future<void> addPlayer(String code, String uid, PlayerProfile profile) =>
      _player(code, uid).set(_newPlayer(profile));

  Future<void> rejoin(String code, String uid, PlayerProfile profile) => _player(
    code,
    uid,
  ).update({'name': profile.name, 'avatarSeed': profile.avatarSeed, 'connected': true});

  Stream<RoomModel?> watchRoom(String code) => _room(code).onValue.map((event) {
    final json = jsonMapOrNull(event.snapshot.value);
    return json == null ? null : RoomModel.fromJson(json);
  });

  /// While listened to, re-marks the player connected after every reconnect
  /// and arms `onDisconnect` to flip it back to false.
  Stream<bool> maintainPresence(String code, String uid) {
    final playerRef = _player(code, uid);
    StreamSubscription<DatabaseEvent>? subscription;
    late final StreamController<bool> controller;
    controller = StreamController<bool>(
      onListen: () {
        subscription = _db.ref('.info/connected').onValue.listen((event) async {
          final connected = event.snapshot.value == true;
          controller.add(connected);
          if (!connected) return;
          try {
            await playerRef.onDisconnect().update({'connected': false});
            await playerRef.update({'connected': true});
          } on Object catch (e) {
            log.w('Presence update failed for $code/$uid', error: e);
          }
        }, onError: controller.addError);
      },
      onCancel: () => subscription?.cancel(),
    );
    return controller.stream;
  }

  /// Returns true if this client became host.
  Future<bool> claimHost(String code, String uid, String previousHostId) async {
    final result = await _db.ref('rooms/$code/hostId').runTransaction((value) {
      if (value != previousHostId) return Transaction.abort();
      return Transaction.success(uid);
    });
    return result.committed;
  }

  Future<void> leave(String code, String uid, {required bool isHost, String? successorUid}) async {
    if (!isHost) {
      await _player(code, uid).remove();
    } else if (successorUid != null) {
      await _room(code).update({'hostId': successorUid, 'players/$uid': null});
    } else {
      await _room(code).remove();
    }
    // The node is gone, so the armed `connected: false` has nothing to update.
    await _player(code, uid).onDisconnect().cancel();
  }
}
