import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

LoginRequest loginRequestFromJson(String str) =>
    LoginRequest.fromJson(json.decode(str));

String loginRequestToJson(LoginRequest data) => json.encode(data.toJson());

@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;
  LoginRequest({required this.email, required this.password});
  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
