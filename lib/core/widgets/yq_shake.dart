import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Shakes ±6 px three times over 300 ms whenever [trigger] changes.
class YqShake extends StatefulWidget {
  const YqShake({super.key, required this.trigger, required this.child});

  final int trigger;
  final Widget child;

  @override
  State<YqShake> createState() => _YqShakeState();
}

class _YqShakeState extends State<YqShake> with SingleTickerProviderStateMixin {
  static const double _amplitude = 6;
  static const int _shakes = 3;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  @override
  void didUpdateWidget(YqShake oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger != oldWidget.trigger && !MediaQuery.disableAnimationsOf(context)) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    child: widget.child,
    builder: (context, child) {
      final t = _controller.value;
      final dx = math.sin(t * math.pi * 2 * _shakes) * _amplitude * (1 - t);
      return Transform.translate(offset: Offset(dx, 0), child: child);
    },
  );
}
