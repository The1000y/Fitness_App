import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/config/localization/app_failure_message_mapper.dart';
import 'package:fitness_app/config/localization/success_message_enum_mapper.dart';
import 'package:fitness_app/config/localization/validation_error_message_mapper.dart';
import 'package:fitness_app/config/utils/auth_validators.dart';
import 'package:fitness_app/l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppLocalizationsEn l10n;

  setUp(() {
    l10n = AppLocalizationsEn();
  });

  group('appFailureMessageMapper', () {
    test('maps all AppFailure subtypes to correct English string', () {
      expect(
        appFailureMessageMapper(const InternetConnectionFailure(), l10n),
        equals(l10n.failureInternetConnection),
      );
      expect(
        appFailureMessageMapper(const TimeoutFailure(), l10n),
        equals(l10n.failureTimeout),
      );
      expect(
        appFailureMessageMapper(const CancelFailure(), l10n),
        equals(l10n.failureCancel),
      );
      expect(
        appFailureMessageMapper(const BadCertificateFailure(), l10n),
        equals(l10n.failureBadCertificate),
      );
      expect(
        appFailureMessageMapper(
          const BadRequestFailure(serverMessage: 'Custom error'),
          l10n,
        ),
        equals('Custom error'),
      );
      expect(
        appFailureMessageMapper(const BadRequestFailure(), l10n),
        equals(l10n.failureBadRequest),
      );
      expect(
        appFailureMessageMapper(const UnauthorizedFailure(), l10n),
        equals(l10n.failureUnauthorized),
      );
      expect(
        appFailureMessageMapper(const ForbiddenFailure(), l10n),
        equals(l10n.failureForbidden),
      );
      expect(
        appFailureMessageMapper(const NotFoundFailure(), l10n),
        equals(l10n.failureNotFound),
      );
      expect(
        appFailureMessageMapper(const MethodNotAllowedFailure(), l10n),
        equals(l10n.failureMethodNotAllowed),
      );
      expect(
        appFailureMessageMapper(
          const ConflictFailure(serverMessage: 'Conflict error'),
          l10n,
        ),
        equals('Conflict error'),
      );
      expect(
        appFailureMessageMapper(const ConflictFailure(), l10n),
        equals(l10n.failureConflict),
      );
      expect(
        appFailureMessageMapper(
          const UnprocessableEntityFailure(serverMessage: 'Unprocessable'),
          l10n,
        ),
        equals('Unprocessable'),
      );
      expect(
        appFailureMessageMapper(const UnprocessableEntityFailure(), l10n),
        equals(l10n.failureUnprocessableEntity),
      );
      expect(
        appFailureMessageMapper(const TooManyRequestsFailure(), l10n),
        equals(l10n.failureTooManyRequests),
      );
      expect(
        appFailureMessageMapper(const ServerFailure(statusCode: 500), l10n),
        equals(l10n.failureServerError),
      );
      expect(
        appFailureMessageMapper(const UnknownFailure(), l10n),
        equals(l10n.failureUnknown),
      );
    });
  });

  group('successMessageMapper', () {
    test('returns null when message is null', () {
      expect(successMessageMapper(null, l10n), isNull);
    });

    test('maps all enum values to correct string', () {
      expect(
        successMessageMapper(AppSuccessMessage.accountCreated, l10n),
        equals(l10n.accountCreated),
      );
      expect(
        successMessageMapper(AppSuccessMessage.loggedIn, l10n),
        equals(l10n.loggedIn),
      );
      expect(
        successMessageMapper(AppSuccessMessage.passwordChanged, l10n),
        equals(l10n.passwordChanged),
      );
      expect(
        successMessageMapper(AppSuccessMessage.profileUpdated, l10n),
        equals(l10n.profileUpdated),
      );
      expect(
        successMessageMapper(AppSuccessMessage.profilePhotoUpdated, l10n),
        equals(l10n.profilePhotoUpdated),
      );
      expect(
        successMessageMapper(AppSuccessMessage.workoutSaved, l10n),
        equals(l10n.workoutSaved),
      );
      expect(
        successMessageMapper(AppSuccessMessage.workoutCompleted, l10n),
        equals(l10n.workoutCompleted),
      );
      expect(
        successMessageMapper(AppSuccessMessage.workoutPlanStarted, l10n),
        equals(l10n.workoutPlanStarted),
      );
      expect(
        successMessageMapper(AppSuccessMessage.workoutDeleted, l10n),
        equals(l10n.workoutDeleted),
      );
      expect(
        successMessageMapper(AppSuccessMessage.exerciseAddedToWorkout, l10n),
        equals(l10n.exerciseAddedToWorkout),
      );
      expect(
        successMessageMapper(AppSuccessMessage.mealLogged, l10n),
        equals(l10n.mealLogged),
      );
      expect(
        successMessageMapper(AppSuccessMessage.waterLogged, l10n),
        equals(l10n.waterLogged),
      );
      expect(
        successMessageMapper(AppSuccessMessage.weightLogged, l10n),
        equals(l10n.weightLogged),
      );
      expect(
        successMessageMapper(AppSuccessMessage.measurementsSaved, l10n),
        equals(l10n.measurementsSaved),
      );
      expect(
        successMessageMapper(AppSuccessMessage.progressPhotoUploaded, l10n),
        equals(l10n.progressPhotoUploaded),
      );
      expect(
        successMessageMapper(AppSuccessMessage.goalCreated, l10n),
        equals(l10n.goalCreated),
      );
      expect(
        successMessageMapper(AppSuccessMessage.goalAchieved, l10n),
        equals(l10n.goalAchieved),
      );
      expect(
        successMessageMapper(AppSuccessMessage.newPersonalRecord, l10n),
        equals(l10n.newPersonalRecord),
      );
      expect(
        successMessageMapper(AppSuccessMessage.reminderSet, l10n),
        equals(l10n.reminderSet),
      );
      expect(
        successMessageMapper(AppSuccessMessage.settingsSaved, l10n),
        equals(l10n.settingsSaved),
      );
      expect(
        successMessageMapper(AppSuccessMessage.otpSentSuccessfully, l10n),
        equals(l10n.otpSentSuccessfully),
      );
      expect(
        successMessageMapper(AppSuccessMessage.otpVerifiedSuccessfully, l10n),
        equals(l10n.otpVerifiedSuccessfully),
      );
    });
  });

  group('mapValidationErrorToMessage', () {
    test('returns null when error is null', () {
      expect(mapValidationErrorToMessage(null, l10n), isNull);
    });

    test('maps all ValidationError enum cases to corresponding localized string', () {
      expect(
        mapValidationErrorToMessage(ValidationError.emailRequired, l10n),
        equals(l10n.emailRequired),
      );
      expect(
        mapValidationErrorToMessage(ValidationError.emailInvalid, l10n),
        equals(l10n.emailInvalid),
      );
      expect(
        mapValidationErrorToMessage(ValidationError.passwordRequired, l10n),
        equals(l10n.passwordRequired),
      );
      expect(
        mapValidationErrorToMessage(ValidationError.passwordMinLength, l10n),
        equals(l10n.passwordMinLength),
      );
      expect(
        mapValidationErrorToMessage(ValidationError.passwordStrongRules, l10n),
        equals(l10n.passwordStrongRules),
      );
      expect(
        mapValidationErrorToMessage(ValidationError.confirmPasswordRequired, l10n),
        equals(l10n.confirmPasswordRequired),
      );
      expect(
        mapValidationErrorToMessage(ValidationError.confirmPasswordMismatch, l10n),
        equals(l10n.confirmPasswordMismatch),
      );
      expect(
        mapValidationErrorToMessage(ValidationError.usernameRequired, l10n),
        equals(l10n.usernameRequired),
      );
      expect(
        mapValidationErrorToMessage(ValidationError.usernameMinLength, l10n),
        equals(l10n.usernameMinLength),
      );
      expect(
        mapValidationErrorToMessage(ValidationError.firstNameRequired, l10n),
        equals(l10n.firstNameRequired),
      );
      expect(
        mapValidationErrorToMessage(ValidationError.firstNameOnlyLetters, l10n),
        equals(l10n.firstNameOnlyLetters),
      );
      expect(
        mapValidationErrorToMessage(ValidationError.lastNameRequired, l10n),
        equals(l10n.lastNameRequired),
      );
      expect(
        mapValidationErrorToMessage(ValidationError.lastNameOnlyLetters, l10n),
        equals(l10n.lastNameOnlyLetters),
      );
      expect(
        mapValidationErrorToMessage(ValidationError.phoneRequired, l10n),
        equals(l10n.phoneRequired),
      );
      expect(
        mapValidationErrorToMessage(ValidationError.phoneInvalid, l10n),
        equals(l10n.phoneInvalid),
      );
      expect(
        mapValidationErrorToMessage(ValidationError.fieldRequired, l10n),
        equals(l10n.fieldRequired),
      );
      expect(
        mapValidationErrorToMessage(ValidationError.fieldMinLength, l10n),
        equals(l10n.fieldMinLength),
      );
      expect(
        mapValidationErrorToMessage(ValidationError.otpRequired, l10n),
        equals(l10n.otpRequired),
      );
      expect(
        mapValidationErrorToMessage(ValidationError.otpIncomplete, l10n),
        equals(l10n.otpIncomplete),
      );
    });
  });
}
