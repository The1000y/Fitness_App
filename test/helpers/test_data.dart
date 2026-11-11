import 'package:fitness_app/features/auth/data/model/responses/login_response/login_response.dart';
import 'package:fitness_app/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:fitness_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:fitness_app/features/exercise/data/model/responses/difficulty_levels_dto.dart';
import 'package:fitness_app/features/exercise/data/model/responses/exercise_dto.dart';
import 'package:fitness_app/features/exercise/data/model/responses/exercises_list_dto.dart';
import 'package:fitness_app/features/exercise/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercises_list_entity.dart';
import 'package:fitness_app/features/meals/data/model/details_meal_dto.dart';
import 'package:fitness_app/features/meals/data/model/details_meal_response.dart';
import 'package:fitness_app/features/meals/domain/entities/details_meal_entity.dart';

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

  static const Map<String, dynamic> difficultyLevelsResponseJson = {
    'message': 'Success',
    'totalLevels': 2,
    'difficulty_levels': [
      {'id': 'difficulty_beginner', 'name': 'Beginner'},
      {'id': 'difficulty_intermediate', 'name': 'Intermediate'},
    ],
  };

  static DifficultyLevelsDto get difficultyLevelsResponse =>
      DifficultyLevelsDto.fromJson(difficultyLevelsResponseJson);

  static List<DifficultyLevelEntity> get difficultyLevelsEntity =>
      difficultyLevelsResponse.toEntity();

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

  static ExerciseDto get exerciseResponse =>
      ExerciseDto.fromJson(exerciseResponseJson);
  static ExerciseEntity get exerciseEntity => exerciseResponse.toEntity();
  static ExercisesListDto get exercisesListResponse =>
      ExercisesListDto.fromJson(exercisesListResponseJson);
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

  static const String mealId = '52772';
  static const String mealName = 'Teriyaki Chicken Casserole';
  static const String mealCategory = 'Chicken';
  static const String mealArea = 'Japanese';
  static const String mealInstructions =
      'Preheat oven to 350 degrees F. Combine soy sauce and water.';
  static const String mealThumb =
      'https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg';
  static const String mealYoutube =
      'https://www.youtube.com/watch?v=4aZr5hZXP_s';
  static const String mealTags = 'Meat,Casserole';
  static const String mealSource = 'https://www.themealdb.com/meal/52772';

  static const Map<String, dynamic> detailsMealDtoJson = {
    'idMeal': mealId,
    'strMeal': mealName,
    'strCategory': mealCategory,
    'strArea': mealArea,
    'strInstructions': mealInstructions,
    'strMealThumb': mealThumb,
    'strTags': mealTags,
    'strYoutube': mealYoutube,
    'strSource': mealSource,
    'strIngredient1': 'Salmon',
    'strMeasure1': '2 fillets',
    'strIngredient2': 'Fennel',
    'strMeasure2': '1 bulb',
    'strIngredient3': 'Olive Oil',
    'strMeasure3': '2 tbsp',
  };

  static const Map<String, dynamic> detailsMealResponseJson = {
    'meals': [detailsMealDtoJson],
  };

  static DetailsMealDto get detailsMealDto =>
      DetailsMealDto.fromJson(detailsMealDtoJson);
  static DetailsMealResponse get detailsMealResponse =>
      DetailsMealResponse.fromJson(detailsMealResponseJson);
  static DetailsMealEntity get detailsMealEntity => detailsMealDto.toEntity();
}
