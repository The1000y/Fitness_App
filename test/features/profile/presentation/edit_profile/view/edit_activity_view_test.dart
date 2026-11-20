import 'package:fitness_app/features/auth/presentation/register/manager/register_option.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/view/edit_activity_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  group('EditActivityView', () {
    testWidgets('renders EditActivityView with title and all activity options', (tester) async {
      await tester.pumpApp(
        const EditActivityView(initialLevel: 'level1'),
        size: const Size(375, 900),
      );

      expect(find.byType(EditActivityView), findsOneWidget);
      expect(find.text('YOUR REGULAR PHYSICAL ACTIVITY LEVEL?'), findsOneWidget);
      expect(find.text('Rookie'), findsOneWidget);
      expect(find.text('Beginner'), findsOneWidget);
      expect(find.text('Intermediate'), findsOneWidget);
      expect(find.text('Advanced'), findsOneWidget);
      expect(find.text('True beast'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('pre-selects matching initial activity level case-insensitively and pops on Done', (tester) async {
      ActivityLevel? poppedResult;

      await tester.pumpApp(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              poppedResult = await Navigator.push<ActivityLevel>(
                context,
                MaterialPageRoute(
                  builder: (_) => const EditActivityView(initialLevel: 'level2'),
                ),
              );
            },
            child: const Text('Launch'),
          ),
        ),
        size: const Size(375, 900),
      );

      await tester.tap(find.text('Launch'));
      await tester.pumpAndSettle();

      expect(find.byType(EditActivityView), findsOneWidget);

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(poppedResult, ActivityLevel.beginner);
    });

    testWidgets('allows selecting a different option and returns new level on Done', (tester) async {
      ActivityLevel? poppedResult;

      await tester.pumpApp(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              poppedResult = await Navigator.push<ActivityLevel>(
                context,
                MaterialPageRoute(
                  builder: (_) => const EditActivityView(initialLevel: 'level1'),
                ),
              );
            },
            child: const Text('Launch'),
          ),
        ),
        size: const Size(375, 900),
      );

      await tester.tap(find.text('Launch'));
      await tester.pumpAndSettle();

      // Tap on 'True beast'
      await tester.tap(find.text('True beast'));
      await tester.pumpAndSettle();

      // Tap Done
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(poppedResult, ActivityLevel.trueBeast);
    });

    testWidgets('handles null initial level gracefully and pops null if Done tapped without selection', (tester) async {
      ActivityLevel? poppedResult;

      await tester.pumpApp(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              poppedResult = await Navigator.push<ActivityLevel>(
                context,
                MaterialPageRoute(
                  builder: (_) => const EditActivityView(initialLevel: null),
                ),
              );
            },
            child: const Text('Launch'),
          ),
        ),
        size: const Size(375, 900),
      );

      await tester.tap(find.text('Launch'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(poppedResult, isNull);
    });

    testWidgets('handles unrecognized initial level and selects an option when tapped', (tester) async {
      ActivityLevel? poppedResult;

      await tester.pumpApp(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              poppedResult = await Navigator.push<ActivityLevel>(
                context,
                MaterialPageRoute(
                  builder: (_) => const EditActivityView(initialLevel: 'unknown_level'),
                ),
              );
            },
            child: const Text('Launch'),
          ),
        ),
        size: const Size(375, 900),
      );

      await tester.tap(find.text('Launch'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Intermediate'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(poppedResult, ActivityLevel.intermediate);
    });
  });
}
