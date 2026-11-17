import 'package:fitness_app/features/profile/data/model/responses/profile_response_dto.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/profile_fakes.dart';

void main() {
  group('ProfileResponseDto', () {
    test('fromJson parses nested user data', () {
      final dto = ProfileResponseDto.fromJson(testProfileJson);

      expect(dto.message, 'Profile fetched successfully');
      expect(dto.user?.id, 'user-1');
      expect(dto.user?.firstName, 'Ada');
      expect(dto.user?.lastName, 'Lovelace');
      expect(dto.user?.email, 'ada@example.com');
      expect(dto.user?.gender, 'female');
      expect(dto.user?.age, 30);
      expect(dto.user?.weight, 60.5);
      expect(dto.user?.height, 170);
      expect(dto.user?.activityLevel, 'active');
      expect(dto.user?.goal, 'fitness');
      expect(dto.user?.photo, '');
    });

    test('toEntity maps all user fields', () {
      final entity = ProfileResponseDto.fromJson(testProfileJson).toEntity();

      expect(entity, testProfile);
    });

    test('toEntity returns empty entity when user is missing', () {
      final dto = ProfileResponseDto.fromJson(const {'message': 'empty'});

      expect(dto.toEntity(), ProfileEntity.empty);
    });

    test('toEntity fills defaults for missing user fields', () {
      final dto = ProfileResponseDto.fromJson(const {
        'user': <String, dynamic>{},
      });

      expect(dto.toEntity(), ProfileEntity.empty);
    });

    test('toJson includes explicit nested user map', () {
      final dto = ProfileResponseDto.fromJson(testProfileJson);
      final json = dto.toJson();

      expect(json['message'], 'Profile fetched successfully');
      expect(json['user'], isA<Map<String, dynamic>>());
      expect((json['user'] as Map<String, dynamic>)['firstName'], 'Ada');
    });
  });
}
