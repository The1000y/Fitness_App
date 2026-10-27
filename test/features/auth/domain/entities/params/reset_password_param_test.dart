import 'package:fitness_app/features/auth/domain/entities/params/reset_password_param.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResetPasswordParam', () {
    test('instantiates correctly with email and password', () {
      const tParam = ResetPasswordParam(
        email: 'user@example.com',
        password: 'Password123!',
      );
      expect(tParam.email, equals('user@example.com'));
      expect(tParam.password, equals('Password123!'));
    });
  });
}
