import 'dart:math';

/// Picks the questions for a game, preferring ones this room hasn't played.
/// Played ones come back (in random order) only once the category runs out.
abstract final class QuestionPicker {
  static List<String> pick({
    required List<String> available,
    required Set<String> used,
    required int count,
    required Random random,
  }) {
    final fresh = [
      for (final id in available)
        if (!used.contains(id)) id,
    ]..shuffle(random);
    if (fresh.length >= count) return fresh.take(count).toList();
    final replays = [
      for (final id in available)
        if (used.contains(id)) id,
    ]..shuffle(random);
    return [...fresh, ...replays].take(count).toList();
  }
}
