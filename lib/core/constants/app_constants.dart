/// Realtime Database instance (europe-west1). flutterfire doesn't write it to
/// firebase_options.dart, so it lives here and is passed to
/// `FirebaseDatabase.instanceFor` in DI.
const String kDatabaseUrl =
    'https://yalla-quiz-8b2a9-default-rtdb.europe-west1.firebasedatabase.app';

/// `flutter run --dart-define=YQ_EMULATOR=true` talks to the local Firebase
/// emulators (`firebase emulators:start --only auth,database`).
const bool kUseFirebaseEmulators = bool.fromEnvironment('YQ_EMULATOR');
const String kEmulatorHost = String.fromEnvironment('YQ_EMULATOR_HOST', defaultValue: '127.0.0.1');

/// Base for the invite deep link encoded in the lobby QR code.
const String kInviteBaseUrl = 'https://yalla-quiz-8b2a9.web.app/join';

const String kAppVersion = '1.0.0';

abstract final class RoomRules {
  /// A–Z and 2–9 without O/0 and I/1. Mirrors the regex in database.rules.json.
  static const String codeAlphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  static const int codeLength = 6;
  static const int maxPlayers = 8;
  static const int minPlayersToStart = 2;
  static const int nameMaxLength = 12;
  static const int avatarCount = 8;

  static const List<int> questionCounts = [5, 10, 15];
  static const List<int> timesPerQuestion = [10, 15, 20];
  static const int defaultQuestionCount = 10;
  static const int defaultTimePerQuestion = 20;

  /// Rough per-question overhead (reveal + leaderboard) for the "about N min" summary.
  static const int overheadSecondsPerQuestion = 10;

  /// How long a disconnected host gets to come back before someone takes over.
  static const Duration hostReconnectGrace = Duration(seconds: 10);

  /// Rooms older than this can be overwritten by a new room with the same code.
  static const Duration staleRoomAge = Duration(hours: 2);

  static const int createAttempts = 5;
}

/// Phase lengths for the game loop (spec 07, 09, 10). The host advances when
/// `phaseStartedAt` (or `questionStartedAt`) plus these has passed on the
/// server clock.
abstract final class GameTiming {
  /// 3, 2, 1 at a second each, then a second of "Yalla!". Before question 1 only.
  static const Duration countdown = Duration(seconds: 4);

  /// 600 ms suspense, then the 3 s "Leaderboard in 3…" bar.
  static const Duration reveal = Duration(milliseconds: 3600);

  /// "Question 5 in 5…".
  static const Duration leaderboard = Duration(seconds: 5);

  /// Late answers are accepted this long after the timer hits 0 (mirrors the
  /// rules), so the host reveals only once it has passed.
  static const Duration answerGrace = Duration(seconds: 1);

  /// How soon the host retries a phase write that failed.
  static const Duration retryDelay = Duration(seconds: 1);
}

abstract final class Breakpoints {
  static const double tablet = 600;
  static const double desktop = 1024;

  /// Phone-style screens are centred at this width on tablet and desktop.
  static const double phoneContentMaxWidth = 480;
}
