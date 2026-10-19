import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/yq_colors.dart';
import '../../../../core/theme/yq_spacing.dart';
import '../../../../core/theme/yq_typography.dart';
import '../../../../core/utils/failure_message.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/yq_app_bar.dart';
import '../../../../core/widgets/yq_brand.dart';
import '../../../../core/widgets/yq_button.dart';
import '../../../../core/widgets/yq_chip.dart';
import '../../../../core/widgets/yq_confirm_dialog.dart';
import '../../../../core/widgets/yq_dot_grid.dart';
import '../../../../core/widgets/yq_keep_screen_awake.dart';
import '../../../../core/widgets/yq_ltr.dart';
import '../../../../core/widgets/yq_pressable.dart';
import '../../../../core/widgets/yq_scaffold.dart';
import '../../../../core/widgets/yq_spinner.dart';
import '../../../../core/widgets/yq_toast.dart';
import '../../../game/presentation/cubit/game_cubit.dart';
import '../../../game/presentation/game_feedback.dart';
import '../../../game/presentation/pages/game_view.dart';
import '../../../room/domain/entities/room.dart';
import '../cubit/lobby_cubit.dart';
import '../widgets/lobby_parts.dart';
import '../widgets/player_grid.dart';
import '../widgets/room_qr.dart';

/// The room for its whole life: 06 Lobby (phone) / 15 host lobby (tablet,
/// desktop), then the game (07–11, 16–19) once the host starts. [LobbyCubit]
/// keeps the session (room, presence, host takeover); [GameCubit] the game.
class LobbyPage extends StatelessWidget {
  const LobbyPage({super.key, required this.code});

  final String code;

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => LobbyCubit(code: code, rooms: getIt(), haptics: getIt())..start(),
      ),
      BlocProvider(
        create: (_) => GameCubit(
          code: code,
          rooms: getIt(),
          questions: getIt(),
          clock: getIt(),
          scheduler: getIt(),
        ),
      ),
    ],
    child: const _LobbyView(),
  );
}

class _LobbyView extends StatelessWidget {
  const _LobbyView();

  Future<void> _requestLeave(BuildContext context) async {
    final cubit = context.read<LobbyCubit>();
    final state = cubit.state;
    if (state.room == null) {
      context.go(Routes.home);
      return;
    }
    if (_inGame(state.room!, context.read<GameCubit>().state)) {
      final confirmed = await showYqConfirm(
        context,
        title: 'game.leave_title'.tr(),
        body: 'game.leave_body'.tr(),
        confirmLabel: 'lobby.leave_confirm'.tr(),
        cancelLabel: 'lobby.leave_cancel'.tr(),
      );
      if (!confirmed) return;
    } else if (state.isHost) {
      final confirmed = await showYqConfirm(
        context,
        title: 'lobby.leave_title'.tr(),
        body: state.room!.players.length > 1 ? 'lobby.leave_body_host'.tr() : null,
        confirmLabel: 'lobby.leave_confirm'.tr(),
        cancelLabel: 'lobby.leave_cancel'.tr(),
      );
      if (!confirmed) return;
    }
    await cubit.leave();
  }

  void _start(BuildContext context) => context.read<GameCubit>().startGame();

  /// Everything but the lobby, unless this player already tapped "Play
  /// again" and is waiting there for the host.
  static bool _inGame(Room room, GameState game) =>
      room.status != RoomStatus.lobby && !(room.status == RoomStatus.finished && game.rematch);

  @override
  Widget build(BuildContext context) {
    final feedback = GameFeedback(getIt(), getIt());
    return MultiBlocListener(
      listeners: [
        BlocListener<LobbyCubit, LobbyState>(
          listenWhen: (a, b) => a.room != b.room || a.myUid != b.myUid,
          listener: (context, state) {
            final room = state.room;
            final uid = state.myUid;
            if (room != null && uid != null) context.read<GameCubit>().onRoom(room, uid);
          },
        ),
        BlocListener<GameCubit, GameState>(
          listenWhen: (a, b) => a.failureCount != b.failureCount,
          listener: (context, state) => YqToast.show(context, failureMessage(state.failure!)),
        ),
      ],
      child: _build(context, feedback),
    );
  }

  Widget _build(BuildContext context, GameFeedback feedback) {
    final game = context.watch<GameCubit>().state;
    return BlocConsumer<LobbyCubit, LobbyState>(
      listenWhen: (a, b) => a.status != b.status || a.promotedCount != b.promotedCount,
      listener: (context, state) {
        switch (state.status) {
          case LobbyStatus.closed:
            YqToast.show(context, 'lobby.closed'.tr());
            context.go(Routes.home);
          case LobbyStatus.left:
            context.go(Routes.home);
          case LobbyStatus.error:
            YqToast.show(context, failureMessage(state.failure!));
            context.go(Routes.home);
          case LobbyStatus.loading || LobbyStatus.ready:
            if (state.promotedCount > 0) YqToast.show(context, 'lobby.now_host'.tr());
        }
      },
      builder: (context, state) {
        final room = state.room;
        final Widget content;
        if (room == null || state.myUid == null) {
          content = const YqDotGridBackground(child: Center(child: YqSpinner()));
        } else if (_inGame(room, game)) {
          content = game.room == null
              ? const YqDotGridBackground(child: Center(child: YqSpinner()))
              : GameView(
                  state: game,
                  feedback: feedback,
                  online: state.online,
                  onHome: () => context.read<LobbyCubit>().leave(),
                );
        } else {
          content = LayoutBuilder(
            builder: (context, constraints) {
              final size = screenSizeFor(constraints.maxWidth);
              final args = _LobbyArgs(
                room: room,
                myUid: state.myUid!,
                isHost: state.isHost,
                leaving: state.leaving,
                onLeave: () => _requestLeave(context),
                onStart: () => _start(context),
              );
              return size == ScreenSize.phone
                  ? _PhoneLobby(args: args)
                  : _HostScreenLobby(args: args, size: size);
            },
          );
        }
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _requestLeave(context);
          },
          // Screens stay on from the countdown to the final results.
          child: KeepScreenAwake(
            enabled: room != null && _inGame(room, game) && !state.leaving,
            child: Scaffold(body: content),
          ),
        );
      },
    );
  }
}

class _LobbyArgs {
  const _LobbyArgs({
    required this.room,
    required this.myUid,
    required this.isHost,
    required this.leaving,
    required this.onLeave,
    required this.onStart,
  });

  final Room room;
  final String myUid;
  final bool isHost;
  final bool leaving;
  final VoidCallback onLeave;
  final VoidCallback onStart;
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.args});

  final _LobbyArgs args;

  @override
  Widget build(BuildContext context) => YqIconButton(
    icon: args.leaving ? const YqSpinner(size: 20) : const Icon(Icons.close_rounded),
    tooltip: 'lobby.leave'.tr(),
    onPressed: args.leaving ? null : args.onLeave,
  );
}

class _PhoneLobby extends StatelessWidget {
  const _PhoneLobby({required this.args});

  final _LobbyArgs args;

  @override
  Widget build(BuildContext context) {
    final room = args.room;
    return YqScaffold(
      appBar: YqAppBar(
        leading: _CloseButton(args: args),
        title: 'lobby.title'.tr(),
        trailing: YqMetaPill(lobbyMeta(room.settings)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: YqSpace.x3),
          LobbyCodeCard(code: room.code),
          const SizedBox(height: YqSpace.x4),
          LobbyShare(code: room.code),
          const SizedBox(height: YqSpace.x6),
          LobbyPlayersHeader(room: room),
          const SizedBox(height: YqSpace.x3),
          PlayerGrid(room: room, myUid: args.myUid, metrics: PlayerGridMetrics.phone),
        ],
      ),
      bottom: LobbyActions(room: room, isHost: args.isHost, onStart: args.onStart),
    );
  }
}

/// Host big screen (15): brand top bar, big player grid, QR + code + start.
class _HostScreenLobby extends StatelessWidget {
  const _HostScreenLobby({required this.args, required this.size});

  final _LobbyArgs args;
  final ScreenSize size;

  static const double _qrSize = 96;
  static const double _startHeight = 76;
  static const double _startWidth = 320;
  static const double _desktopGutter = 48;
  static const double _maxContentWidth = 1200;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final t = context.yqText;
    final room = args.room;
    final insets = MediaQuery.paddingOf(context);
    final gutter = size == ScreenSize.desktop ? _desktopGutter : YqSpace.hostGutter;
    final metrics = PlayerGridMetrics.host.withColumns(size == ScreenSize.desktop ? 4 : 3);

    return YqDotGridBackground(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxContentWidth),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              gutter,
              math.max(YqSpace.x8, insets.top + YqSpace.x4),
              gutter,
              math.max(YqSpace.x10, insets.bottom + YqSpace.x4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    _CloseButton(args: args),
                    const SizedBox(width: YqSpace.x4),
                    const YqBrandRow(),
                    const Spacer(),
                    _RoomChip(code: room.code),
                  ],
                ),
                const SizedBox(height: YqSpace.x14),
                LobbyPlayersHeader(
                  room: room,
                  dotSize: 16,
                  dotHalo: 8,
                  titleStyle: t.headline.copyWith(fontSize: 42),
                  countStyle: t.numeric.copyWith(fontSize: 36),
                ),
                const SizedBox(height: YqSpace.x8),
                Expanded(
                  child: SingleChildScrollView(
                    child: PlayerGrid(room: room, myUid: args.myUid, metrics: metrics),
                  ),
                ),
                const SizedBox(height: YqSpace.x6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RoomQr(
                      code: room.code,
                      size: _qrSize,
                      semanticLabel: 'lobby.qr_label'.tr(args: [room.code]),
                    ),
                    const SizedBox(width: YqSpace.x5),
                    Flexible(
                      child: Tooltip(
                        message: 'lobby.copy'.tr(),
                        child: YqPressable(
                          onPressed: () => copyRoomCode(context, room.code),
                          semanticLabel: 'lobby.copy'.tr(),
                          focusRadius: YqRadius.sm,
                          builder: (context, _) => Padding(
                            padding: const EdgeInsetsDirectional.only(bottom: YqSpace.x6),
                            child: YqNumberText(
                              room.code,
                              style: t.code.copyWith(fontSize: 30, color: c.ink),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: _startWidth,
                      child: LobbyActions(
                        room: room,
                        isHost: args.isHost,
                        onStart: args.onStart,
                        buttonHeight: _startHeight,
                        buttonTextStyle: t.button.copyWith(fontSize: 24),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoomChip extends StatelessWidget {
  const _RoomChip({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final t = context.yqText;
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: YqSpace.x5, vertical: YqSpace.x3),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: YqRadius.all(YqRadius.pill),
        border: Border.all(color: c.line, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('lobby.room_chip'.tr(), style: t.label.copyWith(fontSize: 15, color: c.inkMuted)),
          const SizedBox(width: YqSpace.x3),
          YqNumberText(code, style: t.code.copyWith(fontSize: 17, color: c.ink)),
        ],
      ),
    );
  }
}
