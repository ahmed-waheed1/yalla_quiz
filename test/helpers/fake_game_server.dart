import 'package:fpdart/fpdart.dart';
import 'package:yalla_quiz/core/utils/failure.dart';
import 'package:yalla_quiz/features/room/domain/entities/game_command.dart';
import 'package:yalla_quiz/features/room/domain/entities/room.dart';
import 'package:yalla_quiz/features/room/domain/repositories/room_repository.dart';

import 'fake_clock.dart';

/// An in-memory `rooms/{code}` for game-loop tests. Writes go through the same
/// checks as `database.rules.json` (host only, legal transitions, one score
/// per question, one answer per player, answer deadline) and are echoed to
/// every listener before the write completes, like RTDB's local events.
class FakeGameServer {
  FakeGameServer(this.clock, this._room);

  final FakeClock clock;
  Room _room;
  final List<void Function(Room)> _listeners = [];

  /// Every accepted game command, in order.
  final List<GameCommand> applied = [];

  /// Every rejected game command, in order.
  final List<GameCommand> rejected = [];

  Room get room => _room;

  void listen(void Function(Room) onRoom) {
    _listeners.add(onRoom);
    onRoom(_room);
  }

  /// A direct edit (presence changes, host claims) as another client would make.
  void edit(Room Function(Room) change) {
    _room = change(_room);
    _emit();
  }

  void _emit() {
    for (final l in List.of(_listeners)) {
      l(_room);
    }
  }

  RoomRepository client(String uid) => _Client(this, uid);

  Either<Failure, Unit> _run(String uid, GameCommand command) {
    final next = _room.hostId == uid ? _apply(command) : null;
    if (next == null) {
      rejected.add(command);
      return left(const PermissionFailure('rules'));
    }
    applied.add(command);
    _room = next;
    _emit();
    return right(unit);
  }

  Room? _apply(GameCommand command) {
    final r = _room;
    final now = clock.nowMs();
    final count = r.settings.questionCount;
    switch (command) {
      case StartGame(:final questionIds):
        if (r.status != RoomStatus.lobby || questionIds.length != count) return null;
        return r.copyWith(
          status: RoomStatus.countdown,
          phaseStartedAt: now,
          questionIds: questionIds,
          usedQuestionIds: {...r.usedQuestionIds, ...questionIds},
          currentQuestionIndex: 0,
          scoredQuestionIndex: null,
          answers: const {},
        );
      case StartQuestion(:final index):
        final legal =
            (r.status == RoomStatus.countdown && index == 0) ||
            (r.status == RoomStatus.leaderboard && index == r.currentQuestionIndex + 1);
        if (!legal || index >= count) return null;
        return r.copyWith(
          status: RoomStatus.question,
          currentQuestionIndex: index,
          questionStartedAt: now,
          phaseStartedAt: now,
        );
      case RevealQuestion(:final index, :final scores):
        if (r.status != RoomStatus.question || index != r.currentQuestionIndex) return null;
        if (r.scoredQuestionIndex != null && r.scoredQuestionIndex! >= index) return null;
        final players = <RoomPlayer>[];
        for (final p in r.players) {
          final s = scores[p.uid];
          if (s == null) {
            players.add(p);
            continue;
          }
          if (s.score != p.score + s.lastPoints || s.lastPoints > 1000) return null;
          players.add(p.copyWith(score: s.score, streak: s.streak, lastPoints: s.lastPoints));
        }
        if (scores.keys.any((uid) => r.player(uid) == null)) return null;
        return r.copyWith(
          status: RoomStatus.reveal,
          phaseStartedAt: now,
          scoredQuestionIndex: index,
          players: players,
        );
      case ShowLeaderboard(:final index):
        if (r.status != RoomStatus.reveal || index != r.currentQuestionIndex) return null;
        if (index + 1 >= count) return null;
        return r.copyWith(status: RoomStatus.leaderboard, phaseStartedAt: now);
      case FinishGame(:final index):
        if (r.status != RoomStatus.reveal || index + 1 != count) return null;
        return r.copyWith(status: RoomStatus.finished, phaseStartedAt: now);
      case PlayAgain(:final keep, :final prune):
        if (r.status != RoomStatus.finished) return null;
        if (prune.any((uid) => r.player(uid)?.connected ?? true)) return null;
        return r.copyWith(
          status: RoomStatus.lobby,
          currentQuestionIndex: 0,
          questionIds: const [],
          scoredQuestionIndex: null,
          answers: const {},
          questionStartedAt: null,
          phaseStartedAt: null,
          players: [
            for (final p in r.players)
              if (!prune.contains(p.uid))
                keep.contains(p.uid) ? p.copyWith(score: 0, streak: 0, lastPoints: 0) : p,
          ],
        );
    }
  }

  Either<Failure, Unit> _answer(String uid, int index, int option) {
    final r = _room;
    final me = r.player(uid);
    final now = clock.nowMs();
    final legal =
        me != null &&
        !me.spectator &&
        r.status == RoomStatus.question &&
        index == r.currentQuestionIndex &&
        !r.answersFor(index).containsKey(uid) &&
        now <= (r.questionStartedAt ?? 0) + r.settings.timePerQuestion * 1000 + 1000;
    if (!legal) return left(const PermissionFailure('rules'));
    _room = r.copyWith(
      answers: {
        ...r.answers,
        index: {...r.answersFor(index), uid: PlayerAnswer(option: option, answeredAt: now)},
      },
    );
    _emit();
    return right(unit);
  }
}

class _Client implements RoomRepository {
  _Client(this._server, this._uid);

  final FakeGameServer _server;
  final String _uid;

  @override
  Future<Either<Failure, String>> currentUid() async => right(_uid);

  @override
  Future<Either<Failure, Unit>> runGameCommand({
    required String code,
    required GameCommand command,
  }) async => _server._run(_uid, command);

  @override
  Future<Either<Failure, Unit>> submitAnswer({
    required String code,
    required int questionIndex,
    required int option,
  }) async => _server._answer(_uid, questionIndex, option);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
