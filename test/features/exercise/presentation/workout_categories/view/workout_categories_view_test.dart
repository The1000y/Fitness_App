import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/core/shared/image_title_card.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscle_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscles_by_group_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscles_entity.dart';
import 'package:fitness_app/features/exercise/domain/repo/exercise_repo.dart';
import 'package:fitness_app/features/exercise/domain/use_cases/get_muscle_groups_use_case.dart';
import 'package:fitness_app/features/exercise/domain/use_cases/get_muscles_by_group_use_case.dart';
import 'package:fitness_app/features/exercise/presentation/workout_categories/manager/workout_categories_cubit.dart';
import 'package:fitness_app/features/exercise/presentation/workout_categories/view/workout_categories_body.dart';
import 'package:fitness_app/features/exercise/presentation/workout_categories/view/workout_categories_view.dart';
import 'package:fitness_app/l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/pump_app.dart';

class MockExerciseRepo extends Mock implements ExerciseRepo {}

void main() {
  late MockExerciseRepo repo;

  setUp(() async {
    await getIt.reset();
    repo = MockExerciseRepo();

    getIt.registerFactory<WorkoutCategoriesCubit>(
      () => WorkoutCategoriesCubit(
        GetMuscleGroupsUseCase(repo),
        GetMusclesByGroupUseCase(repo),
      ),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('loads categories and requests muscles for the first group', (
    tester,
  ) async {
    const groupsResponse = Success<MusclesByGroupEntity>(
      MusclesByGroupEntity(
        message: 'Success',
        musclesGroup: [MuscleGroupEntity(id: 'group-1', name: 'Upper body')],
      ),
    );
    const musclesResponse = Success<MusclesEntity>(
      MusclesEntity(message: 'Success', totalMuscles: 0, muscles: []),
    );

    when(() => repo.getMusclesGroups()).thenAnswer((_) async => groupsResponse);
    when(
      () => repo.getMusclesByGroup(id: 'group-1'),
    ).thenAnswer((_) async => musclesResponse);

    await tester.pumpApp(const WorkoutCategoriesView());
    await tester.pumpAndSettle();

    expect(find.byType(WorkoutCategoriesBody), findsOneWidget);
    expect(find.text('Upper body'), findsOneWidget);
    expect(find.text('No muscles available'), findsOneWidget);
    verify(() => repo.getMusclesGroups()).called(1);
    verify(() => repo.getMusclesByGroup(id: 'group-1')).called(1);
  });

  testWidgets('selecting another group displays its returned muscle', (
    tester,
  ) async {
    const groupsResponse = Success<MusclesByGroupEntity>(
      MusclesByGroupEntity(
        message: 'Success',
        musclesGroup: [
          MuscleGroupEntity(id: 'group-1', name: 'Upper body'),
          MuscleGroupEntity(id: 'group-2', name: 'Lower body'),
        ],
      ),
    );
    const emptyMusclesResponse = Success<MusclesEntity>(
      MusclesEntity(message: 'Success', totalMuscles: 0, muscles: []),
    );
    const lowerBodyMusclesResponse = Success<MusclesEntity>(
      MusclesEntity(
        message: 'Success',
        totalMuscles: 1,
        muscles: [
          MuscleEntity(
            id: 'muscle-1',
            name: 'Quadriceps',
            image: 'assets/images/test/test1.png',
          ),
        ],
      ),
    );

    when(() => repo.getMusclesGroups()).thenAnswer((_) async => groupsResponse);
    when(
      () => repo.getMusclesByGroup(id: 'group-1'),
    ).thenAnswer((_) async => emptyMusclesResponse);
    when(
      () => repo.getMusclesByGroup(id: 'group-2'),
    ).thenAnswer((_) async => lowerBodyMusclesResponse);

    await tester.pumpApp(const WorkoutCategoriesView());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lower body'));
    await tester.pumpAndSettle();

    expect(find.text('Quadriceps'), findsOneWidget);
    final card = tester.widget<ImageTitleCard>(find.byType(ImageTitleCard));
    expect(card.imagePath, 'assets/images/test/test1.png');
    verify(() => repo.getMusclesByGroup(id: 'group-2')).called(1);
  });

  testWidgets('shows a localized message when loading categories fails', (
    tester,
  ) async {
    when(() => repo.getMusclesGroups()).thenAnswer(
      (_) async =>
          const Error<MusclesByGroupEntity>(InternetConnectionFailure()),
    );

    await tester.pumpApp(const WorkoutCategoriesView());
    await tester.pumpAndSettle();

    expect(
      find.text(AppLocalizationsEn().failureInternetConnection),
      findsOneWidget,
    );
  });

  testWidgets('does not reselect the first group when another group fails', (
    tester,
  ) async {
    const groupsResponse = Success<MusclesByGroupEntity>(
      MusclesByGroupEntity(
        message: 'Success',
        musclesGroup: [
          MuscleGroupEntity(id: 'group-1', name: 'Upper body'),
          MuscleGroupEntity(id: 'group-2', name: 'Lower body'),
        ],
      ),
    );
    const emptyMusclesResponse = Success<MusclesEntity>(
      MusclesEntity(message: 'Success', totalMuscles: 0, muscles: []),
    );
    const failureResponse = Error<MusclesEntity>(
      InternetConnectionFailure(),
    );

    when(() => repo.getMusclesGroups()).thenAnswer((_) async => groupsResponse);
    when(
      () => repo.getMusclesByGroup(id: 'group-1'),
    ).thenAnswer((_) async => emptyMusclesResponse);
    when(
      () => repo.getMusclesByGroup(id: 'group-2'),
    ).thenAnswer((_) async => failureResponse);

    await tester.pumpApp(const WorkoutCategoriesView());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lower body'));
    await tester.pumpAndSettle();

    expect(
      find.text(AppLocalizationsEn().failureInternetConnection),
      findsOneWidget,
    );
    verify(() => repo.getMusclesByGroup(id: 'group-1')).called(1);
    verify(() => repo.getMusclesByGroup(id: 'group-2')).called(1);
  });
}
