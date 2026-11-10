import 'package:equatable/equatable.dart';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/features/meals/domain/entities/details_meal_entity.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_category_entity.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_entity.dart';

class MealsState extends Equatable {
  final BaseState<List<MealCategoryEntity>> mealsCategoriesState;
  final BaseState<List<MealEntity>> mealsByCategoriesState;
  final String selectedCategory;
  final BaseState<List<DetailsMealEntity>> mealsState;

  const MealsState({
    this.mealsCategoriesState = const BaseState<List<MealCategoryEntity>>(),
    this.mealsByCategoriesState = const BaseState<List<MealEntity>>(),
    this.selectedCategory = '',
    this.mealsState = const BaseState<List<DetailsMealEntity>>(),
  });

  MealsState copyWith({
    BaseState<List<MealCategoryEntity>>? mealsCategoriesState,
    BaseState<List<MealEntity>>? mealsByCategoriesState,
    String? selectedCategory,
    BaseState<List<DetailsMealEntity>>? mealsState,
  }) {
    return MealsState(
      mealsCategoriesState: mealsCategoriesState ?? this.mealsCategoriesState,
      mealsByCategoriesState:
          mealsByCategoriesState ?? this.mealsByCategoriesState,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      mealsState: mealsState ?? this.mealsState,
    );
  }

  @override
  List<Object?> get props => [
    mealsCategoriesState,
    mealsByCategoriesState,
    selectedCategory,
    mealsState,
  ];
}
