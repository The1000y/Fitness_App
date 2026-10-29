import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/features/auth/presentation/login/view/widgets/auth_card.dart';
import '../../../../../../helpers/pump_app.dart';

void main() {
  group('AuthCard', () {
    testWidgets('renders title when given and renders child', (tester) async {
      await tester.pumpApp(
        const AuthCard(
          title: 'CardTitle',
          child: Text('CardChild'),
        ),
      );

      expect(find.text('CardTitle'), findsOneWidget);
      expect(find.text('CardChild'), findsOneWidget);
    });

    testWidgets('omits title when null', (tester) async {
      await tester.pumpApp(
        const AuthCard(
          child: Text('CardChild'),
        ),
      );

      expect(find.text('CardChild'), findsOneWidget);
    });
  });
}
