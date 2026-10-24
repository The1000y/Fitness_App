import 'dart:developer';

import 'package:fitness_app/config/localization/validation_error_message_mapper.dart';
import 'package:fitness_app/config/utils/auth_validators.dart';
import 'package:fitness_app/core/constants/app_icons.dart';
import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:fitness_app/core/shared/custom_blur_card.dart';
import 'package:fitness_app/core/shared/custom_button.dart';
import 'package:fitness_app/core/shared/custom_text_form_field.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var l10n = AppLocalizations.of(context)!;

    return CustomBackgroundImage(
      backgroundImage: AppImages.authBackground,
      fit: BoxFit.cover,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                    l10n.enterYourEmail,
                     style: theme.textTheme.headlineLarge,
                  
                  ),
                  Gap(2.h),
                  Text(
                    l10n.forgotPassword,
                      style: theme.textTheme.headlineSmall,
                  ),
                  Gap(24.h),
                  CustomBlurCard(
                    child: Column(
                      children: [
                        CustomTextFormField(
                          prefixIcon: AppIcons.mail,
                          prefixIconConstraints: BoxConstraints(
                            minWidth: 48.w,
                            minHeight: 24.h,
                          ),
                          controller: emailController,
                          validator: (value) {
                            var error = AppValidators.email(value);
                            if (error != null) {
                              return mapValidationErrorToMessage(error, l10n);
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          hintText: l10n.email,
                        ),
                        Gap(24.h),
                        CustomButton(
                          isLoading: isLoading, // ربط اللودينج بالمتغير
                          label: l10n.sendOtp,
                          height: 38.h,
                          onPressed: isLoading ? null : () async {
                            if (formKey.currentState!.validate()) {
                              log(emailController.text);
                              setState(() {
                                isLoading = true;
                              });
                              await Future.delayed(const Duration(seconds: 2));
                              if (mounted) {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
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
    );
  }
}
