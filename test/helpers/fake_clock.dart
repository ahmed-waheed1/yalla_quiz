import 'dart:math';

import 'package:yalla_quiz/core/services/clock.dart';

/// A server clock and scheduler that only move when the test says so.
class FakeClock implements Clock, Scheduler {
  FakeClock([this._now = 1700000000000]);

  int _now;
  int _seq = 0;
  final List<_FakeTask> _tasks = [];

  @override
  int nowMs() => _now;

  @override
  ScheduledTask schedule(Duration delay, void Function() callback) {
    final task = _FakeTask(_now + max(0, delay.inMilliseconds), _seq++, callback);
    _tasks.add(task);
    return task;
  }

  /// Moves time forward, running every task that falls due on the way (in
  /// order) and letting the async work they start finish.
  Future<void> advance(Duration by) async {
    final target = _now + by.inMilliseconds;
    await flush();
    while (true) {
      _tasks.removeWhere((t) => t.cancelled);
      final due = _tasks.where((t) => t.at <= target).toList()
        ..sort((a, b) => a.at != b.at ? a.at.compareTo(b.at) : a.seq.compareTo(b.seq));
      if (due.isEmpty) break;
      final task = due.first;
      _tasks.remove(task);
      _now = max(_now, task.at);
      task.callback();
      await flush();
    }
    _now = target;
    await flush();
  }

  Future<void> advanceMs(int ms) => advance(Duration(milliseconds: ms));

  /// Lets pending futures and microtasks run.
  static Future<void> flush() async {
    for (var i = 0; i < 5; i++) {
      await Future<void>.delayed(Duration.zero);
    }
  }
}

class _FakeTask implements ScheduledTask {
  _FakeTask(this.at, this.seq, this.callback);

  final int at;
  final int seq;
  final void Function() callback;
  bool cancelled = false;

  @override
  void cancel() => cancelled = true;
}
