import 'package:fitness_app/features/auth/domain/entities/forget_password_entity/forget_password_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ForgetPasswordEntity', () {
    const tEntity1 = ForgetPasswordEntity(
      isSuccess: true,
      message: 'OTP sent successfully',
    );
    const tEntity2 = ForgetPasswordEntity(
      isSuccess: true,
      message: 'OTP sent successfully',
    );
    const tEntityDifferent = ForgetPasswordEntity(
      isSuccess: false,
      message: 'Email not found',
    );

    test('supports value equality via Equatable', () {
      expect(tEntity1, equals(tEntity2));
    });

    test('props contains isSuccess and message', () {
      expect(tEntity1.props, equals([true, 'OTP sent successfully']));
    });

    test('different values are not equal', () {
      expect(tEntity1, isNot(equals(tEntityDifferent)));
    });
  });
}
