import 'package:flutter_test/flutter_test.dart';
import 'package:yalla_quiz/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:yalla_quiz/features/room/presentation/cubit/create_room_cubit.dart';

import '../../helpers/fakes.dart';
import '../../helpers/pump_app.dart';

void main() {
  Future<CreateRoomCubit> loaded(Map<String, int> counts) async {
    final profiles = ProfileCubit(FakeProfileRepository(kNour))..load();
    final cubit = CreateRoomCubit(
      FakeQuestionRepository(counts: counts),
      FakeRoomRepository(),
      profiles,
    );
    await cubit.load();
    return cubit;
  }

  test('defaults to general with 10 questions when it has 30', () async {
    final cubit = await loaded({'general': 30, 'music': 8});
    expect(cubit.state.category, 'general');
    expect(cubit.state.questionCount, 10);
    expect([5, 10, 15].map(cubit.state.isCountAllowed), [true, true, true]);
    expect(cubit.state.canCreate, isTrue);
  });

  test('a small category disables larger counts and drops the selection to fit', () async {
    final cubit = await loaded({'general': 30, 'music': 8});
    cubit.selectCategory('music');
    expect([5, 10, 15].map(cubit.state.isCountAllowed), [true, false, false]);
    expect(cubit.state.questionCount, 5);
    expect(cubit.state.canCreate, isTrue);

    cubit.selectQuestionCount(15);
    expect(cubit.state.questionCount, 5, reason: 'disabled counts cannot be picked');
  });

  test('a category with too few questions for any count cannot be created', () async {
    final cubit = await loaded({'general': 30, 'food': 3});
    cubit.selectCategory('food');
    expect(cubit.state.canCreate, isFalse);
  });

  test('switching back keeps the reduced count (still valid)', () async {
    final cubit = await loaded({'general': 30, 'music': 12});
    cubit.selectCategory('music');
    expect(cubit.state.questionCount, 10);
    cubit.selectCategory('general');
    expect(cubit.state.questionCount, 10);
  });
}
