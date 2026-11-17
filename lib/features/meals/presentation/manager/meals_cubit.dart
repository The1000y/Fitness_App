import 'dart:async';

import 'package:fitness_app/config/base/base_cubit.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/features/meals/domain/entities/details_meal_entity.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_category_entity.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_entity.dart';
import 'package:fitness_app/features/meals/domain/use_cases/get_meal_details_use_case.dart';
import 'package:fitness_app/features/meals/domain/use_cases/get_meals_by_category_use_case.dart';
import 'package:fitness_app/features/meals/domain/use_cases/get_meals_categories_use_case.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_event.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class MealsCubit extends BaseCubit<MealsState, BaseUiEvent> {
  final GetMealsCategoriesUseCase? _getMealsCategoriesUseCase;
  final GetMealsByCategoryUseCase? _getMealsByCategoryUseCase;
  final GetMealDetailsUseCase? _getMealDetailsUseCase;

  @factoryMethod
  factory MealsCubit.create(
    GetMealsCategoriesUseCase getMealsCategoriesUseCase,
    GetMealsByCategoryUseCase getMealsByCategoryUseCase,
    GetMealDetailsUseCase getMealDetailsUseCase,
  ) => MealsCubit(
    getMealsCategoriesUseCase,
    getMealsByCategoryUseCase,
    getMealDetailsUseCase,
  );

  MealsCubit(
    GetMealsCategoriesUseCase? getMealsCategoriesUseCase, [
    GetMealsByCategoryUseCase? getMealsByCategoryUseCase,
    GetMealDetailsUseCase? getMealDetailsUseCase,
  ]) : _getMealsCategoriesUseCase = getMealsCategoriesUseCase,
       _getMealsByCategoryUseCase = getMealsByCategoryUseCase,
       _getMealDetailsUseCase = getMealDetailsUseCase,
       super(const MealsState());

  Future<void> doEvent(MealsEvent event) async {
    switch (event) {
      case GetMealsCategoriesEvent():
        await _getMealsCategories(event.category);

      case GetMealsByCategoryEvent():
        await _getMealsByCategory(event.category);

      case ChangeSelectedMealCategoryEvent():
        final categories = state.mealsCategoriesState.data;
        final chosenCategory = (categories != null && categories.isNotEmpty)
            ? (categories.any((c) => c.name == event.category)
                  ? event.category
                  : categories.first.name)
            : event.category;
        emit(state.copyWith(selectedCategory: chosenCategory));
        await _getMealsByCategory(chosenCategory);
    }
  }

  void onEvent(MealDetailsEvent event) {
    switch (event) {
      case GetMealDetailsEvent():
        _getMealDetails(event.mealId);
    }
  }

  Future<void> _getMealsCategories([String? category]) async {
    if (state.mealsCategoriesState.isLoading || isClosed) return;
    if (_getMealsCategoriesUseCase == null) return;
    emit(
      state.copyWith(
        mealsCategoriesState: state.mealsCategoriesState.copyWith(
          isLoading: true,
        ),
      ),
    );

    final result = await _getMealsCategoriesUseCase.call();

    if (isClosed) return;
    switch (result) {
      case Success<List<MealCategoryEntity>>():
        final categories = result.data;
        if (categories.isNotEmpty) {
          final categoryNames = categories.map((e) => e.name).toList();
          final chosenCategory =
              (category != null && categoryNames.contains(category))
              ? category
              : (categoryNames.contains(state.selectedCategory) &&
                        state.selectedCategory.isNotEmpty
                    ? state.selectedCategory
                    : categoryNames.first);

          emit(
            state.copyWith(
              mealsCategoriesState: state.mealsCategoriesState.copyWith(
                isLoading: false,
                data: categories,
                errorMessage: null,
              ),
              selectedCategory: chosenCategory,
            ),
          );
          unawaited(_getMealsByCategory(chosenCategory));
        } else {
          emit(
            state.copyWith(
              mealsCategoriesState: state.mealsCategoriesState.copyWith(
                isLoading: false,
                data: categories,
                errorMessage: null,
              ),
            ),
          );
        }

      case Error<List<MealCategoryEntity>>():
        emit(
          state.copyWith(
            mealsCategoriesState: state.mealsCategoriesState.copyWith(
              isLoading: false,
              errorMessage: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _getMealsByCategory(String category) async {
    if (state.mealsByCategoriesState.isLoading || isClosed) return;
    if (_getMealsByCategoryUseCase == null) return;
    emit(
      state.copyWith(
        mealsByCategoriesState: state.mealsByCategoriesState.copyWith(
          isLoading: true,
        ),
      ),
    );

    final response = await _getMealsByCategoryUseCase.call(category);

    if (isClosed) return;
    switch (response) {
      case Success<List<MealEntity>>():
        emit(
          state.copyWith(
            mealsByCategoriesState: state.mealsByCategoriesState.copyWith(
              isLoading: false,
              data: response.data,
              errorMessage: null,
            ),
          ),
        );

      case Error<List<MealEntity>>():
        emit(
          state.copyWith(
            mealsByCategoriesState: state.mealsByCategoriesState.copyWith(
              isLoading: false,
              errorMessage: response.failure,
            ),
          ),
        );
    }
  }

  Future<void> _getMealDetails(String mealId) async {
    if (_getMealDetailsUseCase == null) return;
    emit(
      state.copyWith(
        mealsState: BaseState(data: null, isLoading: true, errorMessage: null),
      ),
    );
    var result = await _getMealDetailsUseCase.call(mealId);
    if (isClosed) return;
    switch (result) {
      case Success<List<DetailsMealEntity>>():
        emit(
          state.copyWith(
            mealsState: BaseState(
              data: result.data,
              isLoading: false,
              errorMessage: null,
            ),
          ),
        );

      case Error<List<DetailsMealEntity>>():
        emit(
          state.copyWith(
            mealsState: BaseState(
              isLoading: false,
              errorMessage: result.failure,
            ),
          ),
        );
        emitEvent(ShowFailureMessage(result.failure));
    }
  }
}
