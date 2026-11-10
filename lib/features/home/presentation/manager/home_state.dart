import 'package:equatable/equatable.dart';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscles_by_group_entity.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_category_entity.dart';

import '../../../exercise/domain/entities/muscle_groups_entity.dart';
import '../../domain/entities/popular_training_entity.dart';

class HomeState extends Equatable {
  final BaseState<UserEntity> userState;
  final BaseState<MusclesByGroupEntity> randomMusclesState;
  final BaseState<MuscleGroupsEntity> muscleGroupsState;
  final BaseState<MusclesByGroupEntity> groupMusclesState;
  final BaseState<List<MealCategoryEntity>> mealCategoriesState;
  final BaseState<List<PopularTrainingEntity>> popularTrainingState;
  final String? selectedGroupId;

  const HomeState({
    this.userState = const BaseState<UserEntity>(),
    this.randomMusclesState = const BaseState<MusclesByGroupEntity>(),
    this.muscleGroupsState = const BaseState<MuscleGroupsEntity>(),
    this.groupMusclesState = const BaseState<MusclesByGroupEntity>(),
    this.mealCategoriesState = const BaseState<List<MealCategoryEntity>>(),
    this.popularTrainingState = const BaseState<List<PopularTrainingEntity>>(),
    this.selectedGroupId,
  });

  HomeState copyWith({
    BaseState<UserEntity>? userState,
    BaseState<MusclesByGroupEntity>? randomMusclesState,
    BaseState<MuscleGroupsEntity>? muscleGroupsState,
    BaseState<MusclesByGroupEntity>? groupMusclesState,
    BaseState<List<MealCategoryEntity>>? mealCategoriesState,
    BaseState<List<PopularTrainingEntity>>? popularTrainingState,
    String? selectedGroupId,
  }) {
    return HomeState(
      userState: userState ?? this.userState,
      randomMusclesState: randomMusclesState ?? this.randomMusclesState,
      muscleGroupsState: muscleGroupsState ?? this.muscleGroupsState,
      groupMusclesState: groupMusclesState ?? this.groupMusclesState,
      mealCategoriesState: mealCategoriesState ?? this.mealCategoriesState,
      popularTrainingState: popularTrainingState ?? this.popularTrainingState,
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
    popularTrainingState,
    selectedGroupId,
  ];
}
