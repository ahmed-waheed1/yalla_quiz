import 'dart:math';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/clock.dart';
import '../../../../core/utils/failure.dart';
import '../../../room/domain/entities/room.dart';
import '../../../room/domain/repositories/room_repository.dart';
import 'game_engine.dart';

/// Runs the game loop on the host device. Feed it every room snapshot with
/// [update]; while this device is host it schedules the engine's next step
/// on the server clock and writes it when due.
///
/// There is no local game state: each firing re-reads the latest snapshot, so
/// a device that just became host picks up from whatever phase RTDB is in.
class GameHostDriver {
  GameHostDriver({
    required this.code,
    required this._rooms,
    required this._clock,
    required this._scheduler,
    this._engine = const GameEngine(),
    this.onFailure,
  });

  final String code;
  final RoomRepository _rooms;
  final Clock _clock;
  final Scheduler _scheduler;
  final GameEngine _engine;

  /// Called when a phase write fails (it is retried after
  /// [GameTiming.retryDelay]).
  final void Function(Failure failure)? onFailure;

  Room? _room;
  bool _isHost = false;
  AnswerKey _answerKey = _unknown;
  ScheduledTask? _task;
  bool _writing = false;
  bool _disposed = false;

  static int? _unknown(String _) => null;

  void update(Room room, {required bool isHost, required AnswerKey answerKey}) {
    _room = room;
    _isHost = isHost;
    _answerKey = answerKey;
    _schedule();
  }

  void dispose() {
    _disposed = true;
    _cancel();
  }

  void _cancel() {
    _task?.cancel();
    _task = null;
  }

  void _schedule({Duration minDelay = Duration.zero}) {
    _cancel();
    final room = _room;
    if (_disposed || !_isHost || _writing || room == null) return;
    final step = _engine.next(room, _answerKey);
    if (step == null) return;
    final delay = max(step.dueAt - _clock.nowMs(), minDelay.inMilliseconds);
    _task = _scheduler.schedule(Duration(milliseconds: max(0, delay)), _fire);
  }

  Future<void> _fire() async {
    _task = null;
    final room = _room;
    if (_disposed || !_isHost || _writing || room == null) return;
    final step = _engine.next(room, _answerKey);
    if (step == null) return;
    if (step.dueAt > _clock.nowMs()) return _schedule();

    _writing = true;
    final result = await _rooms.runGameCommand(code: code, command: step.command);
    _writing = false;
    if (_disposed) return;
    result.match(
      (failure) {
        onFailure?.call(failure);
        _schedule(minDelay: GameTiming.retryDelay);
      },
      // Only move on once a snapshot newer than the one we wrote from has
      // arrived; re-running from the old one would repeat the phase.
      (_) {
        if (!identical(_room, room)) _schedule();
      },
    );
  }
}
