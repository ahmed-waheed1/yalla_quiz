import 'dart:math' as math;

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

/// Spoken lines, per language: `assets/sounds/voice/voice_<name>_<lang>.mp3`,
/// or several takes `voice_<name>_<lang>_1.mp3`, `_2`, … picked at random.
/// A language without a file for a line plays nothing for it.
enum YqVoice {
  count3('count_3'),
  count2('count_2'),
  count1('count_1'),
  yalla('yalla'),
  correct('correct'),
  wrong('wrong'),
  timeUp('time_up'),
  leaderboard('leaderboard'),
  victory('victory');

  const YqVoice(this.fileName);

  final String fileName;

  /// The spoken countdown digit (3, 2, 1), or "Yalla!" for 0.
  static YqVoice countdown(int digit) => switch (digit) {
    3 => count3,
    2 => count2,
    1 => count1,
    _ => yalla,
  };

  /// This line's files for [language] among [assets], in a stable order.
  List<String> takes(Iterable<String> assets, String language) {
    final pattern = RegExp('^assets/sounds/voice/voice_${fileName}_$language(_\\d+)?\\.mp3\$');
    return assets.where(pattern.hasMatch).toList()..sort();
  }
}

/// Plays an asset on a named channel. A new sound on a channel stops the one
/// before it; different channels mix.
abstract interface class SoundOutput {
  Future<void> play(String channel, String assetPath);

  Future<void> dispose();
}

/// [SoundOutput] on audioplayers, one player per channel.
class AudioplayersOutput implements SoundOutput {
  final Map<String, Future<AudioPlayer>> _players = {};

  // The default context takes audio focus on Android, so each new player
  // would stop the others (a voice line would cut its chime off). Mixing
  // also leaves the player's own music playing.
  static AudioContext get _mix =>
      AudioContextConfig(focus: AudioContextConfigFocus.mixWithOthers).build();

  Future<AudioPlayer> _player(String channel) => _players.putIfAbsent(channel, () async {
    final player = AudioPlayer();
    await player.setReleaseMode(ReleaseMode.stop);
    await player.setAudioContext(_mix);
    return player;
  });

  @override
  Future<void> play(String channel, String assetPath) async {
    final player = await _player(channel);
    await player.stop();
    // AssetSource paths are relative to `assets/`.
    await player.play(AssetSource(assetPath.substring('assets/'.length)));
  }

  @override
  Future<void> dispose() async {
    for (final p in _players.values) {
      await (await p).dispose();
    }
    _players.clear();
  }
}

/// Plays [YqSound]s when the Sound effects setting is on and [YqVoice] lines
/// when the Voice setting is on; each setting works on its own.
class SoundService {
  SoundService({AssetBundle? bundle, SoundOutput? output, math.Random? random})
    : _bundle = bundle ?? rootBundle,
      _output = output ?? AudioplayersOutput(),
      _random = random ?? math.Random();

  final AssetBundle _bundle;
  final SoundOutput _output;
  final math.Random _random;

  /// Sound effects.
  bool enabled = true;

  /// Voice lines.
  bool voiceEnabled = true;

  static const String _voiceChannel = 'voice';

  Set<String>? _available;

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
    await _play(sound.fileName, sound.assetPath);
  }

  /// Plays a take of [voice] in [language]. False when Voice is off or there's
  /// no file for that language, so the caller can fall back to an effect.
  Future<bool> playVoice(YqVoice voice, String language) async {
    if (!voiceEnabled) return false;
    final takes = voice.takes(await _assets(), language);
    if (takes.isEmpty) return false;
    await _play(_voiceChannel, takes[_random.nextInt(takes.length)]);
    return true;
  }

  Future<void> _play(String channel, String assetPath) async {
    try {
      await _output.play(channel, assetPath);
    } on Object catch (e) {
      log.w('Sound $assetPath failed', error: e);
    }
  }

  Future<void> dispose() => _output.dispose();
}
