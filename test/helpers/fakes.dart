import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:yalla_quiz/core/services/auth_service.dart';
import 'package:yalla_quiz/core/utils/failure.dart';
import 'package:yalla_quiz/features/game/domain/entities/question.dart';
import 'package:yalla_quiz/features/game/domain/repositories/question_repository.dart';
import 'package:yalla_quiz/features/profile/domain/entities/player_profile.dart';
import 'package:yalla_quiz/features/profile/domain/repositories/profile_repository.dart';
import 'package:yalla_quiz/features/room/domain/entities/game_command.dart';
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
  FakeQuestionRepository({Map<String, int>? counts})
    : counts =
          counts ??
          const {
            'food': 30,
            'football': 30,
            'general': 30,
            'geography': 30,
            'movies_tv': 30,
            'music': 30,
          };

  /// Questions per category.
  final Map<String, int> counts;

  @override
  Future<Either<Failure, List<String>>> categories() async => right(counts.keys.toList()..sort());

  @override
  Future<Either<Failure, List<Question>>> questions(String category) async => right([
    for (var i = 0; i < (counts[category] ?? 0); i++)
      Question(
        id: '${category}_$i',
        category: category,
        en: kSampleQuestionEn,
        ar: kSampleQuestionAr,
        answer: 0,
      ),
  ]);
}

/// The design's sample question (Rabat is option 0 here).
const kSampleQuestionEn = LocalizedQuestion(
  text: "What's the capital of Morocco?",
  options: ['Rabat', 'Casablanca', 'Marrakesh', 'Fez'],
);
const kSampleQuestionAr = LocalizedQuestion(
  text: 'إيه عاصمة المغرب؟',
  options: ['الرباط', 'الدار البيضاء', 'مراكش', 'فاس'],
);

class FakeRoomRepository implements RoomRepository {
  FakeRoomRepository({this.room, this.joinFailure, this.online = true});

  Room? room;

  /// What `maintainPresence` reports.
  final bool online;

  /// What `joinRoom` returns; null means success.
  Failure? joinFailure;

  @override
  Future<Either<Failure, String>> currentUid() async => right(kMyUid);

  @override
  Future<Either<Failure, String>> createRoom({
    required RoomSettings settings,
    required PlayerProfile profile,
    bool spectator = false,
  }) async => right('K7XP2Q');

  @override
  Future<Either<Failure, Unit>> joinRoom({
    required String code,
    required PlayerProfile profile,
  }) async => joinFailure == null ? right(unit) : left(joinFailure!);

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
    controller.add(online);
    return controller.stream;
  }

  @override
  Future<Either<Failure, Unit>> runGameCommand({
    required String code,
    required GameCommand command,
  }) async => right(unit);

  @override
  Future<Either<Failure, Unit>> submitAnswer({
    required String code,
    required int questionIndex,
    required int option,
  }) async => right(unit);

  @override
  Future<Either<Failure, Unit>> claimHost({
    required String code,
    required String previousHostId,
  }) async => right(unit);

  @override
  Future<Either<Failure, Unit>> leaveRoom({
    required String code,
    required bool isHost,
    String? successorUid,
  }) async => right(unit);
}

RoomPlayer player(String uid, String name, int seed, {bool connected = true, int joinedAt = 0}) =>
    RoomPlayer(uid: uid, name: name, avatarSeed: seed, joinedAt: joinedAt, connected: connected);

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
