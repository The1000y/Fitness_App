import 'package:fitness_app/features/auth/domain/entities/params/forget_password_param.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ForgetPasswordParam', () {
    test('instantiates correctly with email', () {
      const tParam = ForgetPasswordParam(email: 'user@example.com');
      expect(tParam.email, equals('user@example.com'));
    });
  });
}
