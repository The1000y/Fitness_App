import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscle_groups_entity.dart';
import 'package:fitness_app/features/exercise/presentation/workout_categories/manager/workout_categories_cubit.dart';
import 'package:fitness_app/features/exercise/presentation/workout_categories/manager/workout_categories_state.dart';
import 'package:fitness_app/features/exercise/presentation/workout_categories/view/workout_categories_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/pump_app.dart';

class MockWorkoutCategoriesCubit extends Mock
    implements WorkoutCategoriesCubit {}

void main() {
  late MockWorkoutCategoriesCubit cubit;

  setUp(() {
    cubit = MockWorkoutCategoriesCubit();
    when(() => cubit.state).thenReturn(
      const WorkoutCategoriesState(
        workoutCategoriesState: BaseState<MuscleGroupsEntity>(
          data: MuscleGroupsEntity(message: '', musclesGroup: []),
        ),
      ),
    );
    when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => cubit.uiEventStream).thenAnswer((_) => const Stream.empty());
  });

  group('WorkoutCategoriesBody', () {
    testWidgets('renders CustomBackgroundImage and transparent Scaffold', (
      tester,
    ) async {
      await tester.pumpApp(
        BlocProvider<WorkoutCategoriesCubit>.value(
          value: cubit,
          child: const WorkoutCategoriesBody(),
        ),
      );

      expect(find.byType(WorkoutCategoriesBody), findsOneWidget);
      expect(find.byType(CustomBackgroundImage), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, Colors.transparent);
    });
  });
}
