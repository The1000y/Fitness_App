import 'package:fitness_app/features/profile/data/model/requests/change_password_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChangePasswordRequest', () {
    test('toJson_usesApiFieldNames', () {
      const request = ChangePasswordRequest(
        password: 'Old@1234',
        newPassword: 'New@1234',
      );

      expect(request.toJson(), {
        'password': 'Old@1234',
        'newPassword': 'New@1234',
      });
    });

    test('fromJson_restoresFields', () {
      final request = ChangePasswordRequest.fromJson(const {
        'password': 'Old@1234',
        'newPassword': 'New@1234',
      });

      expect(request.password, 'Old@1234');
      expect(request.newPassword, 'New@1234');
    });
  });
}
