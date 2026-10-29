import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/features/auth/presentation/login/view/widgets/auth_scaffold.dart';
import '../../../../../../helpers/pump_app.dart';

void main() {
  group('AuthScaffold', () {
    testWidgets('renders child, logo, and headers when given', (tester) async {
      await tester.pumpApp(
        const AuthScaffold(
          title: 'Hello',
          subtitle: 'Welcome',
          child: Text('ChildContent'),
        ),
      );

      expect(find.text('Hello'), findsOneWidget);
      expect(find.text('Welcome'), findsOneWidget);
      expect(find.text('ChildContent'), findsOneWidget);
      expect(find.byType(Image), findsNWidgets(2));
    });

    testWidgets('omits headers when title and subtitle are null', (tester) async {
      await tester.pumpApp(
        const AuthScaffold(
          child: Text('ChildContent'),
        ),
      );

      expect(find.text('ChildContent'), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}
