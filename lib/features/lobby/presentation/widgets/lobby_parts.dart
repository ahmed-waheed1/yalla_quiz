import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/haptics.dart';
import '../../../../core/theme/yq_colors.dart';
import '../../../../core/theme/yq_spacing.dart';
import '../../../../core/theme/yq_typography.dart';
import '../../../../core/utils/log.dart';
import '../../../../core/utils/room_code.dart';
import '../../../../core/widgets/yq_button.dart';
import '../../../../core/widgets/yq_card.dart';
import '../../../../core/widgets/yq_live_dot.dart';
import '../../../../core/widgets/yq_ltr.dart';
import '../../../../core/widgets/yq_pressable.dart';
import '../../../../core/widgets/yq_spinner.dart';
import '../../../../core/widgets/yq_toast.dart';
import '../../../room/domain/entities/room.dart';
import 'room_qr.dart';

void copyRoomCode(BuildContext context, String code) {
  Clipboard.setData(ClipboardData(text: code));
  getIt<Haptics>().selection();
  YqToast.show(context, 'lobby.copied'.tr());
}

/// "General · 10 Q"
String lobbyMeta(RoomSettings settings) => 'lobby.meta'.plural(
  settings.questionCount,
  namedArgs: {'category': 'categories.${settings.category}'.tr()},
);

/// Phone code card: label, big code, copy button, QR at the end.
class LobbyCodeCard extends StatelessWidget {
  const LobbyCodeCard({super.key, required this.code});

  final String code;

  static const double _qrSize = 96;
  static const double _copyHeight = 44;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final t = context.yqText;
    return YqCard(
      elevated: true,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'lobby.code_label'.tr(),
                  style: t.label.copyWith(fontSize: 13, color: c.inkMuted),
                ),
                const SizedBox(height: YqSpace.x1),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: YqNumberText(code, style: t.code.copyWith(color: c.ink)),
                ),
                const SizedBox(height: YqSpace.x2),
                YqPressable(
                  onPressed: () => copyRoomCode(context, code),
                  semanticLabel: 'lobby.copy'.tr(),
                  focusRadius: YqRadius.sm,
                  builder: (context, pressed) => AnimatedScale(
                    scale: pressed ? 0.96 : 1,
                    duration: YqMotion.instant,
                    child: Container(
                      height: _copyHeight,
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: YqSpace.x4),
                      decoration: BoxDecoration(
                        color: c.surfaceAlt,
                        borderRadius: YqRadius.all(YqRadius.sm),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.copy_rounded, size: 20, color: c.ink),
                          const SizedBox(width: YqSpace.x2),
                          Text('lobby.copy'.tr(), style: t.label.copyWith(fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: YqSpace.x3 + 2),
          RoomQr(
            code: code,
            size: _qrSize,
            semanticLabel: 'lobby.qr_label'.tr(args: [code]),
          ),
        ],
      ),
    );
  }
}

/// "Share invite" + the message preview.
class LobbyShare extends StatelessWidget {
  const LobbyShare({super.key, required this.code});

  final String code;

  static const double _height = 52;

  Future<void> _share(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    try {
      await SharePlus.instance.share(
        ShareParams(
          text: '${'lobby.share_message'.tr(args: [code])}\n${RoomCode.inviteLink(code)}',
          sharePositionOrigin: box == null ? null : box.localToGlobal(Offset.zero) & box.size,
        ),
      );
    } on Object catch (e) {
      log.w('Share failed', error: e);
      if (context.mounted) copyRoomCode(context, code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Builder(
          builder: (context) => YqButton.secondary(
            label: 'lobby.share'.tr(),
            icon: const Icon(Icons.ios_share_rounded),
            height: _height,
            onPressed: () => _share(context),
          ),
        ),
        const SizedBox(height: YqSpace.x3),
        Text(
          'lobby.share_preview'.tr(args: [code]),
          textAlign: TextAlign.center,
          style: context.yqText.caption.copyWith(color: c.inkMuted),
        ),
      ],
    );
  }
}

/// Live dot + "Waiting for your friends…" + "4/8".
class LobbyPlayersHeader extends StatelessWidget {
  const LobbyPlayersHeader({
    super.key,
    required this.room,
    this.titleStyle,
    this.countStyle,
    this.dotSize = 9,
    this.dotHalo = 5,
  });

  final Room room;
  final TextStyle? titleStyle;
  final TextStyle? countStyle;
  final double dotSize;
  final double dotHalo;

  @override
  Widget build(BuildContext context) {
    final t = context.yqText;
    return Row(
      children: [
        YqLiveDot(size: dotSize, halo: dotHalo),
        const SizedBox(width: YqSpace.x1 + 2),
        Expanded(
          child: Text(
            'lobby.waiting'.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: titleStyle ?? t.titleSm.copyWith(fontSize: 16),
          ),
        ),
        YqNumberText(
          '${room.players.length}/${room.settings.maxPlayers}',
          style: countStyle ?? t.numeric,
        ),
      ],
    );
  }
}

/// Bottom area by role: start button (host), or the waiting status card.
class LobbyActions extends StatelessWidget {
  const LobbyActions({
    super.key,
    required this.room,
    required this.isHost,
    required this.onStart,
    this.buttonHeight = YqSpace.buttonHeight,
    this.buttonTextStyle,
  });

  final Room room;
  final bool isHost;
  final VoidCallback onStart;
  final double buttonHeight;
  final TextStyle? buttonTextStyle;

  static const double _statusHeight = 64;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final t = context.yqText;
    if (!isHost) {
      return Semantics(
        liveRegion: true,
        child: Container(
          constraints: const BoxConstraints(minHeight: _statusHeight),
          padding: const EdgeInsetsDirectional.symmetric(horizontal: YqSpace.x4),
          decoration: BoxDecoration(color: c.surfaceAlt, borderRadius: YqRadius.all(YqRadius.lg)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const YqSpinner(),
              const SizedBox(width: YqSpace.x3),
              Flexible(
                child: Text('lobby.wait_host'.tr(), style: t.titleSm.copyWith(fontSize: 16)),
              ),
            ],
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!room.canStart) ...[
          Text(
            'lobby.need_two'.tr(),
            textAlign: TextAlign.center,
            style: t.caption.copyWith(fontWeight: FontWeight.w700, color: c.inkMuted),
          ),
          const SizedBox(height: YqSpace.x2 + 2),
        ],
        YqButton(
          label: 'lobby.start'.tr(),
          height: buttonHeight,
          textStyle: buttonTextStyle,
          onPressed: room.canStart ? onStart : null,
        ),
      ],
    );
  }
}
