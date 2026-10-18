import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

import '../utils/log.dart';

/// Game sound effects. Files go in `assets/sounds/<name>.mp3`; a missing
/// file is skipped silently, so sounds can be dropped in later.
enum YqSound {
  countdownTick('countdown_tick'),
  yalla('yalla'),
  lockIn('lock_in'),
  timerTick('timer_tick'),
  timeUp('time_up'),
  correct('correct'),
  wrong('wrong'),
  leaderboard('leaderboard'),
  victory('victory');

  const YqSound(this.fileName);

  final String fileName;

  String get assetPath => 'assets/sounds/$fileName.mp3';
}

/// Plays [YqSound]s when the Sound effects setting is on.
class SoundService {
  SoundService({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;

  bool enabled = true;

  Set<String>? _available;
  final Map<YqSound, AudioPlayer> _players = {};

  Future<Set<String>> _assets() async {
    if (_available != null) return _available!;
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(_bundle);
      _available = manifest.listAssets().where((a) => a.startsWith('assets/sounds/')).toSet();
    } on Object catch (e) {
      log.w('Sound manifest unavailable', error: e);
      _available = const {};
    }
    return _available!;
  }

  Future<void> play(YqSound sound) async {
    if (!enabled) return;
    if (!(await _assets()).contains(sound.assetPath)) return;
    try {
      final player = _players.putIfAbsent(
        sound,
        () => AudioPlayer()..setReleaseMode(ReleaseMode.stop),
      );
      await player.stop();
      // AssetSource paths are relative to `assets/`.
      await player.play(AssetSource('sounds/${sound.fileName}.mp3'));
    } on Object catch (e) {
      log.w('Sound ${sound.fileName} failed', error: e);
    }
  }

  Future<void> dispose() async {
    for (final p in _players.values) {
      await p.dispose();
    }
    _players.clear();
  }
}
