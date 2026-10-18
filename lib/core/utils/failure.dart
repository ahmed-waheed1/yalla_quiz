/// Errors that repositories return on the Left side of an Either.
sealed class Failure {
  const Failure();
}

final class NetworkFailure extends Failure {
  const NetworkFailure();
}

final class PermissionFailure extends Failure {
  const PermissionFailure([this.message]);
  final String? message;
}

final class RoomNotFoundFailure extends Failure {
  const RoomNotFoundFailure();
}

final class RoomFullFailure extends Failure {
  const RoomFullFailure(this.maxPlayers);
  final int maxPlayers;
}

final class GameStartedFailure extends Failure {
  const GameStartedFailure();
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([this.message]);
  final String? message;
}
