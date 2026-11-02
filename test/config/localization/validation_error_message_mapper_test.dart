import 'package:fitness_app/config/localization/validation_error_message_mapper.dart';
import 'package:fitness_app/config/utils/auth_validators.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  group('mapValidationErrorToMessage', () {
    test('returns null when error is null', () {
      expect(mapValidationErrorToMessage(null, l10n), isNull);
    });

    test('maps each ValidationError to its corresponding localized string', () {
      expect(
        mapValidationErrorToMessage(ValidationError.emailRequired, l10n),
        l10n.emailRequired,
      );
      expect(
        mapValidationErrorToMessage(ValidationError.emailInvalid, l10n),
        l10n.emailInvalid,
      );
      expect(
        mapValidationErrorToMessage(ValidationError.passwordRequired, l10n),
        l10n.passwordRequired,
      );
      expect(
        mapValidationErrorToMessage(ValidationError.passwordMinLength, l10n),
        l10n.passwordMinLength,
      );
      expect(
        mapValidationErrorToMessage(ValidationError.passwordStrongRules, l10n),
        l10n.passwordStrongRules,
      );
      expect(
        mapValidationErrorToMessage(
          ValidationError.confirmPasswordRequired,
          l10n,
        ),
        l10n.confirmPasswordRequired,
      );
      expect(
        mapValidationErrorToMessage(
          ValidationError.confirmPasswordMismatch,
          l10n,
        ),
        l10n.confirmPasswordMismatch,
      );
      expect(
        mapValidationErrorToMessage(ValidationError.usernameRequired, l10n),
        l10n.usernameRequired,
      );
      expect(
        mapValidationErrorToMessage(ValidationError.usernameMinLength, l10n),
        l10n.usernameMinLength,
      );
      expect(
        mapValidationErrorToMessage(ValidationError.firstNameRequired, l10n),
        l10n.firstNameRequired,
      );
      expect(
        mapValidationErrorToMessage(ValidationError.firstNameOnlyLetters, l10n),
        l10n.firstNameOnlyLetters,
      );
      expect(
        mapValidationErrorToMessage(ValidationError.lastNameRequired, l10n),
        l10n.lastNameRequired,
      );
      expect(
        mapValidationErrorToMessage(ValidationError.lastNameOnlyLetters, l10n),
        l10n.lastNameOnlyLetters,
      );
      expect(
        mapValidationErrorToMessage(ValidationError.phoneRequired, l10n),
        l10n.phoneRequired,
      );
      expect(
        mapValidationErrorToMessage(ValidationError.phoneInvalid, l10n),
        l10n.phoneInvalid,
      );
      expect(
        mapValidationErrorToMessage(ValidationError.fieldRequired, l10n),
        l10n.fieldRequired,
      );
      expect(
        mapValidationErrorToMessage(ValidationError.fieldMinLength, l10n),
        l10n.fieldMinLength,
      );
    });
  });
}
