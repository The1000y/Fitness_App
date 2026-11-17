import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/features/home/presentation/manager/home_cubit.dart';
import 'package:fitness_app/features/home/presentation/manager/home_event.dart';
import 'package:fitness_app/features/home/presentation/manager/home_state.dart';
import 'package:fitness_app/features/home/presentation/views/home_view.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/sections/home_categories.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/sections/home_food_categories.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/sections/home_popular_training.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/sections/home_random_muscles.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/sections/home_upcoming_workouts.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_cubit.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_event.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../helpers/pump_app.dart';

class MockHomeCubit extends Mock implements HomeCubit {}

class MockProfileCubit extends Mock implements ProfileCubit {}

void main() {
  late MockHomeCubit homeCubit;
  late MockProfileCubit profileCubit;

  setUp(() async {
    await getIt.reset();
    homeCubit = MockHomeCubit();
    profileCubit = MockProfileCubit();

    when(() => homeCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => homeCubit.state).thenReturn(const HomeState());
    when(() => homeCubit.close()).thenAnswer((_) async {});

    when(() => profileCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => profileCubit.state).thenReturn(const ProfileState());
    when(() => profileCubit.close()).thenAnswer((_) async {});

    getIt.registerFactory<HomeCubit>(() => homeCubit);
    getIt.registerFactory<ProfileCubit>(() => profileCubit);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('HomeView', () {
    testWidgets('renders HomeView with all section components and header', (tester) async {
      const profile = ProfileEntity(
        id: 'user-1',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        gender: 'male',
        age: 25,
        weight: 70,
        height: 175,
        activityLevel: 'Rookie',
        goal: 'Get fitter',
        photo: 'http://example.com/photo.jpg',
      );
      when(() => profileCubit.state).thenReturn(
        const ProfileState(profileState: BaseState(data: profile)),
      );

      await tester.pumpApp(
        const HomeView(),
        size: const Size(375, 900),
      );

      expect(find.byType(HomeView), findsOneWidget);
      expect(find.textContaining('Hi John,'), findsOneWidget);
      expect(find.text("Let's start your day"), findsOneWidget);

      expect(find.byType(HomeCategories), findsOneWidget);
      expect(find.byType(HomeRandomMuscles), findsOneWidget);
      expect(find.byType(HomeUpcomingWorkouts), findsOneWidget);
      expect(find.byType(HomeFoodCategories), findsOneWidget);
      expect(find.byType(HomePopularTraining), findsOneWidget);
    });

    testWidgets('triggers HomeStarted and LoadProfile on initialization', (tester) async {
      await tester.pumpApp(
        const HomeView(),
        size: const Size(375, 900),
      );

      verify(() => homeCubit.onEvent(const HomeStarted())).called(1);
      verify(() => profileCubit.onEvent(const LoadProfile())).called(1);
    });

    testWidgets('renders fallback avatar icon when profile photo is empty', (tester) async {
      const profile = ProfileEntity(
        id: 'user-1',
        firstName: 'Sarah',
        lastName: 'Smith',
        email: 'sarah@example.com',
        gender: 'female',
        age: 23,
        weight: 60,
        height: 165,
        activityLevel: 'Rookie',
        goal: 'Get fitter',
        photo: '',
      );
      when(() => profileCubit.state).thenReturn(
        const ProfileState(profileState: BaseState(data: profile)),
      );

      await tester.pumpApp(
        const HomeView(),
        size: const Size(375, 900),
      );

      expect(find.textContaining('Hi Sarah,'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });
  });
}
