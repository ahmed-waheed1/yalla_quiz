import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yalla_quiz/core/theme/yq_colors.dart';
import 'package:yalla_quiz/core/widgets/yq_toast.dart';
import 'package:yalla_quiz/features/profile/presentation/pages/profile_setup_page.dart';
import 'package:yalla_quiz/features/room/presentation/pages/create_room_page.dart';
import 'package:yalla_quiz/features/settings/presentation/pages/settings_page.dart';

import '../helpers/pump_app.dart';

/// Checks the colours actually rendered for selected / active states.
void main() {
  setUpAll(initTestEnvironment);

  /// Fill of the segment holding [label] and the colour of its text.
  (Color?, Color?) segmentColors(WidgetTester tester, String label) {
    final text = find.text(label);
    final box = tester.widget<AnimatedContainer>(
      find.ancestor(of: text, matching: find.byType(AnimatedContainer)).first,
    );
    final fill = (box.decoration! as BoxDecoration).color;
    return (fill, tester.widget<Text>(text).style?.color);
  }

  for (final (brightness, colors) in [
    (Brightness.light, YqColors.light),
    (Brightness.dark, YqColors.dark),
  ]) {
    group(brightness.name, () {
      testWidgets('Settings: selected segment is ink on bg and stands out from the track',
          (tester) async {
        registerFakes();
        await pumpScreen(tester, const SettingsPage(), locale: const Locale('en'), brightness: brightness);

        final (fill, fg) = segmentColors(tester, 'languages.en'.tr());
        expect(fill, colors.ink);
        expect(fg, colors.bg);
        expect(fill, isNot(colors.surfaceAlt));

        final (offFill, offFg) = segmentColors(tester, 'languages.ar'.tr());
        expect(offFill?.a, 0);
        expect(offFg, colors.inkMuted);
      });

      testWidgets('Create room: selected count and time segments are ink on bg', (tester) async {
        registerFakes();
        await pumpScreen(tester, const CreateRoomPage(), locale: const Locale('ar'), brightness: brightness);
        for (final label in ['10', 'create.seconds_short'.tr(args: ['20'])]) {
          final (fill, fg) = segmentColors(tester, label);
          expect(fill, colors.ink, reason: label);
          expect(fg, colors.bg, reason: label);
        }
      });

      testWidgets('Toast is ink on bg', (tester) async {
        registerFakes();
        await pumpScreen(tester, const SettingsPage(), locale: const Locale('en'), brightness: brightness);
        YqToast.show(tester.element(find.byType(SettingsPage)), 'Code copied');
        await settle(tester, const Duration(milliseconds: 400));
        final text = find.text('Code copied');
        final pill = tester.widget<Container>(
          find.ancestor(of: text, matching: find.byType(Container)).first,
        );
        expect((pill.decoration! as BoxDecoration).color, colors.ink);
        expect(tester.widget<Text>(text).style?.color, colors.bg);
        await settle(tester, const Duration(seconds: 3));
      });

      testWidgets('Avatar picker check badge uses onPrimary on primary', (tester) async {
        registerFakes();
        await pumpScreen(tester, const ProfileSetupPage(), locale: const Locale('en'), brightness: brightness);
        final check = find.byIcon(Icons.check_rounded);
        expect(tester.widget<Icon>(check).color, colors.onPrimary);
        final badge = tester.widget<Container>(
          find.ancestor(of: check, matching: find.byType(Container)).first,
        );
        expect((badge.decoration! as BoxDecoration).color, colors.primary);
      });
    });
  }
}
