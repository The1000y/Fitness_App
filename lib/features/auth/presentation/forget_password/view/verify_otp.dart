import 'dart:developer';

import 'package:fitness_app/config/localization/validation_error_message_mapper.dart';
import 'package:fitness_app/config/utils/auth_validators.dart';
import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:fitness_app/core/shared/custom_blur_card.dart';
import 'package:fitness_app/core/shared/custom_button.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/view/widgets/helper.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({super.key});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  TextEditingController otpController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

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
                    Text(l10n.otpCode, style: theme.textTheme.headlineLarge),
                    Gap(2.h),
                    Text(
                      l10n.enterYourOtp,
                      style: theme.textTheme.headlineSmall,
                    ),
                    Gap(24.h),
                    CustomBlurCard(
                      child: Column(
                        children: [
                          Pinput(
                            controller: otpController,
                            errorTextStyle: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.accent,
                            ),
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            keyboardType: TextInputType.number,
                            length: 4,
                            animationCurve: Curves.bounceInOut,
                            animationDuration: const Duration(
                              milliseconds: 300,
                            ),
                            showCursor: true,
                            cursor: Align(
                              alignment: Alignment.center,
                              child: Container(
                                margin: EdgeInsets.all(14),
                                width: 1,
                                height: 50,
                                color: AppColors.primary,
                              ),
                            ),
                            defaultPinTheme: Helper.defultPinTheme,
                            focusedPinTheme: Helper.focusPinTheme,
                            submittedPinTheme: Helper.submittedPinTheme,
                            validator: (value) {
                              var error = AppValidators.otpRequired(value);
                              if (error != null) {
                                var message = AppValidators.otpRequired(value);
                                if (message != null) {
                                  return mapValidationErrorToMessage(
                                    error,
                                    l10n,
                                  );
                                }
                              }
                              return null;
                            },
                            pinputAutovalidateMode:
                                PinputAutovalidateMode.onSubmit,
                          ),
                          Gap(24.h),
                          CustomButton(
                            isLoading: isLoading, // ربط اللودينج بالمتغير
                            label: l10n.confirm,
                            height: 38.h,
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                log("otp: ${otpController.text}");
                                await Future.delayed(Duration(seconds: 2));
                                if (mounted) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                            },
                          ),
                          Gap(8),
                          Text(
                            l10n.didntReceiveCode,
                            style: theme.textTheme.bodyMedium,
                          ),
                          Gap(4),
                          InkWell(
                            onTap: () {},
                            child: Text(
                              l10n.resendCode,
                              style: theme.textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.w900,
                                color: AppColors.primary,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.primary,
                              ),
                            ),
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
