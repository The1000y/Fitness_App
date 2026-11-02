sealed class MealDetailsEvent {}

class GetMealDetailsEvent extends MealDetailsEvent {
  final String mealId;
  GetMealDetailsEvent(this.mealId);
}
