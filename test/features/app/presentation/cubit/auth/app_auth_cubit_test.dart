import 'package:fitness_app/features/app/presentation/cubit/auth/app_auth_cubit.dart';
import 'package:fitness_app/features/app/presentation/cubit/auth/app_auth_state.dart';
import 'package:fitness_app/features/app/presentation/cubit/auth/app_auth_ui_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppAuthCubit', () {
    late AppAuthCubit cubit;

    setUp(() {
      cubit = AppAuthCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is AppAuthState', () {
      expect(cubit.state, isA<AppAuthState>());
    });

    test('sessionExpired emits SessionExpiredUiEvent onto uiEventStream', () async {
      final events = <AppAuthUiEvent>[];
      final subscription = cubit.uiEventStream.listen(events.add);

      cubit.sessionExpired();
      await Future.delayed(Duration.zero);

      expect(events.length, equals(1));
      expect(events.first, isA<SessionExpiredUiEvent>());

      await subscription.cancel();
    });
  });
}
