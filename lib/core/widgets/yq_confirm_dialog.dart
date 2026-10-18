import 'package:flutter/material.dart';

import '../theme/yq_colors.dart';
import '../theme/yq_spacing.dart';
import '../theme/yq_typography.dart';
import 'yq_button.dart';

/// Brand-styled confirm dialog. Resolves to true when confirmed.
Future<bool> showYqConfirm(
  BuildContext context, {
  required String title,
  String? body,
  required String confirmLabel,
  required String cancelLabel,
}) async {
  final c = context.yqColors;
  final result = await showDialog<bool>(
    context: context,
    barrierColor: c.scrim,
    builder: (context) {
      final t = context.yqText;
      return Dialog(
        backgroundColor: c.surface,
        shape: RoundedRectangleBorder(borderRadius: YqRadius.all(YqRadius.xl)),
        // Dialog only takes EdgeInsets; equal on all sides so RTL is unaffected.
        insetPadding: const EdgeInsets.all(YqSpace.gutter),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsetsDirectional.all(YqSpace.x6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(title, style: t.title.copyWith(color: c.ink)),
                if (body != null) ...[
                  const SizedBox(height: YqSpace.x2),
                  Text(body, style: t.body.copyWith(color: c.inkMuted)),
                ],
                const SizedBox(height: YqSpace.x6),
                YqButton(label: confirmLabel, onPressed: () => Navigator.of(context).pop(true)),
                const SizedBox(height: YqSpace.x3 + 2),
                YqButton.secondary(
                  label: cancelLabel,
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
  return result ?? false;
}
