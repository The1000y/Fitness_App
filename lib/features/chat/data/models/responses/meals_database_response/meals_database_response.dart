import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'meal_database_dto.dart';

part 'meals_database_response.g.dart';

MealsDatabaseResponse mealsDatabaseResponseFromJson(String str) =>
    MealsDatabaseResponse.fromJson(json.decode(str));

String mealsDatabaseResponseToJson(MealsDatabaseResponse data) =>
    json.encode(data.toJson());

@JsonSerializable(explicitToJson: true)
class MealsDatabaseResponse {
  @JsonKey(name: 'meals')
  final List<MealDatabaseDTO>? meals;

  const MealsDatabaseResponse({this.meals});

  factory MealsDatabaseResponse.fromJson(Map<String, dynamic> json) =>
      _$MealsDatabaseResponseFromJson(json);

  /// Builds the response from raw rows returned by sqflite / drift
  /// (`db.query('meal')`, `db.rawQuery(...)`).
  factory MealsDatabaseResponse.fromRows(List<Map<String, Object?>> rows) =>
      MealsDatabaseResponse(
        meals: rows
            .map(
              (row) => MealDatabaseDTO.fromJson(Map<String, dynamic>.from(row)),
            )
            .toList(),
      );

  Map<String, dynamic> toJson() => _$MealsDatabaseResponseToJson(this);
}

typedef MealsDbResponse = MealsDatabaseResponse;
