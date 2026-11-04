import 'package:fitness_app/features/auth/domain/entities/register_entity/user_enity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDto {
  @JsonKey(name: "firstName")
  String? firstName;
  @JsonKey(name: "lastName")
  String? lastName;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "gender")
  String? gender;
  @JsonKey(name: "age")
  int? age;
  @JsonKey(name: "weight")
  int? weight;
  @JsonKey(name: "height")
  int? height;
  @JsonKey(name: "activityLevel")
  String? activityLevel;
  @JsonKey(name: "goal")
  String? goal;
  @JsonKey(name: "photo")
  String? photo;
  @JsonKey(name: "_id")
  String? id;
  @JsonKey(name: "createdAt")
  DateTime? createdAt;

  UserDto({
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
    this.id,
    this.createdAt,
  });

  UserEntity toEntity(UserDto? user) {
    return UserEntity(
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
      id: id ?? '',
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}
