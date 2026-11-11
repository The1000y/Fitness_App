import 'package:json_annotation/json_annotation.dart';

part 'profile_update_request.g.dart';

@JsonSerializable()
class ProfileUpdateRequest {
  @JsonKey(name: 'firstName')
  final String? firstName;

  @JsonKey(name: 'lastName')
  final String? lastName;

  @JsonKey(name: 'gender')
  final String? gender;

  @JsonKey(name: 'age')
  final int? age;

  @JsonKey(name: 'weight')
  final double? weight;

  @JsonKey(name: 'height')
  final double? height;

  @JsonKey(name: 'activityLevel')
  final String? activityLevel;

  @JsonKey(name: 'goal')
  final String? goal;

  const ProfileUpdateRequest({
    this.firstName,
    this.lastName,
    this.gender,
    this.age,
    this.weight,
    this.height,
    this.activityLevel,
    this.goal,
  });

  factory ProfileUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$ProfileUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileUpdateRequestToJson(this);
}
