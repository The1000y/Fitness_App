import 'package:fitness_app/features/auth/domain/entities/params/verify_otp_param.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VerifyOtpParam', () {
    test('instantiates correctly with resetCode', () {
      const tParam = VerifyOtpParam('1234');
      expect(tParam.resetCode, equals('1234'));
    });
  });
}
