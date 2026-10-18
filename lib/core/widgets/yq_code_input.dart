import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

import '../constants/app_constants.dart';
import '../theme/yq_colors.dart';
import '../theme/yq_spacing.dart';
import '../theme/yq_typography.dart';
import '../utils/room_code.dart';
import 'yq_shake.dart';

/// Six-box room-code input. Always LTR, accepts A–Z and 2–9 only (no O/0,
/// I/1), auto-uppercases, and pasting fills all six. Shakes when
/// [errorCount] changes while [hasError] is true.
class YqCodeInput extends StatelessWidget {
  const YqCodeInput({
    super.key,
    required this.controller,
    this.focusNode,
    this.onChanged,
    this.onCompleted,
    this.hasError = false,
    this.errorCount = 0,
    this.enabled = true,
    this.autofocus = true,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final bool hasError;
  final int errorCount;
  final bool enabled;
  final bool autofocus;

  static const double _glyphSize = 28;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final glyph = context.yqText.code.copyWith(fontSize: _glyphSize, letterSpacing: 0, color: c.ink);
    final reduced = MediaQuery.disableAnimationsOf(context);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: YqShake(
        trigger: errorCount,
        child: Pinput.builder(
          length: RoomRules.codeLength,
          controller: controller,
          focusNode: focusNode,
          autofocus: autofocus,
          enabled: enabled,
          forceErrorState: hasError,
          showErrorWhenFocused: true,
          keyboardType: TextInputType.visiblePassword,
          textCapitalization: TextCapitalization.characters,
          enableSuggestions: false,
          autofillHints: const [],
          closeKeyboardWhenCompleted: false,
          inputFormatters: const [_RoomCodeFormatter()],
          onChanged: onChanged,
          onCompleted: onCompleted,
          separatorBuilder: (_) => const SizedBox(width: YqSpace.codeBoxGap),
          builder: (context, item) => _Box(
            value: item.value,
            type: item.type,
            glyph: glyph,
            colors: c,
            animate: !reduced,
          ),
        ),
      ),
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({
    required this.value,
    required this.type,
    required this.glyph,
    required this.colors,
    required this.animate,
  });

  final String value;
  final PinItemStateType type;
  final TextStyle glyph;
  final YqColors colors;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final c = colors;
    final (Color border, double width, Color fill) = switch (type) {
      PinItemStateType.error => (c.danger, 2.5, c.dangerSoft),
      PinItemStateType.focused => (c.focus, 3.0, c.surface),
      PinItemStateType.submitted => (c.ink, 2.0, c.surface),
      _ => (c.line, 2.0, c.surface),
    };

    final Widget content = value.isNotEmpty
        ? TweenAnimationBuilder<double>(
            key: ValueKey(value),
            tween: Tween(begin: animate ? 1.08 : 1, end: 1),
            duration: YqMotion.instant,
            builder: (context, s, child) => Transform.scale(scale: s, child: child),
            child: Text(value, style: glyph),
          )
        : type == PinItemStateType.focused
            ? Container(width: 2, height: _caretHeight, color: c.focus)
            : const SizedBox.shrink();

    return AnimatedContainer(
      duration: YqMotion.fast,
      width: YqSpace.codeBox.width,
      height: YqSpace.codeBox.height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: YqRadius.all(YqRadius.sm),
        border: Border.all(color: border, width: width),
      ),
      child: content,
    );
  }

  static const double _caretHeight = 30;
}

class _RoomCodeFormatter extends TextInputFormatter {
  const _RoomCodeFormatter();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = RoomCode.sanitize(newValue.text);
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
