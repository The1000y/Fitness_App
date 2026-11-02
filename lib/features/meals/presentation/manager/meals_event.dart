sealed class MealsEvent {}

class GetMealsCategoriesEvent extends MealsEvent {}

class GetMealsByCategoryEvent extends MealsEvent {
  String category;
  GetMealsByCategoryEvent(this.category);
}

class TriggerMealsAfterCategoriesCalledEvent extends MealsEvent {
  String category;
  TriggerMealsAfterCategoriesCalledEvent(this.category);
}
