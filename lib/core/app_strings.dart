/// All user-facing text of the Fitness app, collected from the Figma design.
///
/// Strings are grouped by screen. Texts shared by several screens live in
/// the "Common" group so they are only defined once.
abstract final class AppStrings {
  // ───────────────────────────── Common ─────────────────────────────
  static const String skip = 'Skip';
  static const String next = 'Next';
  static const String back = 'Back';
  static const String done = 'Done';
  static const String confirm = 'Confirm';
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String or = 'Or';
  static const String seeAll = 'See All';
  static const String explore = 'Explore';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String comingSoon = 'Coming Soon';

  // ──────────────────────── Onboarding & Splash ────────────────────────
  static const String onboarding1Title =
      'The price of excellence\nis discipline';
  static const String onboarding2Title = 'Fitness has never been\nso much fun';
  static const String onboarding3Title = 'No more excuses\nDo it now';
  static const String onboardingDescription =
      'Lorem ipsum dolor sit amet consectetur. Eu urna ut gravida quis id pretium purus. Mauris massa';
  static const String doIt = 'Do It';

  // ───────────────────────── Login & Register ─────────────────────────
  static const String loginTitle = 'Hey There\nWelcome Back';
  static const String login = 'Login';
  static const String forgotPassword = 'Forgot Password?';
  static const String dontHaveAccount = "Don't have an account yet? ";
  static const String register = 'Register';

  static const String registerTitle = 'Hey There\nCreate An Account';
  static const String firstName = 'First Name';
  static const String lastName = 'Last Name';
  static const String alreadyHaveAccount = 'Already have an account? ';

  // ─────────────────── OTP, Forgot & Change password ───────────────────
  static const String forgotPasswordTitle = 'Enter Your Email\nForgot Password';
  static const String sendOtp = 'Send OTP';

  static const String otpTitle = 'OTP Code';
  static const String enterYourOtp = 'Enter Your OTP';
  static const String checkYourEmail = 'Check your email';
  static const String didntReceiveCode = "Didn't receive verification code?";
  static const String resendCode = 'Resend Code?';

  static const String createPasswordTitle =
      "Make sure it's 8 characters or more\nCreate New Password";
  static const String oldPassword = 'Old Password';
  static const String newPassword = 'New Password';
  static const String confirmPassword = 'Confirm Password';

  // ──────────────────── Profile setup (steps 1–6) ────────────────────
  static const String genderTitle =
      'Tell us about yourself!\nWe need to know your gender';
  static const String male = 'Male';
  static const String female = 'Female';

  static const String ageTitle =
      'How old are you?\nThis helps us create your personalized plan';
  static const String yearUnit = 'Year';

  static const String weightTitle =
      'What is your weight?\nThis helps us create your personalized plan';
  static const String kgUnit = 'KG';

  static const String heightTitle =
      'What is your height?\nThis helps us create your personalized plan';
  static const String cmUnit = 'CM';

  static const String goalTitle =
      'What is your goal?\nThis helps us create your personalized plan';
  static const String goalGainWeight = 'Gain Weight';
  static const String goalLoseWeight = 'Lose Weight';
  static const String goalGetFitter = 'Get Fitter';
  static const String goalGainFlexibility = 'Gain More Flexibility';
  static const String goalLearnBasics = 'Learn The Basics';

  static const String activityTitle = 'Your regular physical activity level?';
  static const String activityRookie = 'Rookie';
  static const String activityBeginner = 'Beginner';
  static const String activityIntermediate = 'Intermediate';
  static const String activityAdvanced = 'Advanced';
  static const String activityTrueBeast = 'True Beast';

  // ───────────────────────────── Home ─────────────────────────────
  static const String category = 'Category';
  static const String gym = 'Gym';
  static const String fitness = 'Fitness';
  static const String yoga = 'Yoga';
  static const String aerobics = 'Aerobics';
  static const String trainer = 'Trainer';

  static const String recommendationToday = 'Recommendation Today';
  static const String jogging = 'Jogging';
  static const String pushUp = 'Push-up';
  static const String squat = 'Squat';

  static const String upcomingWorkouts = 'Upcoming Workouts';
  static const String recommendationForYou = 'Recommendation For You';

  static const String popularTraining = 'Popular Training';
  static const String strengthenChest = 'Exercises that\nstrengthen your chest';
  static const String strengthenBack = 'Exercises that\nstrengthen your back';
  static const String strengthenBody = 'Exercises that\nstrengthen your body';

  // ─────────────────── Workouts & Exercise details ───────────────────
  static const String workouts = 'Workouts';
  static const String muscleFullBody = 'Full Body';
  static const String muscleChest = 'Chest';
  static const String muscleArm = 'Arm';
  static const String muscleShoulder = 'Shoulder';
  static const String muscleBack = 'Back';
  static const String muscleLegs = 'Legs';
  static const String muscleStomach = 'Stomach';

  static const String levelBeginner = 'Beginner';
  static const String levelIntermediate = 'Intermediate';
  static const String levelAdvanced = 'Advanced';

  static const String minutesUnit = 'MIN';
  static const String caloriesUnit = 'Cal';

  // ───────────────────────── Food & Details ─────────────────────────
  static const String foodRecommendation = 'Food Recommendation';
  static const String breakfast = 'Breakfast';
  static const String lunch = 'Lunch';
  static const String dinner = 'Dinner';

  static const String ingredients = 'Ingredients';
  static const String energy = 'Energy';
  static const String protein = 'Protein';
  static const String carbs = 'Carbs';
  static const String fat = 'Fat';
  static const String recommendation = 'Recommendation';

  // ───────────────────────── Chat (Smart coach) ─────────────────────────
  static const String smartCoach = 'Smart Coach';
  static const String chatWelcome = 'How Can I Assist You\nToday?';
  static const String getStarted = 'Get Started';
  static const String chatHello = 'Hello, how can I assist you\ntoday?';
  static const String previousConversations = 'Previous conversations';

  // ───────────────────────── Profile & Edit ─────────────────────────
  static const String profile = 'Profile';
  static const String editProfile = 'Edit Profile';
  static const String changePassword = 'Change Password';
  static const String selectLanguage = 'Select Language';
  static const String languageEnglish = 'English';
  static const String security = 'Security';
  static const String privacyPolicy = 'Privacy Policy';
  static const String help = 'Help';
  static const String logout = 'Logout';

  static const String yourWeightTapToEdit = 'Your Weight (Tap To Edit)';
  static const String yourGoalTapToEdit = 'Your Goal (Tap To Edit)';
  static const String yourActivityLevelTapToEdit =
      'Your Activity Level (Tap To Edit)';

  // ───────────────────────── Close dialog ─────────────────────────
  static const String closeAppConfirmation =
      'Are you sure you want\nto close the application?';

  // ───────────────────── Dynamic (need a value) ─────────────────────
  static String homeGreeting(String name) => "Hi $name,\nLet's start your day";
  static String chatGreeting(String name) => 'Hi $name, I am your smart coach';
  static String stepCounter(int current, int total) => '$current/$total';
  static String tasksCount(int count) => '$count tasks';
  static String selectLanguageWith(String language) =>
      'Select Language ($language)';
}
