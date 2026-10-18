abstract final class Routes {
  static const String splash = '/';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String createRoom = '/create';
  static const String joinRoom = '/join';
  static const String scan = '/join/scan';
  static const String lobby = '/lobby/:code';

  static String lobbyFor(String code) => '/lobby/$code';

  /// `?code=` pre-fills the join screen (invite links, QR scans).
  static String joinWith(String code) => '$joinRoom?code=$code';

  /// After first-run profile setup, continue to [next] (defaults to home).
  static String profileThen(String next) => '$profile?next=${Uri.encodeComponent(next)}';
}
