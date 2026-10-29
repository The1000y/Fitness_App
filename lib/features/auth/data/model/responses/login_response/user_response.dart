import 'package:fitness_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_response.g.dart';

@JsonSerializable()
class UserResponse {
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
  final String? createdAt;
  UserResponse({
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
      this.createdAt,
});
 factory UserResponse.fromJson(Map<String, dynamic> json) => _$UserResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      gender: gender,
      age: age,
      weight: weight,
      height: height,
      activityLevel: activityLevel,
      goal: goal,
      photo: photo,
      createdAt: createdAt,
    );


  }
}
