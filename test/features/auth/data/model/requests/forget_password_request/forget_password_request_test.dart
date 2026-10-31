import 'dart:convert';
import 'package:fitness_app/features/auth/data/model/requests/forget_password_request/forget_password_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ForgetPasswordRequest', () {
    const tEmail = 'test@example.com';
    final tJson = {'email': tEmail};
    final tJsonString = json.encode(tJson);

    test('fromJson should return valid model when given valid json', () {
      final result = ForgetPasswordRequest.fromJson(tJson);

      expect(result.email, equals(tEmail));
    });

    test('toJson should return correct json map', () {
      final model = ForgetPasswordRequest(email: tEmail);
      final result = model.toJson();

      expect(result, equals(tJson));
    });

    test('forgetPasswordRequestFromJson should deserialize json string', () {
      final result = forgetPasswordRequestFromJson(tJsonString);

      expect(result.email, equals(tEmail));
    });

    test('forgetPasswordRequestToJson should serialize to json string', () {
      final model = ForgetPasswordRequest(email: tEmail);
      final result = forgetPasswordRequestToJson(model);

      expect(result, equals(tJsonString));
    });

    test('handles null email properly', () {
      final model = ForgetPasswordRequest(email: null);
      final jsonResult = model.toJson();
      final fromJsonResult = ForgetPasswordRequest.fromJson(jsonResult);

      expect(fromJsonResult.email, isNull);
    });
  });
}
