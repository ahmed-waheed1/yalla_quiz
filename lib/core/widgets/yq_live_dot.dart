import 'package:flutter/material.dart';

import '../theme/yq_colors.dart';

/// 9 px `success` dot with a 5 px 18% halo, pulsing every 1.4 s.
class YqLiveDot extends StatefulWidget {
  const YqLiveDot({super.key, this.size = 9, this.halo = 5});

  final double size;
  final double halo;

  @override
  State<YqLiveDot> createState() => _YqLiveDotState();
}

class _YqLiveDotState extends State<YqLiveDot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final success = context.yqColors.success;
    final total = widget.size + widget.halo * 2;
    return SizedBox.square(
      dimension: total,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final pulse = Curves.easeOut.transform(_controller.value);
          return Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                width: widget.size + widget.halo * 2 * (0.6 + 0.4 * pulse),
                height: widget.size + widget.halo * 2 * (0.6 + 0.4 * pulse),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: success.withValues(alpha: 0.18 * (1.4 - pulse * 0.6)),
                ),
              ),
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(shape: BoxShape.circle, color: success),
              ),
            ],
          );
        },
      ),
    );
  }
}
