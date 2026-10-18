import 'dart:async';

/// Milliseconds since the epoch on the server's clock. Game code reads time
/// through this so tests can drive it with a fake clock.
abstract interface class Clock {
  int nowMs();
}

/// A pending callback from [Scheduler.schedule].
abstract interface class ScheduledTask {
  void cancel();
}

/// Runs callbacks after a delay. [TimerScheduler] in the app; a fake that
/// advances with the fake clock in tests.
abstract interface class Scheduler {
  ScheduledTask schedule(Duration delay, void Function() callback);
}

class TimerScheduler implements Scheduler {
  const TimerScheduler();

  @override
  ScheduledTask schedule(Duration delay, void Function() callback) =>
      _TimerTask(Timer(delay, callback));
}

class _TimerTask implements ScheduledTask {
  _TimerTask(this._timer);

  final Timer _timer;

  @override
  void cancel() => _timer.cancel();
}
