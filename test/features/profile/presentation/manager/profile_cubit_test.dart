import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/config/routing/app_routes.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_cubit.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_event.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/profile_fakes.dart';

void main() {
  late MockProfileGetUseCase getUseCase;
  late MockProfileLogoutUseCase logoutUseCase;

  const failure = BadRequestFailure(serverMessage: 'Request failed');

  setUp(() {
    getUseCase = MockProfileGetUseCase();
    logoutUseCase = MockProfileLogoutUseCase();
  });

  ProfileCubit buildCubit() => ProfileCubit(getUseCase, logoutUseCase);

  Future<void> dispatch(ProfileCubit cubit, ProfileEvent event) async {
    cubit.onEvent(event);
    await Future<void>.delayed(Duration.zero);
  }

  group('ProfileState', () {
    test('default state is inactive', () {
      const state = ProfileState();

      expect(state.isLoggingOut, isFalse);
      expect(state.profileState, const BaseState<ProfileEntity>());
    });

    test('copyWith keeps existing values', () {
      const state = ProfileState(isLoggingOut: true);

      expect(state.copyWith(), state);
    });

    test('copyWith replaces values', () {
      final state = const ProfileState().copyWith(
        profileState: const BaseState<ProfileEntity>(isLoading: true),
        isLoggingOut: true,
      );

      expect(state.profileState.isLoading, isTrue);
      expect(state.isLoggingOut, isTrue);
    });
  });

  group('ProfileCubit load profile', () {
    blocTest<ProfileCubit, ProfileState>(
      'emits loading then profile data on success',
      build: () {
        when(
          () => getUseCase(),
        ).thenAnswer((_) async => const Success<ProfileEntity>(testProfile));
        return buildCubit();
      },
      act: (cubit) => dispatch(cubit, const LoadProfile()),
      expect: () => [
        const ProfileState(
          profileState: BaseState<ProfileEntity>(isLoading: true),
        ),
        const ProfileState(
          profileState: BaseState<ProfileEntity>(data: testProfile),
        ),
      ],
      verify: (_) => verify(() => getUseCase()).called(1),
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits loading then failure state on error',
      build: () {
        when(
          () => getUseCase(),
        ).thenAnswer((_) async => const Error<ProfileEntity>(failure));
        return buildCubit();
      },
      act: (cubit) => dispatch(cubit, const LoadProfile()),
      expect: () => [
        const ProfileState(
          profileState: BaseState<ProfileEntity>(isLoading: true),
        ),
        const ProfileState(
          profileState: BaseState<ProfileEntity>(errorMessage: failure),
        ),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'ignores a second load while the first is in progress',
      build: buildCubit,
      seed: () => const ProfileState(
        profileState: BaseState<ProfileEntity>(isLoading: true),
      ),
      act: (cubit) => dispatch(cubit, const LoadProfile()),
      expect: () => <ProfileState>[],
      verify: (_) => verifyNever(() => getUseCase()),
    );

    test('emits failure message when loading fails', () async {
      when(
        () => getUseCase(),
      ).thenAnswer((_) async => const Error<ProfileEntity>(failure));
      final cubit = buildCubit();
      final events = <CommonUiEvent>[];
      final subscription = cubit.uiEventStream.listen(events.add);

      await dispatch(cubit, const LoadProfile());

      expect(events, hasLength(1));
      expect(
        events.single,
        isA<ShowFailureMessage>().having(
          (event) => event.failure,
          'failure',
          failure,
        ),
      );

      await subscription.cancel();
      await cubit.close();
    });
  });

  group('ProfileCubit logout', () {
    blocTest<ProfileCubit, ProfileState>(
      'emits logging out then idle on success',
      build: () {
        when(
          () => logoutUseCase(),
        ).thenAnswer((_) async => const Success<void>(null));
        return buildCubit();
      },
      act: (cubit) => dispatch(cubit, const LogoutRequested()),
      expect: () => [
        const ProfileState(isLoggingOut: true),
        const ProfileState(isLoggingOut: false),
      ],
      verify: (_) => verify(() => logoutUseCase()).called(1),
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits logging out then idle on failure',
      build: () {
        when(
          () => logoutUseCase(),
        ).thenAnswer((_) async => const Error<void>(failure));
        return buildCubit();
      },
      act: (cubit) => dispatch(cubit, const LogoutRequested()),
      expect: () => [
        const ProfileState(isLoggingOut: true),
        const ProfileState(isLoggingOut: false),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'ignores logout while already logging out',
      build: buildCubit,
      seed: () => const ProfileState(isLoggingOut: true),
      act: (cubit) => dispatch(cubit, const LogoutRequested()),
      expect: () => <ProfileState>[],
      verify: (_) => verifyNever(() => logoutUseCase()),
    );

    test('navigates to login after successful logout', () async {
      when(
        () => logoutUseCase(),
      ).thenAnswer((_) async => const Success<void>(null));
      final cubit = buildCubit();
      final events = <CommonUiEvent>[];
      final subscription = cubit.uiEventStream.listen(events.add);

      await dispatch(cubit, const LogoutRequested());

      expect(events, hasLength(1));
      expect(
        events.single,
        isA<NavigateAndRemoveUntil>().having(
          (event) => event.routeName,
          'routeName',
          AppRoutes.login,
        ),
      );

      await subscription.cancel();
      await cubit.close();
    });

    test('emits failure message when logout fails', () async {
      when(
        () => logoutUseCase(),
      ).thenAnswer((_) async => const Error<void>(failure));
      final cubit = buildCubit();
      final events = <CommonUiEvent>[];
      final subscription = cubit.uiEventStream.listen(events.add);

      await dispatch(cubit, const LogoutRequested());

      expect(events, hasLength(1));
      expect(
        events.single,
        isA<ShowFailureMessage>().having(
          (event) => event.failure,
          'failure',
          failure,
        ),
      );

      await subscription.cancel();
      await cubit.close();
    });
  });
}
