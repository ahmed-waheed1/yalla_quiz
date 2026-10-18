import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/failure.dart';
import '../../../game/domain/repositories/question_repository.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../../domain/entities/room.dart';
import '../../domain/repositories/room_repository.dart';

part 'create_room_cubit.freezed.dart';

@freezed
abstract class CreateRoomState with _$CreateRoomState {
  const CreateRoomState._();

  const factory CreateRoomState({
    @Default(<String>[]) List<String> categories,
    @Default(true) bool loadingCategories,
    String? category,
    @Default(RoomRules.defaultQuestionCount) int questionCount,
    @Default(RoomRules.defaultTimePerQuestion) int timePerQuestion,
    @Default(false) bool creating,
    Failure? failure,

    /// Set once the room exists; the page navigates to its lobby.
    String? createdCode,
  }) = _CreateRoomState;

  RoomSettings? get settings => category == null
      ? null
      : RoomSettings(
          category: category!,
          questionCount: questionCount,
          timePerQuestion: timePerQuestion,
        );

  bool get canCreate => !creating && category != null;
}

class CreateRoomCubit extends Cubit<CreateRoomState> {
  CreateRoomCubit(this._questions, this._rooms, this._profiles) : super(const CreateRoomState());

  final QuestionRepository _questions;
  final RoomRepository _rooms;
  final ProfileCubit _profiles;

  Future<void> load() async {
    final result = await _questions.categories();
    if (isClosed) return;
    result.match(
      (failure) => emit(state.copyWith(loadingCategories: false, failure: failure)),
      (categories) => emit(
        state.copyWith(
          loadingCategories: false,
          categories: categories,
          category: categories.isEmpty ? null : categories.first,
        ),
      ),
    );
  }

  void selectCategory(String id) => emit(state.copyWith(category: id));

  void selectQuestionCount(int value) => emit(state.copyWith(questionCount: value));

  void selectTimePerQuestion(int value) => emit(state.copyWith(timePerQuestion: value));

  Future<void> create() async {
    final settings = state.settings;
    final profile = _profiles.state;
    if (!state.canCreate || settings == null || profile == null) return;
    emit(state.copyWith(creating: true, failure: null));
    final result = await _rooms.createRoom(settings: settings, profile: profile);
    if (isClosed) return;
    result.match(
      (failure) => emit(state.copyWith(creating: false, failure: failure)),
      (code) => emit(state.copyWith(creating: false, createdCode: code)),
    );
  }
}
