import 'package:fitness_app/features/auth/presentation/register/view/widgets/number_wheel_picker.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/view/edit_weight_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  group('EditWeightView', () {
    testWidgets('renders EditWeightView with title, subtitle, unit, and wheel picker', (tester) async {
      await tester.pumpApp(
        const EditWeightView(initialWeight: 75),
        size: const Size(375, 900),
      );

      expect(find.byType(EditWeightView), findsOneWidget);
      expect(find.text('WHAT IS YOUR WEIGHT?'), findsOneWidget);
      expect(find.text('This helps us create your personalized plan'), findsOneWidget);
      expect(find.text('kg'), findsOneWidget);
      expect(find.byType(NumberWheelPicker), findsOneWidget);
      expect(find.text('75'), findsWidgets);
      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('tapping Done returns initial weight when untouched', (tester) async {
      int? poppedResult;

      await tester.pumpApp(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              poppedResult = await Navigator.push<int>(
                context,
                MaterialPageRoute(
                  builder: (_) => const EditWeightView(initialWeight: 80),
                ),
              );
            },
            child: const Text('Open'),
          ),
        ),
        size: const Size(375, 900),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(poppedResult, 80);
    });

    testWidgets('changing picker value and tapping Done returns updated weight', (tester) async {
      int? poppedResult;

      await tester.pumpApp(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              poppedResult = await Navigator.push<int>(
                context,
                MaterialPageRoute(
                  builder: (_) => const EditWeightView(initialWeight: 70),
                ),
              );
            },
            child: const Text('Open'),
          ),
        ),
        size: const Size(375, 900),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Trigger onChanged on the NumberWheelPicker
      final picker = tester.widget<NumberWheelPicker>(find.byType(NumberWheelPicker));
      picker.onChanged(85);
      await tester.pump();

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(poppedResult, 85);
    });

    testWidgets('renders properly with Arabic locale', (tester) async {
      await tester.pumpApp(
        const EditWeightView(initialWeight: 65),
        locale: const Locale('ar'),
        size: const Size(375, 900),
      );

      expect(find.byType(EditWeightView), findsOneWidget);
      expect(find.text('كجم'), findsOneWidget);
      expect(find.text('تم'), findsOneWidget);
    });
  });
}
