import 'package:fitness_app/features/auth/data/model/responces/register_request/user_dto.dart';
import 'package:fitness_app/features/auth/domain/entities/register_entity/register_response_entity.dart';
import 'package:fitness_app/features/auth/domain/entities/register_entity/user_enity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'register_response.g.dart';

@JsonSerializable()
class RegisterResponseDto {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "user")
  UserDto? user;
  @JsonKey(name: "token")
  String? token;

  RegisterResponseDto({this.message, this.user, this.token});
  RegisterResponeEntity toEntity() {
    return RegisterResponeEntity(
      message: message ?? '',
      user: user?.toEntity(user) ?? UserEntity(),
      token: token ?? '',
    );
  }

  factory RegisterResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseDtoToJson(this);
}
