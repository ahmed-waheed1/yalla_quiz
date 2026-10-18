import 'package:flutter_test/flutter_test.dart';
import 'package:yalla_quiz/core/utils/json.dart';
import 'package:yalla_quiz/features/room/data/models/room_model.dart';
import 'package:yalla_quiz/features/room/domain/entities/room.dart';

Map<Object?, Object?> _room(Map<Object?, Object?> extra) => {
      'hostId': 'host',
      'status': 'question',
      'createdAt': 1,
      'settings': {'category': 'general', 'questionCount': 5, 'timePerQuestion': 10, 'maxPlayers': 8},
      'players': {
        'host': {'name': 'Nour', 'avatarSeed': 0, 'joinedAt': 1, 'connected': true, 'score': 0, 'spectator': true},
        'p1': {'name': 'Omar', 'avatarSeed': 1, 'joinedAt': 2, 'connected': true, 'score': 850},
      },
      ...extra,
    };

Room _parse(Map<Object?, Object?> raw) => RoomModel.fromJson(jsonMapOrNull(raw)!).toEntity('K7XP2Q');

void main() {
  test('answers parse from the list RTDB returns for dense question keys', () {
    final room = _parse(_room({
      'answers': [
        {'p1': {'option': 2, 'answeredAt': 100}},
        null,
        {'host': {'option': 0, 'answeredAt': 300}},
      ],
    }));
    expect(room.answersFor(0), {'p1': const PlayerAnswer(option: 2, answeredAt: 100)});
    expect(room.answersFor(1), isEmpty);
    expect(room.answersFor(2)['host']!.option, 0);
  });

  test('answers parse from a map with sparse question keys', () {
    final room = _parse(_room({
      'answers': {
        '3': {'p1': {'option': 1, 'answeredAt': 400}},
      },
    }));
    expect(room.answers.keys, [3]);
    expect(room.answersFor(3)['p1']!.answeredAt, 400);
  });

  test('scoring guard, used ids and spectators', () {
    final room = _parse(_room({
      'scoredQuestionIndex': 2,
      'usedQuestionIds': {'general_001': true, 'general_007': true},
    }));
    expect(room.scoredQuestionIndex, 2);
    expect(room.usedQuestionIds, {'general_001', 'general_007'});
    expect(room.player('host')!.spectator, isTrue);
    expect(room.contestants.map((p) => p.uid), ['p1']);
    expect(room.canStart, isFalse);
  });

  test('missing game fields default to empty', () {
    final room = _parse(_room({'status': 'lobby'}));
    expect(room.scoredQuestionIndex, isNull);
    expect(room.usedQuestionIds, isEmpty);
    expect(room.answers, isEmpty);
    expect(room.player('p1')!.spectator, isFalse);
  });
}
