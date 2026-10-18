import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_constants.dart';
import '../theme/yq_colors.dart';
import '../theme/yq_spacing.dart';
import '../theme/yq_typography.dart';
import '../utils/room_code.dart';
import 'yq_shake.dart';

enum _BoxState { empty, focused, filled, error }

/// Six-box room-code input. Always LTR, accepts A–Z and 2–9 only (no O/0,
/// I/1), auto-uppercases, and pasting fills all six. Shakes when
/// [errorCount] changes while [hasError] is true.
///
/// One invisible [TextField] spans the boxes and owns input, focus, paste and
/// semantics; the boxes only render its value. (Built on Flutter's own
/// TextField rather than pinput, whose v7 depends on the separate
/// `material_ui` package and can't see this app's `Material` ancestors.)
class YqCodeInput extends StatelessWidget {
  const YqCodeInput({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onChanged,
    this.onCompleted,
    this.hasError = false,
    this.errorCount = 0,
    this.enabled = true,
    this.autofocus = true,
    this.semanticLabel,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final bool hasError;
  final int errorCount;
  final bool enabled;
  final bool autofocus;
  final String? semanticLabel;

  /// Wraps the hidden input so tests can check it paints nothing.
  @visibleForTesting
  static const Key hiddenFieldKey = Key('yq-code-input-hidden-field');

  static const double _glyphSize = 28;

  /// Every state set explicitly: `InputDecoration.collapsed` only clears
  /// `border`, so the theme's enabled/focused borders (1.5 line, 3 focus)
  /// would still be drawn around the field.
  static const InputDecoration _invisibleDecoration = InputDecoration(
    isCollapsed: true,
    filled: false,
    contentPadding: EdgeInsetsDirectional.zero,
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    counterText: '',
  );
  static const double _caretHeight = 30;

  void _handleChanged(String value) {
    onChanged?.call(value);
    if (value.length == RoomRules.codeLength) onCompleted?.call(value);
  }

  _BoxState _stateFor(int index, String value) {
    if (hasError) return _BoxState.error;
    if (index < value.length) return _BoxState.filled;
    return focusNode.hasFocus && index == value.length ? _BoxState.focused : _BoxState.empty;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final glyph = context.yqText.code.copyWith(
      fontSize: _glyphSize,
      letterSpacing: 0,
      color: c.ink,
    );
    final reduced = MediaQuery.disableAnimationsOf(context);
    final invisible = c.ink.withValues(alpha: 0);
    final hidden = TextStyle(color: invisible, fontSize: 1);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: YqShake(
        trigger: errorCount,
        child: Stack(
          children: [
            ListenableBuilder(
              listenable: Listenable.merge([controller, focusNode]),
              builder: (context, _) {
                final value = controller.text;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < RoomRules.codeLength; i++) ...[
                      if (i > 0) const SizedBox(width: YqSpace.codeBoxGap),
                      _Box(
                        value: i < value.length ? value[i] : '',
                        state: _stateFor(i, value),
                        glyph: glyph,
                        caretHeight: _caretHeight,
                        animate: !reduced,
                      ),
                    ],
                  ],
                );
              },
            ),
            Positioned.fill(
              child: RepaintBoundary(
                key: hiddenFieldKey,
                // Nothing of the real field may show: the boxes are the UI.
                child: TextSelectionTheme(
                  data: TextSelectionThemeData(
                    cursorColor: invisible,
                    selectionColor: invisible,
                    selectionHandleColor: invisible,
                  ),
                  child: Semantics(
                    label: semanticLabel,
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      autofocus: autofocus,
                      enabled: enabled,
                      showCursor: false,
                      cursorColor: invisible,
                      autocorrect: false,
                      enableSuggestions: false,
                      keyboardType: TextInputType.visiblePassword,
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.go,
                      inputFormatters: const [_RoomCodeFormatter()],
                      style: hidden,
                      // Fill the boxes' full height so every pixel of them
                      // is the field (taps anywhere focus it).
                      expands: true,
                      maxLines: null,
                      decoration: _invisibleDecoration,
                      onChanged: _handleChanged,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({
    required this.value,
    required this.state,
    required this.glyph,
    required this.caretHeight,
    required this.animate,
  });

  final String value;
  final _BoxState state;
  final TextStyle glyph;
  final double caretHeight;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final c = context.yqColors;
    final (Color border, double width, Color fill) = switch (state) {
      _BoxState.error => (c.danger, 2.5, c.dangerSoft),
      _BoxState.focused => (c.focus, 3.0, c.surface),
      _BoxState.filled => (c.ink, 2.0, c.surface),
      _BoxState.empty => (c.line, 2.0, c.surface),
    };

    final Widget content = value.isNotEmpty
        ? TweenAnimationBuilder<double>(
            key: ValueKey(value),
            tween: Tween(begin: animate ? 1.08 : 1, end: 1),
            duration: YqMotion.instant,
            builder: (context, s, child) => Transform.scale(scale: s, child: child),
            child: Text(value, style: glyph),
          )
        : state == _BoxState.focused
        ? Container(width: 2, height: caretHeight, color: c.focus)
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
