// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get done => 'Done';

  @override
  String get doIt => 'Do it';

  @override
  String get confirm => 'Confirm';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get seeAll => 'See all';

  @override
  String get or => 'Or';

  @override
  String stepOfTotal(int current, int total) {
    return '$current/$total';
  }

  @override
  String get personalizedPlanHint =>
      'This helps us create your personalized plan';

  @override
  String get onboardingTitle1 => 'The price of excellence is discipline';

  @override
  String get onboardingTitle2 => 'Fitness has never been so much fun';

  @override
  String get onboardingTitle3 => 'No more excuses. Do it now';

  @override
  String get loginWelcomeBack => 'Hey there, welcome back';

  @override
  String get login => 'Login';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get oldPassword => 'Old password';

  @override
  String get newPassword => 'New password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account yet?';

  @override
  String get register => 'Register';

  @override
  String get registerTitle => 'Hey there, create an account';

  @override
  String get firstName => 'First name';

  @override
  String get lastName => 'Last name';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get forgotPasswordTitle => 'Forgot password';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get otpCode => 'OTP code';

  @override
  String get enterYourOtp => 'Enter your OTP';

  @override
  String get checkYourEmail => 'Check your email';

  @override
  String get didntReceiveCode => 'Didn\'t receive the verification code?';

  @override
  String get resendCode => 'Resend code?';

  @override
  String get createNewPassword => 'Create new password';

  @override
  String get passwordLengthHint => 'Make sure it\'s 8 characters or more';

  @override
  String get genderTitle => 'Tell us about yourself!';

  @override
  String get genderSubtitle => 'We need to know your gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get ageTitle => 'How old are you?';

  @override
  String get yearUnit => 'year';

  @override
  String get weightTitle => 'What is your weight?';

  @override
  String get kgUnit => 'kg';

  @override
  String get heightTitle => 'What is your height?';

  @override
  String get cmUnit => 'CM';

  @override
  String get goalTitle => 'What is your goal?';

  @override
  String get goalGainWeight => 'Gain weight';

  @override
  String get goalLoseWeight => 'Lose weight';

  @override
  String get goalGetFitter => 'Get fitter';

  @override
  String get goalGainFlexibility => 'Gain more flexibility';

  @override
  String get goalLearnBasics => 'Learn the basics';

  @override
  String get activityTitle => 'Your regular physical activity level?';

  @override
  String get activityRookie => 'Rookie';

  @override
  String get activityTrueBeast => 'True beast';

  @override
  String get levelBeginner => 'Beginner';

  @override
  String get levelIntermediate => 'Intermediate';

  @override
  String get levelAdvanced => 'Advanced';

  @override
  String homeGreeting(String name) {
    return 'Hi $name,';
  }

  @override
  String get homeSubtitle => 'Let\'s start your day';

  @override
  String get explore => 'Explore';

  @override
  String get category => 'Category';

  @override
  String get categoryGym => 'Gym';

  @override
  String get categoryFitness => 'Fitness';

  @override
  String get categoryYoga => 'Yoga';

  @override
  String get categoryAerobics => 'Aerobics';

  @override
  String get categoryTrainer => 'Trainer';

  @override
  String get recommendationToday => 'Recommendation for today';

  @override
  String get jogging => 'Jogging';

  @override
  String get pushUp => 'Push-up';

  @override
  String get squat => 'Squat';

  @override
  String get upcomingWorkouts => 'Upcoming workouts';

  @override
  String get fullBody => 'Full body';

  @override
  String get chest => 'Chest';

  @override
  String get arm => 'Arm';

  @override
  String get arms => 'Arms';

  @override
  String get shoulder => 'Shoulder';

  @override
  String get bodyBack => 'Back';

  @override
  String get legs => 'Legs';

  @override
  String get stomach => 'Stomach';

  @override
  String get recommendationForYou => 'Recommendation for you';

  @override
  String get breakfast => 'Breakfast';

  @override
  String get lunch => 'Lunch';

  @override
  String get dinner => 'Dinner';

  @override
  String get popularTraining => 'Popular training';

  @override
  String get strengthenChest => 'Exercises that strengthen your chest';

  @override
  String get strengthenBack => 'Exercises that strengthen your back';

  @override
  String get strengthenBody => 'Exercises that strengthen your body';

  @override
  String tasksCount(int count) {
    return '$count tasks';
  }

  @override
  String get workouts => 'Workouts';

  @override
  String minutesShort(int minutes) {
    return '$minutes MIN';
  }

  @override
  String caloriesShort(int calories) {
    return '$calories Cal';
  }

  @override
  String setsAndReps(int sets, int reps) {
    return '$sets sets × $reps reps';
  }

  @override
  String get foodRecommendation => 'Food recommendation';

  @override
  String get energy => 'Energy';

  @override
  String get protein => 'Protein';

  @override
  String get carbs => 'Carbs';

  @override
  String get fat => 'Fat';

  @override
  String get ingredients => 'Ingredients';

  @override
  String get recommendation => 'Recommendation';

  @override
  String get smartCoach => 'Smart coach';

  @override
  String chatGreeting(String name) {
    return 'Hi $name, I am your smart coach';
  }

  @override
  String get chatHelpPrompt => 'How can I assist you today?';

  @override
  String get getStarted => 'Get started';

  @override
  String get previousConversations => 'Previous conversations';

  @override
  String get profile => 'Profile';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get changePassword => 'Change password';

  @override
  String get selectLanguage => 'Select language';

  @override
  String get currentLanguageName => 'English';

  @override
  String get security => 'Security';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get help => 'Help';

  @override
  String get logout => 'Logout';

  @override
  String get yourWeightTapToEdit => 'Your weight (tap to edit)';

  @override
  String get yourGoalTapToEdit => 'Your goal (tap to edit)';

  @override
  String get yourActivityTapToEdit => 'Your activity level (tap to edit)';

  @override
  String get closeAppConfirm =>
      'Are you sure you want to close the application?';

  @override
  String get accepted => 'Order accepted successfully';

  @override
  String get orderStatusUpdatedSuccessfully =>
      'Order status updated successfully';

  @override
  String get failureInternetConnection =>
      'No internet connection. Please check your network and try again.';

  @override
  String get failureTimeout => 'The request timed out. Please try again.';

  @override
  String get failureCancel => 'The request was cancelled.';

  @override
  String get failureBadCertificate =>
      'Secure connection failed. Invalid server certificate.';

  @override
  String get failureBadRequest =>
      'Invalid request. Please check your data and try again.';

  @override
  String get failureUnauthorized =>
      'Your session has expired. Please log in again.';

  @override
  String get failureForbidden => 'You don\'t have permission to do this.';

  @override
  String get failureNotFound => 'The requested item was not found.';

  @override
  String get failureMethodNotAllowed => 'This action is not allowed.';

  @override
  String get failureConflict =>
      'This action conflicts with the current state. Please refresh and try again.';

  @override
  String get failureUnprocessableEntity =>
      'We couldn\'t process your data. Please review it and try again.';

  @override
  String get failureTooManyRequests =>
      'Too many requests. Please wait a moment and try again.';

  @override
  String get failureServerError => 'Server error. Please try again later.';

  @override
  String get failureUnknown => 'Something went wrong. Please try again.';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Please enter a valid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordMinLength => 'Password must be at least 8 characters';

  @override
  String get passwordStrongRules =>
      'Password must include uppercase, lowercase, a number and a special character';

  @override
  String get confirmPasswordRequired => 'Please confirm your password';

  @override
  String get confirmPasswordMismatch => 'Passwords do not match';

  @override
  String get usernameRequired => 'Username is required';

  @override
  String get usernameMinLength => 'Username is too short';

  @override
  String get firstNameRequired => 'First name is required';

  @override
  String get firstNameOnlyLetters => 'First name must contain letters only';

  @override
  String get lastNameRequired => 'Last name is required';

  @override
  String get lastNameOnlyLetters => 'Last name must contain letters only';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get phoneInvalid => 'Please enter a valid phone number';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get fieldMinLength => 'This field is too short';

  @override
  String get accountCreated => 'Account created successfully';

  @override
  String get loggedIn => 'Logged in successfully';

  @override
  String get passwordChanged => 'Password changed successfully';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get profilePhotoUpdated => 'Profile photo updated';

  @override
  String get workoutSaved => 'Workout saved';

  @override
  String get workoutCompleted => 'Workout completed, great job!';

  @override
  String get workoutPlanStarted => 'Workout plan started';

  @override
  String get workoutDeleted => 'Workout deleted';

  @override
  String get exerciseAddedToWorkout => 'Exercise added to your workout';

  @override
  String get mealLogged => 'Meal logged';

  @override
  String get waterLogged => 'Water intake logged';

  @override
  String get weightLogged => 'Weight logged';

  @override
  String get measurementsSaved => 'Measurements saved';

  @override
  String get progressPhotoUploaded => 'Progress photo uploaded';

  @override
  String get goalCreated => 'Goal created';

  @override
  String get goalAchieved => 'Goal achieved, congratulations!';

  @override
  String get newPersonalRecord => 'New personal record!';

  @override
  String get reminderSet => 'Reminder set';

  @override
  String get settingsSaved => 'Settings saved';

  @override
  String get failedToLoadVideo =>
      'Couldn\'t load the video. Please check your internet connection and try again.';

  @override
  String get videoPlayerError =>
      'Something went wrong while playing the video. Please try again.';

  @override
  String get invalidVideo => 'The video link is invalid or unavailable.';

  @override
  String get embeddingDisabled =>
      'This video can\'t be played here because the owner has disabled embedding.';

  @override
  String get videoNotFound =>
      'This video isn\'t available. It may have been removed or set to private.';

  @override
  String get notFound => 'Unable to find the requested resource.';

  @override
  String get retry => 'Retry';

  @override
  String get unableToPlayVideo => 'Unable to play video';

  @override
  String get cancel => 'cancel the video';
}
