import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

/// Server-aligned clock from `.info/serverTimeOffset`. Game timers are
/// computed from server timestamps with this, never from a local countdown.
class ServerClock {
  ServerClock(FirebaseDatabase database)
      : _offsetRef = database.ref('.info/serverTimeOffset');

  final DatabaseReference _offsetRef;
  StreamSubscription<DatabaseEvent>? _subscription;
  int _offsetMs = 0;

  void start() {
    _subscription ??= _offsetRef.onValue.listen((event) {
      final value = event.snapshot.value;
      if (value is num) _offsetMs = value.round();
    });
  }

  int get offsetMs => _offsetMs;

  int nowMs() => DateTime.now().millisecondsSinceEpoch + _offsetMs;

  Future<void> dispose() async => _subscription?.cancel();
}
