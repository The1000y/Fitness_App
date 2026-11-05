abstract class ApiStrings {
  static final String baseUrl = 'https://fitness.elevateegy.com/api/v1';

  static const String mealBaseUrl = 'https://www.themealdb.com/api/json/v1/1';

  static String get signup => '/auth/signup';
  static const String signin = '/auth/signin';
  static String get changePassword => '/auth/change-password';
  static String get uploadPhoto => '/auth/upload-photo';
  static String get profileData => '/auth/profile-data';
  static String get logout => '/auth/logout';
  static String get forgotPassword => '/auth/forgotPassword';
  static String get verifyResetCode => '/auth/verifyResetCode';
  static String get resetPassword => '/auth/resetPassword';
  static String get deleteMe => '/auth/deleteMe';
  static String get editProfile => '/auth/editProfile';

  static String get levels => '/levels';

  static const String difficultyLevelsByPrimeMover =
      '/levels/difficulty-levels/by-prime-mover';

  static String get muscles => '/muscles';
  static String get randomMuscles => '/muscles/random';

  static String musclesByGroupId(String muscleGroupId) =>
      '/musclesGroup/$muscleGroupId';

  static String get primeMoversByMuscleGroup => '/musclesGroup/by-muscle-group';

  static String get exercises => '/exercises';

  static const String exercisesByMuscleDifficulty =
      '/exercises/by-muscle-difficulty';

  static String get randomExercises => '/exercises/random';

  static const String mealCategories = '$mealBaseUrl/categories.php';

  static const String mealsByCategory = '$mealBaseUrl/filter.php';

  static const String mealDetails = '$mealBaseUrl/lookup.php';

  static const String qPrimeMoverMuscleId = 'primeMoverMuscleId';
  static const String qMuscleGroupId = 'muscleGroupId';
  static const String qDifficultyLevelId = 'difficultyLevelId';
  static const String qTargetMuscleGroupId = 'targetMuscleGroupId';
  static const String qLimit = 'limit';
  static const String qPage = 'page';
  static const String qMealCategory = 'c';
  static const String qMealId = 'i';
}
