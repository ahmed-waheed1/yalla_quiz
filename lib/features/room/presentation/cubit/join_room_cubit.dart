import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/services/haptics.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/room_code.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../../domain/repositories/room_repository.dart';

part 'join_room_cubit.freezed.dart';

@freezed
abstract class JoinRoomState with _$JoinRoomState {
  const JoinRoomState._();

  const factory JoinRoomState({
    @Default('') String code,
    @Default(false) bool submitting,

    /// Shown as the error card under the boxes (not found / full / started).
    Failure? error,

    /// Bumped on every error so the boxes shake again.
    @Default(0) int errorCount,

    /// Other failures (network, …) shown as a toast.
    Failure? transientFailure,
    String? joinedCode,
  }) = _JoinRoomState;

  bool get isComplete => RoomCode.isValid(code);

  bool get canSubmit => isComplete && !submitting && error == null;
}

class JoinRoomCubit extends Cubit<JoinRoomState> {
  JoinRoomCubit(this._rooms, this._profiles, this._haptics) : super(const JoinRoomState());

  final RoomRepository _rooms;
  final ProfileCubit _profiles;
  final Haptics _haptics;

  void codeChanged(String code) {
    if (code == state.code) return;
    emit(state.copyWith(code: code, error: null, transientFailure: null));
  }

  Future<void> submit() async {
    final profile = _profiles.state;
    if (!state.canSubmit || profile == null) return;
    emit(state.copyWith(submitting: true, transientFailure: null));
    final result = await _rooms.joinRoom(code: state.code, profile: profile);
    if (isClosed) return;
    result.match(
      (failure) {
        switch (failure) {
          case RoomNotFoundFailure() || RoomFullFailure() || GameStartedFailure():
            _haptics.heavy();
            emit(state.copyWith(
              submitting: false,
              error: failure,
              errorCount: state.errorCount + 1,
            ));
          default:
            emit(state.copyWith(submitting: false, transientFailure: failure));
        }
      },
      (_) => emit(state.copyWith(submitting: false, joinedCode: state.code)),
    );
  }
}
