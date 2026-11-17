abstract class ApiStrings {
  static final String baseUrl = 'https://fitness.elevateegy.com/api/v1';

  static const String mealBaseUrl = 'https://www.themealdb.com/api/json/v1/1';
  static const String namedFitnessDio = 'fitnessDio';
  static const String namedMealDio = 'mealDio';

  static const String signup = '/auth/signup';
  static const String signin = '/auth/signin';
  static const String changePassword = '/auth/change-password';
  static const String uploadPhoto =
      '/auth/upload-photo';
  static const String profileData = '/auth/profile-data';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgotPassword';
  static const String verifyResetCode = '/auth/verifyResetCode';
  static const String resetPassword = '/auth/resetPassword';
  static String get deleteMe => '/auth/deleteMe';
  static const String  editProfile = '/auth/editProfile';

  static const String levels = '/levels';

  static const String difficultyLevelsByPrimeMover =
      '/levels/difficulty-levels/by-prime-mover';

  static const String muscles = '/muscles';
  static const String randomMuscles = '/muscles/random';

  static String musclesByGroupId(String muscleGroupId) =>
      '/musclesGroup/$muscleGroupId';

  static const String musclesByGroup = '/musclesGroup/by-muscle-group';

  static const String primeMoversByMuscleGroup =
      '/musclesGroup/by-muscle-group';

  static const String exercises = '/exercises';

  static const String exercisesByMuscleDifficulty =
      '/exercises/by-muscle-difficulty';

  static const String randomExercises = '/exercises/random';

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
  static const String ollamaBaseUrl = 'http://10.0.2.2:11434';
  static const String ollamaChat = '/api/chat';
  static const String ollamaModel = 'qwen3.5:4b';
  static const String namedOllamaDio = 'ollamaDio';
}
