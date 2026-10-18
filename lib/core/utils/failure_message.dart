import 'package:easy_localization/easy_localization.dart';

import 'failure.dart';

/// Generic user-facing text for a failure. Screens with dedicated error UI
/// (e.g. Join room) handle their specific failures themselves.
String failureMessage(Failure failure) => switch (failure) {
      NetworkFailure() => 'common.error_network'.tr(),
      RoomNotFoundFailure() => 'join.invalid_title'.tr(),
      RoomFullFailure(:final maxPlayers) =>
        'join.full_title'.tr(args: ['$maxPlayers', '$maxPlayers']),
      GameStartedFailure() => 'join.started_title'.tr(),
      PermissionFailure() || UnexpectedFailure() => 'common.error_generic'.tr(),
    };
