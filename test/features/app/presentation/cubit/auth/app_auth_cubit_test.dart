import 'package:fitness_app/core/constants/storage_keys.dart';
import 'package:fitness_app/features/app/presentation/cubit/auth/app_auth_cubit.dart';
import 'package:fitness_app/features/app/presentation/cubit/auth/app_auth_state.dart';
import 'package:fitness_app/features/app/presentation/cubit/auth/app_auth_ui_event.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/fakes.dart';

void main() {
  late InMemorySecureStorage storage;
  late AppAuthCubit cubit;

  setUp(() {
    storage = InMemorySecureStorage();
    cubit = AppAuthCubit(storage);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('AppAuthCubit', () {
    test('initial state is AppAuthState', () {
      expect(cubit.state, const AppAuthState());
    });

    test('setUserId writes to storage and updates state', () async {
      await cubit.setUserId('user_123');

      expect(cubit.state.userId, 'user_123');
      expect(await storage.read(key: StorageKeys.kUserId), 'user_123');
    });

    test('setUserId ignores empty or whitespace string', () async {
      await cubit.setUserId('   ');

      expect(cubit.state.userId, isNull);
    });

    test('restoreUserId restores id from storage', () async {
      await storage.write(key: StorageKeys.kUserId, value: 'user_456');

      await cubit.restoreUserId();

      expect(cubit.state.userId, 'user_456');
    });

    test('clearUserId removes id from storage and state', () async {
      await cubit.setUserId('user_123');
      await cubit.clearUserId();

      expect(cubit.state.userId, isNull);
      expect(await storage.read(key: StorageKeys.kUserId), isNull);
    });

    test(
      'sessionExpired clears userId and emits SessionExpiredUiEvent onto uiEventStream',
      () async {
        await cubit.setUserId('user_123');

        final events = <AppAuthUiEvent>[];
        final subscription = cubit.uiEventStream.listen(events.add);

        await cubit.sessionExpired();
        await pumpEventQueue();

        expect(cubit.state.userId, isNull);
        expect(await storage.read(key: StorageKeys.kUserId), isNull);
        expect(events.length, equals(1));
        expect(events.first, isA<SessionExpiredUiEvent>());

        await subscription.cancel();
      },
    );
  });
}
