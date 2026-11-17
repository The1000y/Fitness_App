import 'package:fitness_app/features/chat/data/models/responses/exexercises_database_response/exercises_database_response.dart';
import 'package:fitness_app/features/chat/data/models/responses/mappers/exercises_database_response_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExerciseDatabaseDtoMapper', () {
    test(
      'maps ExerciseDatabaseDTO to ExerciseEntity correctly with extended database fields',
      () {
        const dto = ExerciseDatabaseDTO(
          id: 'ex-001',
          name: 'Barbell Bench Press',
          nameAr: 'تمرين الضغط بالبار',
          difficultyId: 'intermediate',
          difficultyRank: 3,
          muscleGroupId: 'chest',
          primeMoverId: 'pectoralis_major',
          primaryEquipmentId: 'barbell',
          secondaryEquipmentId: 'bench',
          bodyRegionId: 'upper_body',
          posture: 'Lying',
          grip: 'Pronated',
          laterality: 'Bilateral',
          mechanics: 'compound',
          forceType: 'Push',
          singleOrDoubleArm: 'Double Arm',
          armsMode: 'Continuous',
          legsMode: 'Continuous',
          footElevation: 'Floor',
          loadPositionEnding: 'Chest',
          combinationExercises: 'Single Exercise',
          classification: 'Strength',
          demoUrl: 'https://youtube.com/demo',
          explainUrl: 'https://youtube.com/explain',
          popularity: 99,
        );

        final entity = dto.toEntity();

        expect(entity.id, 'ex-001');
        expect(entity.exercise, 'Barbell Bench Press');
        expect(entity.nameAr, 'تمرين الضغط بالبار');
        expect(entity.difficultyLevel, 'intermediate');
        expect(entity.difficultyRank, 3);
        expect(entity.targetMuscleGroup, 'chest');
        expect(entity.primeMoverMuscle, 'pectoralis_major');
        expect(entity.secondaryMuscle, isNull);
        expect(entity.tertiaryMuscle, isNull);
        expect(entity.primaryEquipment, 'barbell');
        expect(entity.secondaryEquipment, 'bench');
        expect(entity.bodyRegion, 'upper_body');
        expect(entity.posture, 'Lying');
        expect(entity.grip, 'Pronated');
        expect(entity.laterality, 'Bilateral');
        expect(entity.mechanics, 'compound');
        expect(entity.forceType, 'Push');
        expect(entity.singleOrDoubleArm, 'Double Arm');
        expect(entity.armsMode, 'Continuous');
        expect(entity.legsMode, 'Continuous');
        expect(entity.footElevation, 'Floor');
        expect(entity.loadPositionEnding, 'Chest');
        expect(entity.combinationExercises, 'Single Exercise');
        expect(entity.classification, 'Strength');
        expect(
          entity.shortYoutubeDemonstrationLink,
          'https://youtube.com/demo',
        );
        expect(
          entity.inDepthYoutubeExplanationLink,
          'https://youtube.com/explain',
        );
        expect(entity.popularity, 99);
      },
    );

    test('handles null fields with sensible defaults', () {
      const dto = ExerciseDatabaseDTO();
      final entity = dto.toEntity();

      expect(entity.id, '');
      expect(entity.exercise, '');
      expect(entity.difficultyLevel, '');
      expect(entity.targetMuscleGroup, '');
      expect(entity.primeMoverMuscle, '');
      expect(entity.primaryEquipment, '');
      expect(entity.shortYoutubeDemonstrationLink, '');
      expect(entity.bodyRegion, '');
      expect(entity.mechanics, '');
      expect(entity.nameAr, isNull);
      expect(entity.difficultyRank, isNull);
      expect(entity.popularity, isNull);
    });
  });

  group('ExercisesDatabaseResponseMapper', () {
    test('maps ExercisesDatabaseResponse to List<ExerciseEntity>', () {
      final response = ExercisesDatabaseResponse(
        exercises: const [
          ExerciseDatabaseDTO(id: 'ex-1', name: 'Push Up'),
          ExerciseDatabaseDTO(id: 'ex-2', name: 'Pull Up'),
        ],
      );

      final entities = response.toEntity();

      expect(entities.length, 2);
      expect(entities[0].id, 'ex-1');
      expect(entities[0].exercise, 'Push Up');
      expect(entities[1].id, 'ex-2');
      expect(entities[1].exercise, 'Pull Up');
    });

    test('returns empty list if response.exercises is null', () {
      final response = ExercisesDatabaseResponse(exercises: null);
      expect(response.toEntity(), isEmpty);
    });
  });
}
