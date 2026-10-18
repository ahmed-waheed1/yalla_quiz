import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:yalla_quiz/core/router/app_router.dart';
import 'package:yalla_quiz/core/router/routes.dart';
import 'package:yalla_quiz/core/router/yq_transitions.dart';
import 'package:yalla_quiz/core/theme/yq_spacing.dart';
import 'package:yalla_quiz/features/home/presentation/pages/home_page.dart';
import 'package:yalla_quiz/features/settings/presentation/pages/settings_page.dart';

import '../helpers/pump_app.dart';

const _childKey = Key('child');

/// Builds a transition at fixed animation values and returns the widget tree.
Future<void> _pumpTransition(
  WidgetTester tester,
  YqTransition kind, {
  required double animation,
  double secondary = 0,
  TextDirection direction = TextDirection.ltr,
  bool reducedMotion = false,
}) async {
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(disableAnimations: reducedMotion),
      child: Directionality(
        textDirection: direction,
        child: Builder(
          builder: (context) => YqTransitions.builderFor(kind)(
            context,
            AlwaysStoppedAnimation(animation),
            AlwaysStoppedAnimation(secondary),
            const SizedBox(key: _childKey, width: 10, height: 10),
          ),
        ),
      ),
    ),
  );
}

double _dx(WidgetTester tester) {
  final transform = tester.widget<Transform>(
    find.ancestor(of: find.byKey(_childKey), matching: find.byType(Transform)).first,
  );
  return transform.transform.getTranslation().x;
}

void main() {
  group('slide', () {
    testWidgets('enters from the right in LTR', (tester) async {
      await _pumpTransition(tester, YqTransition.slide, animation: 0.3);
      expect(_dx(tester), greaterThan(0));
    });

    testWidgets('enters from the left in RTL', (tester) async {
      await _pumpTransition(tester, YqTransition.slide, animation: 0.3, direction: TextDirection.rtl);
      expect(_dx(tester), lessThan(0));
    });

    testWidgets('covered page moves towards the start edge (both directions)', (tester) async {
      await _pumpTransition(tester, YqTransition.slide, animation: 1, secondary: 0.5);
      expect(_dx(tester), lessThan(0));
      await _pumpTransition(tester, YqTransition.slide,
          animation: 1, secondary: 0.5, direction: TextDirection.rtl);
      expect(_dx(tester), greaterThan(0));
    });

    testWidgets('settles at rest with no offset', (tester) async {
      await _pumpTransition(tester, YqTransition.slide, animation: 1);
      expect(_dx(tester), 0);
    });
  });

  testWidgets('fade-through: incoming page is invisible until the outgoing one is gone',
      (tester) async {
    await _pumpTransition(tester, YqTransition.fade, animation: 0.2);
    final fades = tester.widgetList<FadeTransition>(
      find.ancestor(of: find.byKey(_childKey), matching: find.byType(FadeTransition)),
    );
    expect(fades.map((f) => f.opacity.value), contains(0.0));
  });

  for (final kind in YqTransition.values) {
    testWidgets('${kind.name}: reduced motion means no animation', (tester) async {
      await _pumpTransition(tester, kind, animation: 0.3, reducedMotion: true);
      for (final type in [Transform, Opacity, FadeTransition, ScaleTransition]) {
        expect(
          find.ancestor(of: find.byKey(_childKey), matching: find.byType(type)),
          findsNothing,
          reason: '$type',
        );
      }
    });
  }

  group('app router', () {
    setUpAll(initTestEnvironment);

    for (final locale in const [Locale('en'), Locale('ar')]) {
      testWidgets('pushing Settings slides in from the end edge (${locale.languageCode})',
          (tester) async {
        registerFakes();
        final router = buildRouter();
        addTearDown(router.dispose);
        await pumpRouterApp(tester, router, locale: locale);
        await settle(tester); // splash → home
        expect(find.byType(HomePage), findsOneWidget);

        final route = ModalRoute.of(tester.element(find.byType(HomePage)))!;
        expect(route.transitionDuration, YqMotion.base);

        router.push(Routes.settings);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 60));
        final dx = tester
            .widget<Transform>(
              find.ancestor(of: find.byType(SettingsPage), matching: find.byType(Transform)).first,
            )
            .transform
            .getTranslation()
            .x;
        expect(dx, locale.languageCode == 'ar' ? lessThan(0) : greaterThan(0));

        await settle(tester);
        expect(find.byType(SettingsPage), findsOneWidget);
      });
    }

    testWidgets('reduced motion: pushed page is in place on the first frame', (tester) async {
      registerFakes();
      final router = buildRouter();
      addTearDown(router.dispose);
      await pumpRouterApp(tester, router, locale: const Locale('en'), disableAnimations: true);
      await settle(tester);

      router.push(Routes.settings);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 60));
      final page = find.byType(SettingsPage);
      expect(page, findsOneWidget);
      expect(tester.getTopLeft(page), Offset.zero);
      await settle(tester);
    });

    testWidgets('unknown paths go home', (tester) async {
      registerFakes();
      final router = buildRouter();
      addTearDown(router.dispose);
      await pumpRouterApp(tester, router, locale: const Locale('en'));
      await settle(tester);
      router.go('/nope/123');
      await settle(tester);
      expect(find.byType(HomePage), findsOneWidget);
      expect(router.state.matchedLocation, Routes.home);
      expect(router, isA<GoRouter>());
    });
  });
}
