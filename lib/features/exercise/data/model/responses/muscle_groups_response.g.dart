// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'muscle_groups_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MuscleGroupsResponse _$MuscleGroupsResponseFromJson(
  Map<String, dynamic> json,
) => MuscleGroupsResponse(
  message: json['message'] as String?,
  musclesGroup: (json['musclesGroup'] as List<dynamic>?)
      ?.map((e) => MuscleGroupDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MuscleGroupsResponseToJson(
  MuscleGroupsResponse instance,
) => <String, dynamic>{
  'message': instance.message,
  'musclesGroup': instance.musclesGroup?.map((e) => e.toJson()).toList(),
};
