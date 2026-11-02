import 'package:fitness_app/config/utils/auth_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppValidators', () {
    group('email', () {
      test('returns emailRequired for null, empty, or whitespace', () {
        expect(AppValidators.email(null), ValidationError.emailRequired);
        expect(AppValidators.email(''), ValidationError.emailRequired);
        expect(AppValidators.email('   '), ValidationError.emailRequired);
      });

      test('returns emailInvalid for malformed email addresses', () {
        expect(AppValidators.email('plainaddress'), ValidationError.emailInvalid);
        expect(AppValidators.email('@missingusername.com'), ValidationError.emailInvalid);
        expect(AppValidators.email('username@.com'), ValidationError.emailInvalid);
        expect(AppValidators.email('user@domain.c'), ValidationError.emailInvalid);
      });

      test('returns null for valid email addresses', () {
        expect(AppValidators.email('test@example.com'), isNull);
        expect(AppValidators.email('user.name@example.co.uk'), isNull);
        expect(AppValidators.email('  spaces_around@test.com  '), isNull);
      });
    });

    group('password', () {
      test('returns passwordRequired for null or empty', () {
        expect(AppValidators.password(null), ValidationError.passwordRequired);
        expect(AppValidators.password(''), ValidationError.passwordRequired);
      });

      test('returns passwordMinLength for fewer than 8 characters', () {
        expect(AppValidators.password('1234567'), ValidationError.passwordMinLength);
      });

      test('returns null for 8 or more characters', () {
        expect(AppValidators.password('12345678'), isNull);
        expect(AppValidators.password('longpassword'), isNull);
      });
    });

    group('strongPassword', () {
      test('returns passwordRequired for null or empty', () {
        expect(AppValidators.strongPassword(null), ValidationError.passwordRequired);
        expect(AppValidators.strongPassword(''), ValidationError.passwordRequired);
      });

      test('returns passwordStrongRules when missing required character types', () {
        // Missing special character
        expect(AppValidators.strongPassword('Password123'), ValidationError.passwordStrongRules);
        // Missing uppercase
        expect(AppValidators.strongPassword('password123!'), ValidationError.passwordStrongRules);
        // Missing lowercase
        expect(AppValidators.strongPassword('PASSWORD123!'), ValidationError.passwordStrongRules);
        // Missing digit
        expect(AppValidators.strongPassword('Password!@#'), ValidationError.passwordStrongRules);
        // Too short (< 8)
        expect(AppValidators.strongPassword('Pass1!'), ValidationError.passwordStrongRules);
      });

      test('returns null for valid strong password', () {
        expect(AppValidators.strongPassword('Password123!'), isNull);
        expect(AppValidators.strongPassword('P@ssw0rd2026'), isNull);
      });
    });

    group('confirmPassword', () {
      test('returns confirmPasswordRequired for null or empty', () {
        expect(AppValidators.confirmPassword(null, 'Password123!'), ValidationError.confirmPasswordRequired);
        expect(AppValidators.confirmPassword('', 'Password123!'), ValidationError.confirmPasswordRequired);
      });

      test('returns confirmPasswordMismatch when values differ', () {
        expect(AppValidators.confirmPassword('Different123!', 'Password123!'), ValidationError.confirmPasswordMismatch);
      });

      test('returns null when values match', () {
        expect(AppValidators.confirmPassword('Password123!', 'Password123!'), isNull);
      });
    });

    group('username', () {
      test('returns usernameRequired for null, empty, or whitespace', () {
        expect(AppValidators.username(null), ValidationError.usernameRequired);
        expect(AppValidators.username(''), ValidationError.usernameRequired);
        expect(AppValidators.username('  '), ValidationError.usernameRequired);
      });

      test('returns usernameMinLength for fewer than 3 characters', () {
        expect(AppValidators.username('ab'), ValidationError.usernameMinLength);
      });

      test('returns null for 3 or more characters', () {
        expect(AppValidators.username('abc'), isNull);
        expect(AppValidators.username('  validUser  '), isNull);
      });
    });

    group('addressFields', () {
      test('returns fieldRequired for null, empty, or whitespace', () {
        expect(AppValidators.addressFields(null), ValidationError.fieldRequired);
        expect(AppValidators.addressFields(''), ValidationError.fieldRequired);
        expect(AppValidators.addressFields('  '), ValidationError.fieldRequired);
      });

      test('returns fieldMinLength for fewer than 3 characters', () {
        expect(AppValidators.addressFields('12'), ValidationError.fieldMinLength);
      });

      test('returns null for 3 or more characters', () {
        expect(AppValidators.addressFields('Main Street'), isNull);
      });
    });

    group('firstName and lastName', () {
      test('firstName validates required and letter-only constraints', () {
        expect(AppValidators.firstName(null), ValidationError.firstNameRequired);
        expect(AppValidators.firstName(''), ValidationError.firstNameRequired);
        expect(AppValidators.firstName('   '), ValidationError.firstNameRequired);
        expect(AppValidators.firstName('A'), ValidationError.firstNameOnlyLetters); // < 2 chars
        expect(AppValidators.firstName('John123'), ValidationError.firstNameOnlyLetters); // numbers
        expect(AppValidators.firstName('John!'), ValidationError.firstNameOnlyLetters); // symbols
        expect(AppValidators.firstName('John'), isNull);
      });

      test('lastName validates required and letter-only constraints', () {
        expect(AppValidators.lastName(null), ValidationError.lastNameRequired);
        expect(AppValidators.lastName(''), ValidationError.lastNameRequired);
        expect(AppValidators.lastName('   '), ValidationError.lastNameRequired);
        expect(AppValidators.lastName('D'), ValidationError.lastNameOnlyLetters);
        expect(AppValidators.lastName('Doe1'), ValidationError.lastNameOnlyLetters);
        expect(AppValidators.lastName('Doe'), isNull);
      });
    });

    group('phone', () {
      test('returns phoneRequired for null or empty', () {
        expect(AppValidators.phone(null), ValidationError.phoneRequired);
        expect(AppValidators.phone(''), ValidationError.phoneRequired);
      });

      test('returns phoneInvalid for non-Egyptian phone numbers', () {
        expect(AppValidators.phone('1234567890'), ValidationError.phoneInvalid);
        expect(AppValidators.phone('01312345678'), ValidationError.phoneInvalid); // 013 not allowed
        expect(AppValidators.phone('0101234567'), ValidationError.phoneInvalid); // 10 digits instead of 11
        expect(AppValidators.phone('010123456789'), ValidationError.phoneInvalid); // 12 digits
        expect(AppValidators.phone('0101234567a'), ValidationError.phoneInvalid);
      });

      test('returns null for valid Egyptian phone numbers (010, 011, 012, 015)', () {
        expect(AppValidators.phone('01012345678'), isNull);
        expect(AppValidators.phone('01112345678'), isNull);
        expect(AppValidators.phone('01212345678'), isNull);
        expect(AppValidators.phone('01512345678'), isNull);
      });
    });
  });
}
