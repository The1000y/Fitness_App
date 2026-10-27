import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/auth/presentation/login/manager/login_state.dart';

void main() {
  group('LoginState', () {
    test('initial state has default values', () {
      const state = LoginState();
      expect(state.isLoading, false);
      expect(state.errorMessage, null);
      expect(state.data, null);
    });

    test('update keeps existing fields when parameters are null', () {
      const state = LoginState(errorMessage: UnauthorizedFailure());
      final updated = state.update(isLoading: true);
      expect(updated.isLoading, true);
      expect(updated.errorMessage, isA<UnauthorizedFailure>());
    });

    test('props equality works', () {
      const s1 = LoginState(isLoading: true);
      const s2 = LoginState(isLoading: true);
      const s3 = LoginState(isLoading: false);

      expect(s1, s2);
      expect(s1, isNot(s3));
    });
  });
}
