import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/features/auth/data/model/responses/login_response/login_response.dart';
import 'package:fitness_app/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:fitness_app/features/auth/domain/entities/login_entity/user_entity.dart';
import '../../../../helpers/test_data.dart';

void main() {
  group('LoginResponse & UserResponse Models & Entities', () {
    test('fromJson with full JSON and toEntity mapping', () {
      final response = LoginResponse.fromJson(TestData.loginResponseJson);
      expect(response.message, 'Login successful');
      expect(response.token, TestData.fakeToken);
      expect(response.user?.id, 'user_123');
      expect(response.user?.email, TestData.validEmail);

      final entity = response.toEntity();
      expect(entity, isA<LoginEntity>());
      expect(entity.message, 'Login successful');
      expect(entity.token, TestData.fakeToken);
      expect(entity.user.email, TestData.validEmail);
    });

    test('fromJson and toEntity with all-null/missing fields defaults correctly', () {
      final response = LoginResponse.fromJson({});
      expect(response.message, null);
      expect(response.token, null);
      expect(response.user, null);

      final entity = response.toEntity();
      expect(entity.message, '');
      expect(entity.token, '');
      expect(entity.user, isA<UserEntity>());
      expect(entity.user.email, null);
    });

    test('Equatable equality for LoginEntity and UserEntity', () {
      final u1 = UserEntity(email: 'a@b.com');
      final u2 = UserEntity(email: 'a@b.com');
      final u3 = UserEntity(email: 'c@d.com');

      expect(u1, u2);
      expect(u1, isNot(u3));
      expect(u1.props, contains('a@b.com'));

      final l1 = LoginEntity(message: 'm', user: u1, token: 't');
      final l2 = LoginEntity(message: 'm', user: u2, token: 't');
      final l3 = LoginEntity(message: 'm', user: u3, token: 't');

      expect(l1, l2);
      expect(l1, isNot(l3));
    });

    test('weight/height/age arriving as a double decodes correctly', () {
      final jsonWithDoubles = {
        'message': 'OK',
        'token': 'tok',
        'user': {
          'age': 25.5,
          'weight': 70.5,
          'height': 175.5,
        },
      };
      final res = LoginResponse.fromJson(jsonWithDoubles);
      expect(res.user?.weight, 70.5);
      expect(res.user?.height, 175.5);
      expect(res.user?.age, 25);

      final entity = res.toEntity();
      expect(entity.user.weight, 70.5);
      expect(entity.user.height, 175.5);
      expect(entity.user.age, 25);
    });

    test('integer JSON weight and height decode to double values', () {
      final jsonWithInts = {
        'message': 'OK',
        'token': 'tok',
        'user': {
          'weight': 70,
          'height': 175,
        },
      };
      final res = LoginResponse.fromJson(jsonWithInts);
      expect(res.user?.weight, 70.0);
      expect(res.user?.weight, isA<double>());
      expect(res.user?.height, 175.0);
      expect(res.user?.height, isA<double>());
    });
  });
}
