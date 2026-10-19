import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yalla_quiz/core/services/haptics.dart';
import 'package:yalla_quiz/core/services/sound_service.dart';
import 'package:yalla_quiz/features/game/presentation/game_feedback.dart';

import '../helpers/fakes.dart';

/// An asset bundle whose manifest lists [assets] and nothing else.
class _ManifestBundle extends CachingAssetBundle {
  _ManifestBundle(this.assets);

  final List<String> assets;

  @override
  Future<ByteData> load(String key) async {
    if (key != 'AssetManifest.bin') throw StateError('No asset $key');
    return const StandardMessageCodec().encodeMessage({for (final a in assets) a: <Object?>[]})!;
  }
}

const _voice = 'assets/sounds/voice';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeSoundOutput output;

  SoundService service(List<String> assets, {math.Random? random}) =>
      SoundService(bundle: _ManifestBundle(assets), output: output, random: random);

  setUp(() => output = FakeSoundOutput());

  group('YqVoice.takes', () {
    test('matches one file or numbered takes for the language only', () {
      final assets = [
        '$_voice/voice_correct_ar_2.mp3',
        '$_voice/voice_correct_ar_1.mp3',
        '$_voice/voice_correct_en.mp3',
        '$_voice/voice_correct_arx.mp3',
        '$_voice/voice_correct_ar_extra.mp3',
        'assets/sounds/voice_correct_ar.mp3',
      ];
      expect(YqVoice.correct.takes(assets, 'ar'), [
        '$_voice/voice_correct_ar_1.mp3',
        '$_voice/voice_correct_ar_2.mp3',
      ]);
      expect(YqVoice.correct.takes(assets, 'en'), ['$_voice/voice_correct_en.mp3']);
    });

    test('countdown maps 3, 2, 1 and 0 to their lines', () {
      expect([3, 2, 1, 0].map(YqVoice.countdown), [
        YqVoice.count3,
        YqVoice.count2,
        YqVoice.count1,
        YqVoice.yalla,
      ]);
    });
  });

  group('SoundService', () {
    test('plays a voice line on its own channel, in the given language', () async {
      final sound = service(['$_voice/voice_count_3_ar.mp3']);
      expect(await sound.playVoice(YqVoice.count3, 'ar'), isTrue);
      expect(await sound.playVoice(YqVoice.count3, 'en'), isFalse);
      expect(output.played, [('voice', '$_voice/voice_count_3_ar.mp3')]);
    });

    test('picks among the takes', () async {
      final sound = service([
        '$_voice/voice_correct_ar_1.mp3',
        '$_voice/voice_correct_ar_2.mp3',
      ], random: math.Random(1));
      for (var i = 0; i < 20; i++) {
        await sound.playVoice(YqVoice.correct, 'ar');
      }
      expect(output.assets.toSet(), {
        '$_voice/voice_correct_ar_1.mp3',
        '$_voice/voice_correct_ar_2.mp3',
      });
    });

    test('Voice and Sound effects mute independently', () async {
      final sound = service(['assets/sounds/correct.mp3', '$_voice/voice_correct_ar.mp3'])
        ..enabled = false;
      await sound.play(YqSound.correct);
      expect(await sound.playVoice(YqVoice.correct, 'ar'), isTrue);
      expect(output.assets, ['$_voice/voice_correct_ar.mp3']);

      sound
        ..enabled = true
        ..voiceEnabled = false;
      output.played.clear();
      await sound.play(YqSound.correct);
      expect(await sound.playVoice(YqVoice.correct, 'ar'), isFalse);
      expect(output.assets, ['assets/sounds/correct.mp3']);
    });

    test('skips effects without a file', () async {
      await service(const []).play(YqSound.victory);
      expect(output.played, isEmpty);
    });
  });

  group('GameFeedback', () {
    const assets = [
      'assets/sounds/countdown_tick.mp3',
      'assets/sounds/yalla.mp3',
      'assets/sounds/correct.mp3',
      '$_voice/voice_count_3_ar.mp3',
      '$_voice/voice_yalla_ar.mp3',
      '$_voice/voice_correct_ar.mp3',
    ];

    GameFeedback feedback(SoundService sound, String language) =>
        GameFeedback(Haptics()..enabled = false, sound, language: language);

    Future<void> settle() => Future<void>.delayed(Duration.zero);

    test('the spoken countdown replaces the tick and yalla effect', () async {
      final ar = feedback(service(assets), 'ar')
        ..countdown(3)
        ..countdown(0);
      await settle();
      expect(output.assets, ['$_voice/voice_count_3_ar.mp3', '$_voice/voice_yalla_ar.mp3']);
      expect(ar.language, 'ar');
    });

    test('the countdown falls back to effects without a voice file or with Voice off', () async {
      feedback(service(assets), 'en')
        ..countdown(3)
        ..countdown(0);
      await settle();
      expect(output.assets, ['assets/sounds/countdown_tick.mp3', 'assets/sounds/yalla.mp3']);

      output.played.clear();
      feedback(service(assets)..voiceEnabled = false, 'ar').countdown(3);
      await settle();
      expect(output.assets, ['assets/sounds/countdown_tick.mp3']);
    });

    test('a correct answer plays the chime and the voice line together', () async {
      feedback(service(assets), 'ar').correct();
      await settle();
      expect(output.played, [
        ('correct', 'assets/sounds/correct.mp3'),
        ('voice', '$_voice/voice_correct_ar.mp3'),
      ]);
    });
  });

  test('the bundled Arabic countdown has all four clips', () async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final assets = manifest.listAssets();
    for (final digit in [3, 2, 1, 0]) {
      expect(YqVoice.countdown(digit).takes(assets, 'ar'), hasLength(1), reason: '$digit');
    }
  });
}
