sealed class MealsEvent {}

class GetMealsCategoriesEvent extends MealsEvent {
  final String? category;
  GetMealsCategoriesEvent([this.category]);
}

class GetMealsByCategoryEvent extends MealsEvent {
  final String category;
  GetMealsByCategoryEvent(this.category);
}

class ChangeSelectedMealCategoryEvent extends MealsEvent {
  final String category;
  ChangeSelectedMealCategoryEvent(this.category);
}

sealed class MealDetailsEvent {}

class GetMealDetailsEvent extends MealDetailsEvent {
  final String mealId;
  GetMealDetailsEvent(this.mealId);
}
