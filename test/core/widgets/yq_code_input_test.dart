import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yalla_quiz/core/theme/yq_theme.dart';
import 'package:yalla_quiz/core/widgets/yq_code_input.dart';

import '../../helpers/pump_app.dart';

/// The hidden TextField behind the six boxes must paint nothing and must
/// cover every box, so any tap focuses it.
void main() {
  setUpAll(initTestEnvironment);

  late TextEditingController controller;
  late FocusNode focusNode;

  setUp(() {
    controller = TextEditingController();
    focusNode = FocusNode();
  });
  tearDown(() {
    controller.dispose();
    focusNode.dispose();
  });

  Future<void> pumpInput(
    WidgetTester tester, {
    required Brightness brightness,
    bool hasError = false,
    bool autofocus = false,
  }) async {
    registerFakes();
    await tester.pumpWidget(
      MaterialApp(
        theme: YqTheme.build(brightness, const Locale('en')),
        home: Scaffold(
          body: Center(
            child: YqCodeInput(
              controller: controller,
              focusNode: focusNode,
              hasError: hasError,
              autofocus: autofocus,
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  /// Every pixel the hidden field paints, as RGBA bytes.
  Future<List<int>> hiddenFieldPixels(WidgetTester tester) async {
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(YqCodeInput.hiddenFieldKey),
    );
    expect(boundary.size.width, greaterThan(0));
    final bytes = await tester.runAsync(() async {
      final image = await boundary.toImage();
      final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      image.dispose();
      return data!.buffer.asUint8List();
    });
    return bytes!;
  }

  void expectInvisible(List<int> rgba, String state) {
    var visible = 0;
    for (var i = 3; i < rgba.length; i += 4) {
      if (rgba[i] != 0) visible++;
    }
    expect(visible, 0, reason: '$state: hidden field painted $visible visible pixels');
  }

  for (final brightness in Brightness.values) {
    group(brightness.name, () {
      testWidgets('hidden field paints nothing: idle, focused, typed, selected, error', (
        tester,
      ) async {
        await pumpInput(tester, brightness: brightness);
        expectInvisible(await hiddenFieldPixels(tester), 'idle');

        focusNode.requestFocus();
        await tester.pump();
        expectInvisible(await hiddenFieldPixels(tester), 'focused');

        await tester.enterText(find.byType(TextField), 'K7X');
        await tester.pump();
        expectInvisible(await hiddenFieldPixels(tester), 'typed');

        controller.selection = const TextSelection(baseOffset: 0, extentOffset: 3);
        await tester.pump();
        expectInvisible(await hiddenFieldPixels(tester), 'text selected');

        await pumpInput(tester, brightness: brightness, hasError: true);
        focusNode.requestFocus();
        await tester.pump();
        expectInvisible(await hiddenFieldPixels(tester), 'error + focused');
      });

      testWidgets('hidden field covers all six boxes', (tester) async {
        await pumpInput(tester, brightness: brightness);
        final field = tester.getRect(find.byKey(YqCodeInput.hiddenFieldKey));
        final boxes = tester.getRect(find.byType(YqCodeInput));
        expect(field, boxes);
        expect(field.height, greaterThanOrEqualTo(62));
      });

      testWidgets('tapping the bottom of the last box focuses the input', (tester) async {
        await pumpInput(tester, brightness: brightness);
        expect(focusNode.hasFocus, isFalse);
        final input = tester.getRect(find.byType(YqCodeInput));
        // Bottom-right corner of the sixth box (LTR, always).
        await tester.tapAt(input.bottomRight - const Offset(6, 4));
        await tester.pump();
        expect(focusNode.hasFocus, isTrue);
      });

      testWidgets('tapping the bottom of the first box focuses the input', (tester) async {
        await pumpInput(tester, brightness: brightness);
        final input = tester.getRect(find.byType(YqCodeInput));
        await tester.tapAt(input.bottomLeft + const Offset(6, -4));
        await tester.pump();
        expect(focusNode.hasFocus, isTrue);
      });
    });
  }
}
