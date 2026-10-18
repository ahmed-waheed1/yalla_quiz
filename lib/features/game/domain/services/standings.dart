import '../../../room/domain/entities/room.dart';

/// A contestant's place on the leaderboard.
final class Standing {
  const Standing({required this.player, required this.rank, required this.previousRank});

  final RoomPlayer player;

  /// 1-based, after the latest scored question.
  final int rank;

  /// 1-based, before the latest scored question (score − lastPoints).
  final int previousRank;

  /// Places climbed (positive) or dropped (negative).
  int get delta => previousRank - rank;
}

/// Rankings, vote counts and the fastest answer, derived from the room.
/// Pure, so every device shows the same order.
abstract final class Standings {
  /// Contestants by score (highest first); ties keep join order.
  static List<Standing> of(Room room) {
    final now = _ranked(room.contestants, (p) => p.score);
    final before = _ranked(room.contestants, (p) => p.score - p.lastPoints);
    final previousRank = {for (var i = 0; i < before.length; i++) before[i].uid: i + 1};
    return [
      for (var i = 0; i < now.length; i++)
        Standing(player: now[i], rank: i + 1, previousRank: previousRank[now[i].uid]!),
    ];
  }

  static List<RoomPlayer> _ranked(List<RoomPlayer> players, int Function(RoomPlayer) score) {
    final order = {for (var i = 0; i < players.length; i++) players[i].uid: i};
    return [...players]..sort((a, b) {
      final byScore = score(b).compareTo(score(a));
      return byScore != 0 ? byScore : order[a.uid]!.compareTo(order[b.uid]!);
    });
  }

  /// How many players picked each option for question [index].
  static List<int> votes(Room room, int index) {
    final counts = List<int>.filled(4, 0);
    for (final a in room.answersFor(index).values) {
      if (a.option >= 0 && a.option < counts.length) counts[a.option]++;
    }
    return counts;
  }

  /// The contestant who answered [correctOption] first, with their points.
  static (RoomPlayer, int)? fastestCorrect(Room room, int index, int correctOption) {
    RoomPlayer? best;
    var bestAt = 0;
    for (final e in room.answersFor(index).entries) {
      final p = room.player(e.key);
      if (p == null || p.spectator || e.value.option != correctOption) continue;
      if (best == null || e.value.answeredAt < bestAt) {
        best = p;
        bestAt = e.value.answeredAt;
      }
    }
    return best == null ? null : (best, best.lastPoints);
  }
}
