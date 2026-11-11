import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/exercise_error_view.dart';
import '../../../../../../helpers/pump_app.dart';

void main() {
  Future<void> openErrorView(WidgetTester tester) async {
    await tester.pumpApp(
      Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ExerciseErrorView(),
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  group('ExerciseErrorView', () {
    testWidgets('renders the failure message and icon', (tester) async {
      await openErrorView(tester);

      expect(find.text('Failed to load exercises'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Go Back'), findsOneWidget);
    });

    testWidgets('Go Back pops the current route', (tester) async {
      await openErrorView(tester);

      await tester.tap(find.text('Go Back'));
      await tester.pumpAndSettle();

      expect(find.text('open'), findsOneWidget);
      expect(find.byType(ExerciseErrorView), findsNothing);
    });
  });
}
