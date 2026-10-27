/// Route names for every page of the Fitness app, taken from the Figma design.
abstract final class AppRoutes {
  const AppRoutes._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';

  // Auth.
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';
  static const String createPassword = '/create-password';
  static const String changePassword = '/change-password';

  // Profile setup (steps 1/6 – 6/6).
  static const String setupGender = '/setup/gender';
  static const String setupAge = '/setup/age';
  static const String setupWeight = '/setup/weight';
  static const String setupHeight = '/setup/height';
  static const String setupGoal = '/setup/goal';
  static const String setupActivity = '/setup/activity';

  // Main shell (bottom nav: Home / Chat / Workouts / Profile).
  static const String main = '/main';

  // Workouts.
  static const String exerciseDetails = '/exercise-details';

  // Food.
  static const String food = '/food';
  static const String foodDetails = '/food-details';

  // Smart coach chat.
  static const String chatHistory = '/chat-history';

  // Profile.
  static const String editProfile = '/edit-profile';
  static const String editWeight = '/edit-weight';
  static const String editGoal = '/edit-goal';
  static const String editActivity = '/edit-activity';
}
