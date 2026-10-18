import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/haptics.dart';
import '../../../../core/utils/failure.dart';
import '../../../room/domain/entities/room.dart';
import '../../../room/domain/repositories/room_repository.dart';
import '../../../room/domain/services/host_succession.dart';

part 'lobby_cubit.freezed.dart';

enum LobbyStatus { loading, ready, closed, left, error }

@freezed
abstract class LobbyState with _$LobbyState {
  const LobbyState._();

  const factory LobbyState({
    @Default(LobbyStatus.loading) LobbyStatus status,
    Room? room,
    String? myUid,
    @Default(true) bool online,
    @Default(false) bool leaving,

    /// Bumped each time this player is promoted to host (for a toast).
    @Default(0) int promotedCount,
    Failure? failure,
  }) = _LobbyState;

  bool get isHost => room != null && myUid != null && room!.isHost(myUid!);
}

/// Lobby: live room + presence, and host takeover when the host drops.
class LobbyCubit extends Cubit<LobbyState> {
  LobbyCubit({
    required this.code,
    required this._rooms,
    required this._haptics,
    this._hostGrace = RoomRules.hostReconnectGrace,
  }) : super(const LobbyState());

  final String code;
  final RoomRepository _rooms;
  final Haptics _haptics;
  final Duration _hostGrace;

  static const Duration _leaveTimeout = Duration(seconds: 5);

  StreamSubscription<Either<Failure, Option<Room>>>? _roomSub;
  StreamSubscription<bool>? _presenceSub;
  Timer? _hostTimer;
  String? _awayHostId;

  Future<void> start() async {
    final uidResult = await _rooms.currentUid();
    if (isClosed) return;
    uidResult.match(
      (failure) => emit(state.copyWith(status: LobbyStatus.error, failure: failure)),
      (uid) {
        emit(state.copyWith(myUid: uid));
        _roomSub = _rooms.watchRoom(code).listen(_onRoom);
        _presenceSub = _rooms
            .maintainPresence(code)
            .listen(
              (online) => emit(state.copyWith(online: online)),
              onError: (Object _) => emit(state.copyWith(online: false)),
            );
      },
    );
  }

  void _onRoom(Either<Failure, Option<Room>> event) {
    if (state.leaving) return;
    event.match(
      (failure) => emit(state.copyWith(status: LobbyStatus.error, failure: failure)),
      (maybeRoom) => maybeRoom.match(() => _close(), (room) {
        final uid = state.myUid!;
        if (room.player(uid) == null) return _close();
        final wasHost = state.room != null && state.isHost;
        final promoted = state.room != null && !wasHost && room.isHost(uid);
        if (promoted) _haptics.medium();
        emit(
          state.copyWith(
            status: LobbyStatus.ready,
            room: room,
            promotedCount: state.promotedCount + (promoted ? 1 : 0),
          ),
        );
        _evaluateHost(room);
      }),
    );
  }

  void _close() {
    _cancelHostTimer();
    emit(state.copyWith(status: LobbyStatus.closed));
  }

  /// When the host is away, wait out the grace period, then the agreed
  /// successor (earliest connected joiner) claims the room.
  void _evaluateHost(Room room) {
    final uid = state.myUid!;
    if (room.isHost(uid) || !HostSuccession.hostIsAway(room)) {
      _cancelHostTimer();
      return;
    }
    if (_hostTimer != null && _awayHostId == room.hostId) return;
    _cancelHostTimer();
    _awayHostId = room.hostId;
    _hostTimer = Timer(_hostGrace, _onHostGraceElapsed);
  }

  Future<void> _onHostGraceElapsed() async {
    _hostTimer = null;
    final room = state.room;
    final uid = state.myUid;
    if (room == null || uid == null || state.leaving) return;
    if (!HostSuccession.hostIsAway(room) || room.hostId != _awayHostId) return;
    final successor = HostSuccession.successor(room, excludeUid: room.hostId);
    if (successor?.uid == uid) {
      await _rooms.claimHost(code: code, previousHostId: room.hostId);
    } else {
      // Someone else should claim; check again if they don't.
      _evaluateHost(room);
    }
  }

  void _cancelHostTimer() {
    _hostTimer?.cancel();
    _hostTimer = null;
    _awayHostId = null;
  }

  Future<void> leave() async {
    final room = state.room;
    final uid = state.myUid;
    if (state.leaving) return;
    emit(state.copyWith(leaving: true));
    _cancelHostTimer();
    await _presenceSub?.cancel();
    _presenceSub = null;
    if (room != null && uid != null) {
      final isHost = room.isHost(uid);
      final successor = isHost
          ? HostSuccession.successor(room, excludeUid: uid, allowDisconnected: true)
          : null;
      // Offline, the write stays queued and lands on reconnect; don't block.
      await _rooms
          .leaveRoom(code: code, isHost: isHost, successorUid: successor?.uid)
          .timeout(_leaveTimeout, onTimeout: () => left(const NetworkFailure()));
    }
    await _roomSub?.cancel();
    _roomSub = null;
    if (!isClosed) emit(state.copyWith(status: LobbyStatus.left));
  }

  @override
  Future<void> close() async {
    _cancelHostTimer();
    await _roomSub?.cancel();
    await _presenceSub?.cancel();
    return super.close();
  }
}
