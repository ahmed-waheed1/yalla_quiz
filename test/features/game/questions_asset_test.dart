import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yalla_quiz/features/game/data/models/question_model.dart';

/// Validates every bundled question file against the format the game needs.
void main() {
  final files = Directory('assets/questions').listSync().whereType<File>().where((f) => f.path.endsWith('.json'));

  test('there is at least one question file', () => expect(files, isNotEmpty));

  for (final file in files) {
    group(file.uri.pathSegments.last, () {
      final raw = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      final questions = raw.map((e) => QuestionModel.fromJson(e as Map<String, dynamic>)).toList();
      final category = file.uri.pathSegments.last.replaceAll('.json', '');

      test('has enough questions for the default count', () {
        expect(questions.length, greaterThanOrEqualTo(10));
      });

      test('ids are unique and prefixed with the category', () {
        final ids = questions.map((q) => q.id).toList();
        expect(ids.toSet().length, ids.length);
        for (final id in ids) {
          expect(id, startsWith('${category}_'));
        }
      });

      test('every question has en and ar text, 4 distinct options and a valid answer', () {
        for (final q in questions) {
          for (final loc in [q.en, q.ar]) {
            expect(loc.q.trim(), isNotEmpty, reason: q.id);
            expect(loc.options, hasLength(4), reason: q.id);
            expect(loc.options.toSet(), hasLength(4), reason: '${q.id}: duplicate option');
            expect(loc.options.every((o) => o.trim().isNotEmpty), isTrue, reason: q.id);
          }
          expect(q.answer, inInclusiveRange(0, 3), reason: q.id);
        }
      });

      test('Arabic text is actually Arabic', () {
        final arabic = RegExp('[؀-ۿ]');
        for (final q in questions) {
          expect(arabic.hasMatch(q.ar.q), isTrue, reason: q.id);
        }
      });
    });
  }

  test('general has 30 questions', () {
    final raw = jsonDecode(File('assets/questions/general.json').readAsStringSync()) as List;
    expect(raw, hasLength(30));
  });
}
