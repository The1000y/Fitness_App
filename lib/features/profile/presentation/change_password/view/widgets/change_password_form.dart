import 'package:fitness_app/config/localization/validation_error_message_mapper.dart';
import 'package:fitness_app/config/utils/auth_validators.dart';
import 'package:fitness_app/core/constants/app_icons.dart';
import 'package:fitness_app/core/shared/custom_blur_card.dart';
import 'package:fitness_app/core/shared/custom_button.dart';
import 'package:fitness_app/core/shared/custom_text_form_field.dart';
import 'package:fitness_app/features/profile/presentation/change_password/manager/change_password_cubit.dart';
import 'package:fitness_app/features/profile/presentation/change_password/manager/change_password_event.dart';
import 'package:fitness_app/features/profile/presentation/change_password/manager/change_password_state.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ChangePasswordCubit>().doEvent(
      SubmitChangePasswordEvent(
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final prefixConstraints = BoxConstraints(minWidth: 48.w, minHeight: 24.h);

    return Form(
      key: _formKey,
      child: CustomBlurCard(
        child: Column(
          children: [
            CustomTextFormField(
              controller: _oldPasswordController,
              hintText: l10n.oldPassword,
              isPassword: true,
              prefixIcon: AppIcons.lock,
              prefixIconConstraints: prefixConstraints,
              textInputAction: TextInputAction.next,
              validator: (value) => mapValidationErrorToMessage(
                AppValidators.password(value),
                l10n,
              ),
            ),
            Gap(24.h),
            CustomTextFormField(
              controller: _newPasswordController,
              hintText: l10n.newPassword,
              isPassword: true,
              prefixIcon: AppIcons.lock,
              prefixIconConstraints: prefixConstraints,
              textInputAction: TextInputAction.next,
              validator: (value) => mapValidationErrorToMessage(
                AppValidators.newPassword(value, _oldPasswordController.text),
                l10n,
              ),
            ),
            Gap(24.h),
            CustomTextFormField(
              controller: _confirmPasswordController,
              hintText: l10n.confirmPassword,
              isPassword: true,
              prefixIcon: AppIcons.lock,
              prefixIconConstraints: prefixConstraints,
              textInputAction: TextInputAction.done,
              validator: (value) => mapValidationErrorToMessage(
                AppValidators.confirmPassword(
                  value,
                  _newPasswordController.text,
                ),
                l10n,
              ),
            ),
            Gap(24.h),
            BlocSelector<ChangePasswordCubit, ChangePasswordState, bool>(
              selector: (state) => state.isLoading,
              builder: (context, isLoading) => CustomButton(
                label: l10n.done,
                height: 38.h,
                isLoading: isLoading,
                onPressed: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
