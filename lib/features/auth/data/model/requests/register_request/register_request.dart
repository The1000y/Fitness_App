import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

@JsonSerializable()
class RegisterRequestDto {
  @JsonKey(name: "firstName")
  final String firstName;
  @JsonKey(name: "lastName")
  final String lastName;
  @JsonKey(name: "email")
  final String email;
  @JsonKey(name: "password")
  final String password;
  @JsonKey(name: "rePassword")
  final String rePassword;
  @JsonKey(name: "gender")
  final String gender;
  @JsonKey(name: "height")
  final int height;
  @JsonKey(name: "weight")
  final int weight;
  @JsonKey(name: "age")
  final int age;
  @JsonKey(name: "goal")
  final String goal;
  @JsonKey(name: "activityLevel")
  final String activityLevel;

  RegisterRequestDto({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.rePassword,
    required this.gender,
    required this.height,
    required this.weight,
    required this.age,
    required this.goal,
    required this.activityLevel,
  });

  factory RegisterRequestDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestDtoToJson(this);
}
