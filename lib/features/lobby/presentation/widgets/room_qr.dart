import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../../../core/theme/yq_colors.dart';
import '../../../../core/utils/room_code.dart';

/// Invite QR (deep link to the join screen). Always dark modules on a white
/// tile so it scans in both themes.
class RoomQr extends StatelessWidget {
  const RoomQr({super.key, required this.code, required this.size, required this.semanticLabel});

  final String code;
  final double size;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final padding = size * 0.06;
    return Semantics(
      label: semanticLabel,
      image: true,
      child: Container(
        width: size,
        height: size,
        padding: EdgeInsetsDirectional.all(padding),
        decoration: BoxDecoration(
          color: YqColors.light.surface,
          borderRadius: BorderRadius.circular(size * 0.06),
        ),
        child: PrettyQrView.data(
          data: RoomCode.inviteLink(code),
          decoration: const PrettyQrDecoration(
            shape: PrettyQrSquaresSymbol(color: YqColors.brandNight),
          ),
        ),
      ),
    );
  }
}
