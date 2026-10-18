import 'package:flutter_test/flutter_test.dart';
import 'package:yalla_quiz/features/game/domain/services/standings.dart';
import 'package:yalla_quiz/features/room/domain/entities/room.dart';

import '../../helpers/fakes.dart';

void main() {
  final room = sampleRoom(
    hostId: 'host',
    players: [
      player('host', 'Nour', 0, joinedAt: 1).copyWith(spectator: true),
      player('a', 'Omar', 1, joinedAt: 2).copyWith(score: 3330, lastPoints: 850),
      player('b', 'Salma', 2, joinedAt: 3).copyWith(score: 3150, lastPoints: 0),
      player('c', 'Youssef', 3, joinedAt: 4).copyWith(score: 3420, lastPoints: 900),
      player('d', 'Mariam', 4, joinedAt: 5).copyWith(score: 3150, lastPoints: 0),
    ],
  ).copyWith(
    answers: {
      3: {
        'a': const PlayerAnswer(option: 1, answeredAt: 500),
        'b': const PlayerAnswer(option: 2, answeredAt: 100),
        'c': const PlayerAnswer(option: 1, answeredAt: 300),
      },
    },
  );

  test('ranks contestants by score, ties by join order, with deltas', () {
    final s = Standings.of(room);
    expect(s.map((x) => x.player.uid), ['c', 'a', 'b', 'd']);
    expect(s.map((x) => x.rank), [1, 2, 3, 4]);
    // Before: b 3150, d 3150, c 2520, a 2480.
    expect(s.map((x) => x.previousRank), [3, 4, 1, 2]);
    expect(s.map((x) => x.delta), [2, 2, -2, -2]);
  });

  test('vote counts per option', () {
    expect(Standings.votes(room, 3), [0, 2, 1, 0]);
    expect(Standings.votes(room, 0), [0, 0, 0, 0]);
  });

  test('fastest correct answer', () {
    final (p, points) = Standings.fastestCorrect(room, 3, 1)!;
    expect(p.uid, 'c');
    expect(points, 900);
    expect(Standings.fastestCorrect(room, 3, 3), isNull);
  });
}
