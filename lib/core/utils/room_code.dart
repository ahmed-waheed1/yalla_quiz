import 'dart:math';

import '../constants/app_constants.dart';

abstract final class RoomCode {
  static final RegExp _valid = RegExp(
    '^[${RoomRules.codeAlphabet}]{${RoomRules.codeLength}}\$',
  );

  static String generate([Random? random]) {
    final r = random ?? Random.secure();
    return List.generate(
      RoomRules.codeLength,
      (_) => RoomRules.codeAlphabet[r.nextInt(RoomRules.codeAlphabet.length)],
    ).join();
  }

  static bool isValid(String code) => _valid.hasMatch(code);

  /// Uppercases and drops anything outside the alphabet (typed or pasted).
  static String sanitize(String input) => input
      .toUpperCase()
      .split('')
      .where(RoomRules.codeAlphabet.contains)
      .take(RoomRules.codeLength)
      .join();

  /// Pulls a room code out of a scanned QR payload: an invite link
  /// (`…/join?code=K7XP2Q`) or a bare code.
  static String? fromScan(String raw) {
    final trimmed = raw.trim();
    final uri = Uri.tryParse(trimmed);
    final isLink = uri != null && uri.hasScheme;
    final candidate = isLink ? uri.queryParameters['code'] : trimmed;
    if (candidate == null || candidate.length != RoomRules.codeLength) return null;
    final code = sanitize(candidate);
    return isValid(code) ? code : null;
  }

  static String inviteLink(String code) => '$kInviteBaseUrl?code=$code';
}
