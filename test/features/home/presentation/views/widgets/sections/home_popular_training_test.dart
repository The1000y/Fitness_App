import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/features/home/domain/entities/popular_training_entity.dart';
import 'package:fitness_app/features/home/presentation/manager/home_cubit.dart';
import 'package:fitness_app/features/home/presentation/manager/home_state.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/sections/home_popular_training.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../../../helpers/pump_app.dart';

class MockHomeCubit extends Mock implements HomeCubit {}

void main() {
  late MockHomeCubit homeCubit;

  setUp(() {
    homeCubit = MockHomeCubit();
    when(() => homeCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => homeCubit.close()).thenAnswer((_) async {});
  });

  testWidgets('HomePopularTraining renders list of popular training items', (
    tester,
  ) async {
    const trainings = [
      PopularTrainingEntity(
        muscleId: 'm-1',
        muscleName: 'Chest',
        difficultyLevelId: 'd-1',
        difficultyLevelName: 'Beginner',
        totalExercises: 5,
        muscleImage: null,
      ),
    ];

    when(() => homeCubit.state).thenReturn(
      const HomeState(popularTrainingState: BaseState(data: trainings)),
    );

    await tester.pumpApp(
      BlocProvider<HomeCubit>.value(
        value: homeCubit,
        child: const HomePopularTraining(),
      ),
    );

    expect(find.byType(HomePopularTraining), findsOneWidget);
    expect(find.textContaining('Chest'), findsOneWidget);
  });
}
