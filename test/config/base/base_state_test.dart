import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BaseState', () {
    test('default constructor sets initial values', () {
      const state = BaseState<String>();

      expect(state.isLoading, isFalse);
      expect(state.errorMessage, isNull);
      expect(state.data, isNull);
    });

    test('supports value equality', () {
      const state1 = BaseState<int>(
        isLoading: true,
        errorMessage: TimeoutFailure(),
        data: 42,
      );
      const state2 = BaseState<int>(
        isLoading: true,
        errorMessage: TimeoutFailure(),
        data: 42,
      );

      expect(state1, equals(state2));
      expect(state1.props, equals([true, const TimeoutFailure(), 42]));
    });

    test('copyWith updates specified fields', () {
      const state = BaseState<String>(
        isLoading: false,
        errorMessage: null,
        data: 'initial',
      );

      final updated = state.copyWith(
        isLoading: true,
        data: 'updated',
        errorMessage: const ServerFailure(statusCode: 500),
      );

      expect(updated.isLoading, isTrue);
      expect(updated.data, equals('updated'));
      expect(
        updated.errorMessage,
        equals(const ServerFailure(statusCode: 500)),
      );
    });
  });
}
