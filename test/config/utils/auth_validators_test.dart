import 'package:fitness_app/config/utils/auth_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppValidators', () {
    group('otpRequired', () {
      test('returns otpRequired when null or empty', () {
        expect(
          AppValidators.otpRequired(null),
          equals(ValidationError.otpRequired),
        );
        expect(
          AppValidators.otpRequired(''),
          equals(ValidationError.otpRequired),
        );
      });

      test('returns otpIncomplete when length is less than 4', () {
        expect(
          AppValidators.otpRequired('1'),
          equals(ValidationError.otpIncomplete),
        );
        expect(
          AppValidators.otpRequired('12'),
          equals(ValidationError.otpIncomplete),
        );
        expect(
          AppValidators.otpRequired('123'),
          equals(ValidationError.otpIncomplete),
        );
      });

      test('returns null when valid 4 or more digits', () {
        expect(AppValidators.otpRequired('1234'), isNull);
        expect(AppValidators.otpRequired('123456'), isNull);
      });
    });

    group('email', () {
      test('returns emailRequired when null, empty or whitespace', () {
        expect(
          AppValidators.email(null),
          equals(ValidationError.emailRequired),
        );
        expect(AppValidators.email(''), equals(ValidationError.emailRequired));
        expect(
          AppValidators.email('   '),
          equals(ValidationError.emailRequired),
        );
      });

      test('returns emailInvalid when pattern is wrong', () {
        expect(
          AppValidators.email('plainaddress'),
          equals(ValidationError.emailInvalid),
        );
        expect(
          AppValidators.email('@missingusername.com'),
          equals(ValidationError.emailInvalid),
        );
        expect(
          AppValidators.email('user@.com'),
          equals(ValidationError.emailInvalid),
        );
        expect(
          AppValidators.email('user@domain'),
          equals(ValidationError.emailInvalid),
        );
      });

      test('returns null when email is valid', () {
        expect(AppValidators.email('test@example.com'), isNull);
        expect(AppValidators.email('user.name@sub.domain.co'), isNull);
        expect(AppValidators.email('  spaced@domain.com  '), isNull);
      });
    });

    group('password', () {
      test('returns passwordRequired when null or empty', () {
        expect(
          AppValidators.password(null),
          equals(ValidationError.passwordRequired),
        );
        expect(
          AppValidators.password(''),
          equals(ValidationError.passwordRequired),
        );
      });

      test('returns passwordMinLength when length < 8', () {
        expect(
          AppValidators.password('1234567'),
          equals(ValidationError.passwordMinLength),
        );
      });

      test('returns null when length >= 8', () {
        expect(AppValidators.password('12345678'), isNull);
        expect(AppValidators.password('longpassword'), isNull);
      });
    });

    group('strongPassword', () {
      test('returns passwordRequired when null or empty', () {
        expect(
          AppValidators.strongPassword(null),
          equals(ValidationError.passwordRequired),
        );
        expect(
          AppValidators.strongPassword(''),
          equals(ValidationError.passwordRequired),
        );
      });

      test('returns passwordStrongRules when missing rules', () {
        // Missing uppercase
        expect(
          AppValidators.strongPassword('password123!'),
          equals(ValidationError.passwordStrongRules),
        );
        // Missing lowercase
        expect(
          AppValidators.strongPassword('PASSWORD123!'),
          equals(ValidationError.passwordStrongRules),
        );
        // Missing digit
        expect(
          AppValidators.strongPassword('Password!!!'),
          equals(ValidationError.passwordStrongRules),
        );
        // Missing special char
        expect(
          AppValidators.strongPassword('Password123'),
          equals(ValidationError.passwordStrongRules),
        );
        // Too short (<8)
        expect(
          AppValidators.strongPassword('P1!a'),
          equals(ValidationError.passwordStrongRules),
        );
      });

      test('returns null when strong password meets all criteria', () {
        expect(AppValidators.strongPassword('P@ssword1'), isNull);
        expect(AppValidators.strongPassword('Strong123?'), isNull);
      });
    });

    group('confirmPassword', () {
      test('returns confirmPasswordRequired when null or empty', () {
        expect(
          AppValidators.confirmPassword(null, 'secret'),
          equals(ValidationError.confirmPasswordRequired),
        );
        expect(
          AppValidators.confirmPassword('', 'secret'),
          equals(ValidationError.confirmPasswordRequired),
        );
      });

      test('returns confirmPasswordMismatch when does not match original', () {
        expect(
          AppValidators.confirmPassword('other', 'secret'),
          equals(ValidationError.confirmPasswordMismatch),
        );
      });

      test('returns null when matching original password', () {
        expect(AppValidators.confirmPassword('secret', 'secret'), isNull);
      });
    });

    group('username', () {
      test('returns usernameRequired when null, empty or whitespace', () {
        expect(
          AppValidators.username(null),
          equals(ValidationError.usernameRequired),
        );
        expect(
          AppValidators.username(''),
          equals(ValidationError.usernameRequired),
        );
        expect(
          AppValidators.username('   '),
          equals(ValidationError.usernameRequired),
        );
      });

      test('returns usernameMinLength when trimmed length < 3', () {
        expect(
          AppValidators.username('ab'),
          equals(ValidationError.usernameMinLength),
        );
      });

      test('returns null when valid length', () {
        expect(AppValidators.username('abc'), isNull);
        expect(AppValidators.username('john_doe'), isNull);
      });
    });

    group('addressFields', () {
      test('returns fieldRequired when null, empty or whitespace', () {
        expect(
          AppValidators.addressFields(null),
          equals(ValidationError.fieldRequired),
        );
        expect(
          AppValidators.addressFields(''),
          equals(ValidationError.fieldRequired),
        );
      });

      test('returns fieldMinLength when < 3 chars', () {
        expect(
          AppValidators.addressFields('st'),
          equals(ValidationError.fieldMinLength),
        );
      });

      test('returns null when >= 3 chars', () {
        expect(AppValidators.addressFields('Main Street'), isNull);
      });
    });

    group('firstName', () {
      test('returns firstNameRequired when null or empty', () {
        expect(
          AppValidators.firstName(null),
          equals(ValidationError.firstNameRequired),
        );
        expect(
          AppValidators.firstName(''),
          equals(ValidationError.firstNameRequired),
        );
      });

      test(
        'returns firstNameOnlyLetters when containing non-letters or outside 2-30 range',
        () {
          expect(
            AppValidators.firstName('A'),
            equals(ValidationError.firstNameOnlyLetters),
          );
          expect(
            AppValidators.firstName('John1'),
            equals(ValidationError.firstNameOnlyLetters),
          );
          expect(
            AppValidators.firstName('A' * 31),
            equals(ValidationError.firstNameOnlyLetters),
          );
        },
      );

      test('returns null when valid firstName', () {
        expect(AppValidators.firstName('John'), isNull);
        expect(AppValidators.firstName('Alice'), isNull);
      });
    });

    group('lastName', () {
      test('returns lastNameRequired when null or empty', () {
        expect(
          AppValidators.lastName(null),
          equals(ValidationError.lastNameRequired),
        );
        expect(
          AppValidators.lastName(''),
          equals(ValidationError.lastNameRequired),
        );
      });

      test(
        'returns lastNameOnlyLetters when containing non-letters or outside 2-30 range',
        () {
          expect(
            AppValidators.lastName('A'),
            equals(ValidationError.lastNameOnlyLetters),
          );
          expect(
            AppValidators.lastName('Doe2'),
            equals(ValidationError.lastNameOnlyLetters),
          );
          expect(
            AppValidators.lastName('B' * 31),
            equals(ValidationError.lastNameOnlyLetters),
          );
        },
      );

      test('returns null when valid lastName', () {
        expect(AppValidators.lastName('Doe'), isNull);
        expect(AppValidators.lastName('Smith'), isNull);
      });
    });

    group('phone', () {
      test('returns phoneRequired when null or empty', () {
        expect(
          AppValidators.phone(null),
          equals(ValidationError.phoneRequired),
        );
        expect(AppValidators.phone(''), equals(ValidationError.phoneRequired));
      });

      test('returns phoneInvalid when format is not Egyptian mobile', () {
        expect(
          AppValidators.phone('1234567890'),
          equals(ValidationError.phoneInvalid),
        );
        expect(
          AppValidators.phone('01312345678'),
          equals(ValidationError.phoneInvalid),
        ); // prefix 013 not allowed
        expect(
          AppValidators.phone('0101234567'),
          equals(ValidationError.phoneInvalid),
        ); // 10 digits
        expect(
          AppValidators.phone('010123456789'),
          equals(ValidationError.phoneInvalid),
        ); // 12 digits
      });

      test('returns null when valid Egyptian mobile number', () {
        expect(AppValidators.phone('01012345678'), isNull);
        expect(AppValidators.phone('01112345678'), isNull);
        expect(AppValidators.phone('01212345678'), isNull);
        expect(AppValidators.phone('01512345678'), isNull);
      });
    });
  });
}
