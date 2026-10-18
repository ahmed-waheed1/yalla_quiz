import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:yalla_quiz/core/services/auth_service.dart';
import 'package:yalla_quiz/core/utils/failure.dart';
import 'package:yalla_quiz/features/game/domain/entities/question.dart';
import 'package:yalla_quiz/features/game/domain/repositories/question_repository.dart';
import 'package:yalla_quiz/features/profile/domain/entities/player_profile.dart';
import 'package:yalla_quiz/features/profile/domain/repositories/profile_repository.dart';
import 'package:yalla_quiz/features/room/domain/entities/room.dart';
import 'package:yalla_quiz/features/room/domain/repositories/room_repository.dart';
import 'package:yalla_quiz/features/settings/domain/entities/app_settings.dart';
import 'package:yalla_quiz/features/settings/domain/repositories/settings_repository.dart';

const kMyUid = 'me';

class FakeProfileRepository implements ProfileRepository {
  FakeProfileRepository(this.profile);

  PlayerProfile? profile;

  @override
  Either<Failure, Option<PlayerProfile>> load() => right(Option.fromNullable(profile));

  @override
  Future<Either<Failure, Unit>> save(PlayerProfile p) async {
    profile = p;
    return right(unit);
  }
}

class FakeSettingsRepository implements SettingsRepository {
  @override
  AppSettings load() => const AppSettings();

  @override
  Future<Either<Failure, Unit>> save(AppSettings settings) async => right(unit);
}

class FakeQuestionRepository implements QuestionRepository {
  @override
  Future<Either<Failure, List<String>>> categories() async =>
      right(['food', 'football', 'general', 'geography', 'movies_tv', 'music']);

  @override
  Future<Either<Failure, List<Question>>> questions(String category) async => right(const []);
}

class FakeRoomRepository implements RoomRepository {
  FakeRoomRepository({this.room, this.joinFailure});

  Room? room;

  /// What `joinRoom` returns; null means success.
  Failure? joinFailure;

  @override
  Future<Either<Failure, String>> currentUid() async => right(kMyUid);

  @override
  Future<Either<Failure, String>> createRoom({
    required RoomSettings settings,
    required PlayerProfile profile,
  }) async =>
      right('K7XP2Q');

  @override
  Future<Either<Failure, Unit>> joinRoom({
    required String code,
    required PlayerProfile profile,
  }) async =>
      joinFailure == null ? right(unit) : left(joinFailure!);

  @override
  Stream<Either<Failure, Option<Room>>> watchRoom(String code) {
    // Never completes, like a live RTDB listener.
    final controller = StreamController<Either<Failure, Option<Room>>>();
    controller.add(right(Option.fromNullable(room)));
    return controller.stream;
  }

  @override
  Stream<bool> maintainPresence(String code) {
    final controller = StreamController<bool>();
    controller.add(true);
    return controller.stream;
  }

  @override
  Future<Either<Failure, Unit>> claimHost({
    required String code,
    required String previousHostId,
  }) async =>
      right(unit);

  @override
  Future<Either<Failure, Unit>> leaveRoom({
    required String code,
    required bool isHost,
    String? successorUid,
  }) async =>
      right(unit);
}

RoomPlayer player(String uid, String name, int seed, {bool connected = true, int joinedAt = 0}) =>
    RoomPlayer(
      uid: uid,
      name: name,
      avatarSeed: seed,
      joinedAt: joinedAt,
      connected: connected,
    );

/// Sample room from the design: K7XP2Q, General, 10 questions.
Room sampleRoom({required String hostId, required List<RoomPlayer> players}) => Room(
      code: 'K7XP2Q',
      hostId: hostId,
      status: RoomStatus.lobby,
      createdAt: 0,
      settings: const RoomSettings(category: 'general'),
      players: players,
    );

class FakeAuthService implements AuthService {
  @override
  String? get uid => kMyUid;

  @override
  Future<String> ensureSignedIn() async => kMyUid;
}
