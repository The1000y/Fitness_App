import 'dart:convert';

import 'package:fitness_app/features/auth/data/model/responses/login_response/user_response.dart';
import 'package:fitness_app/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:fitness_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

@JsonSerializable(explicitToJson: true)
class LoginResponse {
  final String? message;
  final UserResponse? user;
  final String? token;

  LoginResponse({this.message, this.user, this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

  LoginEntity toEntity() {
    return LoginEntity(
      message: message ?? '',
      user: user?.toEntity() ?? UserEntity(),
      token: token ?? '',
    );
  }
}
