import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/services/clock.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/log.dart';
import '../../../room/domain/entities/game_command.dart';
import '../../../room/domain/entities/room.dart';
import '../../../room/domain/repositories/room_repository.dart';
import '../../domain/entities/question.dart';
import '../../domain/repositories/question_repository.dart';
import '../../domain/services/game_engine.dart';
import '../../domain/services/game_host_driver.dart';
import '../../domain/services/question_picker.dart';

part 'game_cubit.freezed.dart';

@freezed
abstract class GameState with _$GameState {
  const GameState._();

  const factory GameState({
    Room? room,
    String? myUid,

    /// The room's category, by question id.
    @Default(<String, Question>{}) Map<String, Question> questions,

    /// My pick while its write is in flight, for question [pendingIndex].
    int? pendingIndex,
    int? pendingOption,

    /// Host is writing the start of the game.
    @Default(false) bool starting,

    /// A player tapped "Play again" before the host did: show the lobby.
    @Default(false) bool rematch,

    /// Last user-visible failure; [failureCount] changes with each one.
    Failure? failure,
    @Default(0) int failureCount,
  }) = _GameState;

  bool get isHost => room != null && myUid != null && room!.isHost(myUid!);

  RoomPlayer? get me => myUid == null ? null : room?.player(myUid!);

  bool get isSpectator => me?.spectator ?? false;

  Question? get currentQuestion {
    final r = room;
    if (r == null || r.currentQuestionIndex >= r.questionIds.length) return null;
    return questions[r.questionIds[r.currentQuestionIndex]];
  }

  /// My answer for the current question: confirmed by RTDB, or still pending.
  int? get myOption {
    final r = room;
    if (r == null || myUid == null) return null;
    final index = r.currentQuestionIndex;
    return r.answersFor(index)[myUid]?.option ?? (pendingIndex == index ? pendingOption : null);
  }
}

/// The game for one device: renders from the room in RTDB, sends this
/// player's answer, and (on the host) drives the phases.
class GameCubit extends Cubit<GameState> {
  GameCubit({
    required this.code,
    required this._rooms,
    required this._questions,
    required this._clock,
    required Scheduler scheduler,
    Random? random,
  }) : _random = random ?? Random(),
       super(const GameState()) {
    _driver = GameHostDriver(
      code: code,
      rooms: _rooms,
      clock: _clock,
      scheduler: scheduler,
      onFailure: (f) => log.w('Phase write failed, retrying: $f'),
    );
  }

  final String code;
  final RoomRepository _rooms;
  final QuestionRepository _questions;
  final Clock _clock;
  final Random _random;
  late final GameHostDriver _driver;
  String? _loadedCategory;

  int serverNow() => _clock.nowMs();

  /// Call with every room snapshot.
  void onRoom(Room room, String myUid) {
    if (isClosed) return;
    emit(
      state.copyWith(
        room: room,
        myUid: myUid,
        rematch: state.rematch && room.status == RoomStatus.finished,
        // A pending pick only matters while the question runs; afterwards
        // the room's answers are the truth (a rejected late pick is gone).
        pendingIndex: room.status == RoomStatus.question ? state.pendingIndex : null,
      ),
    );
    if (_loadedCategory != room.settings.category) _loadQuestions(room.settings.category);
    _drive();
  }

  void _drive() {
    final room = state.room;
    if (room == null || isClosed) return;
    _driver.update(room, isHost: state.isHost, answerKey: (id) => state.questions[id]?.answer);
  }

  Future<void> _loadQuestions(String category) async {
    _loadedCategory = category;
    final result = await _questions.questions(category);
    if (isClosed) return;
    result.match(
      (failure) {
        _loadedCategory = null;
        _fail(failure);
      },
      (list) {
        emit(state.copyWith(questions: {for (final q in list) q.id: q}));
        _drive();
      },
    );
  }

  /// Host, in the lobby: pick the questions and start the countdown.
  Future<void> startGame() async {
    final room = state.room;
    if (room == null || !state.isHost || room.status != RoomStatus.lobby || state.starting) return;
    if (!room.canStart) return;
    emit(state.copyWith(starting: true));
    if (state.questions.isEmpty) await _loadQuestions(room.settings.category);
    final ids = QuestionPicker.pick(
      available: state.questions.keys.toList()..sort(),
      used: room.usedQuestionIds,
      count: room.settings.questionCount,
      random: _random,
    );
    final result = ids.length < room.settings.questionCount
        ? null
        : await _rooms.runGameCommand(code: code, command: StartGame(ids));
    if (isClosed) return;
    emit(state.copyWith(starting: false));
    if (result == null) {
      _fail(const UnexpectedFailure('Not enough questions'));
    } else {
      result.match(_fail, (_) {});
    }
  }

  /// Locks in [option] for the current question. Returns false if it is too
  /// late, already answered, or this device is a spectator.
  bool answer(int option) {
    final room = state.room;
    if (room == null || room.status != RoomStatus.question) return false;
    if (state.isSpectator || state.me == null || state.myOption != null) return false;
    if (serverNow() > GameEngine.questionEndsAt(room)) return false;
    final index = room.currentQuestionIndex;
    emit(state.copyWith(pendingIndex: index, pendingOption: option));
    _rooms.submitAnswer(code: code, questionIndex: index, option: option).then((result) {
      if (isClosed) return;
      result.match((failure) {
        // Too late or rejected: drop the lock so the UI shows time's up.
        if (state.pendingIndex == index) emit(state.copyWith(pendingIndex: null));
        _fail(failure);
      }, (_) {});
    });
    return true;
  }

  /// Host: everyone back to the lobby with scores reset, dropped players
  /// removed. Others: wait in the lobby until the host does.
  Future<void> playAgain() async {
    final room = state.room;
    if (room == null || room.status != RoomStatus.finished) return;
    if (!state.isHost) {
      emit(state.copyWith(rematch: true));
      return;
    }
    final prune = [
      for (final p in room.players)
        if (!p.connected && p.uid != room.hostId) p.uid,
    ];
    final keep = [
      for (final p in room.players)
        if (!prune.contains(p.uid)) p.uid,
    ];
    final result = await _rooms.runGameCommand(
      code: code,
      command: PlayAgain(keep: keep, prune: prune),
    );
    if (!isClosed) result.match(_fail, (_) {});
  }

  void _fail(Failure failure) =>
      emit(state.copyWith(failure: failure, failureCount: state.failureCount + 1));

  @override
  Future<void> close() {
    _driver.dispose();
    return super.close();
  }
}
