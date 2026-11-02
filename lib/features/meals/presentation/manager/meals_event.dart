sealed class MealsEvent {}

class GetMealsCategoriesEvent extends MealsEvent {
  String? category;
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
