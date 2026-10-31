import 'package:fitness_app/config/localization/validation_error_message_mapper.dart';
import 'package:fitness_app/config/utils/auth_validators.dart';
import 'package:fitness_app/core/constants/app_icons.dart';
import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:fitness_app/core/shared/custom_blur_card.dart';
import 'package:fitness_app/core/shared/custom_button.dart';
import 'package:fitness_app/core/shared/custom_text_form_field.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/manager/forget_password_cubit.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/manager/forget_password_event.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/manager/forget_password_state.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'package:gap/gap.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var l10n = AppLocalizations.of(context)!;
    var cubit = context.read<ForgetPasswordCubit>();
    return CustomBackgroundImage(
      backgroundImage: AppImages.authBackground,
      fit: BoxFit.cover,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        AppImages.logo,
                        fit: BoxFit.contain,
                        width: 70.w,
                        height: 48.w,
                      ),
                    ),
                    Gap(96.h),
                    Text(
                      l10n.passwordLengthHint,
    
                      style: theme.textTheme.headlineSmall,
                    ),
                    Gap(2.h),
                    Text(
                      l10n.createNewPassword,
                      style: theme.textTheme.headlineLarge,
                    ),
                    Gap(24.h),
                    CustomBlurCard(
                      child: Column(
                        children: [
                          CustomTextFormField(
                            validator: (value) {
                              var error = AppValidators.password(value);
                              return mapValidationErrorToMessage(error, l10n);
                            },
                            textInputAction: TextInputAction.done,
                            controller: passwordController,
                            hintText: l10n.password,
                            isPassword: isObscured,
                            prefixIcon: AppIcons.lock,
                            prefixIconConstraints: BoxConstraints(
                              minWidth: 48.w,
                              minHeight: 24.h,
                            ),
                          ),
                          Gap(24),
                          CustomTextFormField(
                            validator: (value) {
                              var error = AppValidators.confirmPassword(
                                value,
                                passwordController.text,
                              );
                              return mapValidationErrorToMessage(error, l10n);
                            },
                            textInputAction: TextInputAction.next,
                            controller: confirmPasswordController,
                            hintText: l10n.password,
                            isPassword: isObscured,
                            prefixIcon: AppIcons.lock,
                            prefixIconConstraints: BoxConstraints(
                              minWidth: 48.w,
                              minHeight: 24.h,
                            ),
                          ),
                          Gap(24.h),
                          BlocSelector<
                            ForgetPasswordCubit,
                            ForgetPasswordState,
                            bool
                          >(
                            selector: (state) {
                              return state.resetPasswordState.isLoading;
                            },
                            builder: (context, state) {
                              return CustomButton(
                                isLoading: state, // ربط اللودينج بالمتغير
                                label: l10n.confirm,
                                height: 38.h,
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    await cubit.doEvent(
                                      ResetPasswordEvent(
                                        passwordController.text,
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
