import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/yq_avatar_palette.dart';

/// Player avatar: base circle, one abstract shape and a dot (8 presets).
class YqAvatar extends StatelessWidget {
  const YqAvatar({super.key, required this.seed, required this.size, this.semanticLabel})
    : ghost = false;

  /// Placeholder for a player who is joining; pulses 0.4 ↔ 0.9.
  const YqAvatar.ghost({super.key, required this.size})
    : seed = 0,
      ghost = true,
      semanticLabel = null;

  final int seed;
  final double size;
  final bool ghost;
  final String? semanticLabel;

  static final Map<int, String> _svgCache = {};
  static String? _ghostSvg;

  static String _hex(Color c) => '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

  static String _svg(YqAvatarPreset p) {
    const s = YqAvatarPalette.canvas;
    const mid = s / 2;
    return '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 $s $s">'
        '<circle cx="$mid" cy="$mid" r="$mid" fill="${_hex(p.bg)}"/>'
        '<path d="${p.shape}" fill="${_hex(p.shapeColor)}" transform="rotate(${p.rotation} $mid $mid)"/>'
        '<circle cx="${p.dot.dx}" cy="${p.dot.dy}" r="${YqAvatarPalette.dotRadius}" fill="${_hex(p.dotColor)}"/>'
        '</svg>';
  }

  @override
  Widget build(BuildContext context) {
    final presets = YqAvatarPalette.presets;
    final svg = ghost
        ? (_ghostSvg ??= _svg(YqAvatarPalette.ghost))
        : _svgCache.putIfAbsent(seed, () => _svg(presets[seed % presets.length]));
    final picture = SvgPicture.string(
      svg,
      width: size,
      height: size,
      semanticsLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
    );
    return ghost ? _GhostPulse(child: picture) : picture;
  }
}

class _GhostPulse extends StatefulWidget {
  const _GhostPulse({required this.child});

  final Widget child;

  @override
  State<_GhostPulse> createState() => _GhostPulseState();
}

class _GhostPulseState extends State<_GhostPulse> with SingleTickerProviderStateMixin {
  static const Duration _period = Duration(milliseconds: 1400);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _period ~/ 2,
  );
  late final Animation<double> _opacity = Tween<double>(
    begin: 0.4,
    end: 0.9,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(opacity: _opacity, child: widget.child);
}

/// Selected-avatar ring used in the picker: 3 `bg` + 3 `primary` double ring.
class YqAvatarRing extends StatelessWidget {
  const YqAvatarRing({super.key, required this.child, required this.color, required this.gap});

  final Widget child;
  final Color color;
  final Color gap;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(color: color, spreadRadius: 6),
        BoxShadow(color: gap, spreadRadius: 3),
      ],
    ),
    child: child,
  );
}
