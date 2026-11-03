
import 'dart:convert';

import 'package:fitness_app/features/exercise/data/model/responses/muscle_dto.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscles_by_group_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'muscles_by_group_response.g.dart';

MusclesByGroupResponse musclesByGroupResponseFromJson(String str) =>
    MusclesByGroupResponse.fromJson(json.decode(str));

String musclesByGroupResponseToJson(MusclesByGroupResponse data) =>
    json.encode(data.toJson());

@JsonSerializable(explicitToJson: true)
class MusclesByGroupResponse {
  final String? message;
  final int? totalMuscles;
  final List<MuscleDto>? muscles;

  MusclesByGroupResponse({
    this.message,
    this.totalMuscles,
    this.muscles,
  });

  factory MusclesByGroupResponse.fromJson(Map<String, dynamic> json) =>
      _$MusclesByGroupResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MusclesByGroupResponseToJson(this);

  MusclesByGroupEntity toEntity() {
    return MusclesByGroupEntity(
      message: message ?? '',
      muscles: muscles?.map((muscle) => muscle.toEntity()).toList() ?? [],
    );
  }
}
