// To parse this JSON data, do
//
//     final verifyOtpRequest = verifyOtpRequestFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'verify_otp_request.g.dart';

VerifyOtpRequest verifyOtpRequestFromJson(String str) => VerifyOtpRequest.fromJson(json.decode(str));

String verifyOtpRequestToJson(VerifyOtpRequest data) => json.encode(data.toJson());

@JsonSerializable()
class VerifyOtpRequest {
    @JsonKey(name: "resetCode")
    String? resetCode;

    VerifyOtpRequest({
        this.resetCode,
    });

    factory VerifyOtpRequest.fromJson(Map<String, dynamic> json) => _$VerifyOtpRequestFromJson(json);

    Map<String, dynamic> toJson() => _$VerifyOtpRequestToJson(this);
}
