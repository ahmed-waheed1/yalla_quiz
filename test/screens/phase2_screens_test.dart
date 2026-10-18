import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yalla_quiz/features/lobby/presentation/pages/lobby_page.dart';
import 'package:yalla_quiz/features/room/domain/entities/room.dart';
import 'package:yalla_quiz/features/room/presentation/pages/create_room_page.dart';

import '../helpers/fake_clock.dart';
import '../helpers/fakes.dart';
import '../helpers/pump_app.dart';

const Size kDesktop = Size(1440, 900);

/// A common laptop window, shorter than the desktop design.
const Size kLaptop = Size(1280, 800);

/// Renders every Phase 2 screen and state (07–11 on phones, 16–19 on the
/// spectator host's big screen, the reconnecting banner and the Create-room
/// hosting toggle) in light and dark, English and Arabic, and fails on any
/// FlutterError. Time is pinned with a FakeClock.
void main() {
  setUpAll(initTestEnvironment);

  final now = FakeClock().nowMs();
  const uids = ['nour', kMyUid, 'salma', 'youssef', 'mariam', 'karim', 'laila', 'hamza'];
  const names = ['Nour', 'Omar', 'Salma', 'Youssef', 'Mariam', 'Karim', 'Laila', 'Hamza'];
  const scores = [3420, 3330, 3150, 2980, 2410, 2050, 1720, 990];
  const lastPoints = [900, 850, 0, 0, 500, 700, 0, 0];

  /// Question 4 of 10 (index 3), 20 s per question, like the design.
  Room gameRoom(
    RoomStatus status, {
    int phaseAgoMs = 2000,
    int questionAgoMs = 6000,
    Map<String, int> answers = const {},
    bool spectatorHost = false,
    bool hostIsMe = false,
    int players = 8,
    int index = 3,
  }) {
    final questionStart = now - questionAgoMs;
    // Omar's points follow his answer (option 0 is right).
    final omarRight = answers[kMyUid] == 0 || status == RoomStatus.leaderboard;
    return sampleRoom(
      hostId: spectatorHost || hostIsMe ? kMyUid : 'nour',
      players: [
        for (var i = 0; i < players; i++)
          player(uids[i], names[i], i, joinedAt: i).copyWith(
            score: spectatorHost && uids[i] == kMyUid ? 0 : scores[i],
            lastPoints: uids[i] == kMyUid && (spectatorHost || !omarRight) ? 0 : lastPoints[i],
            streak: lastPoints[i] > 0 && (uids[i] != kMyUid || omarRight) ? 3 : 0,
            spectator: spectatorHost && uids[i] == kMyUid,
          ),
      ],
    ).copyWith(
      status: status,
      settings: const RoomSettings(category: 'general', questionCount: 10, timePerQuestion: 20),
      questionIds: [for (var i = 0; i < 10; i++) 'general_$i'],
      currentQuestionIndex: index,
      questionStartedAt: questionStart,
      phaseStartedAt: now - phaseAgoMs,
      scoredQuestionIndex: status == RoomStatus.question ? index - 1 : index,
      answers: {
        index: {
          for (final e in answers.entries)
            e.key: PlayerAnswer(option: e.value, answeredAt: questionStart + 3000),
        },
      },
    );
  }

  const fiveAnswered = {'nour': 0, 'salma': 1, 'youssef': 0, 'mariam': 2};
  Widget lobby(WidgetTester _) => const LobbyPage(code: 'K7XP2Q');

  final cases = <_Case>[
    // 07 Get ready
    _Case('07 get ready 3', gameRoom(RoomStatus.countdown, phaseAgoMs: 200), 'game.get_ready'),
    _Case('07 get ready yalla', gameRoom(RoomStatus.countdown, phaseAgoMs: 3300), 'game.yalla_sub'),
    // 08 Question
    _Case(
      '08 question unanswered',
      gameRoom(RoomStatus.question, answers: const {'nour': 0, 'salma': 1}),
      'game.pick_answer',
    ),
    _Case(
      '08 question selected',
      gameRoom(RoomStatus.question, questionAgoMs: 14000, answers: {...fiveAnswered, kMyUid: 2}),
      'game.locked_waiting',
    ),
    _Case(
      '08 question time up',
      gameRoom(RoomStatus.question, questionAgoMs: 20500, answers: fiveAnswered),
      'game.time_up_body',
    ),
    _Case(
      '08 question (spectator host on a phone)',
      gameRoom(RoomStatus.question, spectatorHost: true, answers: fiveAnswered),
      'game.answer_on_phone',
    ),
    _Case(
      '08 question (host who plays: keep the screen open)',
      gameRoom(RoomStatus.question, hostIsMe: true, answers: fiveAnswered),
      'game.keep_open',
    ),
    _Case(
      '08 question (player on a tablet)',
      gameRoom(RoomStatus.question, answers: fiveAnswered),
      'game.pick_answer',
      size: kTablet,
    ),
    _Case(
      '13 reconnecting over a question',
      gameRoom(RoomStatus.question, answers: fiveAnswered),
      'game.reconnecting_body',
      online: false,
    ),
    // 09 Reveal
    _Case(
      '09 reveal correct',
      gameRoom(RoomStatus.reveal, answers: {...fiveAnswered, kMyUid: 0}),
      'game.correct_title',
    ),
    _Case(
      '09 reveal wrong',
      gameRoom(RoomStatus.reveal, answers: {...fiveAnswered, kMyUid: 2}),
      'game.wrong_title',
    ),
    _Case(
      '09 reveal missed',
      gameRoom(RoomStatus.reveal, answers: fiveAnswered),
      'game.missed_title',
    ),
    _Case(
      '09 reveal suspense',
      gameRoom(RoomStatus.reveal, phaseAgoMs: 100, answers: {...fiveAnswered, kMyUid: 0}),
      'game.leaderboard_in',
    ),
    _Case(
      '09 reveal (last question)',
      gameRoom(RoomStatus.reveal, index: 9, answers: {...fiveAnswered, kMyUid: 0}),
      'game.results_in',
    ),
    // 10 Leaderboard
    _Case(
      '10 leaderboard (rows moving)',
      gameRoom(RoomStatus.leaderboard, phaseAgoMs: 400),
      'game.leaderboard',
    ),
    // Omar climbs from 4th to 2nd.
    _Case('10 leaderboard', gameRoom(RoomStatus.leaderboard), 'game.climbed', plural: 2),
    // 11 Final results
    _Case('11 final results', gameRoom(RoomStatus.finished, index: 9), 'game.play_again'),
    _Case(
      '11 final results (2 players)',
      gameRoom(RoomStatus.finished, index: 9, players: 2),
      'game.play_again',
    ),
    _Case(
      '11 final results → play again (waiting for the host)',
      gameRoom(RoomStatus.finished, index: 9),
      'lobby.wait_host',
      interact: (tester) async {
        await tester.tap(find.text('game.play_again'.tr()));
        await settle(tester, const Duration(milliseconds: 600));
      },
    ),
    // 16–19 Host big screen (spectator host)
    for (final size in [kTablet, kDesktop, kLaptop]) ...[
      _Case(
        '16 host question',
        gameRoom(RoomStatus.question, spectatorHost: true, answers: fiveAnswered),
        'game.answer_on_phone',
        size: size,
      ),
      _Case(
        '17 host reveal',
        gameRoom(RoomStatus.reveal, spectatorHost: true, answers: fiveAnswered),
        'lobby.room_chip',
        size: size,
      ),
      _Case(
        '18 host leaderboard',
        gameRoom(RoomStatus.leaderboard, spectatorHost: true),
        'game.leaderboard',
        size: size,
      ),
      _Case(
        '19 host final results',
        gameRoom(RoomStatus.finished, index: 9, spectatorHost: true),
        'game.play_again',
        size: size,
      ),
    ],
  ];

  final createCases = <_CreateCase>[
    _CreateCase('create room hosting toggle (phone: plays)', kPhone, 'create.host_plays_hint'),
    _CreateCase(
      'create room hosting toggle (tablet: big screen)',
      kTablet,
      'create.host_screen_hint',
    ),
    _CreateCase(
      'create room hosting toggle (phone → big screen)',
      kPhone,
      'create.host_screen_hint',
      interact: (tester) async {
        final toggle = find.text('create.host_screen'.tr());
        await tester.ensureVisible(toggle);
        await tester.tap(toggle);
        await settle(tester, const Duration(milliseconds: 600));
      },
    ),
  ];

  for (final brightness in Brightness.values) {
    for (final locale in const [Locale('en'), Locale('ar')]) {
      group('${brightness.name} ${locale.languageCode}', () {
        for (final c in cases) {
          testWidgets('${c.name}${_sizeLabel(c.size)}', (tester) async {
            registerFakes(
              rooms: FakeRoomRepository(room: c.room, online: c.online),
              clock: FakeClock(now),
            );
            await _render(
              tester,
              lobby(tester),
              c.size,
              brightness,
              locale,
              c.interact,
              () => c.plural == null ? c.expectKey.tr() : c.expectKey.plural(c.plural!),
            );
          });
        }
        for (final c in createCases) {
          testWidgets(c.name, (tester) async {
            registerFakes();
            await _render(
              tester,
              const CreateRoomPage(),
              c.size,
              brightness,
              locale,
              c.interact,
              c.expectKey.tr,
            );
          });
        }
      });
    }
  }
}

String _sizeLabel(Size size) => size == kPhone
    ? ''
    : size == kTablet
    ? ' [tablet]'
    : size == kLaptop
    ? ' [laptop]'
    : ' [desktop]';

Future<void> _render(
  WidgetTester tester,
  Widget page,
  Size size,
  Brightness brightness,
  Locale locale,
  Future<void> Function(WidgetTester)? interact,
  String Function() expectText,
) async {
  final recorder = FlutterErrorRecorder()..start();
  addTearDown(recorder.stop);
  await pumpScreen(tester, page, locale: locale, size: size, brightness: brightness);
  if (interact != null) await interact(tester);
  // Resolved after pumping, once the translations have loaded.
  final text = expectText();
  final stem = _stem(text);
  expect(
    find.byWidgetPredicate((w) => w is Text && (w.data ?? '').contains(stem), skipOffstage: false),
    findsWidgets,
    reason: text,
  );
  await settle(tester, const Duration(seconds: 1));
  expect(
    recorder.errors.map((e) => e.exceptionAsString()).toList(),
    isEmpty,
    reason: 'FlutterErrors (${brightness.name}, ${locale.languageCode}, $size)',
  );
  expect(tester.takeException(), isNull);
  await tester.pumpWidget(const SizedBox.shrink());
  await settle(tester, const Duration(seconds: 3));
}

/// The fixed part of a translation (before its first placeholder).
String _stem(String text) => text.split('{').first.trim();

class _Case {
  _Case(
    this.name,
    this.room,
    this.expectKey, {
    this.size = kPhone,
    this.online = true,
    this.interact,
    this.plural,
  });

  final String name;
  final Room room;
  final String expectKey;

  /// Count for a plural [expectKey].
  final int? plural;
  final Size size;
  final bool online;
  final Future<void> Function(WidgetTester tester)? interact;
}

class _CreateCase {
  _CreateCase(this.name, this.size, this.expectKey, {this.interact});

  final String name;
  final Size size;
  final String expectKey;
  final Future<void> Function(WidgetTester tester)? interact;
}
