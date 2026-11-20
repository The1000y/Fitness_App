import 'package:fitness_app/core/shared/custom_button.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/view/edit_option_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  group('EditOptionScaffold', () {
    testWidgets('renders title in uppercase, subtitle, and child widget', (tester) async {
      await tester.pumpApp(
        EditOptionScaffold(
          title: 'Select goal',
          subtitle: 'Personalized Plan Hint',
          onDone: () {},
          child: const Text('Inner Child Content'),
        ),
      );

      expect(find.text('SELECT GOAL'), findsOneWidget);
      expect(find.text('Personalized Plan Hint'), findsOneWidget);
      expect(find.text('Inner Child Content'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('does not render subtitle text when subtitle is null', (tester) async {
      await tester.pumpApp(
        EditOptionScaffold(
          title: 'Select level',
          onDone: () {},
          child: const Text('Child without subtitle'),
        ),
      );

      expect(find.text('SELECT LEVEL'), findsOneWidget);
      expect(find.text('Child without subtitle'), findsOneWidget);
    });

    testWidgets('tapping Done button triggers onDone callback', (tester) async {
      bool doneCalled = false;

      await tester.pumpApp(
        EditOptionScaffold(
          title: 'Weight',
          onDone: () => doneCalled = true,
          child: const Text('Weight Content'),
        ),
      );

      final doneButton = find.byType(CustomButton);
      expect(doneButton, findsOneWidget);

      await tester.tap(doneButton);
      await tester.pump();

      expect(doneCalled, isTrue);
    });

    testWidgets('renders properly in Arabic locale with localized Done text', (tester) async {
      await tester.pumpApp(
        EditOptionScaffold(
          title: 'عنوان',
          subtitle: 'وصف إضافي',
          onDone: () {},
          child: const Text('المحتوى'),
        ),
        locale: const Locale('ar'),
      );

      expect(find.text('عنوان'), findsOneWidget);
      expect(find.text('وصف إضافي'), findsOneWidget);
      expect(find.text('المحتوى'), findsOneWidget);
      expect(find.text('تم'), findsOneWidget);
    });
  });
}
