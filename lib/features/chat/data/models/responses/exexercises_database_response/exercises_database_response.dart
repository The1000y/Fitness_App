import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'exercise_database_dto.dart';

export 'exercise_database_dto.dart';

part 'exercises_database_response.g.dart';

ExercisesDatabaseResponse exercisesDatabaseResponseFromJson(String str) =>
    ExercisesDatabaseResponse.fromJson(json.decode(str));

String exercisesDatabaseResponseToJson(ExercisesDatabaseResponse data) =>
    json.encode(data.toJson());

@JsonSerializable(explicitToJson: true)
class ExercisesDatabaseResponse {
  @JsonKey(name: 'exercises')
  final List<ExerciseDatabaseDTO>? exercises;

  const ExercisesDatabaseResponse({this.exercises});

  factory ExercisesDatabaseResponse.fromJson(Map<String, dynamic> json) =>
      _$ExercisesDatabaseResponseFromJson(json);

  /// Builds the response from raw rows returned by sqflite / drift
  /// (`db.query('exercise')`, `db.rawQuery(...)`).
  factory ExercisesDatabaseResponse.fromRows(List<Map<String, Object?>> rows) =>
      ExercisesDatabaseResponse(
        exercises: rows
            .map(
              (row) =>
                  ExerciseDatabaseDTO.fromJson(Map<String, dynamic>.from(row)),
            )
            .toList(),
      );

  Map<String, dynamic> toJson() => _$ExercisesDatabaseResponseToJson(this);
}

typedef ExercisesDbResponse = ExercisesDatabaseResponse;
