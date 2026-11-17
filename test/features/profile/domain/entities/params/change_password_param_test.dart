import 'package:fitness_app/features/profile/domain/entities/params/change_password_param.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChangePasswordParam', () {
    test('equalValues_areEqual', () {
      const a = ChangePasswordParam(oldPassword: 'a', newPassword: 'b');
      const b = ChangePasswordParam(oldPassword: 'a', newPassword: 'b');

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('differentValues_areNotEqual', () {
      const a = ChangePasswordParam(oldPassword: 'a', newPassword: 'b');
      const b = ChangePasswordParam(oldPassword: 'a', newPassword: 'c');

      expect(a, isNot(b));
    });
  });
}
