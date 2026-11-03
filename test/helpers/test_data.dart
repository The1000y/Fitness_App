import 'package:fitness_app/features/auth/data/model/responses/login_response/login_response.dart';
import 'package:fitness_app/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:fitness_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:fitness_app/features/exercise/data/model/responses/exercise_response.dart';
import 'package:fitness_app/features/exercise/data/model/responses/exercises_list_response.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercises_list_entity.dart';

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

  static const String primeMoverMuscleId = 'muscle_chest';
  static const String difficultyLevelId = 'difficulty_intermediate';

  static const Map<String, dynamic> exerciseResponseJson = {
    '_id': 'exercise_1',
    'exercise': 'Push Up',
    'difficulty_level': 'Intermediate',
    'target_muscle_group': 'Chest',
    'prime_mover_muscle': 'Pectoralis Major',
    'secondary_muscle': 'Triceps',
    'tertiary_muscle': 'Anterior Deltoid',
    'primary_equipment': 'Bodyweight',
    'secondary_equipment': 'None',
    'short_youtube_demonstration_link':
        'https://www.youtube.com/watch?v=abc123',
    'in_depth_youtube_explanation_link':
        'https://www.youtube.com/watch?v=xyz789',
    'body_region': 'Upper Body',
    'mechanics': 'Compound',
  };

  static const Map<String, dynamic> exercisesListResponseJson = {
    'message': 'Success',
    'totalExercises': 2,
    'totalPages': 1,
    'currentPage': 1,
    'exercises': [
      exerciseResponseJson,
      {
        '_id': 'exercise_2',
        'exercise': 'Dumbbell Fly',
        'difficulty_level': 'Beginner',
        'target_muscle_group': 'Chest',
        'prime_mover_muscle': 'Pectoralis Major',
        'secondary_muscle': 'Anterior Deltoid',
        'tertiary_muscle': null,
        'primary_equipment': 'Dumbbell',
        'secondary_equipment': 'Bench',
        'short_youtube_demonstration_link':
            'https://www.youtube.com/watch?v=def456',
        'in_depth_youtube_explanation_link': null,
        'body_region': 'Upper Body',
        'mechanics': 'Isolation',
      },
    ],
  };

  static ExerciseResponse get exerciseResponse =>
      ExerciseResponse.fromJson(exerciseResponseJson);
  static ExerciseEntity get exerciseEntity => exerciseResponse.toEntity();
  static ExercisesListResponse get exercisesListResponse =>
      ExercisesListResponse.fromJson(exercisesListResponseJson);
  static ExercisesListEntity get exercisesListEntity =>
      exercisesListResponse.toEntity();
  static ExerciseEntity get emptyLinkExerciseEntity => const ExerciseEntity(
    id: 'exercise_3',
    exercise: 'Plank',
    difficultyLevel: 'Beginner',
    targetMuscleGroup: 'Core',
    primeMoverMuscle: 'Rectus Abdominis',
    primaryEquipment: 'Bodyweight',
    shortYoutubeDemonstrationLink: '',
    bodyRegion: 'Core',
    mechanics: 'Isolation',
  );
}
