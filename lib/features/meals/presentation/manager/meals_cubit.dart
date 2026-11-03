import 'dart:async';

import 'package:fitness_app/config/base/base_cubit.dart';
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_category_entity.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_entity.dart';
import 'package:fitness_app/features/meals/domain/use_cases/get_meals_by_category_use_case.dart';
import 'package:fitness_app/features/meals/domain/use_cases/get_meals_categories_use_case.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_event.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_state.dart';
import 'package:injectable/injectable.dart';
import '../../../../config/base/base_response.dart';

@injectable
class MealsCubit extends BaseCubit<MealsState, BaseUiEvent> {
  final GetMealsCategoriesUseCase _getMealsCategoriesUseCase;
  final GetMealsByCategoryUseCase _getMealsByCategoryUseCase;

  MealsCubit(this._getMealsCategoriesUseCase, this._getMealsByCategoryUseCase)
    : super(const MealsState());

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

  Future<void> _getMealsCategories([String? category]) async {
    if (state.mealsCategoriesState.isLoading || isClosed) return;
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
}
