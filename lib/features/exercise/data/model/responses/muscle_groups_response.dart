import 'dart:convert';

import 'package:fitness_app/features/exercise/data/model/responses/muscle_group_dto.dart';
import 'package:fitness_app/features/exercise/domain/entities/muscle_groups_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'muscle_groups_response.g.dart';

MuscleGroupsResponse musclesResponseFromJson(String str) =>
    MuscleGroupsResponse.fromJson(json.decode(str));

String musclesResponseToJson(MuscleGroupsResponse data) =>
    json.encode(data.toJson());

@JsonSerializable(explicitToJson: true)
class MuscleGroupsResponse {
  final String? message;

  @JsonKey(name: 'musclesGroup')
  final List<MuscleGroupDto>? musclesGroup;

  MuscleGroupsResponse({this.message, this.musclesGroup});

  factory MuscleGroupsResponse.fromJson(Map<String, dynamic> json) =>
      _$MuscleGroupsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MuscleGroupsResponseToJson(this);

  MuscleGroupsEntity toEntity() {
    return MuscleGroupsEntity(
      message: message ?? '',
      musclesGroup:
          musclesGroup?.map((muscle) => muscle.toEntity()).toList() ?? [],
    );
  }
}
