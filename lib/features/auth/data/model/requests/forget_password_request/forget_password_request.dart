// To parse this JSON data, do
//
//     final forgetPasswordRequest = forgetPasswordRequestFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'forget_password_request.g.dart';

ForgetPasswordRequest forgetPasswordRequestFromJson(String str) => ForgetPasswordRequest.fromJson(json.decode(str));

String forgetPasswordRequestToJson(ForgetPasswordRequest data) => json.encode(data.toJson());

@JsonSerializable()
class ForgetPasswordRequest {
    @JsonKey(name: "email")
    String? email;

    ForgetPasswordRequest({
        this.email,
    });

    factory ForgetPasswordRequest.fromJson(Map<String, dynamic> json) => _$ForgetPasswordRequestFromJson(json);

    Map<String, dynamic> toJson() => _$ForgetPasswordRequestToJson(this);
}
