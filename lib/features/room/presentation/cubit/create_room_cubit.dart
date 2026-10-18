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

    /// Questions available per category; counts above this are disabled.
    @Default(<String, int>{}) Map<String, int> available,
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

  int get availableInCategory => category == null ? 0 : available[category] ?? 0;

  bool isCountAllowed(int count) => count <= availableInCategory;

  bool get canCreate => !creating && category != null && isCountAllowed(questionCount);
}

class CreateRoomCubit extends Cubit<CreateRoomState> {
  CreateRoomCubit(this._questions, this._rooms, this._profiles) : super(const CreateRoomState());

  final QuestionRepository _questions;
  final RoomRepository _rooms;
  final ProfileCubit _profiles;

  Future<void> load() async {
    final result = await _questions.categories();
    if (isClosed) return;
    final categories = result.match((failure) {
      emit(state.copyWith(loadingCategories: false, failure: failure));
      return null;
    }, (c) => c);
    if (categories == null) return;

    final available = <String, int>{};
    for (final id in categories) {
      final questions = await _questions.questions(id);
      available[id] = questions.match((_) => 0, (q) => q.length);
    }
    if (isClosed) return;
    // Prefer "general" (the design default), else the first category.
    final initial = categories.contains(_defaultCategory)
        ? _defaultCategory
        : (categories.isEmpty ? null : categories.first);
    _emitFitted(
      state.copyWith(
        loadingCategories: false,
        categories: categories,
        available: available,
        category: initial,
      ),
    );
  }

  void selectCategory(String id) => _emitFitted(state.copyWith(category: id));

  void selectQuestionCount(int value) {
    if (state.isCountAllowed(value)) emit(state.copyWith(questionCount: value));
  }

  /// Drops the question count to the largest one the category can fill.
  void _emitFitted(CreateRoomState next) {
    if (next.isCountAllowed(next.questionCount)) return emit(next);
    final fitting = RoomRules.questionCounts.where(next.isCountAllowed);
    emit(fitting.isEmpty ? next : next.copyWith(questionCount: fitting.last));
  }

  static const String _defaultCategory = 'general';

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
