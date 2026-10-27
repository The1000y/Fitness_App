import 'dart:convert';
import 'package:fitness_app/features/auth/data/model/requests/reset_password_request/reset_password_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResetPasswordRequest', () {
    const tEmail = 'test@example.com';
    const tPassword = 'NewPassword123!';
    final tJson = {
      'email': tEmail,
      'newPassword': tPassword,
    };
    final tJsonString = json.encode(tJson);

    test('fromJson should return valid model when given valid json', () {
      final result = ResetPasswordRequest.fromJson(tJson);

      expect(result.email, equals(tEmail));
      expect(result.newPassword, equals(tPassword));
    });

    test('toJson should return correct json map', () {
      final model = ResetPasswordRequest(
        email: tEmail,
        newPassword: tPassword,
      );
      final result = model.toJson();

      expect(result, equals(tJson));
    });

    test('resetPasswordRequestFromJson should deserialize json string', () {
      final result = resetPasswordRequestFromJson(tJsonString);

      expect(result.email, equals(tEmail));
      expect(result.newPassword, equals(tPassword));
    });

    test('resetPasswordRequestToJson should serialize to json string', () {
      final model = ResetPasswordRequest(
        email: tEmail,
        newPassword: tPassword,
      );
      final result = resetPasswordRequestToJson(model);

      expect(result, equals(tJsonString));
    });

    test('handles null fields properly', () {
      final model = ResetPasswordRequest(email: null, newPassword: null);
      final jsonResult = model.toJson();
      final fromJsonResult = ResetPasswordRequest.fromJson(jsonResult);

      expect(fromJsonResult.email, isNull);
      expect(fromJsonResult.newPassword, isNull);
    });
  });
}
