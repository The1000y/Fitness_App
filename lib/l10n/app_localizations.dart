import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @doIt.
  ///
  /// In en, this message translates to:
  /// **'Do it'**
  String get doIt;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get or;

  /// No description provided for @stepOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{current}/{total}'**
  String stepOfTotal(int current, int total);

  /// No description provided for @personalizedPlanHint.
  ///
  /// In en, this message translates to:
  /// **'This helps us create your personalized plan'**
  String get personalizedPlanHint;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'The price of excellence is discipline'**
  String get onboardingTitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Fitness has never been so much fun'**
  String get onboardingTitle2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'No more excuses. Do it now'**
  String get onboardingTitle3;

  /// No description provided for @loginWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Hey there, welcome back'**
  String get loginWelcomeBack;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old password'**
  String get oldPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account yet?'**
  String get dontHaveAccount;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Hey there, create an account'**
  String get registerTitle;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgotPasswordTitle;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @otpCode.
  ///
  /// In en, this message translates to:
  /// **'OTP code'**
  String get otpCode;

  /// No description provided for @enterYourOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter your OTP'**
  String get enterYourOtp;

  /// No description provided for @checkYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get checkYourEmail;

  /// No description provided for @didntReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the verification code?'**
  String get didntReceiveCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code?'**
  String get resendCode;

  /// No description provided for @createNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Create new password'**
  String get createNewPassword;

  /// No description provided for @passwordLengthHint.
  ///
  /// In en, this message translates to:
  /// **'Make sure it\'s 8 characters or more'**
  String get passwordLengthHint;

  /// No description provided for @genderTitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us about yourself!'**
  String get genderTitle;

  /// No description provided for @genderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We need to know your gender'**
  String get genderSubtitle;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @ageTitle.
  ///
  /// In en, this message translates to:
  /// **'How old are you?'**
  String get ageTitle;

  /// No description provided for @yearUnit.
  ///
  /// In en, this message translates to:
  /// **'year'**
  String get yearUnit;

  /// No description provided for @weightTitle.
  ///
  /// In en, this message translates to:
  /// **'What is your weight?'**
  String get weightTitle;

  /// No description provided for @kgUnit.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kgUnit;

  /// No description provided for @heightTitle.
  ///
  /// In en, this message translates to:
  /// **'What is your height?'**
  String get heightTitle;

  /// No description provided for @cmUnit.
  ///
  /// In en, this message translates to:
  /// **'CM'**
  String get cmUnit;

  /// No description provided for @goalTitle.
  ///
  /// In en, this message translates to:
  /// **'What is your goal?'**
  String get goalTitle;

  /// No description provided for @goalGainWeight.
  ///
  /// In en, this message translates to:
  /// **'Gain weight'**
  String get goalGainWeight;

  /// No description provided for @goalLoseWeight.
  ///
  /// In en, this message translates to:
  /// **'Lose weight'**
  String get goalLoseWeight;

  /// No description provided for @goalGetFitter.
  ///
  /// In en, this message translates to:
  /// **'Get fitter'**
  String get goalGetFitter;

  /// No description provided for @goalGainFlexibility.
  ///
  /// In en, this message translates to:
  /// **'Gain more flexibility'**
  String get goalGainFlexibility;

  /// No description provided for @goalLearnBasics.
  ///
  /// In en, this message translates to:
  /// **'Learn the basics'**
  String get goalLearnBasics;

  /// No description provided for @activityTitle.
  ///
  /// In en, this message translates to:
  /// **'Your regular physical activity level?'**
  String get activityTitle;

  /// No description provided for @activityRookie.
  ///
  /// In en, this message translates to:
  /// **'Rookie'**
  String get activityRookie;

  /// No description provided for @activityTrueBeast.
  ///
  /// In en, this message translates to:
  /// **'True beast'**
  String get activityTrueBeast;

  /// No description provided for @levelBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get levelBeginner;

  /// No description provided for @levelIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get levelIntermediate;

  /// No description provided for @levelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get levelAdvanced;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi {name},'**
  String homeGreeting(String name);

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s start your day'**
  String get homeSubtitle;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @categoryGym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get categoryGym;

  /// No description provided for @categoryFitness.
  ///
  /// In en, this message translates to:
  /// **'Fitness'**
  String get categoryFitness;

  /// No description provided for @categoryYoga.
  ///
  /// In en, this message translates to:
  /// **'Yoga'**
  String get categoryYoga;

  /// No description provided for @categoryAerobics.
  ///
  /// In en, this message translates to:
  /// **'Aerobics'**
  String get categoryAerobics;

  /// No description provided for @categoryTrainer.
  ///
  /// In en, this message translates to:
  /// **'Trainer'**
  String get categoryTrainer;

  /// No description provided for @recommendationToday.
  ///
  /// In en, this message translates to:
  /// **'Recommendation for today'**
  String get recommendationToday;

  /// No description provided for @jogging.
  ///
  /// In en, this message translates to:
  /// **'Jogging'**
  String get jogging;

  /// No description provided for @pushUp.
  ///
  /// In en, this message translates to:
  /// **'Push-up'**
  String get pushUp;

  /// No description provided for @squat.
  ///
  /// In en, this message translates to:
  /// **'Squat'**
  String get squat;

  /// No description provided for @upcomingWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Upcoming workouts'**
  String get upcomingWorkouts;

  /// No description provided for @fullBody.
  ///
  /// In en, this message translates to:
  /// **'Full body'**
  String get fullBody;

  /// No description provided for @chest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get chest;

  /// No description provided for @arm.
  ///
  /// In en, this message translates to:
  /// **'Arm'**
  String get arm;

  /// No description provided for @arms.
  ///
  /// In en, this message translates to:
  /// **'Arms'**
  String get arms;

  /// No description provided for @shoulder.
  ///
  /// In en, this message translates to:
  /// **'Shoulder'**
  String get shoulder;

  /// No description provided for @bodyBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get bodyBack;

  /// No description provided for @legs.
  ///
  /// In en, this message translates to:
  /// **'Legs'**
  String get legs;

  /// No description provided for @stomach.
  ///
  /// In en, this message translates to:
  /// **'Stomach'**
  String get stomach;

  /// No description provided for @recommendationForYou.
  ///
  /// In en, this message translates to:
  /// **'Recommendation for you'**
  String get recommendationForYou;

  /// No description provided for @breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// No description provided for @lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// No description provided for @dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dinner;

  /// No description provided for @popularTraining.
  ///
  /// In en, this message translates to:
  /// **'Popular training'**
  String get popularTraining;

  /// No description provided for @strengthenChest.
  ///
  /// In en, this message translates to:
  /// **'Exercises that strengthen your chest'**
  String get strengthenChest;

  /// No description provided for @strengthenBack.
  ///
  /// In en, this message translates to:
  /// **'Exercises that strengthen your back'**
  String get strengthenBack;

  /// No description provided for @strengthenBody.
  ///
  /// In en, this message translates to:
  /// **'Exercises that strengthen your body'**
  String get strengthenBody;

  /// No description provided for @tasksCount.
  ///
  /// In en, this message translates to:
  /// **'{count} tasks'**
  String tasksCount(int count);

  /// No description provided for @workouts.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get workouts;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes} MIN'**
  String minutesShort(int minutes);

  /// No description provided for @caloriesShort.
  ///
  /// In en, this message translates to:
  /// **'{calories} Cal'**
  String caloriesShort(int calories);

  /// No description provided for @setsAndReps.
  ///
  /// In en, this message translates to:
  /// **'{sets} sets × {reps} reps'**
  String setsAndReps(int sets, int reps);

  /// No description provided for @foodRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Food recommendation'**
  String get foodRecommendation;

  /// No description provided for @energy.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get energy;

  /// No description provided for @protein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get protein;

  /// No description provided for @carbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get carbs;

  /// No description provided for @fat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get fat;

  /// No description provided for @ingredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// No description provided for @recommendation.
  ///
  /// In en, this message translates to:
  /// **'Recommendation'**
  String get recommendation;

  /// No description provided for @smartCoach.
  ///
  /// In en, this message translates to:
  /// **'Smart coach'**
  String get smartCoach;

  /// No description provided for @chatGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi {name}, I am your smart coach'**
  String chatGreeting(String name);

  /// No description provided for @chatHelpPrompt.
  ///
  /// In en, this message translates to:
  /// **'How can I assist you today?'**
  String get chatHelpPrompt;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @previousConversations.
  ///
  /// In en, this message translates to:
  /// **'Previous conversations'**
  String get previousConversations;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// No description provided for @currentLanguageName.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get currentLanguageName;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @yourWeightTapToEdit.
  ///
  /// In en, this message translates to:
  /// **'Your weight (tap to edit)'**
  String get yourWeightTapToEdit;

  /// No description provided for @yourGoalTapToEdit.
  ///
  /// In en, this message translates to:
  /// **'Your goal (tap to edit)'**
  String get yourGoalTapToEdit;

  /// No description provided for @yourActivityTapToEdit.
  ///
  /// In en, this message translates to:
  /// **'Your activity level (tap to edit)'**
  String get yourActivityTapToEdit;

  /// No description provided for @closeAppConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to close the application?'**
  String get closeAppConfirm;

  /// No description provided for @accepted.
  ///
  /// In en, this message translates to:
  /// **'Order accepted successfully'**
  String get accepted;

  /// No description provided for @orderStatusUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Order status updated successfully'**
  String get orderStatusUpdatedSuccessfully;

  /// No description provided for @failureInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network and try again.'**
  String get failureInternetConnection;

  /// No description provided for @failureTimeout.
  ///
  /// In en, this message translates to:
  /// **'The request timed out. Please try again.'**
  String get failureTimeout;

  /// No description provided for @failureCancel.
  ///
  /// In en, this message translates to:
  /// **'The request was cancelled.'**
  String get failureCancel;

  /// No description provided for @failureBadCertificate.
  ///
  /// In en, this message translates to:
  /// **'Secure connection failed. Invalid server certificate.'**
  String get failureBadCertificate;

  /// No description provided for @failureBadRequest.
  ///
  /// In en, this message translates to:
  /// **'Invalid request. Please check your data and try again.'**
  String get failureBadRequest;

  /// No description provided for @failureUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please log in again.'**
  String get failureUnauthorized;

  /// No description provided for @failureForbidden.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to do this.'**
  String get failureForbidden;

  /// No description provided for @failureNotFound.
  ///
  /// In en, this message translates to:
  /// **'The requested item was not found.'**
  String get failureNotFound;

  /// No description provided for @failureMethodNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'This action is not allowed.'**
  String get failureMethodNotAllowed;

  /// No description provided for @failureConflict.
  ///
  /// In en, this message translates to:
  /// **'This action conflicts with the current state. Please refresh and try again.'**
  String get failureConflict;

  /// No description provided for @failureUnprocessableEntity.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t process your data. Please review it and try again.'**
  String get failureUnprocessableEntity;

  /// No description provided for @failureTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please wait a moment and try again.'**
  String get failureTooManyRequests;

  /// No description provided for @failureServerError.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get failureServerError;

  /// No description provided for @failureUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get failureUnknown;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMinLength;

  /// No description provided for @passwordStrongRules.
  ///
  /// In en, this message translates to:
  /// **'Password must include uppercase, lowercase, a number and a special character'**
  String get passwordStrongRules;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirmPasswordRequired;

  /// No description provided for @confirmPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get confirmPasswordMismatch;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get usernameRequired;

  /// No description provided for @usernameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Username is too short'**
  String get usernameMinLength;

  /// No description provided for @firstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get firstNameRequired;

  /// No description provided for @firstNameOnlyLetters.
  ///
  /// In en, this message translates to:
  /// **'First name must contain letters only'**
  String get firstNameOnlyLetters;

  /// No description provided for @lastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get lastNameRequired;

  /// No description provided for @lastNameOnlyLetters.
  ///
  /// In en, this message translates to:
  /// **'Last name must contain letters only'**
  String get lastNameOnlyLetters;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get phoneInvalid;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @fieldMinLength.
  ///
  /// In en, this message translates to:
  /// **'This field is too short'**
  String get fieldMinLength;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get accountCreated;

  /// No description provided for @loggedIn.
  ///
  /// In en, this message translates to:
  /// **'Logged in successfully'**
  String get loggedIn;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChanged;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// No description provided for @profilePhotoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile photo updated'**
  String get profilePhotoUpdated;

  /// No description provided for @workoutSaved.
  ///
  /// In en, this message translates to:
  /// **'Workout saved'**
  String get workoutSaved;

  /// No description provided for @workoutCompleted.
  ///
  /// In en, this message translates to:
  /// **'Workout completed, great job!'**
  String get workoutCompleted;

  /// No description provided for @workoutPlanStarted.
  ///
  /// In en, this message translates to:
  /// **'Workout plan started'**
  String get workoutPlanStarted;

  /// No description provided for @workoutDeleted.
  ///
  /// In en, this message translates to:
  /// **'Workout deleted'**
  String get workoutDeleted;

  /// No description provided for @exerciseAddedToWorkout.
  ///
  /// In en, this message translates to:
  /// **'Exercise added to your workout'**
  String get exerciseAddedToWorkout;

  /// No description provided for @mealLogged.
  ///
  /// In en, this message translates to:
  /// **'Meal logged'**
  String get mealLogged;

  /// No description provided for @waterLogged.
  ///
  /// In en, this message translates to:
  /// **'Water intake logged'**
  String get waterLogged;

  /// No description provided for @weightLogged.
  ///
  /// In en, this message translates to:
  /// **'Weight logged'**
  String get weightLogged;

  /// No description provided for @measurementsSaved.
  ///
  /// In en, this message translates to:
  /// **'Measurements saved'**
  String get measurementsSaved;

  /// No description provided for @progressPhotoUploaded.
  ///
  /// In en, this message translates to:
  /// **'Progress photo uploaded'**
  String get progressPhotoUploaded;

  /// No description provided for @goalCreated.
  ///
  /// In en, this message translates to:
  /// **'Goal created'**
  String get goalCreated;

  /// No description provided for @goalAchieved.
  ///
  /// In en, this message translates to:
  /// **'Goal achieved, congratulations!'**
  String get goalAchieved;

  /// No description provided for @newPersonalRecord.
  ///
  /// In en, this message translates to:
  /// **'New personal record!'**
  String get newPersonalRecord;

  /// No description provided for @reminderSet.
  ///
  /// In en, this message translates to:
  /// **'Reminder set'**
  String get reminderSet;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get settingsSaved;

  /// No description provided for @failedToLoadVideo.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the video. Please check your internet connection and try again.'**
  String get failedToLoadVideo;

  /// No description provided for @videoPlayerError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while playing the video. Please try again.'**
  String get videoPlayerError;

  /// No description provided for @invalidVideo.
  ///
  /// In en, this message translates to:
  /// **'The video link is invalid or unavailable.'**
  String get invalidVideo;

  /// No description provided for @embeddingDisabled.
  ///
  /// In en, this message translates to:
  /// **'This video can\'t be played here because the owner has disabled embedding.'**
  String get embeddingDisabled;

  /// No description provided for @videoNotFound.
  ///
  /// In en, this message translates to:
  /// **'This video isn\'t available. It may have been removed or set to private.'**
  String get videoNotFound;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'Unable to find the requested resource.'**
  String get notFound;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @unableToPlayVideo.
  ///
  /// In en, this message translates to:
  /// **'Unable to play video'**
  String get unableToPlayVideo;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'cancel the video'**
  String get cancel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
