
import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscle_group_entity.dart';

class MuscleGroupsEntity extends Equatable {
  final String message;
  final int totalMuscles;
  final List<MuscleGroupEntity> muscles;

  const MuscleGroupsEntity({
    required this.message,
    required this.totalMuscles,
    required this.muscles,
  });

  @override
  List<Object?> get props => [message, totalMuscles, muscles];
}
