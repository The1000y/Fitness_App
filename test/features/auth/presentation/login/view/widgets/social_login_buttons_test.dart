import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/features/auth/presentation/login/view/widgets/social_login_buttons.dart';
import '../../../../../../helpers/pump_app.dart';

void main() {
  group('SocialLoginButtons', () {
    testWidgets('callbacks fire per button and semantics labels are correct', (tester) async {
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
    });

    testWidgets('null callback disables button semantics', (tester) async {
      await tester.pumpApp(
        const SocialLoginButtons(),
      );

      final semantics = tester.getSemantics(find.bySemanticsLabel('Facebook'));
      expect(semantics.getSemanticsData().actions & (1 << SemanticsAction.tap.index), 0);
    });
  });
}
