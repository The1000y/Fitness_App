import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/features/auth/data/model/requests/login_request/login_request.dart';
import '../../../../helpers/test_data.dart';

void main() {
  group('LoginRequest Model', () {
    test('toJson and fromJson work correctly', () {
      final request = LoginRequest(
        email: TestData.validEmail,
        password: TestData.validPassword,
      );

      final json = request.toJson();
      expect(json['email'], TestData.validEmail);
      expect(json['password'], TestData.validPassword);

      final fromJson = LoginRequest.fromJson(json);
      expect(fromJson.email, TestData.validEmail);
      expect(fromJson.password, TestData.validPassword);
    });

    test('loginRequestFromJson and loginRequestToJson helpers work', () {
      const jsonStr = '{"email":"test@example.com","password":"Test@1234"}';
      final req = loginRequestFromJson(jsonStr);
      expect(req.email, 'test@example.com');

      final jsonOutput = loginRequestToJson(req);
      expect(jsonOutput, contains('test@example.com'));
    });
  });
}
