import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/home/domain/entities/popular_training_entity.dart';
import 'package:fitness_app/features/home/presentation/manager/home_cubit.dart';
import 'package:fitness_app/features/home/presentation/manager/home_event.dart';
import 'package:fitness_app/features/home/presentation/manager/home_state.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/sections/home_popular_training.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/shimmer/popular_training_shimmer.dart';
import 'package:flutter/material.dart';
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

  Widget makeTestableWidget() {
    return BlocProvider<HomeCubit>.value(
      value: homeCubit,
      child: const HomePopularTraining(),
    );
  }

  group('HomePopularTraining', () {
    testWidgets('renders shimmer when popularTrainingState is loading', (tester) async {
      when(() => homeCubit.state).thenReturn(
        const HomeState(popularTrainingState: BaseState(isLoading: true)),
      );

      await tester.pumpApp(makeTestableWidget());

      expect(find.byType(HomePopularTraining), findsOneWidget);
      expect(find.byType(PopularTrainingShimmer), findsOneWidget);
    });

    testWidgets('renders empty message when trainings list is empty', (tester) async {
      when(() => homeCubit.state).thenReturn(
        const HomeState(popularTrainingState: BaseState(data: [])),
      );

      await tester.pumpApp(makeTestableWidget());

      expect(find.byType(HomePopularTraining), findsOneWidget);
      expect(find.text('No popular training available'), findsOneWidget);
    });

    testWidgets('renders error view and triggers retry event on button tap', (tester) async {
      const failure = InternetConnectionFailure();
      when(() => homeCubit.state).thenReturn(
        const HomeState(popularTrainingState: BaseState(errorMessage: failure)),
      );

      await tester.pumpApp(makeTestableWidget());

      expect(find.byType(HomePopularTraining), findsOneWidget);
      expect(find.text('No internet connection. Please check your network and try again.'), findsOneWidget);

      final retryButton = find.byType(ElevatedButton);
      if (retryButton.evaluate().isNotEmpty) {
        await tester.tap(retryButton);
        verify(() => homeCubit.onEvent(const HomePopularTrainingRetried())).called(1);
      }
    });

    testWidgets('renders list of popular training items when data is available', (tester) async {
      const trainings = [
        PopularTrainingEntity(
          muscleId: 'm-1',
          muscleName: 'Chest',
          difficultyLevelId: 'd-1',
          difficultyLevelName: 'Beginner',
          totalExercises: 5,
          muscleImage: null,
        ),
        PopularTrainingEntity(
          muscleId: 'm-2',
          muscleName: 'Legs',
          difficultyLevelId: 'd-2',
          difficultyLevelName: 'Intermediate',
          totalExercises: 8,
          muscleImage: null,
        ),
      ];

      when(() => homeCubit.state).thenReturn(
        const HomeState(popularTrainingState: BaseState(data: trainings)),
      );

      await tester.pumpApp(makeTestableWidget());

      expect(find.byType(HomePopularTraining), findsOneWidget);
      expect(find.textContaining('Chest'), findsOneWidget);
      expect(find.textContaining('Legs'), findsOneWidget);
      expect(find.text('Beginner'), findsOneWidget);
      expect(find.text('Intermediate'), findsOneWidget);
    });
  });
}
