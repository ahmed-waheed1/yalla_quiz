import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yalla_quiz/features/home/presentation/pages/home_page.dart';
import 'package:yalla_quiz/features/home/presentation/pages/splash_page.dart';
import 'package:yalla_quiz/features/lobby/presentation/pages/lobby_page.dart';
import 'package:yalla_quiz/features/room/domain/entities/room.dart';
import 'package:yalla_quiz/gen/assets.gen.dart';

import '../helpers/fake_clock.dart';
import '../helpers/fakes.dart';
import '../helpers/pump_app.dart';

/// Every screen that shows brand artwork picks the right SVG for the theme
/// (light/dark) and the language (en/ar), and the hero is never mirrored.
void main() {
  setUpAll(initTestEnvironment);

  Finder svg(String path) => find.byWidgetPredicate(
    (w) =>
        w is SvgPicture &&
        w.bytesLoader is SvgAssetLoader &&
        (w.bytesLoader as SvgAssetLoader).assetName == path,
  );

  String wordmark(String lang, Brightness b) {
    final i = Assets.images;
    final dark = b == Brightness.dark;
    return lang == 'ar'
        ? (dark ? i.wordmarkArDark : i.wordmarkArLight)
        : (dark ? i.wordmarkEnDark : i.wordmarkEnLight);
  }

  final now = FakeClock().nowMs();
  Room room(RoomStatus status, {int phaseAgoMs = 0, bool spectatorHost = false}) =>
      sampleRoom(
        hostId: spectatorHost ? kMyUid : 'nour',
        players: [
          player('nour', 'Nour', 0, joinedAt: 1),
          player(kMyUid, 'Omar', 1, joinedAt: 2).copyWith(spectator: spectatorHost),
          player('salma', 'Salma', 2, joinedAt: 3),
        ],
      ).copyWith(
        status: status,
        questionIds: [for (var i = 0; i < 10; i++) 'general_$i'],
        phaseStartedAt: now - phaseAgoMs,
        questionStartedAt: now - phaseAgoMs,
      );

  Future<void> pump(
    WidgetTester tester,
    Widget page,
    String lang,
    Brightness b, {
    Room? r,
    Size size = kPhone,
    bool settleAfter = true,
  }) async {
    registerFakes(
      rooms: FakeRoomRepository(room: r),
      clock: FakeClock(now),
    );
    await pumpScreen(
      tester,
      page,
      locale: Locale(lang),
      brightness: b,
      size: size,
      settleAfter: settleAfter,
    );
  }

  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await settle(tester, const Duration(seconds: 3));
  }

  for (final b in Brightness.values) {
    for (final lang in const ['en', 'ar']) {
      group('${b.name} $lang', () {
        testWidgets('splash: wordmark', (tester) async {
          // The splash routes on after its 1.1 s intro; check mid-way.
          await pump(tester, const SplashPage(), lang, b, settleAfter: false);
          await settle(tester, const Duration(milliseconds: 500));
          expect(svg(wordmark(lang, b)), findsOneWidget);
          await unmount(tester);
        });

        testWidgets('home: wordmark and hero (never mirrored)', (tester) async {
          await pump(tester, const HomePage(), lang, b);
          expect(svg(wordmark(lang, b)), findsOneWidget);
          final hero = b == Brightness.dark ? Assets.images.heroDark : Assets.images.heroLight;
          expect(svg(hero), findsOneWidget);
          expect(tester.widget<SvgPicture>(svg(hero)).matchTextDirection, isFalse);
          await unmount(tester);
        });

        testWidgets('07 "Yalla!" frame', (tester) async {
          await pump(
            tester,
            const LobbyPage(code: 'K7XP2Q'),
            lang,
            b,
            r: room(RoomStatus.countdown, phaseAgoMs: 3300),
          );
          expect(svg(lang == 'ar' ? Assets.images.yallaAr : Assets.images.yallaEn), findsOneWidget);
          await unmount(tester);
        });

        testWidgets('15 host lobby: brand row', (tester) async {
          await pump(
            tester,
            const LobbyPage(code: 'K7XP2Q'),
            lang,
            b,
            r: room(RoomStatus.lobby),
            size: kTablet,
          );
          expect(svg(wordmark(lang, b)), findsOneWidget);
          await unmount(tester);
        });

        testWidgets('16 host big screen: brand row', (tester) async {
          await pump(
            tester,
            const LobbyPage(code: 'K7XP2Q'),
            lang,
            b,
            r: room(RoomStatus.question, spectatorHost: true),
            size: kTablet,
          );
          expect(svg(wordmark(lang, b)), findsOneWidget);
          await unmount(tester);
        });
      });
    }
  }
}
