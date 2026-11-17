import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/features/exercise/data/model/responses/exercise_dto.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercise_entity.dart';
import '../../../../helpers/test_data.dart';

void main() {
  group('ExerciseDto', () {
    test('fromJson maps every snake_case field', () {
      final response = ExerciseDto.fromJson(TestData.exerciseResponseJson);

      expect(response.id, 'exercise_1');
      expect(response.exercise, 'Push Up');
      expect(response.difficultyLevel, 'Intermediate');
      expect(response.targetMuscleGroup, 'Chest');
      expect(response.primeMoverMuscle, 'Pectoralis Major');
      expect(response.secondaryMuscle, 'Triceps');
      expect(response.tertiaryMuscle, 'Anterior Deltoid');
      expect(response.primaryEquipment, 'Bodyweight');
      expect(response.secondaryEquipment, 'None');
      expect(
        response.shortYoutubeDemonstrationLink,
        'https://www.youtube.com/watch?v=abc123',
      );
      expect(
        response.inDepthYoutubeExplanationLink,
        'https://www.youtube.com/watch?v=xyz789',
      );
      expect(response.bodyRegion, 'Upper Body');
      expect(response.mechanics, 'Compound');
    });

    test('toJson keeps the original snake_case keys', () {
      final json = TestData.exerciseResponse.toJson();

      expect(json['_id'], 'exercise_1');
      expect(json['difficulty_level'], 'Intermediate');
      expect(json['target_muscle_group'], 'Chest');
      expect(json['prime_mover_muscle'], 'Pectoralis Major');
      expect(json['secondary_muscle'], 'Triceps');
      expect(json['tertiary_muscle'], 'Anterior Deltoid');
      expect(json['primary_equipment'], 'Bodyweight');
      expect(json['secondary_equipment'], 'None');
      expect(
        json['short_youtube_demonstration_link'],
        'https://www.youtube.com/watch?v=abc123',
      );
      expect(
        json['in_depth_youtube_explanation_link'],
        'https://www.youtube.com/watch?v=xyz789',
      );
      expect(json['body_region'], 'Upper Body');
      expect(json['mechanics'], 'Compound');
    });

    test('toEntity maps all response fields', () {
      final entity = TestData.exerciseResponse.toEntity();

      expect(entity, isA<ExerciseEntity>());
      expect(entity.id, 'exercise_1');
      expect(entity.exercise, 'Push Up');
      expect(entity.difficultyLevel, 'Intermediate');
      expect(entity.targetMuscleGroup, 'Chest');
      expect(entity.primeMoverMuscle, 'Pectoralis Major');
      expect(entity.secondaryMuscle, 'Triceps');
      expect(entity.tertiaryMuscle, 'Anterior Deltoid');
      expect(entity.primaryEquipment, 'Bodyweight');
      expect(entity.secondaryEquipment, 'None');
      expect(
        entity.shortYoutubeDemonstrationLink,
        'https://www.youtube.com/watch?v=abc123',
      );
      expect(
        entity.inDepthYoutubeExplanationLink,
        'https://www.youtube.com/watch?v=xyz789',
      );
      expect(entity.bodyRegion, 'Upper Body');
      expect(entity.mechanics, 'Compound');
    });

    test('toEntity falls back to empty strings for required fields', () {
      final entity = ExerciseDto.fromJson({}).toEntity();

      expect(entity.id, '');
      expect(entity.exercise, '');
      expect(entity.difficultyLevel, '');
      expect(entity.targetMuscleGroup, '');
      expect(entity.primeMoverMuscle, '');
      expect(entity.primaryEquipment, '');
      expect(entity.shortYoutubeDemonstrationLink, '');
      expect(entity.bodyRegion, '');
      expect(entity.mechanics, '');
    });

    test('toEntity keeps optional fields null when absent', () {
      final entity = ExerciseDto.fromJson({}).toEntity();

      expect(entity.secondaryMuscle, isNull);
      expect(entity.tertiaryMuscle, isNull);
      expect(entity.secondaryEquipment, isNull);
      expect(entity.inDepthYoutubeExplanationLink, isNull);
    });

    test('ExerciseEntity equality is value based', () {
      final first = TestData.exerciseEntity;
      final second = TestData.exerciseResponse.toEntity();
      final different = ExerciseDto.fromJson({
        ...TestData.exerciseResponseJson,
        'exercise': 'Pull Up',
      }).toEntity();

      expect(first, second);
      expect(first, isNot(different));
      expect(first.props, contains('Push Up'));
    });
  });
}
