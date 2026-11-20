import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/config/localization/success_message_enum_mapper.dart';
import 'package:fitness_app/core/services/image_picker_service.dart';
import 'package:fitness_app/features/profile/domain/entities/params/update_profile_param.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_app/features/profile/domain/use_cases/profile_update_use_case.dart';
import 'package:fitness_app/features/profile/domain/use_cases/profile_upload_photo_use_case.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/manager/edit_profile_cubit.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/manager/edit_profile_event.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/profile_fakes.dart';

class MockProfileUpdateUseCase extends Mock implements ProfileUpdateUseCase {}

class MockProfileUploadPhotoUseCase extends Mock
    implements ProfileUploadPhotoUseCase {}

class MockImagePickerService extends Mock implements ImagePickerService {}

void main() {
  late MockProfileUpdateUseCase updateUseCase;
  late MockProfileUploadPhotoUseCase uploadPhotoUseCase;
  late MockImagePickerService imagePickerService;
  late EditProfileCubit cubit;

  setUpAll(() {
    registerFallbackValue(const UpdateProfileParam());
  });

  setUp(() {
    updateUseCase = MockProfileUpdateUseCase();
    uploadPhotoUseCase = MockProfileUploadPhotoUseCase();
    imagePickerService = MockImagePickerService();

    cubit = EditProfileCubit(
      updateUseCase,
      uploadPhotoUseCase,
      imagePickerService,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  group('EditProfileCubit', () {
    test('initial state has all fields set to default null/false', () {
      expect(cubit.state.initialProfile, isNull);
      expect(cubit.state.weight, isNull);
      expect(cubit.state.goal, isNull);
      expect(cubit.state.activityLevel, isNull);
      expect(cubit.state.pickedPhotoPath, isNull);
      expect(cubit.state.isSaving, isFalse);
    });

    group('InitEditProfileEvent', () {
      test('sets state fields properly from ProfileEntity', () async {
        await cubit.doEvent(const InitEditProfileEvent(testProfile));

        expect(cubit.state.initialProfile, testProfile);
        expect(cubit.state.weight, testProfile.weight.toDouble());
        expect(cubit.state.goal, testProfile.goal);
        expect(cubit.state.activityLevel, testProfile.activityLevel);
      });
    });

    group('Field change events', () {
      test('EditWeightChangedEvent updates weight in state', () async {
        await cubit.doEvent(const EditWeightChangedEvent(72.5));
        expect(cubit.state.weight, 72.5);
      });

      test('GoalChangedEvent updates goal in state', () async {
        await cubit.doEvent(const GoalChangedEvent('Gain weight'));
        expect(cubit.state.goal, 'Gain weight');
      });

      test('ActivityLevelChangedEvent updates activity level in state', () async {
        await cubit.doEvent(const ActivityLevelChangedEvent('beast'));
        expect(cubit.state.activityLevel, 'beast');
      });
    });

    group('PickPhotoEvent', () {
      test('updates pickedPhotoPath when picker returns a non-null path', () async {
        when(() => imagePickerService.pickFromGallery()).thenAnswer(
          (_) async => '/path/to/picked.png',
        );

        await cubit.doEvent(const PickPhotoEvent());

        expect(cubit.state.pickedPhotoPath, '/path/to/picked.png');
        verify(() => imagePickerService.pickFromGallery()).called(1);
      });

      test('leaves pickedPhotoPath unchanged when picker returns null', () async {
        when(() => imagePickerService.pickFromGallery()).thenAnswer(
          (_) async => null,
        );

        await cubit.doEvent(const PickPhotoEvent());

        expect(cubit.state.pickedPhotoPath, isNull);
        verify(() => imagePickerService.pickFromGallery()).called(1);
      });

      test('does not emit or crash when cubit is closed during photo picking', () async {
        when(() => imagePickerService.pickFromGallery()).thenAnswer((_) async {
          await cubit.close();
          return '/path/to/picked.png';
        });

        await cubit.doEvent(const PickPhotoEvent());

        expect(cubit.isClosed, isTrue);
      });
    });

    group('SaveEditProfileEvent', () {
      test('returns early without action when initialProfile is null', () async {
        final events = <CommonUiEvent>[];
        final subscription = cubit.uiEventStream.listen(events.add);

        await cubit.doEvent(
          const SaveEditProfileEvent(firstName: 'Ada', lastName: 'Lovelace'),
        );
        await pumpEventQueue();

        expect(events, isEmpty);
        verifyZeroInteractions(updateUseCase);
        verifyZeroInteractions(uploadPhotoUseCase);

        await subscription.cancel();
      });

      test('returns early when isSaving is already true', () async {
        await cubit.doEvent(const InitEditProfileEvent(testProfile));

        // Create a state with isSaving == true
        cubit.emit(
          cubit.state.copyWith(
            saveState: const BaseState<ProfileEntity>(isLoading: true),
          ),
        );

        final events = <CommonUiEvent>[];
        final subscription = cubit.uiEventStream.listen(events.add);

        await cubit.doEvent(
          const SaveEditProfileEvent(firstName: 'NewName', lastName: 'Lovelace'),
        );
        await pumpEventQueue();

        expect(events, isEmpty);
        verifyZeroInteractions(updateUseCase);
        verifyZeroInteractions(uploadPhotoUseCase);

        await subscription.cancel();
      });

      test('with no changes emits PopRoute and returns early without use case calls', () async {
        await cubit.doEvent(const InitEditProfileEvent(testProfile));

        final events = <CommonUiEvent>[];
        final subscription = cubit.uiEventStream.listen(events.add);

        await cubit.doEvent(
          SaveEditProfileEvent(
            firstName: testProfile.firstName,
            lastName: testProfile.lastName,
          ),
        );
        await pumpEventQueue();

        expect(events, hasLength(1));
        expect(events.first, isA<PopRoute>());
        verifyZeroInteractions(updateUseCase);
        verifyZeroInteractions(uploadPhotoUseCase);

        await subscription.cancel();
      });

      test('trims whitespace and treats equal trimmed values as no changes', () async {
        await cubit.doEvent(const InitEditProfileEvent(testProfile));

        final events = <CommonUiEvent>[];
        final subscription = cubit.uiEventStream.listen(events.add);

        await cubit.doEvent(
          SaveEditProfileEvent(
            firstName: '  ${testProfile.firstName}  ',
            lastName: '  ${testProfile.lastName}  ',
          ),
        );
        await pumpEventQueue();

        expect(events, hasLength(1));
        expect(events.first, isA<PopRoute>());
        verifyZeroInteractions(updateUseCase);

        await subscription.cancel();
      });

      test('updates text fields successfully and emits ShowSuccessMessage and PopRoute', () async {
        await cubit.doEvent(const InitEditProfileEvent(testProfile));

        const updatedProfile = ProfileEntity(
          id: 'user-1',
          firstName: 'AdaNew',
          lastName: 'Lovelace',
          email: 'ada@example.com',
          gender: 'female',
          age: 30,
          weight: 60.5,
          height: 170,
          activityLevel: 'active',
          goal: 'fitness',
          photo: '',
        );

        when(() => updateUseCase(any())).thenAnswer(
          (_) async => const Success<ProfileEntity>(updatedProfile),
        );

        final events = <CommonUiEvent>[];
        final subscription = cubit.uiEventStream.listen(events.add);

        await cubit.doEvent(
          const SaveEditProfileEvent(
            firstName: 'AdaNew',
            lastName: 'Lovelace',
          ),
        );
        await pumpEventQueue();

        expect(cubit.state.initialProfile, updatedProfile);
        expect(cubit.state.saveState.data, updatedProfile);
        expect(events, hasLength(2));
        expect(
          events.first,
          isA<ShowSuccessMessage>().having(
            (e) => e.message,
            'message',
            AppSuccessMessage.profileUpdated,
          ),
        );
        expect(events.last, isA<PopRoute>());

        final captured = verify(() => updateUseCase(captureAny())).captured.single as UpdateProfileParam;
        expect(captured.firstName, 'AdaNew');
        expect(captured.lastName, isNull);
        expect(captured.weight, isNull);
        expect(captured.goal, isNull);
        expect(captured.activityLevel, isNull);

        await subscription.cancel();
      });

      test('passes all changed fields in UpdateProfileParam when multiple fields change', () async {
        await cubit.doEvent(const InitEditProfileEvent(testProfile));
        await cubit.doEvent(const EditWeightChangedEvent(75.0));
        await cubit.doEvent(const GoalChangedEvent('Gain weight'));
        await cubit.doEvent(const ActivityLevelChangedEvent('beast'));

        const updatedProfile = ProfileEntity(
          id: 'user-1',
          firstName: 'NewFirst',
          lastName: 'NewLast',
          email: 'ada@example.com',
          gender: 'female',
          age: 30,
          weight: 75.0,
          height: 170,
          activityLevel: 'beast',
          goal: 'Gain weight',
          photo: '',
        );

        when(() => updateUseCase(any())).thenAnswer(
          (_) async => const Success<ProfileEntity>(updatedProfile),
        );

        final events = <CommonUiEvent>[];
        final subscription = cubit.uiEventStream.listen(events.add);

        await cubit.doEvent(
          const SaveEditProfileEvent(
            firstName: 'NewFirst',
            lastName: 'NewLast',
          ),
        );
        await pumpEventQueue();

        final captured = verify(() => updateUseCase(captureAny())).captured.single as UpdateProfileParam;
        expect(captured.firstName, 'NewFirst');
        expect(captured.lastName, 'NewLast');
        expect(captured.weight, 75.0);
        expect(captured.goal, 'Gain weight');
        expect(captured.activityLevel, 'beast');

        await subscription.cancel();
      });

      test('handles updateUseCase failure by updating saveState and emitting ShowFailureMessage and PopRoute', () async {
        await cubit.doEvent(const InitEditProfileEvent(testProfile));
        const failure = ServerFailure();

        when(() => updateUseCase(any())).thenAnswer(
          (_) async => const Error<ProfileEntity>(failure),
        );

        final events = <CommonUiEvent>[];
        final subscription = cubit.uiEventStream.listen(events.add);

        await cubit.doEvent(
          const SaveEditProfileEvent(
            firstName: 'AdaNew',
            lastName: 'Lovelace',
          ),
        );
        await pumpEventQueue();

        expect(cubit.state.saveState.errorMessage, failure);
        expect(events, hasLength(2));
        expect(
          events.first,
          isA<ShowFailureMessage>().having((e) => e.failure, 'failure', failure),
        );
        expect(events.last, isA<PopRoute>());
        verifyNever(() => uploadPhotoUseCase(any()));

        await subscription.cancel();
      });

      test('uploads photo successfully without text changes', () async {
        await cubit.doEvent(const InitEditProfileEvent(testProfile));
        when(() => imagePickerService.pickFromGallery()).thenAnswer(
          (_) async => '/path/photo.png',
        );
        await cubit.doEvent(const PickPhotoEvent());

        const updatedProfile = ProfileEntity(
          id: 'user-1',
          firstName: 'Ada',
          lastName: 'Lovelace',
          email: 'ada@example.com',
          gender: 'female',
          age: 30,
          weight: 60.5,
          height: 170,
          activityLevel: 'active',
          goal: 'fitness',
          photo: 'http://server.com/photo.png',
        );

        when(() => uploadPhotoUseCase('/path/photo.png')).thenAnswer(
          (_) async => const Success<ProfileEntity>(updatedProfile),
        );

        final events = <CommonUiEvent>[];
        final subscription = cubit.uiEventStream.listen(events.add);

        await cubit.doEvent(
          SaveEditProfileEvent(
            firstName: testProfile.firstName,
            lastName: testProfile.lastName,
          ),
        );
        await pumpEventQueue();

        expect(cubit.state.initialProfile, updatedProfile);
        expect(cubit.state.pickedPhotoPath, isNull);
        expect(events, hasLength(2));
        expect(
          events.first,
          isA<ShowSuccessMessage>().having(
            (e) => e.message,
            'message',
            AppSuccessMessage.profileUpdated,
          ),
        );
        expect(events.last, isA<PopRoute>());

        verify(() => uploadPhotoUseCase('/path/photo.png')).called(1);
        verifyNever(() => updateUseCase(any()));

        await subscription.cancel();
      });

      test('handles uploadPhotoUseCase failure by emitting ShowFailureMessage and PopRoute', () async {
        await cubit.doEvent(const InitEditProfileEvent(testProfile));
        when(() => imagePickerService.pickFromGallery()).thenAnswer(
          (_) async => '/path/photo.png',
        );
        await cubit.doEvent(const PickPhotoEvent());

        const failure = InternetConnectionFailure();
        when(() => uploadPhotoUseCase('/path/photo.png')).thenAnswer(
          (_) async => const Error<ProfileEntity>(failure),
        );

        final events = <CommonUiEvent>[];
        final subscription = cubit.uiEventStream.listen(events.add);

        await cubit.doEvent(
          SaveEditProfileEvent(
            firstName: testProfile.firstName,
            lastName: testProfile.lastName,
          ),
        );
        await pumpEventQueue();

        expect(cubit.state.saveState.errorMessage, failure);
        expect(events, hasLength(2));
        expect(
          events.first,
          isA<ShowFailureMessage>().having((e) => e.failure, 'failure', failure),
        );
        expect(events.last, isA<PopRoute>());

        await subscription.cancel();
      });

      test('executes both text update and photo upload sequentially when both changed', () async {
        await cubit.doEvent(const InitEditProfileEvent(testProfile));
        when(() => imagePickerService.pickFromGallery()).thenAnswer(
          (_) async => '/path/new_avatar.png',
        );
        await cubit.doEvent(const PickPhotoEvent());

        const textUpdatedProfile = ProfileEntity(
          id: 'user-1',
          firstName: 'UpdatedFirst',
          lastName: 'Lovelace',
          email: 'ada@example.com',
          gender: 'female',
          age: 30,
          weight: 60.5,
          height: 170,
          activityLevel: 'active',
          goal: 'fitness',
          photo: '',
        );

        const finalProfile = ProfileEntity(
          id: 'user-1',
          firstName: 'UpdatedFirst',
          lastName: 'Lovelace',
          email: 'ada@example.com',
          gender: 'female',
          age: 30,
          weight: 60.5,
          height: 170,
          activityLevel: 'active',
          goal: 'fitness',
          photo: 'http://cdn.com/new_avatar.png',
        );

        when(() => updateUseCase(any())).thenAnswer(
          (_) async => const Success<ProfileEntity>(textUpdatedProfile),
        );
        when(() => uploadPhotoUseCase('/path/new_avatar.png')).thenAnswer(
          (_) async => const Success<ProfileEntity>(finalProfile),
        );

        final events = <CommonUiEvent>[];
        final subscription = cubit.uiEventStream.listen(events.add);

        await cubit.doEvent(
          const SaveEditProfileEvent(
            firstName: 'UpdatedFirst',
            lastName: 'Lovelace',
          ),
        );
        await pumpEventQueue();

        expect(cubit.state.initialProfile, finalProfile);
        expect(cubit.state.pickedPhotoPath, isNull);
        expect(events, hasLength(2));
        expect(events.first, isA<ShowSuccessMessage>());
        expect(events.last, isA<PopRoute>());

        verify(() => updateUseCase(any())).called(1);
        verify(() => uploadPhotoUseCase('/path/new_avatar.png')).called(1);

        await subscription.cancel();
      });

      test('does not upload photo if text update fails when both changed', () async {
        await cubit.doEvent(const InitEditProfileEvent(testProfile));
        when(() => imagePickerService.pickFromGallery()).thenAnswer(
          (_) async => '/path/new_avatar.png',
        );
        await cubit.doEvent(const PickPhotoEvent());

        const failure = ServerFailure();
        when(() => updateUseCase(any())).thenAnswer(
          (_) async => const Error<ProfileEntity>(failure),
        );

        final events = <CommonUiEvent>[];
        final subscription = cubit.uiEventStream.listen(events.add);

        await cubit.doEvent(
          const SaveEditProfileEvent(
            firstName: 'UpdatedFirst',
            lastName: 'Lovelace',
          ),
        );
        await pumpEventQueue();

        expect(cubit.state.saveState.errorMessage, failure);
        expect(events.first, isA<ShowFailureMessage>());
        verifyNever(() => uploadPhotoUseCase(any()));

        await subscription.cancel();
      });

      group('Save failure behavior and event order', () {
        test('Text update fails: emits ShowFailureMessage then PopRoute, sets errorMessage, photo use case never called', () async {
          await cubit.doEvent(const InitEditProfileEvent(testProfile));
          const failure = ServerFailure();

          when(() => updateUseCase(any())).thenAnswer(
            (_) async => const Error<ProfileEntity>(failure),
          );

          final events = <CommonUiEvent>[];
          final subscription = cubit.uiEventStream.listen(events.add);

          await cubit.doEvent(
            const SaveEditProfileEvent(
              firstName: 'AdaNew',
              lastName: 'Lovelace',
            ),
          );
          await pumpEventQueue();

          expect(cubit.state.saveState.errorMessage, failure);
          expect(events, [
            isA<ShowFailureMessage>().having((e) => e.failure, 'failure', failure),
            isA<PopRoute>(),
          ]);
          verify(() => updateUseCase(any())).called(1);
          verifyZeroInteractions(uploadPhotoUseCase);

          await subscription.cancel();
        });

        test('Photo upload fails (no text changes): emits ShowFailureMessage then PopRoute', () async {
          await cubit.doEvent(const InitEditProfileEvent(testProfile));
          when(() => imagePickerService.pickFromGallery()).thenAnswer(
            (_) async => '/path/photo.png',
          );
          await cubit.doEvent(const PickPhotoEvent());

          const failure = InternetConnectionFailure();
          when(() => uploadPhotoUseCase('/path/photo.png')).thenAnswer(
            (_) async => const Error<ProfileEntity>(failure),
          );

          final events = <CommonUiEvent>[];
          final subscription = cubit.uiEventStream.listen(events.add);

          await cubit.doEvent(
            SaveEditProfileEvent(
              firstName: testProfile.firstName,
              lastName: testProfile.lastName,
            ),
          );
          await pumpEventQueue();

          expect(cubit.state.saveState.errorMessage, failure);
          expect(events, [
            isA<ShowFailureMessage>().having((e) => e.failure, 'failure', failure),
            isA<PopRoute>(),
          ]);
          verify(() => uploadPhotoUseCase('/path/photo.png')).called(1);
          verifyZeroInteractions(updateUseCase);

          await subscription.cancel();
        });

        test('Text update succeeds, then photo upload fails: update called once, final events are ShowFailureMessage then PopRoute', () async {
          await cubit.doEvent(const InitEditProfileEvent(testProfile));
          when(() => imagePickerService.pickFromGallery()).thenAnswer(
            (_) async => '/path/new_avatar.png',
          );
          await cubit.doEvent(const PickPhotoEvent());

          const textUpdatedProfile = ProfileEntity(
            id: 'user-1',
            firstName: 'UpdatedFirst',
            lastName: 'Lovelace',
            email: 'ada@example.com',
            gender: 'female',
            age: 30,
            weight: 60.5,
            height: 170,
            activityLevel: 'active',
            goal: 'fitness',
            photo: '',
          );
          const failure = ServerFailure();

          when(() => updateUseCase(any())).thenAnswer(
            (_) async => const Success<ProfileEntity>(textUpdatedProfile),
          );
          when(() => uploadPhotoUseCase('/path/new_avatar.png')).thenAnswer(
            (_) async => const Error<ProfileEntity>(failure),
          );

          final events = <CommonUiEvent>[];
          final subscription = cubit.uiEventStream.listen(events.add);

          await cubit.doEvent(
            const SaveEditProfileEvent(
              firstName: 'UpdatedFirst',
              lastName: 'Lovelace',
            ),
          );
          await pumpEventQueue();

          expect(cubit.state.saveState.errorMessage, failure);
          expect(events, [
            isA<ShowFailureMessage>().having((e) => e.failure, 'failure', failure),
            isA<PopRoute>(),
          ]);
          verify(() => updateUseCase(any())).called(1);
          verify(() => uploadPhotoUseCase('/path/new_avatar.png')).called(1);

          await subscription.cancel();
        });

        test('After a failure, a second SaveEditProfileEvent is not blocked (isSaving is false again)', () async {
          await cubit.doEvent(const InitEditProfileEvent(testProfile));
          const failure = ServerFailure();

          when(() => updateUseCase(any())).thenAnswer(
            (_) async => const Error<ProfileEntity>(failure),
          );

          // First attempt fails
          await cubit.doEvent(
            const SaveEditProfileEvent(
              firstName: 'Attempt1',
              lastName: 'Lovelace',
            ),
          );
          await pumpEventQueue();

          expect(cubit.state.isSaving, isFalse);

          // Second attempt succeeds
          const updatedProfile = ProfileEntity(
            id: 'user-1',
            firstName: 'Attempt2',
            lastName: 'Lovelace',
            email: 'ada@example.com',
            gender: 'female',
            age: 30,
            weight: 60.5,
            height: 170,
            activityLevel: 'active',
            goal: 'fitness',
            photo: '',
          );
          when(() => updateUseCase(any())).thenAnswer(
            (_) async => const Success<ProfileEntity>(updatedProfile),
          );

          final events = <CommonUiEvent>[];
          final subscription = cubit.uiEventStream.listen(events.add);

          await cubit.doEvent(
            const SaveEditProfileEvent(
              firstName: 'Attempt2',
              lastName: 'Lovelace',
            ),
          );
          await pumpEventQueue();

          expect(cubit.state.isSaving, isFalse);
          expect(cubit.state.initialProfile, updatedProfile);
          expect(events, contains(isA<ShowSuccessMessage>()));
          verify(() => updateUseCase(any())).called(2);

          await subscription.cancel();
        });
      });

      test('handles cubit closure safely during text update', () async {
        await cubit.doEvent(const InitEditProfileEvent(testProfile));

        when(() => updateUseCase(any())).thenAnswer((_) async {
          await cubit.close();
          return const Success<ProfileEntity>(testProfile);
        });

        await cubit.doEvent(
          const SaveEditProfileEvent(
            firstName: 'NewName',
            lastName: 'Lovelace',
          ),
        );

        expect(cubit.isClosed, isTrue);
      });

      test('handles cubit closure safely during photo upload', () async {
        await cubit.doEvent(const InitEditProfileEvent(testProfile));
        when(() => imagePickerService.pickFromGallery()).thenAnswer(
          (_) async => '/path/avatar.png',
        );
        await cubit.doEvent(const PickPhotoEvent());

        when(() => uploadPhotoUseCase('/path/avatar.png')).thenAnswer((_) async {
          await cubit.close();
          return const Success<ProfileEntity>(testProfile);
        });

        await cubit.doEvent(
          SaveEditProfileEvent(
            firstName: testProfile.firstName,
            lastName: testProfile.lastName,
          ),
        );

        expect(cubit.isClosed, isTrue);
      });
    });
  });
}
