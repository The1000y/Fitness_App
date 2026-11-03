import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscle_entity.dart';

class MusclesByGroupEntity extends Equatable {
  final String message;
  final List<MuscleEntity> muscles;

  const MusclesByGroupEntity({
    required this.message,
    required this.muscles,
  });

  @override
  List<Object?> get props => [message, muscles];
}