// To parse this JSON data, do
//
//     final resetPasswordRequest = resetPasswordRequestFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'reset_password_request.g.dart';

ResetPasswordRequest resetPasswordRequestFromJson(String str) => ResetPasswordRequest.fromJson(json.decode(str));

String resetPasswordRequestToJson(ResetPasswordRequest data) => json.encode(data.toJson());

@JsonSerializable()
class ResetPasswordRequest {
    @JsonKey(name: "email")
    String? email;
    @JsonKey(name: "newPassword")
    String? newPassword;

    ResetPasswordRequest({
        this.email,
        this.newPassword,
    });

    factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) => _$ResetPasswordRequestFromJson(json);

    Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);
}
