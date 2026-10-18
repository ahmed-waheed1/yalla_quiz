import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:yalla_quiz/core/constants/app_constants.dart';
import 'package:yalla_quiz/core/utils/room_code.dart';

void main() {
  group('RoomCode', () {
    test('generates valid codes without O, 0, I or 1', () {
      final random = Random(42);
      for (var i = 0; i < 500; i++) {
        final code = RoomCode.generate(random);
        expect(code, hasLength(RoomRules.codeLength));
        expect(RoomCode.isValid(code), isTrue, reason: code);
        expect(code, isNot(matches(RegExp('[OI01]'))));
      }
    });

    test('sanitize uppercases and drops characters outside the alphabet', () {
      expect(RoomCode.sanitize('k7x-p2q'), 'K7XP2Q');
      expect(RoomCode.sanitize('o0i1ab'), 'AB');
      expect(RoomCode.sanitize('ABCDEFGH'), 'ABCDEF');
    });

    test('fromScan reads invite links and bare codes', () {
      expect(RoomCode.fromScan(RoomCode.inviteLink('K7XP2Q')), 'K7XP2Q');
      expect(RoomCode.fromScan(' k7xp2q '), 'K7XP2Q');
      expect(RoomCode.fromScan('https://example.com/other'), isNull);
      expect(RoomCode.fromScan('HELLO WORLD'), isNull);
    });

    test('alphabet matches the regex in database.rules.json', () {
      final rulesRegex = RegExp(r'^[A-HJ-NP-Z2-9]{6}$');
      for (final ch in RoomRules.codeAlphabet.split('')) {
        expect(rulesRegex.hasMatch(ch * 6), isTrue, reason: ch);
      }
      expect(RoomRules.codeAlphabet.length, 32);
    });
  });
}
