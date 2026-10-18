import 'package:flutter_test/flutter_test.dart';
import 'package:yalla_quiz/features/room/domain/entities/room.dart';
import 'package:yalla_quiz/features/room/domain/services/host_succession.dart';

RoomPlayer _p(String uid, int joinedAt, {bool connected = true}) =>
    RoomPlayer(uid: uid, name: uid, avatarSeed: 0, joinedAt: joinedAt, connected: connected);

Room _room(String hostId, List<RoomPlayer> players) => Room(
  code: 'K7XP2Q',
  hostId: hostId,
  status: RoomStatus.lobby,
  createdAt: 0,
  settings: const RoomSettings(category: 'general'),
  players: players,
);

void main() {
  group('HostSuccession', () {
    test('host is away when disconnected or missing', () {
      expect(HostSuccession.hostIsAway(_room('a', [_p('a', 1)])), isFalse);
      expect(HostSuccession.hostIsAway(_room('a', [_p('a', 1, connected: false)])), isTrue);
      expect(HostSuccession.hostIsAway(_room('a', [_p('b', 2)])), isTrue);
    });

    test('successor is the earliest connected joiner other than the host', () {
      final room = _room('a', [
        _p('a', 1, connected: false),
        _p('b', 2, connected: false),
        _p('c', 3),
        _p('d', 4),
      ]);
      expect(HostSuccession.successor(room, excludeUid: 'a')?.uid, 'c');
    });

    test('falls back to a disconnected player only when allowed', () {
      final room = _room('a', [_p('a', 1), _p('b', 2, connected: false)]);
      expect(HostSuccession.successor(room, excludeUid: 'a'), isNull);
      expect(HostSuccession.successor(room, excludeUid: 'a', allowDisconnected: true)?.uid, 'b');
    });

    test('no successor when the host is alone', () {
      final room = _room('a', [_p('a', 1)]);
      expect(HostSuccession.successor(room, excludeUid: 'a', allowDisconnected: true), isNull);
    });
  });

  test('estimatedMinutes matches the design summary (10 × 20 s ≈ 5 min)', () {
    expect(const RoomSettings(category: 'general').estimatedMinutes, 5);
  });
}
