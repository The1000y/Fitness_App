import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/core/constants/app_strings.dart';
import 'package:fitness_app/features/auth/presentation/login/view/widgets/auth_or_divider.dart';
import '../../../../../../helpers/pump_app.dart';

void main() {
  group('AuthOrDivider', () {
    testWidgets('renders AppStrings.or and two dividers', (tester) async {
      await tester.pumpApp(const AuthOrDivider());

      expect(find.text(AppStrings.or), findsOneWidget);
      expect(find.byType(Divider), findsNWidgets(2));
    });
  });
}
