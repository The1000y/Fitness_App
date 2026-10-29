
import 'dart:convert';

import 'package:fitness_app/features/exercise/data/model/responses/muscle_group_response.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscles_by_group_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'muscles_response.g.dart';

MusclesResponse musclesResponseFromJson(String str) =>
    MusclesResponse.fromJson(json.decode(str));

String musclesResponseToJson(MusclesResponse data) =>
    json.encode(data.toJson());

@JsonSerializable(explicitToJson: true)
class MusclesResponse {
  final String? message;

  @JsonKey(name: 'musclesGroup')
  final List<MuscleGroupResponse>? musclesGroup;

  MusclesResponse({
    this.message,
    this.musclesGroup,
  });

  factory MusclesResponse.fromJson(Map<String, dynamic> json) =>
      _$MusclesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MusclesResponseToJson(this);

  MusclesByGroupEntity toEntity() {
    return MusclesByGroupEntity(
      message: message ?? '',
      musclesGroup: musclesGroup
              ?.map((muscle) => muscle.toEntity())
              .toList() ??
          [],
    );
  }
}
