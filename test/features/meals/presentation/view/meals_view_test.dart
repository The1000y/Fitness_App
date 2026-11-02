import 'dart:async';

import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/category_filter_widget.dart';
import 'package:fitness_app/core/shared/custom_app_bar.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:fitness_app/features/meals/presentation/view/widgets/custom_ui_states.dart';
import 'package:fitness_app/core/shared/image_title_card.dart';
import 'package:fitness_app/features/meals/domain/use_cases/get_meals_by_category_use_case.dart';
import 'package:fitness_app/features/meals/domain/use_cases/get_meals_categories_use_case.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_cubit.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_event.dart';
import 'package:fitness_app/features/meals/presentation/view/meals_view.dart';
import 'package:fitness_app/features/meals/presentation/view/widgets/shimmers/shimmers.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:fitness_app/l10n/app_localizations_en.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/meals_fakes.dart';
import '../../../../helpers/meals_test_data.dart';

void main() {
  final l10n = AppLocalizationsEn();
  late FakeMealsRepo fakeRepo;
  late GetMealsCategoriesUseCase getMealsCategoriesUseCase;
  late GetMealsByCategoryUseCase getMealsByCategoryUseCase;
  late MealsCubit cubit;

  setUp(() {
    fakeRepo = FakeMealsRepo();
    getMealsCategoriesUseCase = GetMealsCategoriesUseCase(fakeRepo);
    getMealsByCategoryUseCase = GetMealsByCategoryUseCase(fakeRepo);
    cubit = MealsCubit(getMealsCategoriesUseCase, getMealsByCategoryUseCase);
  });

  tearDown(() async {
    await cubit.close();
  });

  Future<void> pumpMealsView(
    WidgetTester tester, {
    String? activeCategory,
  }) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ScreenUtilPlusInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<MealsCubit>.value(
            value: cubit,
            child: MealsView(activeCategory: activeCategory),
          ),
        ),
      ),
    );
  }

  group('MealsView Static Shell and AppBar', () {
    testWidgets(
      'renders background image and AppBar with foodRecommendation title',
      (WidgetTester tester) async {
        await pumpMealsView(tester);

        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is CustomBackgroundImage &&
                widget.backgroundImage == AppImages.layoutBackground,
          ),
          findsOneWidget,
        );
        expect(find.byType(CustomAppBar), findsOneWidget);
        expect(find.text(l10n.foodRecommendation), findsOneWidget);
      },
    );
  });

  group('MealsView Loading States', () {
    testWidgets(
      'renders MealsViewShimmer when categories are actively loading',
      (WidgetTester tester) async {
        fakeRepo.categoriesCompleter = Completer();

        unawaited(cubit.doEvent(GetMealsCategoriesEvent()));
        await pumpMealsView(tester);
        await tester.pump();

        expect(find.byType(MealsViewShimmer), findsOneWidget);
        expect(find.byType(CategoryTabBarShimmer), findsOneWidget);
        expect(find.byType(MealsGridShimmer), findsOneWidget);
      },
    );

    testWidgets(
      'renders CategoryTabBar and MealsGridShimmer when meals are loading',
      (WidgetTester tester) async {
        fakeRepo.nextCategoriesResult = Success(MealsTestData.categoryEntities);
        fakeRepo.mealsCompleter = Completer();

        await cubit.doEvent(GetMealsCategoriesEvent());
        await pumpMealsView(tester);
        await tester.pump();

        expect(find.byType(CategoryTabBar), findsOneWidget);
        expect(find.byType(MealsGridShimmer), findsOneWidget);
      },
    );
  });

  group('MealsView Error States', () {
    testWidgets(
      'renders CategoriesErrorState on categories failure and tapping retry re-fetches categories',
      (WidgetTester tester) async {
        fakeRepo.nextCategoriesResult = const Error(
          InternetConnectionFailure(),
        );

        await cubit.doEvent(GetMealsCategoriesEvent());
        await pumpMealsView(tester);
        await tester.pumpAndSettle();

        expect(find.byType(CategoriesErrorState), findsOneWidget);
        expect(find.text(l10n.couldNotLoadCategories), findsOneWidget);
        expect(find.text(l10n.retry), findsOneWidget);

        final initialCallCount = fakeRepo.getCategoriesCallCount;

        // Tap retry button in CategoriesErrorState
        await tester.tap(find.text(l10n.retry));
        await tester.pump();

        expect(fakeRepo.getCategoriesCallCount, initialCallCount + 1);
      },
    );

    testWidgets(
      'renders MealsErrorState on meals failure and tapping retry re-fetches meals',
      (WidgetTester tester) async {
        fakeRepo.nextCategoriesResult = Success(MealsTestData.categoryEntities);
        fakeRepo.nextMealsResult = const Error(ServerFailure());

        await cubit.doEvent(GetMealsCategoriesEvent());
        await pumpMealsView(tester);
        await tester.pumpAndSettle();

        expect(find.byType(MealsErrorState), findsOneWidget);
        expect(find.text(l10n.somethingWentWrong), findsOneWidget);
        expect(find.text(l10n.tryAgain), findsOneWidget);

        final initialMealsCount = fakeRepo.getMealsCallCount;

        // Tap try again button
        await tester.tap(find.text(l10n.tryAgain));
        await tester.pump();

        expect(fakeRepo.getMealsCallCount, initialMealsCount + 1);
        expect(fakeRepo.lastCategory, 'Beef');
      },
    );
  });

  group('MealsView Empty States', () {
    testWidgets(
      'renders CategoriesEmptyState when categories list is empty and refresh re-fetches',
      (WidgetTester tester) async {
        fakeRepo.nextCategoriesResult = const Success([]);

        await cubit.doEvent(GetMealsCategoriesEvent());
        await pumpMealsView(tester);
        await tester.pumpAndSettle();

        expect(find.byType(CategoriesEmptyState), findsOneWidget);
        expect(find.text(l10n.noCategoriesAvailable), findsOneWidget);
        expect(find.text(l10n.refresh), findsOneWidget);

        final initialCallCount = fakeRepo.getCategoriesCallCount;
        await tester.tap(find.text(l10n.refresh));
        await tester.pump();

        expect(fakeRepo.getCategoriesCallCount, initialCallCount + 1);
      },
    );

    testWidgets(
      'renders MealsEmptyState when meals list is empty and refresh re-fetches',
      (WidgetTester tester) async {
        fakeRepo.nextCategoriesResult = Success(MealsTestData.categoryEntities);
        fakeRepo.nextMealsResult = const Success([]);

        await cubit.doEvent(GetMealsCategoriesEvent());
        await pumpMealsView(tester);
        await tester.pumpAndSettle();

        expect(find.byType(MealsEmptyState), findsOneWidget);
        expect(find.text(l10n.noCategoryMealsYet('beef')), findsOneWidget);
        expect(find.text(l10n.refresh), findsOneWidget);

        final initialMealsCount = fakeRepo.getMealsCallCount;
        await tester.tap(find.text(l10n.refresh));
        await tester.pump();

        expect(fakeRepo.getMealsCallCount, initialMealsCount + 1);
        expect(fakeRepo.lastCategory, 'Beef');
      },
    );
  });

  group('MealsView Populated State and Navigation Flow', () {
    testWidgets(
      'renders categories in CategoryTabBar and meals in GridView with ImageTitleCard',
      (WidgetTester tester) async {
        fakeRepo.nextCategoriesResult = Success(MealsTestData.categoryEntities);
        fakeRepo.nextMealsResult = Success(MealsTestData.mealEntities);

        await cubit.doEvent(GetMealsCategoriesEvent());
        await pumpMealsView(tester);
        await tester.pumpAndSettle();

        // Verify CategoryTabBar renders all 3 categories
        expect(find.byType(CategoryTabBar), findsOneWidget);
        expect(find.text('Beef'), findsOneWidget);
        expect(find.text('Chicken'), findsOneWidget);
        expect(find.text('Dessert'), findsOneWidget);

        // Verify GridView renders 2 meal cards
        expect(find.byType(GridView), findsOneWidget);
        expect(find.byType(ImageTitleCard), findsNWidgets(2));
        expect(find.text('Beef Stew'), findsOneWidget);
        expect(find.text('Beef and Oyster pie'), findsOneWidget);
      },
    );

    testWidgets(
      'switches category when tapping another category chip and loads new meals',
      (WidgetTester tester) async {
        fakeRepo.nextCategoriesResult = Success(MealsTestData.categoryEntities);
        fakeRepo.nextMealsResult = Success(MealsTestData.mealEntities);

        await cubit.doEvent(GetMealsCategoriesEvent());
        await pumpMealsView(tester);
        await tester.pumpAndSettle();

        expect(find.text('Beef Stew'), findsOneWidget);
        expect(fakeRepo.lastCategory, 'Beef');

        // Configure next meals response for 'Chicken'
        fakeRepo.nextMealsResult = Success(MealsTestData.chickenMealEntities);

        // Tap 'Chicken' category chip
        await tester.tap(find.text('Chicken'));
        await tester.pumpAndSettle();

        expect(fakeRepo.lastCategory, 'Chicken');
        expect(find.text('Chicken Curry'), findsOneWidget);
        expect(find.byType(ImageTitleCard), findsOneWidget);
      },
    );

    testWidgets('preselects activeCategory when provided via constructor', (
      WidgetTester tester,
    ) async {
      fakeRepo.nextCategoriesResult = Success(MealsTestData.categoryEntities);
      fakeRepo.nextMealsResult = Success(MealsTestData.chickenMealEntities);

      await cubit.doEvent(GetMealsCategoriesEvent());
      await pumpMealsView(tester, activeCategory: 'Chicken');
      await tester.pumpAndSettle();

      expect(fakeRepo.lastCategory, 'Chicken');
      expect(find.text('Chicken Curry'), findsOneWidget);
    });
  });
}
