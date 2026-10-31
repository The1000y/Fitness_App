import 'dart:convert';
import 'package:fitness_app/features/auth/data/model/requests/verify_otp_request/verify_otp_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VerifyOtpRequest', () {
    const tResetCode = '1234';
    final tJson = {'resetCode': tResetCode};
    final tJsonString = json.encode(tJson);

    test('fromJson should return valid model when given valid json', () {
      final result = VerifyOtpRequest.fromJson(tJson);

      expect(result.resetCode, equals(tResetCode));
    });

    test('toJson should return correct json map', () {
      final model = VerifyOtpRequest(resetCode: tResetCode);
      final result = model.toJson();

      expect(result, equals(tJson));
    });

    test('verifyOtpRequestFromJson should deserialize json string', () {
      final result = verifyOtpRequestFromJson(tJsonString);

      expect(result.resetCode, equals(tResetCode));
    });

    test('verifyOtpRequestToJson should serialize to json string', () {
      final model = VerifyOtpRequest(resetCode: tResetCode);
      final result = verifyOtpRequestToJson(model);

      expect(result, equals(tJsonString));
    });

    test('handles null resetCode properly', () {
      final model = VerifyOtpRequest(resetCode: null);
      final jsonResult = model.toJson();
      final fromJsonResult = VerifyOtpRequest.fromJson(jsonResult);

      expect(fromJsonResult.resetCode, isNull);
    });
  });
}
