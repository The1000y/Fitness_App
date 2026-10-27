import 'package:fitness_app/features/auth/data/model/responces/login_response/login_response.dart';
import 'package:fitness_app/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:fitness_app/features/auth/domain/entities/login_entity/user_entity.dart';

class TestData {
  static const String validEmail = 'test@example.com';
  static const String validPassword = 'Test@1234';
  static const String fakeToken = 'fake.jwt.token';

  static const Map<String, dynamic> loginResponseJson = {
    'message': 'Login successful',
    'token': fakeToken,
    'user': {
      '_id': 'user_123',
      'firstName': 'John',
      'lastName': 'Doe',
      'email': validEmail,
      'gender': 'male',
      'age': 25,
      'weight': 70,
      'height': 175,
      'activityLevel': 'active',
      'goal': 'fitness',
      'photo': 'photo.png',
      'createdAt': '2026-01-01T00:00:00.000Z',
    },
  };

  static LoginResponse get loginResponse =>
      LoginResponse.fromJson(loginResponseJson);
  static LoginEntity get loginEntity => loginResponse.toEntity();
  static UserEntity get userEntity => loginEntity.user;
}
