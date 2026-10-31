// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'muscles_by_group_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusclesByGroupResponse _$MusclesByGroupResponseFromJson(
  Map<String, dynamic> json,
) => MusclesByGroupResponse(
  message: json['message'] as String?,
  totalMuscles: (json['totalMuscles'] as num?)?.toInt(),
  muscles: (json['muscles'] as List<dynamic>?)
      ?.map((e) => MuscleResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MusclesByGroupResponseToJson(
  MusclesByGroupResponse instance,
) => <String, dynamic>{
  'message': instance.message,
  'totalMuscles': instance.totalMuscles,
  'muscles': instance.muscles?.map((e) => e.toJson()).toList(),
};
