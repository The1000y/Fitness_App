// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileResponseDto _$ProfileResponseDtoFromJson(Map<String, dynamic> json) =>
    ProfileResponseDto(
      message: json['message'] as String?,
      user: json['user'] == null
          ? null
          : ProfileUserDto.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProfileResponseDtoToJson(ProfileResponseDto instance) =>
    <String, dynamic>{
      'message': instance.message,
      'user': instance.user?.toJson(),
    };

ProfileUserDto _$ProfileUserDtoFromJson(Map<String, dynamic> json) =>
    ProfileUserDto(
      id: json['_id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      gender: json['gender'] as String?,
      age: (json['age'] as num?)?.toInt(),
      weight: (json['weight'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      activityLevel: json['activityLevel'] as String?,
      goal: json['goal'] as String?,
      photo: json['photo'] as String?,
    );

Map<String, dynamic> _$ProfileUserDtoToJson(ProfileUserDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'gender': instance.gender,
      'age': instance.age,
      'weight': instance.weight,
      'height': instance.height,
      'activityLevel': instance.activityLevel,
      'goal': instance.goal,
      'photo': instance.photo,
    };
