import 'package:fitness_app/features/auth/data/model/responces/forget_password_responce/forgot_password_response_dto.dart';
import 'package:fitness_app/features/auth/domain/entities/forget_password_entity/forget_password_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ForgotPasswordResponseDto', () {
    final tStandardJson = {
      'data': 'Reset code sent',
      'message': 'Success message',
      'errorCode': '0',
      'isSuccess': true,
    };

    final tDto = ForgotPasswordResponseDto(
      data: 'Reset code sent',
      message: 'Success message',
      errorCode: '0',
      isSuccess: true,
    );

    test('fromJson should parse standard JSON correctly', () {
      final result = ForgotPasswordResponseDto.fromJson(tStandardJson);

      expect(result.data, equals('Reset code sent'));
      expect(result.message, equals('Success message'));
      expect(result.errorCode, equals('0'));
      expect(result.isSuccess, isTrue);
    });

    test('toJson should convert model to correct Map', () {
      final result = tDto.toJson();

      expect(result, equals(tStandardJson));
    });

    test('toDomain should map correctly to ForgetPasswordEntity', () {
      final entity = tDto.toDomain();

      expect(entity, isA<ForgetPasswordEntity>());
      expect(entity.isSuccess, isTrue);
      expect(entity.message, equals('Success message'));
      expect(
        entity,
        equals(
          const ForgetPasswordEntity(
            isSuccess: true,
            message: 'Success message',
          ),
        ),
      );
    });

    group('fromJson with "value" key variant', () {
      test('handles value as a Map with message key', () {
        final jsonWithValueMap = {
          'value': {'message': 'OTP sent to your email'},
          'error': 200,
          'isSuccess': true,
        };

        final result = ForgotPasswordResponseDto.fromJson(jsonWithValueMap);

        expect(result.data, equals('OTP sent to your email'));
        expect(result.message, equals('OTP sent to your email'));
        expect(result.errorCode, equals('200'));
        expect(result.isSuccess, isTrue);
      });

      test('handles value as a String', () {
        final jsonWithValueString = {
          'value': 'Direct message string',
          'isSuccess': false,
        };

        final result = ForgotPasswordResponseDto.fromJson(jsonWithValueString);

        expect(result.data, equals('Direct message string'));
        expect(result.message, equals('Direct message string'));
        expect(result.errorCode, equals('0'));
        expect(result.isSuccess, isFalse);
      });

      test('handles value as null', () {
        final jsonWithValueNull = {
          'value': null,
          'error': '404',
          'isSuccess': false,
        };

        final result = ForgotPasswordResponseDto.fromJson(jsonWithValueNull);

        expect(result.data, equals(''));
        expect(result.message, equals(''));
        expect(result.errorCode, equals('404'));
        expect(result.isSuccess, isFalse);
      });

      test('handles value Map with null message', () {
        final jsonWithValueMapNullMessage = {
          'value': <String, dynamic>{'message': null},
          'isSuccess': true,
        };

        final result = ForgotPasswordResponseDto.fromJson(
          jsonWithValueMapNullMessage,
        );

        expect(result.data, equals(''));
        expect(result.message, equals(''));
        expect(result.errorCode, equals('0'));
        expect(result.isSuccess, isTrue);
      });
    });
  });
}
