import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:fitness_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:fitness_app/features/auth/presentation/login/manager/login_state.dart';

void main() {
  final entity = LoginEntity(
    message: 'ok',
    user: UserEntity(),
    token: 'fake.jwt.token',
  );

  group('LoginState', () {
    test('initial state wraps an idle BaseState', () {
      const state = LoginState();

      expect(state.loginState.isLoading, false);
      expect(state.loginState.errorMessage, null);
      expect(state.loginState.data, null);
      expect(state.loginState, const BaseState<LoginEntity>());
    });

    test('copyWith without arguments keeps the current loginState', () {
      const state = LoginState(
        loginState: BaseState<LoginEntity>(isLoading: true),
      );

      expect(state.copyWith(), state);
    });

    test('copyWith replaces loginState', () {
      const state = LoginState();
      final updated = state.copyWith(
        loginState: const BaseState<LoginEntity>(isLoading: true),
      );

      expect(updated.loginState.isLoading, true);
      expect(state.loginState.isLoading, false);
    });

    test('can hold data and failure inside loginState', () {
      final success = LoginState(
        loginState: BaseState<LoginEntity>(data: entity),
      );
      const failed = LoginState(
        loginState: BaseState<LoginEntity>(errorMessage: UnauthorizedFailure()),
      );

      expect(success.loginState.data, entity);
      expect(failed.loginState.errorMessage, isA<UnauthorizedFailure>());
    });

    test('props equality works', () {
      const s1 = LoginState(
        loginState: BaseState<LoginEntity>(isLoading: true),
      );
      const s2 = LoginState(
        loginState: BaseState<LoginEntity>(isLoading: true),
      );
      const s3 = LoginState(
        loginState: BaseState<LoginEntity>(isLoading: false),
      );

      expect(s1, s2);
      expect(s1, isNot(s3));
    });
  });
}
