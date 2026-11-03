import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/exercises_list_entity.dart';
import 'exercise_response.dart';

part 'exercises_list_response.g.dart';

@JsonSerializable(explicitToJson: true)
class ExercisesListResponse {
  final String? message;
  final int? totalExercises;
  final int? totalPages;
  final int? currentPage;
  final List<ExerciseResponse>? exercises;

  ExercisesListResponse({
    this.message,
    this.totalExercises,
    this.totalPages,
    this.currentPage,
    this.exercises,
  });

  factory ExercisesListResponse.fromJson(Map<String, dynamic> json) =>
      _$ExercisesListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExercisesListResponseToJson(this);

  ExercisesListEntity toEntity() {
    return ExercisesListEntity(
      message: message ?? '',
      totalExercises: totalExercises ?? 0,
      totalPages: totalPages ?? 0,
      currentPage: currentPage ?? 0,
      exercises: exercises?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}
