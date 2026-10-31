
/// All API endpoints used by the app.
///
/// .env should contain:
/// BASE_URL=https://fitness.elevateegy.com/api/v1
abstract class ApiStrings {
  // ---------------------------------------------------------------------------
  // Base URLs
  // ---------------------------------------------------------------------------
  static const String baseUrl =
      'https://fitness.elevateegy.com/api/v1';

  /// TheMealDB (separate third-party API)
  static const String mealBaseUrl =
      'https://www.themealdb.com/api/json/v1/1';

  // ---------------------------------------------------------------------------
  // Auth
  // ---------------------------------------------------------------------------
  static String get signup => '/auth/signup'; // POST
  static const String signin = '/auth/signin'; // POST
  static String get changePassword => '/auth/change-password'; // PATCH
  static String get uploadPhoto => '/auth/upload-photo'; // PUT
  static String get profileData => '/auth/profile-data'; // GET
  static String get logout => '/auth/logout'; // GET
  static String get forgotPassword => '/auth/forgotPassword'; // POST
  static String get verifyResetCode => '/auth/verifyResetCode'; // POST
  static String get resetPassword => '/auth/resetPassword'; // PUT
  static String get deleteMe => '/auth/deleteMe'; // DELETE
  static String get editProfile => '/auth/editProfile'; // PUT

  // ---------------------------------------------------------------------------
  // Levels
  // ---------------------------------------------------------------------------
  static String get levels => '/levels'; // GET

  /// GET (Bearer) – query: primeMoverMuscleId
  static String get difficultyLevelsByPrimeMover =>
      '/levels/difficulty-levels/by-prime-mover';

  // ---------------------------------------------------------------------------
  // Muscles
  // ---------------------------------------------------------------------------
  static String get randomMuscles =>
      '/muscles/random'; // GET (20 random prime movers)

  /// GET – all muscles
  static const String muscles = '/muscles';

  /// GET – query: muscleGroupId
  static const String musclesByGroup =
      '/musclesGroup/by-muscle-group';

  /// GET – all muscles by muscle group id (path parameter)
  static String musclesByGroupId(String muscleGroupId) =>
      '/musclesGroup/$muscleGroupId';

  /// GET – query: muscleGroupId
  static String get primeMoversByMuscleGroup =>
      '/musclesGroup/by-muscle-group';

  // ---------------------------------------------------------------------------
  // Exercises
  // ---------------------------------------------------------------------------
  static String get exercises => '/exercises'; // GET

  /// GET – query: primeMoverMuscleId, difficultyLevelId
  static String get exercisesByMuscleDifficulty =>
      '/exercises/by-muscle-difficulty';

  /// GET – query: targetMuscleGroupId, difficultyLevelId, limit
  static String get randomExercises => '/exercises/random';

  // ---------------------------------------------------------------------------
  // Meals (TheMealDB)
  // ---------------------------------------------------------------------------
  static const String mealCategories =
      '$mealBaseUrl/categories.php'; // GET

  /// GET – query: c (category name, e.g. Seafood)
  static const String mealsByCategory =
      '$mealBaseUrl/filter.php';

  /// GET – query: i (meal id, e.g. 52959)
  static const String mealDetails =
      '$mealBaseUrl/lookup.php';

  // ---------------------------------------------------------------------------
  // Query parameter keys
  // ---------------------------------------------------------------------------
  static const String qPrimeMoverMuscleId = 'primeMoverMuscleId';
  static const String qMuscleGroupId = 'muscleGroupId';
  static const String qDifficultyLevelId = 'difficultyLevelId';
  static const String qTargetMuscleGroupId = 'targetMuscleGroupId';
  static const String qLimit = 'limit';
  static const String qMealCategory = 'c';
  static const String qMealId = 'i';
}
