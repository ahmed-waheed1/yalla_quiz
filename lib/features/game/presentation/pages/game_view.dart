import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/yq_colors.dart';
import '../../../../core/theme/yq_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/yq_banner.dart';
import '../../../../core/widgets/yq_spinner.dart';
import '../../../room/domain/entities/room.dart';
import '../cubit/game_cubit.dart';
import '../game_feedback.dart';
import '../widgets/final_results_view.dart';
import '../widgets/get_ready_view.dart';
import '../widgets/host_views.dart';
import '../widgets/leaderboard_view.dart';
import '../widgets/question_view.dart';
import '../widgets/reveal_view.dart';

/// The game, from the countdown to the final results. Renders whatever phase
/// the room is in; a spectator host on a tablet or desktop gets the big-screen
/// layouts (16–19), everyone else the phone ones.
class GameView extends StatelessWidget {
  const GameView({
    super.key,
    required this.state,
    required this.feedback,
    required this.online,
    required this.onHome,
  });

  final GameState state;
  final GameFeedback feedback;
  final bool online;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    final room = state.room!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = screenSizeFor(constraints.maxWidth);
        final big = state.isSpectator && size != ScreenSize.phone;
        return _ConnectionOverlay(
          online: online,
          child: _PhaseSwitcher(
            status: room.status,
            phaseKey: '${room.status.name}-${room.currentQuestionIndex}',
            child: switch (room.status) {
              RoomStatus.countdown => GetReadyView(room: room, feedback: feedback),
              RoomStatus.question =>
                big
                    ? HostQuestionView(state: state, size: size)
                    : QuestionView(state: state, feedback: feedback),
              RoomStatus.reveal =>
                big
                    ? HostRevealView(state: state, size: size)
                    : RevealView(state: state, feedback: feedback),
              RoomStatus.leaderboard =>
                big
                    ? HostLeaderboardView(state: state, size: size, feedback: feedback)
                    : LeaderboardView(state: state, feedback: feedback),
              RoomStatus.finished =>
                big
                    ? HostFinalResultsView(
                        state: state,
                        size: size,
                        feedback: feedback,
                        onHome: onHome,
                      )
                    : FinalResultsView(state: state, feedback: feedback, onHome: onHome),
              RoomStatus.lobby => const Center(child: YqSpinner()),
            },
          ),
        );
      },
    );
  }
}

/// Fades between phases (fade-through, `base`), except "Yalla!" → question,
/// which is a hard cut.
class _PhaseSwitcher extends StatefulWidget {
  const _PhaseSwitcher({required this.status, required this.phaseKey, required this.child});

  final RoomStatus status;
  final String phaseKey;
  final Widget child;

  @override
  State<_PhaseSwitcher> createState() => _PhaseSwitcherState();
}

class _PhaseSwitcherState extends State<_PhaseSwitcher> {
  Duration _duration = YqMotion.base;

  @override
  void didUpdateWidget(_PhaseSwitcher old) {
    super.didUpdateWidget(old);
    if (old.phaseKey == widget.phaseKey) return;
    final hardCut = old.status == RoomStatus.countdown && widget.status == RoomStatus.question;
    _duration = hardCut ? Duration.zero : YqMotion.base;
  }

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    final duration = _duration == Duration.zero
        ? Duration.zero
        : reduced
        ? YqMotion.reducedFade
        : _duration;
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: YqMotion.out,
      switchOutCurve: YqMotion.out,
      child: KeyedSubtree(key: ValueKey(widget.phaseKey), child: widget.child),
    );
  }
}

/// 13 reconnecting: a warning banner over the game (which dims to 40 % and
/// stops taking taps); "Back online!" for 1.5 s once the connection returns.
/// The round doesn't pause — the player's score is safe either way.
class _ConnectionOverlay extends StatefulWidget {
  const _ConnectionOverlay({required this.online, required this.child});

  final bool online;
  final Widget child;

  @override
  State<_ConnectionOverlay> createState() => _ConnectionOverlayState();
}

class _ConnectionOverlayState extends State<_ConnectionOverlay> {
  static const Duration _backOnlineFor = Duration(milliseconds: 1500);
  static const double _dimmed = 0.4;

  bool _backOnline = false;
  Timer? _timer;

  @override
  void didUpdateWidget(_ConnectionOverlay old) {
    super.didUpdateWidget(old);
    if (!old.online && widget.online) {
      _timer?.cancel();
      setState(() => _backOnline = true);
      _timer = Timer(_backOnlineFor, () {
        if (mounted) setState(() => _backOnline = false);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offline = !widget.online;
    final reduced = MediaQuery.disableAnimationsOf(context);
    return Stack(
      children: [
        AnimatedOpacity(
          opacity: offline ? _dimmed : 1,
          duration: reduced ? YqMotion.reducedFade : YqMotion.fast,
          child: IgnorePointer(ignoring: offline, child: widget.child),
        ),
        if (offline || _backOnline)
          PositionedDirectional(
            start: YqSpace.gutter,
            end: YqSpace.gutter,
            top: YqSpace.x14,
            child: SafeArea(
              bottom: false,
              child: offline
                  ? YqBanner(
                      kind: YqBannerKind.warning,
                      icon: YqSpinner(color: context.yqColors.warning),
                      title: 'game.reconnecting'.tr(),
                      body: 'game.reconnecting_body'.tr(),
                    )
                  : YqBanner(
                      kind: YqBannerKind.success,
                      icon: const Icon(Icons.wifi_rounded),
                      title: 'game.back_online'.tr(),
                    ),
            ),
          ),
      ],
    );
  }
}
