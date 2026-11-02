import 'package:fitness_app/config/base/base_cubit.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/features/meals/domain/entities/details_meal_entity.dart';
import 'package:fitness_app/features/meals/domain/use_cases/get_meal_details_use_case.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_event.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class MealsCubit extends BaseCubit<MealsState, BaseUiEvent> {
  final GetMealDetailsUseCase _getMealDetailsUseCase;
  MealsCubit(this._getMealDetailsUseCase) : super(const MealsState());

  void onEvent(MealDetailsEvent event) {
    switch (event) {
      case GetMealDetailsEvent():
        _getMealDetails(event.mealId);
    }
  }

  Future<void> _getMealDetails(String mealId) async {
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
