import 'package:fitness_app/config/base/base_cubit.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/config/localization/success_message_enum_mapper.dart';
import 'package:fitness_app/core/services/image_picker_service.dart';
import 'package:fitness_app/features/profile/domain/entities/params/update_profile_param.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_app/features/profile/domain/use_cases/profile_update_use_case.dart';
import 'package:fitness_app/features/profile/domain/use_cases/profile_upload_photo_use_case.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/manager/edit_profile_event.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/manager/edit_profile_state.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/errors/app_failure.dart';

@injectable
class EditProfileCubit extends BaseCubit<EditProfileState, CommonUiEvent> {
  final ProfileUpdateUseCase _updateUseCase;
  final ProfileUploadPhotoUseCase _uploadPhotoUseCase;
  final ImagePickerService _imagePickerService;

  EditProfileCubit(
    this._updateUseCase,
    this._uploadPhotoUseCase,
    this._imagePickerService,
  ) : super(const EditProfileState());

  Future<void> doEvent(EditProfileEvent event) async {
    switch (event) {
      case InitEditProfileEvent():
        emit(
          EditProfileState(
            initialProfile: event.profile,
            weight: event.profile.weight.toDouble(),
            goal: event.profile.goal,
            activityLevel: event.profile.activityLevel,
          ),
        );
      case EditWeightChangedEvent():
        emit(state.copyWith(weight: event.weight));
      case GoalChangedEvent():
        emit(state.copyWith(goal: event.goal));
      case ActivityLevelChangedEvent():
        emit(state.copyWith(activityLevel: event.activityLevel));
      case PickPhotoEvent():
        await _pickPhoto();
      case SaveEditProfileEvent():
        await _save(event);
    }
  }

  Future<void> _pickPhoto() async {
    final path = await _imagePickerService.pickFromGallery();
    if (isClosed || path == null) return;
    emit(state.copyWith(pickedPhotoPath: path));
  }

  Future<void> _save(SaveEditProfileEvent event) async {
    final initial = state.initialProfile;
    if (state.isSaving || initial == null) return;

    final firstName = event.firstName.trim();
    final lastName = event.lastName.trim();

    final param = UpdateProfileParam(
      firstName: firstName != initial.firstName ? firstName : null,
      lastName: lastName != initial.lastName ? lastName : null,
      weight: state.weight != initial.weight.toDouble() ? state.weight : null,
      goal: state.goal != initial.goal ? state.goal : null,
      activityLevel: state.activityLevel != initial.activityLevel
          ? state.activityLevel
          : null,
    );
    final hasTextChanges = param != const UpdateProfileParam();
    final photoPath = state.pickedPhotoPath;

    if (!hasTextChanges && photoPath == null) {
      emitEvent(const PopRoute());
      return;
    }

    emit(
      state.copyWith(
        saveState: const BaseState<ProfileEntity>(isLoading: true),
      ),
    );

    ProfileEntity? saved;

    if (hasTextChanges) {
      final result = await _updateUseCase(param);
      if (isClosed) return;
      switch (result) {
        case Success<ProfileEntity>():
          saved = result.data;
        case Error<ProfileEntity>():
          _fail(result.failure);
          return;
      }
    }

    if (photoPath != null) {
      final result = await _uploadPhotoUseCase(photoPath);
      if (isClosed) return;
      switch (result) {
        case Success<ProfileEntity>():
          saved = result.data;
        case Error<ProfileEntity>():
          _fail(result.failure);
          return;
      }
    }

    emit(
      state.copyWith(
        initialProfile: saved,
        pickedPhotoPath: null,
        saveState: BaseState<ProfileEntity>(data: saved),
      ),
    );
    emitEvent(const ShowSuccessMessage(AppSuccessMessage.profileUpdated));
    emitEvent(const PopRoute());
  }

  void _fail(AppFailure failure) {
    emit(
      state.copyWith(
        saveState: BaseState<ProfileEntity>(errorMessage: failure),
      ),
    );
    emitEvent(ShowFailureMessage(failure));
    emitEvent(const PopRoute());
  }
}
