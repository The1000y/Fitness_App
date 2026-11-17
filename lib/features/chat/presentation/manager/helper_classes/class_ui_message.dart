import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_entity.dart';

class ChatUiMessage extends Equatable {
  final bool isUser;
  final String text;
  final List<ExerciseEntity> exercises;
  final List<MealEntity> meals;
  const ChatUiMessage({
    required this.isUser,
    required this.text,
    this.exercises = const [],
    this.meals = const [],
  });

  @override
  List<Object?> get props => [isUser, text, exercises, meals];
}
