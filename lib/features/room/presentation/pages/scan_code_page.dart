import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/haptics.dart';
import '../../../../core/theme/yq_colors.dart';
import '../../../../core/theme/yq_spacing.dart';
import '../../../../core/theme/yq_typography.dart';
import '../../../../core/utils/room_code.dart';
import '../../../../core/widgets/yq_app_bar.dart';
import '../../../../core/widgets/yq_scaffold.dart';

/// Camera QR scanner. Pops with the room code from an invite QR.
class ScanCodePage extends StatefulWidget {
  const ScanCodePage({super.key});

  @override
  State<ScanCodePage> createState() => _ScanCodePageState();
}

class _ScanCodePageState extends State<ScanCodePage> {
  final MobileScannerController _controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );
  bool _done = false;

  static const double _viewfinderRadius = YqRadius.xl;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_done) return;
    for (final barcode in capture.barcodes) {
      final raw = barcode.rawValue;
      final code = raw == null ? null : RoomCode.fromScan(raw);
      if (code != null) {
        _done = true;
        getIt<Haptics>().medium();
        context.pop(code);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final t = context.yqText;
    return YqScaffold(
      appBar: YqAppBar.back(context, title: 'scan.title'.tr()),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: YqSpace.x6),
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: YqRadius.all(_viewfinderRadius),
              child: DecoratedBox(
                decoration: BoxDecoration(color: c.inverse),
                child: MobileScanner(
                  controller: _controller,
                  onDetect: _onDetect,
                  errorBuilder: (context, _) => Center(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.all(YqSpace.x6),
                      child: Text(
                        'scan.camera_error'.tr(),
                        textAlign: TextAlign.center,
                        style: t.body.copyWith(color: c.onInverse),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: YqSpace.x4),
          Text(
            'scan.hint'.tr(),
            textAlign: TextAlign.center,
            style: t.body.copyWith(color: c.inkMuted),
          ),
        ],
      ),
    );
  }
}
