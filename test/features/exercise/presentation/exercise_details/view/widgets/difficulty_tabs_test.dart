import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/exercise/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/difficulty_tabs.dart';
import '../../../../../../helpers/pump_app.dart';

void main() {
  const levels = [
    DifficultyLevelEntity(id: 'beginner', name: 'Beginner'),
    DifficultyLevelEntity(id: 'intermediate', name: 'Intermediate'),
    DifficultyLevelEntity(id: 'advanced', name: 'Advanced'),
  ];

  group('DifficultyTabs', () {
    testWidgets('renders every level', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: DifficultyTabs(
            levels: levels,
            selectedIndex: 0,
            onSelected: (_) {},
          ),
        ),
      );

      expect(find.text('Beginner'), findsOneWidget);
      expect(find.text('Intermediate'), findsOneWidget);
      expect(find.text('Advanced'), findsOneWidget);
    });

    testWidgets('highlights only the selected level', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: DifficultyTabs(
            levels: levels,
            selectedIndex: 1,
            onSelected: (_) {},
          ),
        ),
      );

      final containers = tester
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
          .toList();

      expect(
        (containers[0].decoration! as BoxDecoration).color,
        Colors.transparent,
      );
      expect(
        (containers[1].decoration! as BoxDecoration).color,
        AppColors.primary,
      );
      expect(
        (containers[2].decoration! as BoxDecoration).color,
        Colors.transparent,
      );
    });

    testWidgets('reports the tapped level index', (tester) async {
      int? selected;

      await tester.pumpApp(
        Scaffold(
          body: DifficultyTabs(
            levels: levels,
            selectedIndex: 0,
            onSelected: (index) => selected = index,
          ),
        ),
      );

      await tester.tap(find.text('Intermediate'));
      await tester.pump();

      expect(selected, 1);
    });
  });
}
