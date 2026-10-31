
import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscle_entity.dart';

class MusclesEntity extends Equatable {
  final String message;
  final int totalMuscles;
  final List<MuscleEntity> muscles;

  const MusclesEntity({
    required this.message,
    required this.totalMuscles,
    required this.muscles,
  });

  @override
  List<Object?> get props => [message, totalMuscles, muscles];
}
