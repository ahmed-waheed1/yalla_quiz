import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:yalla_quiz/features/game/domain/services/question_picker.dart';

void main() {
  final all = [for (var i = 0; i < 12; i++) 'general_$i'];

  test('picks distinct unused questions while there are enough', () {
    final used = all.take(5).toSet();
    final picked = QuestionPicker.pick(available: all, used: used, count: 5, random: Random(1));
    expect(picked, hasLength(5));
    expect(picked.toSet(), hasLength(5));
    expect(picked.any(used.contains), isFalse);
  });

  test('reuses played questions only once the category runs out', () {
    final used = all.take(10).toSet();
    final picked = QuestionPicker.pick(available: all, used: used, count: 5, random: Random(2));
    expect(picked.toSet(), hasLength(5));
    expect(picked.take(2).toSet(), {'general_10', 'general_11'});
    expect(picked.skip(2).every(used.contains), isTrue);
  });

  test('returns fewer when the category is smaller than the game', () {
    final picked = QuestionPicker.pick(
      available: all.take(3).toList(),
      used: const {},
      count: 5,
      random: Random(3),
    );
    expect(picked, hasLength(3));
  });
}
