import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/exercise_empty_view.dart';
import '../../../../../../helpers/pump_app.dart';

void main() {
  group('ExerciseEmptyView', () {
    testWidgets('renders the empty message', (tester) async {
      await tester.pumpApp(const ExerciseEmptyView());

      expect(find.text('No exercises found'), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);
    });

    testWidgets('uses the secondary text color', (tester) async {
      await tester.pumpApp(const ExerciseEmptyView());

      final text = tester.widget<Text>(find.text('No exercises found'));
      expect(text.style?.color, AppColors.textSecondary);
    });
  });
}
