import '../entities/room.dart';

/// Decides who takes over when the host leaves or drops. Pure logic, so every
/// client reaches the same answer and only one of them claims the room.
abstract final class HostSuccession {
  /// True when the host is gone or marked disconnected.
  static bool hostIsAway(Room room) {
    final host = room.host;
    return host == null || !host.connected;
  }

  /// The connected player who joined earliest, excluding [excludeUid] (normally
  /// the current host). Falls back to any remaining player when
  /// [allowDisconnected] is set (used when the host leaves on purpose).
  static RoomPlayer? successor(
    Room room, {
    required String excludeUid,
    bool allowDisconnected = false,
  }) {
    final candidates = room.players.where((p) => p.uid != excludeUid).toList();
    for (final p in candidates) {
      if (p.connected) return p;
    }
    return allowDisconnected && candidates.isNotEmpty ? candidates.first : null;
  }
}
