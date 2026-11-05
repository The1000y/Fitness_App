import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/features/exercise/data/model/responses/difficulty_levels_dto.dart';
import 'package:fitness_app/features/exercise/domain/entities/difficulty_level_entity.dart';
import '../../../../helpers/test_data.dart';

void main() {
  group('DifficultyLevelsDto', () {
    test('fromJson maps the counters and levels', () {
      final response = DifficultyLevelsDto.fromJson(
        TestData.difficultyLevelsResponseJson,
      );

      expect(response.message, 'Success');
      expect(response.totalLevels, 2);
      expect(response.difficultyLevels, hasLength(2));
      expect(response.difficultyLevels?.first.id, 'difficulty_beginner');
      expect(response.difficultyLevels?.first.name, 'Beginner');
    });

    test('toJson keeps the original keys', () {
      final json = TestData.difficultyLevelsResponse.toJson();

      expect(json['message'], 'Success');
      expect(json['totalLevels'], 2);
      expect((json['difficulty_levels'] as List).length, 2);
      expect(
        (json['difficulty_levels'] as List).first['id'],
        'difficulty_beginner',
      );
    });

    test('toEntity maps every level', () {
      final levels = TestData.difficultyLevelsResponse.toEntity();

      expect(levels, isA<List<DifficultyLevelEntity>>());
      expect(levels, hasLength(2));
      expect(
        levels.first,
        const DifficultyLevelEntity(
          id: 'difficulty_beginner',
          name: 'Beginner',
        ),
      );
      expect(levels.last.id, TestData.difficultyLevelId);
      expect(levels.last.name, 'Intermediate');
    });

    test('fromJson with an empty payload produces safe defaults', () {
      final response = DifficultyLevelsDto.fromJson({});

      expect(response.message, isNull);
      expect(response.totalLevels, isNull);
      expect(response.difficultyLevels, isNull);
    });

    test('toEntity replaces missing values with defaults', () {
      final levels = DifficultyLevelsDto.fromJson({}).toEntity();

      expect(levels, isEmpty);
    });

    test('missing level fields fall back to empty strings', () {
      final response = DifficultyLevelsDto.fromJson({
        'difficulty_levels': [<String, dynamic>{}],
      });

      final level = response.toEntity().single;
      expect(level.id, '');
      expect(level.name, '');
    });

    test('DifficultyLevelEntity equality is value based', () {
      final first = TestData.difficultyLevelsEntity.first;
      final second = TestData.difficultyLevelsResponse.toEntity().first;
      final different = DifficultyLevelsDto.fromJson({
        'difficulty_levels': [
          {'id': 'difficulty_advanced', 'name': 'Advanced'},
        ],
      }).toEntity().first;

      expect(first, second);
      expect(first, isNot(different));
      expect(first.props, contains('Beginner'));
    });
  });
}
