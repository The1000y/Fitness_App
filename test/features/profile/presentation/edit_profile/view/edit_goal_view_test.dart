import 'package:fitness_app/features/auth/presentation/register/manager/register_option.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/view/edit_goal_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  group('EditGoalView', () {
    testWidgets('renders EditGoalView with title, subtitle, and all 5 goal options', (tester) async {
      await tester.pumpApp(
        const EditGoalView(initialGoal: 'gain weight'),
        size: const Size(375, 1000),
      );

      expect(find.byType(EditGoalView), findsOneWidget);
      expect(find.text('WHAT IS YOUR GOAL?'), findsOneWidget);
      expect(find.text('This helps us create your personalized plan'), findsOneWidget);
      expect(find.text('Gain weight'), findsOneWidget);
      expect(find.text('Lose weight'), findsOneWidget);
      expect(find.text('Get fitter'), findsOneWidget);
      expect(find.text('Gain more flexibility'), findsOneWidget);
      expect(find.text('Learn the basics'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('pre-selects matching initial goal case-insensitively and pops with it on Done', (tester) async {
      Goal? poppedResult;

      await tester.pumpApp(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              poppedResult = await Navigator.push<Goal>(
                context,
                MaterialPageRoute(
                  builder: (_) => const EditGoalView(initialGoal: 'lose weight'),
                ),
              );
            },
            child: const Text('Launch'),
          ),
        ),
        size: const Size(375, 1000),
      );

      await tester.tap(find.text('Launch'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(poppedResult, Goal.loseWeight);
    });

    testWidgets('allows selecting a different goal and pops new Goal on Done', (tester) async {
      Goal? poppedResult;

      await tester.pumpApp(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              poppedResult = await Navigator.push<Goal>(
                context,
                MaterialPageRoute(
                  builder: (_) => const EditGoalView(initialGoal: 'gain weight'),
                ),
              );
            },
            child: const Text('Launch'),
          ),
        ),
        size: const Size(375, 1000),
      );

      await tester.tap(find.text('Launch'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Get fitter'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(poppedResult, Goal.getFitter);
    });

    testWidgets('handles null initial goal gracefully and pops null if Done tapped without selection', (tester) async {
      Goal? poppedResult;

      await tester.pumpApp(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              poppedResult = await Navigator.push<Goal>(
                context,
                MaterialPageRoute(
                  builder: (_) => const EditGoalView(initialGoal: null),
                ),
              );
            },
            child: const Text('Launch'),
          ),
        ),
        size: const Size(375, 1000),
      );

      await tester.tap(find.text('Launch'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(poppedResult, isNull);
    });

    testWidgets('handles unrecognized initial goal and selects when an option is tapped', (tester) async {
      Goal? poppedResult;

      await tester.pumpApp(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              poppedResult = await Navigator.push<Goal>(
                context,
                MaterialPageRoute(
                  builder: (_) => const EditGoalView(initialGoal: 'unrecognized_goal'),
                ),
              );
            },
            child: const Text('Launch'),
          ),
        ),
        size: const Size(375, 1000),
      );

      await tester.tap(find.text('Launch'));
      await tester.pumpAndSettle();

      final gainFlexibilityFinder = find.text('Gain more flexibility');
      await tester.ensureVisible(gainFlexibilityFinder);
      await tester.tap(gainFlexibilityFinder);
      await tester.pumpAndSettle();

      final doneFinder = find.text('Done');
      await tester.ensureVisible(doneFinder);
      await tester.tap(doneFinder);
      await tester.pumpAndSettle();

      expect(poppedResult, Goal.gainFlexibility);
    });
  });
}
