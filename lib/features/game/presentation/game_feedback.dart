import 'dart:async';

import '../../../core/services/haptics.dart';
import '../../../core/services/sound_service.dart';

/// Haptics, sound and voice for game moments, each behind its own setting.
/// Voice lines play in the device's app [language], on top of their effect,
/// except the countdown, where a spoken digit replaces the tick.
class GameFeedback {
  GameFeedback(this._haptics, this._sound, {required this.language});

  final Haptics _haptics;
  final SoundService _sound;

  /// The app language code (`en`, `ar`) that picks the voice files.
  final String language;

  static const Duration _doubleTapGap = Duration(milliseconds: 120);

  /// 3, 2, 1, then 0 for "Yalla!", as each appears on screen.
  void countdown(int digit) {
    digit == 0 ? _haptics.heavy() : _haptics.selection();
    unawaited(
      _voiceOr(YqVoice.countdown(digit), digit == 0 ? YqSound.yalla : YqSound.countdownTick),
    );
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

  void timeUp() => _both(YqSound.timeUp, YqVoice.timeUp);

  void correct() {
    _haptics.light();
    Future<void>.delayed(_doubleTapGap, _haptics.light);
    _both(YqSound.correct, YqVoice.correct);
  }

  void wrong() {
    _haptics.heavy();
    _both(YqSound.wrong, YqVoice.wrong);
  }

  void leaderboard() => _both(YqSound.leaderboard, YqVoice.leaderboard);

  void yourRow() => _haptics.selection();

  void crown() {
    _haptics.heavy();
    _both(YqSound.victory, YqVoice.victory);
  }

  void _both(YqSound sound, YqVoice voice) {
    unawaited(_sound.play(sound));
    unawaited(_sound.playVoice(voice, language));
  }

  Future<void> _voiceOr(YqVoice voice, YqSound fallback) async {
    if (!await _sound.playVoice(voice, language)) await _sound.play(fallback);
  }
}
