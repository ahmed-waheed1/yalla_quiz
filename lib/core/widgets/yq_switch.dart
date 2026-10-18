import 'package:flutter/material.dart';

import '../theme/yq_colors.dart';

/// Toggle: `success` track when on, `line` when off (from the theme).
///
/// The "on" thumb is `surface`: white in light (as designed) and night in
/// dark, where a white thumb on the light-green dark `success` track is only
/// 1.77:1. The "off" thumb keeps the theme's white.
class YqSwitch extends StatelessWidget {
  const YqSwitch({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    return Switch(
      value: value,
      onChanged: onChanged,
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected) ? c.surface : null,
      ),
    );
  }
}
