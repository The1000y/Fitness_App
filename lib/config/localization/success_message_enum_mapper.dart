import 'package:fitness_app/l10n/app_localizations.dart';

enum AppSuccessMessage {
  // Auth
  accountCreated,
  loggedIn,
  passwordChanged,

  // Profile
  profileUpdated,
  profilePhotoUpdated,

  // Workout
  workoutSaved,
  workoutCompleted,
  workoutPlanStarted,
  workoutDeleted,
  exerciseAddedToWorkout,

  // Nutrition
  mealLogged,
  waterLogged,

  // Progress & goals
  weightLogged,
  measurementsSaved,
  progressPhotoUploaded,
  goalCreated,
  goalAchieved,
  newPersonalRecord,

  // Settings
  reminderSet,
  settingsSaved,
  otpSentSuccessfully,
  otpVerifiedSuccessfully,
}

String? successMessageMapper(
  AppSuccessMessage? message,
  AppLocalizations l10n,
) {
  if (message == null) return null;
  switch (message) {
    case AppSuccessMessage.accountCreated:
      return l10n.accountCreated;

    case AppSuccessMessage.loggedIn:
      return l10n.loggedIn;

    case AppSuccessMessage.passwordChanged:
      return l10n.passwordChanged;
    case AppSuccessMessage.profileUpdated:
      return l10n.profileUpdated;
    case AppSuccessMessage.profilePhotoUpdated:
      return l10n.profilePhotoUpdated;
    case AppSuccessMessage.workoutSaved:
      return l10n.workoutSaved;
    case AppSuccessMessage.workoutCompleted:
      return l10n.workoutCompleted;
    case AppSuccessMessage.workoutPlanStarted:
      return l10n.workoutPlanStarted;
    case AppSuccessMessage.workoutDeleted:
      return l10n.workoutDeleted;
    case AppSuccessMessage.exerciseAddedToWorkout:
      return l10n.exerciseAddedToWorkout;
    case AppSuccessMessage.mealLogged:
      return l10n.mealLogged;
    case AppSuccessMessage.waterLogged:
      return l10n.waterLogged;
    case AppSuccessMessage.weightLogged:
      return l10n.weightLogged;
    case AppSuccessMessage.measurementsSaved:
      return l10n.measurementsSaved;
    case AppSuccessMessage.progressPhotoUploaded:
      return l10n.progressPhotoUploaded;
    case AppSuccessMessage.goalCreated:
      return l10n.goalCreated;
    case AppSuccessMessage.goalAchieved:
      return l10n.goalAchieved;
    case AppSuccessMessage.newPersonalRecord:
      return l10n.newPersonalRecord;
    case AppSuccessMessage.reminderSet:
      return l10n.reminderSet;

    case AppSuccessMessage.settingsSaved:
      return l10n.settingsSaved;
    case AppSuccessMessage.otpSentSuccessfully:
      return l10n.otpSentSuccessfully;
    case AppSuccessMessage.otpVerifiedSuccessfully:
      return l10n.otpVerifiedSuccessfully;
  }
}
