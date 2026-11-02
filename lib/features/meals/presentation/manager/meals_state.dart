import 'package:equatable/equatable.dart';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_category_entity.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_entity.dart';

class MealsState extends Equatable {
  final BaseState<List<MealCategoryEntity>> mealsCategoriesState;
  final BaseState<List<MealEntity>> mealsByCategoriesState;

  const MealsState({
    this.mealsCategoriesState = const BaseState<List<MealCategoryEntity>>(),
    this.mealsByCategoriesState = const BaseState<List<MealEntity>>(),
  });

  MealsState copyWith({
    BaseState<List<MealCategoryEntity>>? mealsCategoriesState,
    final BaseState<List<MealEntity>>? mealsByCategoriesState,
  }) {
    return MealsState(
      mealsCategoriesState: mealsCategoriesState ?? this.mealsCategoriesState,
      mealsByCategoriesState:
          mealsByCategoriesState ?? this.mealsByCategoriesState,
    );
  }

  @override
  List<Object?> get props => [mealsCategoriesState, mealsByCategoriesState];
}
