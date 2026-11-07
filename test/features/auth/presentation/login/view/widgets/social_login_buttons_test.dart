import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/features/auth/presentation/login/view/widgets/social_login_buttons.dart';
import '../../../../../../helpers/pump_app.dart';

void main() {
  group('SocialLoginButtons', () {
    testWidgets('callbacks fire per button and semantics labels are correct', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      try {
        bool fbClicked = false;
        bool googleClicked = false;
        bool appleClicked = false;

        await tester.pumpApp(
          SocialLoginButtons(
            onFacebookTap: () => fbClicked = true,
            onGoogleTap: () => googleClicked = true,
            onAppleTap: () => appleClicked = true,
          ),
        );

        expect(find.bySemanticsLabel('Facebook'), findsOneWidget);
        expect(find.bySemanticsLabel('Google'), findsOneWidget);
        expect(find.bySemanticsLabel('Apple'), findsOneWidget);

        await tester.tap(find.bySemanticsLabel('Facebook'));
        expect(fbClicked, true);

        await tester.tap(find.bySemanticsLabel('Google'));
        expect(googleClicked, true);

        await tester.tap(find.bySemanticsLabel('Apple'));
        expect(appleClicked, true);
      } finally {
        handle.dispose();
      }
    });

    testWidgets(
      'null callback disables button semantics and tapping disabled button does nothing',
      (tester) async {
        final handle = tester.ensureSemantics();
        try {
          await tester.pumpApp(const SocialLoginButtons());

          for (final label in ['Facebook', 'Google', 'Apple']) {
            final semantics = tester.getSemantics(find.bySemanticsLabel(label));
            expect(
              semantics.getSemanticsData().hasAction(SemanticsAction.tap),
              false,
            );

            await tester.tap(find.bySemanticsLabel(label));
            await tester.pump();
          }
        } finally {
          handle.dispose();
        }
      },
    );

    testWidgets('non-null callbacks have tap action enabled', (tester) async {
      final handle = tester.ensureSemantics();
      try {
        await tester.pumpApp(
          SocialLoginButtons(
            onFacebookTap: () {},
            onGoogleTap: () {},
            onAppleTap: () {},
          ),
        );

        for (final label in ['Facebook', 'Google', 'Apple']) {
          final semantics = tester.getSemantics(find.bySemanticsLabel(label));
          expect(
            semantics.getSemanticsData().hasAction(SemanticsAction.tap),
            true,
          );
        }
      } finally {
        handle.dispose();
      }
    });
  });
}
