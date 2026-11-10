import 'package:fitness_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExerciseEntity', () {
    test('supports value equality via Equatable', () {
      const ex1 = ExerciseEntity(
        id: 'bench-press',
        exercise: 'Barbell Bench Press',
        difficultyLevel: 'Intermediate',
        targetMuscleGroup: 'Chest',
        primeMoverMuscle: 'Pectoralis Major',
        primaryEquipment: 'Barbell',
        secondaryEquipment: 'Bench',
        shortYoutubeDemonstrationLink: 'https://youtube.com/demo',
        inDepthYoutubeExplanationLink: 'https://youtube.com/explain',
        bodyRegion: 'Upper Body',
        mechanics: 'Compound',
      );
      const ex2 = ExerciseEntity(
        id: 'bench-press',
        exercise: 'Barbell Bench Press',
        difficultyLevel: 'Intermediate',
        targetMuscleGroup: 'Chest',
        primeMoverMuscle: 'Pectoralis Major',
        primaryEquipment: 'Barbell',
        secondaryEquipment: 'Bench',
        shortYoutubeDemonstrationLink: 'https://youtube.com/demo',
        inDepthYoutubeExplanationLink: 'https://youtube.com/explain',
        bodyRegion: 'Upper Body',
        mechanics: 'Compound',
      );

      expect(ex1, equals(ex2));
      expect(ex1.hashCode, equals(ex2.hashCode));
    });

    test('supports basic fields with null extended database fields', () {
      const ex = ExerciseEntity(
        id: 'pushup',
        exercise: 'Push Up',
        difficultyLevel: 'Beginner',
        targetMuscleGroup: 'Chest',
        primeMoverMuscle: 'Pectoralis Major',
        secondaryMuscle: 'Triceps',
        tertiaryMuscle: 'Anterior Deltoid',
        primaryEquipment: 'Bodyweight',
        secondaryEquipment: null,
        shortYoutubeDemonstrationLink: 'https://youtube.com/demo',
        inDepthYoutubeExplanationLink: null,
        bodyRegion: 'Upper Body',
        mechanics: 'Compound',
      );

      expect(ex.id, 'pushup');
      expect(ex.exercise, 'Push Up');
      expect(ex.nameAr, isNull);
      expect(ex.difficultyRank, isNull);
      expect(ex.posture, isNull);
      expect(ex.grip, isNull);
      expect(ex.laterality, isNull);
      expect(ex.forceType, isNull);
      expect(ex.popularity, isNull);
    });

    test('supports extended database fields when provided', () {
      const ex = ExerciseEntity(
        id: 'pushup',
        exercise: 'Push Up',
        difficultyLevel: 'Beginner',
        targetMuscleGroup: 'Chest',
        primeMoverMuscle: 'Pectoralis Major',
        primaryEquipment: 'Bodyweight',
        shortYoutubeDemonstrationLink: 'https://youtube.com/demo',
        bodyRegion: 'Upper Body',
        mechanics: 'Compound',
        nameAr: 'تمرين الضغط',
        difficultyRank: 1,
        posture: 'Prone',
        forceType: 'Push',
        popularity: 100,
      );

      expect(ex.nameAr, 'تمرين الضغط');
      expect(ex.difficultyRank, 1);
      expect(ex.posture, 'Prone');
      expect(ex.forceType, 'Push');
      expect(ex.popularity, 100);
    });
  });
}
