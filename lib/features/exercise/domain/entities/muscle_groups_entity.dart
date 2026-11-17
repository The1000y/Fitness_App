import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscle_group_entity.dart';

class MuscleGroupsEntity extends Equatable {
  final String message;
  final List<MuscleGroupEntity> musclesGroup;

  const MuscleGroupsEntity({required this.message, required this.musclesGroup});

  @override
  List<Object?> get props => [message, musclesGroup];
}
