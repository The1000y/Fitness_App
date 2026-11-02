import 'package:equatable/equatable.dart';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/features/meals/domain/entities/details_meal_entity.dart';

class MealsState extends Equatable {
  final BaseState<List<DetailsMealEntity>> mealsState;

  const MealsState({
    this.mealsState = const BaseState<List<DetailsMealEntity>>(),
  });

  MealsState copyWith({BaseState<List<DetailsMealEntity>>? mealsState}) {
    return MealsState(mealsState: mealsState ?? this.mealsState);
  }

  @override
  List<Object?> get props => [mealsState];
}
