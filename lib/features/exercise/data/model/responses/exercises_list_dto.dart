import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/exercises_list_entity.dart';
import 'exercise_dto.dart';

part 'exercises_list_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class ExercisesListDto {
  final String? message;
  final int? totalExercises;
  final int? totalPages;
  final int? currentPage;
  final List<ExerciseDto>? exercises;

  ExercisesListDto({
    this.message,
    this.totalExercises,
    this.totalPages,
    this.currentPage,
    this.exercises,
  });

  factory ExercisesListDto.fromJson(Map<String, dynamic> json) =>
      _$ExercisesListDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ExercisesListDtoToJson(this);

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
