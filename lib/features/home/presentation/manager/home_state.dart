import 'package:equatable/equatable.dart';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscles_by_group_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscles_entity.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_category_entity.dart';

class HomeState extends Equatable {
  final BaseState<UserEntity> userState;
  final BaseState<MusclesEntity> randomMusclesState;
  final BaseState<MusclesByGroupEntity> muscleGroupsState;
  final BaseState<MusclesEntity> groupMusclesState;
  final BaseState<List<MealCategoryEntity>> mealCategoriesState;
  final String? selectedGroupId;

  const HomeState({
    this.userState = const BaseState<UserEntity>(),
    this.randomMusclesState = const BaseState<MusclesEntity>(),
    this.muscleGroupsState = const BaseState<MusclesByGroupEntity>(),
    this.groupMusclesState = const BaseState<MusclesEntity>(),
    this.mealCategoriesState = const BaseState<List<MealCategoryEntity>>(),
    this.selectedGroupId,
  });

  HomeState copyWith({
    BaseState<UserEntity>? userState,
    BaseState<MusclesEntity>? randomMusclesState,
    BaseState<MusclesByGroupEntity>? muscleGroupsState,
    BaseState<MusclesEntity>? groupMusclesState,
    BaseState<List<MealCategoryEntity>>? mealCategoriesState,
    String? selectedGroupId,
  }) {
    return HomeState(
      userState: userState ?? this.userState,
      randomMusclesState: randomMusclesState ?? this.randomMusclesState,
      muscleGroupsState: muscleGroupsState ?? this.muscleGroupsState,
      groupMusclesState: groupMusclesState ?? this.groupMusclesState,
      mealCategoriesState: mealCategoriesState ?? this.mealCategoriesState,
      selectedGroupId: selectedGroupId ?? this.selectedGroupId,
    );
  }

  @override
  List<Object?> get props => [
    userState,
    randomMusclesState,
    muscleGroupsState,
    groupMusclesState,
    mealCategoriesState,
    selectedGroupId,
  ];
}