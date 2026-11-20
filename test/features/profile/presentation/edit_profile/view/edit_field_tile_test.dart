import 'package:fitness_app/features/profile/presentation/edit_profile/view/edit_field_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  group('EditFieldTile', () {
    testWidgets('renders label, value, and Tap to edit action text', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: EditFieldTile(
            label: 'Weight',
            value: '75 kg',
            onTap: () {},
          ),
        ),
      );

      expect(find.text('Weight '), findsOneWidget);
      expect(find.text('75 kg'), findsOneWidget);
      expect(find.text('(tap to edit)'), findsOneWidget);
    });

    testWidgets('triggers onTap callback when Tap to edit is tapped', (tester) async {
      bool tapped = false;

      await tester.pumpApp(
        Scaffold(
          body: EditFieldTile(
            label: 'Goal',
            value: 'Gain weight',
            onTap: () => tapped = true,
          ),
        ),
      );

      final tapToEditFinder = find.text('(tap to edit)');
      expect(tapToEditFinder, findsOneWidget);

      await tester.tap(tapToEditFinder);
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('renders correctly in Arabic locale', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: EditFieldTile(
            label: 'الوزن',
            value: '75 كجم',
            onTap: () {},
          ),
        ),
        locale: const Locale('ar'),
      );

      expect(find.text('الوزن '), findsOneWidget);
      expect(find.text('75 كجم'), findsOneWidget);
      expect(find.text('(اضغط للتعديل)'), findsOneWidget);
    });
  });
}
