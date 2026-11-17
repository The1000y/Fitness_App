import 'package:fitness_app/config/localization/validation_error_message_mapper.dart';
import 'package:fitness_app/config/utils/auth_validators.dart';
import 'package:fitness_app/l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppValidators.newPassword', () {
    test('empty_returnsPasswordRequired', () {
      expect(
        AppValidators.newPassword('', 'Old@1234'),
        ValidationError.passwordRequired,
      );
    });

    test('weak_returnsStrongRules', () {
      expect(
        AppValidators.newPassword('weakpass', 'Old@1234'),
        ValidationError.passwordStrongRules,
      );
    });

    test('sameAsOld_returnsSameAsOld', () {
      expect(
        AppValidators.newPassword('Old@1234', 'Old@1234'),
        ValidationError.newPasswordSameAsOld,
      );
    });

    test('strongAndDifferent_returnsNull', () {
      expect(AppValidators.newPassword('New@1234', 'Old@1234'), isNull);
    });
  });

  group('mapValidationErrorToMessage', () {
    test('newPasswordSameAsOld_mapsToEnglishMessage', () {
      expect(
        mapValidationErrorToMessage(
          ValidationError.newPasswordSameAsOld,
          AppLocalizationsEn(),
        ),
        'New password must be different from the old password',
      );
    });
  });
}
