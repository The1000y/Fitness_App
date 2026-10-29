import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/features/auth/presentation/login/view/widgets/auth_footer_link.dart';
import '../../../../../../helpers/pump_app.dart';

void main() {
  group('AuthFooterLink', () {
    testWidgets('shows text and link label, and link tap calls onPressed', (
      tester,
    ) async {
      bool clicked = false;
      await tester.pumpApp(
        AuthFooterLink(
          text: 'HaveAccount?',
          linkLabel: 'Login',
          onPressed: () => clicked = true,
        ),
      );

      expect(find.text('HaveAccount?'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);

      await tester.tap(find.text('Login'));
      expect(clicked, true);
    });
  });
}
