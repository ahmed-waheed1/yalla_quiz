import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/yq_colors.dart';
import '../../../../core/theme/yq_spacing.dart';
import '../../../../core/theme/yq_typography.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/failure_message.dart';
import '../../../../core/widgets/yq_app_bar.dart';
import '../../../../core/widgets/yq_banner.dart';
import '../../../../core/widgets/yq_button.dart';
import '../../../../core/widgets/yq_code_input.dart';
import '../../../../core/widgets/yq_scaffold.dart';
import '../../../../core/widgets/yq_toast.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../cubit/join_room_cubit.dart';

/// 05 Join room.
class JoinRoomPage extends StatelessWidget {
  const JoinRoomPage({super.key, this.initialCode});

  /// Pre-filled from an invite link; auto-submits when complete.
  final String? initialCode;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => JoinRoomCubit(getIt(), getIt<ProfileCubit>(), getIt()),
        child: _JoinRoomView(initialCode: initialCode),
      );
}

class _JoinRoomView extends StatefulWidget {
  const _JoinRoomView({this.initialCode});

  final String? initialCode;

  @override
  State<_JoinRoomView> createState() => _JoinRoomViewState();
}

class _JoinRoomViewState extends State<_JoinRoomView> {
  late final TextEditingController _code = TextEditingController(text: widget.initialCode ?? '');
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    final initial = widget.initialCode;
    if (initial != null && initial.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _onChanged(initial, submitIfComplete: true));
    }
  }

  @override
  void dispose() {
    _code.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onChanged(String value, {bool submitIfComplete = false}) {
    final cubit = context.read<JoinRoomCubit>();
    cubit.codeChanged(value);
    if (submitIfComplete && cubit.state.isComplete) cubit.submit();
  }

  Future<void> _scan() async {
    final code = await context.push<String>(Routes.scan);
    if (!mounted || code == null) return;
    _code.text = code;
    _onChanged(code, submitIfComplete: true);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final t = context.yqText;

    return BlocConsumer<JoinRoomCubit, JoinRoomState>(
      listenWhen: (a, b) => a.joinedCode != b.joinedCode || a.transientFailure != b.transientFailure,
      listener: (context, state) {
        final code = state.joinedCode;
        if (code != null) {
          context.go(Routes.lobbyFor(code));
        } else if (state.transientFailure != null) {
          YqToast.show(context, failureMessage(state.transientFailure!));
        }
      },
      builder: (context, state) {
        final cubit = context.read<JoinRoomCubit>();
        return YqScaffold(
          appBar: YqAppBar.back(context, title: 'join.title'.tr()),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: YqSpace.x6 + 4),
              Text('join.head'.tr(), style: t.headline),
              const SizedBox(height: YqSpace.x1),
              Text('join.sub'.tr(), style: t.body.copyWith(color: c.inkMuted)),
              const SizedBox(height: YqSpace.x6),
              Text('join.code_label'.tr(), style: t.label.copyWith(color: c.inkMuted)),
              const SizedBox(height: YqSpace.x3 + 2),
              Center(
                child: YqCodeInput(
                  controller: _code,
                  focusNode: _focus,
                  semanticLabel: 'join.code_label'.tr(),
                  hasError: state.error != null,
                  errorCount: state.errorCount,
                  enabled: !state.submitting,
                  autofocus: widget.initialCode == null,
                  onChanged: _onChanged,
                  onCompleted: (value) => _onChanged(value, submitIfComplete: true),
                ),
              ),
              _ErrorCard(error: state.error),
              const SizedBox(height: YqSpace.x6),
              _OrDivider(label: 'common.or'.tr()),
              const SizedBox(height: YqSpace.x6),
              YqButton.secondary(
                label: 'join.scan'.tr(),
                icon: const Icon(Icons.qr_code_scanner_rounded),
                onPressed: state.submitting ? null : _scan,
              ),
            ],
          ),
          bottom: YqButton(
            label: 'join.go'.tr(),
            loading: state.submitting,
            onPressed: state.canSubmit ? cubit.submit : null,
          ),
        );
      },
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.error});

  final Failure? error;

  @override
  Widget build(BuildContext context) {
    final e = error;
    final reduced = MediaQuery.disableAnimationsOf(context);
    final Widget? card = switch (e) {
      RoomNotFoundFailure() => YqBanner(
          kind: YqBannerKind.danger,
          icon: const Icon(Icons.error_outline_rounded),
          iconSize: 24,
          title: 'join.invalid_title'.tr(),
          body: 'join.invalid_body'.tr(),
          bodySize: 14,
        ),
      RoomFullFailure(:final maxPlayers) => YqBanner(
          kind: YqBannerKind.danger,
          icon: const Icon(Icons.group_outlined),
          iconSize: 24,
          title: 'join.full_title'.tr(args: ['$maxPlayers', '$maxPlayers']),
          body: 'join.full_body'.tr(),
          bodySize: 14,
        ),
      GameStartedFailure() => YqBanner(
          kind: YqBannerKind.danger,
          icon: const Icon(Icons.timer_outlined),
          iconSize: 24,
          title: 'join.started_title'.tr(),
          body: 'join.started_body'.tr(),
          bodySize: 14,
        ),
      _ => null,
    };
    return AnimatedSwitcher(
      duration: reduced ? YqMotion.reducedFade : YqMotion.base,
      switchInCurve: YqMotion.out,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: reduced
            ? child
            : SlideTransition(
                position: Tween(begin: const Offset(0, -0.1), end: Offset.zero).animate(animation),
                child: child,
              ),
      ),
      child: card == null
          ? const SizedBox(width: double.infinity)
          : Padding(
              key: ValueKey(e.runtimeType),
              padding: const EdgeInsetsDirectional.only(top: YqSpace.x3 + 2),
              child: card,
            ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    return Row(
      children: [
        Expanded(child: Container(height: 2, color: c.line)),
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: YqSpace.x6),
          child: Text(label, style: context.yqText.label.copyWith(color: c.inkMuted)),
        ),
        Expanded(child: Container(height: 2, color: c.line)),
      ],
    );
  }
}
