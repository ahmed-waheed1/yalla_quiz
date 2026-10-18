import 'dart:async';

import '../../../core/services/haptics.dart';
import '../../../core/services/sound_service.dart';

/// Haptics + sound for game moments. Both respect their settings.
class GameFeedback {
  GameFeedback(this._haptics, this._sound);

  final Haptics _haptics;
  final SoundService _sound;

  static const Duration _doubleTapGap = Duration(milliseconds: 120);

  void countdownDigit() {
    _haptics.selection();
    unawaited(_sound.play(YqSound.countdownTick));
  }

  void yalla() {
    _haptics.heavy();
    unawaited(_sound.play(YqSound.yalla));
  }

  void lockIn() {
    _haptics.medium();
    unawaited(_sound.play(YqSound.lockIn));
  }

  /// Each second of the last five, while the player hasn't answered.
  void panicTick() {
    _haptics.light();
    unawaited(_sound.play(YqSound.timerTick));
  }

  void timeUp() => unawaited(_sound.play(YqSound.timeUp));

  void correct() {
    _haptics.light();
    Future<void>.delayed(_doubleTapGap, _haptics.light);
    unawaited(_sound.play(YqSound.correct));
  }

  void wrong() {
    _haptics.heavy();
    unawaited(_sound.play(YqSound.wrong));
  }

  void leaderboard() => unawaited(_sound.play(YqSound.leaderboard));

  void yourRow() => _haptics.selection();

  void crown() {
    _haptics.heavy();
    unawaited(_sound.play(YqSound.victory));
  }
}
