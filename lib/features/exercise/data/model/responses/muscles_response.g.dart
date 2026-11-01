// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'muscles_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusclesResponse _$MusclesResponseFromJson(Map<String, dynamic> json) =>
    MusclesResponse(
      message: json['message'] as String?,
      musclesGroup: (json['musclesGroup'] as List<dynamic>?)
          ?.map((e) => MuscleGroupResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MusclesResponseToJson(MusclesResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'musclesGroup': instance.musclesGroup?.map((e) => e.toJson()).toList(),
    };
