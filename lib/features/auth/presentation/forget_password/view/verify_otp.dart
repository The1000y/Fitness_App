import 'package:fitness_app/config/localization/validation_error_message_mapper.dart';
import 'package:fitness_app/config/utils/auth_validators.dart';
import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:fitness_app/core/shared/custom_blur_card.dart';
import 'package:fitness_app/core/shared/custom_button.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/manager/forget_password_cubit.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/manager/forget_password_event.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/manager/forget_password_state.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/view/widgets/helper.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({super.key});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  late TextEditingController otpController;
  late GlobalKey<FormState> formKey;
  @override
  void initState() {
    otpController = TextEditingController();
    formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  String _formatDuration(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<ForgetPasswordCubit>();

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
                          BlocSelector<
                            ForgetPasswordCubit,
                            ForgetPasswordState,
                            bool
                          >(
                            selector: (state) {
                              return state.isTimerExpired;
                            },
                            builder: (context, state) {
                              return Pinput(
                                    controller: otpController,
                                    errorTextStyle: theme.textTheme.bodySmall
                                        ?.copyWith(color: AppColors.accent),
                                    onTapOutside: (event) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
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
                                        margin: const EdgeInsets.all(14),
                                        width: 1,
                                        height: 50,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    defaultPinTheme: Helper.defultPinTheme,
                                    focusedPinTheme: Helper.defultPinTheme,
                                    submittedPinTheme: Helper.submittedPinTheme,
                                    errorPinTheme: Helper.submittedPinTheme,
                                    forceErrorState: state,
                                    validator: (value) {
                                      final error = AppValidators.otpRequired(
                                        value,
                                      );
                                      if (error != null) {
                                        return mapValidationErrorToMessage(
                                          error,
                                          l10n,
                                        );
                                      }
                                      return null;
                                    },
                                    pinputAutovalidateMode:
                                        PinputAutovalidateMode.onSubmit,
                                  )
                                  .animate(target: state ? 1 : 0)
                                  .shake(
                                    duration: 400.ms,
                                    offset: const Offset(0.001, 2),
                                    curve: Curves.linear,
                                    //  hz: 0.2,
                                  );
                            },
                          ),

                          Gap(24.h),
                          BlocSelector<
                            ForgetPasswordCubit,
                            ForgetPasswordState,
                            bool
                          >(
                            selector: (state) {
                              return state.verifyOtpState.isLoading;
                            },
                            builder: (context, state) {
                              return CustomButton(
                                isLoading: state,
                                label: l10n.confirm,
                                height: 38.h,
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    await cubit.doEvent(
                                      VerifyOtpEvent(otpController.text),
                                    );
                                    otpController.clear();
                                  }
                                },
                              );
                            },
                          ),

                          Gap(16.h),

                          Text(
                            l10n.didntReceiveCode,
                            style: theme.textTheme.bodyMedium,
                          ),
                          Gap(6.h),
                          BlocSelector<
                            ForgetPasswordCubit,
                            ForgetPasswordState,
                            bool
                          >(
                            selector: (state) {
                              return state.canResend;
                            },
                            builder: (context, state) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: state
                                        ? () {
                                            cubit.doEvent(ResendCodeEvent());
                                          }
                                        : null,
                                    child: Text(
                                      l10n.resendCode,
                                      style: theme.textTheme.bodyLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.w900,
                                            color: state
                                                ? AppColors.primary
                                                : Colors.grey,
                                            decoration: state
                                                ? TextDecoration.underline
                                                : TextDecoration.none,
                                            decorationColor: AppColors.primary,
                                          ),
                                    ),
                                  ),
                                  if (!state) ...[
                                    Gap(8.w),
                                    BlocSelector<
                                      ForgetPasswordCubit,
                                      ForgetPasswordState,
                                      int
                                    >(
                                      selector: (state) => state.timerCount,
                                      builder: (context, timerCount) {
                                        return Text(
                                          _formatDuration(timerCount),
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        );
                                      },
                                    ),
                                  ],
                                ],
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
