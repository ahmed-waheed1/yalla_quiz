import 'package:flutter/widgets.dart';

import '../di/injection.dart';
import '../services/screen_awake.dart';

/// Holds the wake lock while [enabled], and always releases it on dispose.
class KeepScreenAwake extends StatefulWidget {
  const KeepScreenAwake({super.key, required this.enabled, required this.child});

  final bool enabled;
  final Widget child;

  @override
  State<KeepScreenAwake> createState() => _KeepScreenAwakeState();
}

class _KeepScreenAwakeState extends State<KeepScreenAwake> {
  final ScreenAwake _awake = getIt<ScreenAwake>();

  @override
  void initState() {
    super.initState();
    if (widget.enabled) _awake.set(true);
  }

  @override
  void didUpdateWidget(KeepScreenAwake oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) _awake.set(widget.enabled);
  }

  @override
  void dispose() {
    if (widget.enabled) _awake.set(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
