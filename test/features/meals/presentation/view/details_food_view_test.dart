import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/core/shared/custom_video_player.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/meals/domain/entities/details_meal_entity.dart';
import 'package:fitness_app/features/meals/domain/use_cases/get_meal_details_use_case.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_cubit.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_event.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_state.dart';
import 'package:fitness_app/features/meals/presentation/view/details_food_view.dart';
import 'package:fitness_app/features/meals/presentation/view/widgets/data_of_ingredients.dart';
import 'package:fitness_app/features/meals/presentation/view/widgets/meal_info_overlay.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../helpers/fakes.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late FakeMealsRepo fakeMealsRepo;
  late GetMealDetailsUseCase useCase;
  late MealsCubit cubit;
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  setUp(() {
    fakeMealsRepo = FakeMealsRepo();
    useCase = GetMealDetailsUseCase(fakeMealsRepo);
    cubit = MealsCubit(useCase);
  });

  tearDown(() async {
    await cubit.close();
  });

  Widget buildTestableDetailsFoodView(MealsCubit cubit) {
    return MediaQuery(
      data: const MediaQueryData(textScaler: TextScaler.linear(0.6)),
      child: BlocProvider<MealsCubit>.value(
        value: cubit,
        child: const DetailsFoodView(mealId: TestData.mealId),
      ),
    );
  }

  group('DetailsFoodView Widget Tests', () {
    testWidgets('renders CircularProgressIndicator when isLoading is true', (tester) async {
      cubit.emit(
        const MealsState(
          mealsState: BaseState(isLoading: true),
        ),
      );

      await tester.pumpApp(buildTestableDetailsFoodView(cubit));

      final indicatorFinder = find.byType(CircularProgressIndicator);
      expect(indicatorFinder, findsOneWidget);
      final indicator = tester.widget<CircularProgressIndicator>(indicatorFinder);
      expect(indicator.color, AppColors.primary);
    });

    testWidgets('renders localized error message when errorMessage is present', (tester) async {
      cubit.emit(
        const MealsState(
          mealsState: BaseState(
            isLoading: false,
            errorMessage: NotFoundFailure(),
          ),
        ),
      );

      await tester.pumpApp(buildTestableDetailsFoodView(cubit));

      expect(find.text(l10n.failureNotFound), findsOneWidget);
    });

    testWidgets('renders dataNotAvailable when data is null and not loading', (tester) async {
      cubit.emit(
        const MealsState(
          mealsState: BaseState(data: null, isLoading: false, errorMessage: null),
        ),
      );

      await tester.pumpApp(buildTestableDetailsFoodView(cubit));

      expect(find.text(l10n.dataNotAvailable), findsOneWidget);
    });

    testWidgets('renders dataNotAvailable when data is empty list', (tester) async {
      cubit.emit(
        const MealsState(
          mealsState: BaseState(
            data: <DetailsMealEntity>[],
            isLoading: false,
            errorMessage: null,
          ),
        ),
      );

      await tester.pumpApp(buildTestableDetailsFoodView(cubit));

      expect(find.text(l10n.dataNotAvailable), findsOneWidget);
    });

    testWidgets('renders meal details, video player, and ingredients list on success', (tester) async {
      cubit.emit(
        MealsState(
          mealsState: BaseState(
            data: [TestData.detailsMealEntity],
            isLoading: false,
            errorMessage: null,
          ),
        ),
      );

      await tester.pumpApp(buildTestableDetailsFoodView(cubit));

      // Video player
      expect(find.byType(CustomVideoPlayer), findsOneWidget);

      // Meal Info Overlay
      expect(find.byType(MealInfoOverlay), findsOneWidget);
      expect(find.text(TestData.mealName), findsOneWidget);
      expect(find.text(TestData.mealCategory), findsOneWidget);

      // Ingredients header
      expect(find.text(l10n.ingredients), findsOneWidget);

      // Ingredients list
      expect(find.byType(DataOfIngredients), findsNWidgets(3));
      expect(find.text('Salmon'), findsOneWidget);
      expect(find.text('2 fillets'), findsOneWidget);
      expect(find.text('Fennel'), findsOneWidget);
      expect(find.text('1 bulb'), findsOneWidget);
    });

    testWidgets('shows snackbar when cubit emits ShowFailureMessage', (tester) async {
      fakeMealsRepo.nextResult = const Error<List<DetailsMealEntity>>(InternetConnectionFailure());

      await tester.pumpApp(buildTestableDetailsFoodView(cubit));

      // Trigger cubit failure event
      cubit.onEvent(GetMealDetailsEvent(TestData.mealId));
      await tester.pumpAndSettle();

      expect(find.text(l10n.failureInternetConnection), findsWidgets);
    });
  });
}
