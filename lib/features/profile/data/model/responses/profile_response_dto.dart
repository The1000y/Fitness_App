import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile_response_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class ProfileResponseDto {
  final String? message;
  final ProfileUserDto? user;

  const ProfileResponseDto({this.message, this.user});

  factory ProfileResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileResponseDtoToJson(this);

  ProfileEntity toEntity() => user?.toEntity() ?? ProfileEntity.empty;
}

@JsonSerializable()
class ProfileUserDto {
  @JsonKey(name: '_id')
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? gender;
  final int? age;
  final double? weight;
  final double? height;
  final String? activityLevel;
  final String? goal;
  final String? photo;

  const ProfileUserDto({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.age,
    this.weight,
    this.height,
    this.activityLevel,
    this.goal,
    this.photo,
  });

  factory ProfileUserDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileUserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileUserDtoToJson(this);

  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id ?? '',
      firstName: firstName ?? '',
      lastName: lastName ?? '',
      email: email ?? '',
      gender: gender ?? '',
      age: age ?? 0,
      weight: weight ?? 0,
      height: height ?? 0,
      activityLevel: activityLevel ?? '',
      goal: goal ?? '',
      photo: photo ?? '',
    );
  }
}
