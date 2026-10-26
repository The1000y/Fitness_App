import 'package:fitness_app/config/localization/validation_error_message_mapper.dart';
import 'package:fitness_app/config/routing/app_routes.dart';
import 'package:fitness_app/config/utils/auth_validators.dart';
import 'package:fitness_app/core/constants/app_icons.dart';
import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/custom_blur_card.dart';
import 'package:fitness_app/core/shared/custom_button.dart';
import 'package:fitness_app/core/shared/custom_text_form_field.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_cubit.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_event.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_state.dart';
import 'package:fitness_app/features/auth/presentation/register/view/social_login_row.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class RegisterFormPage extends StatefulWidget {
  const RegisterFormPage({super.key});

  @override
  State<RegisterFormPage> createState() => _RegisterFormPageState();
}

class _RegisterFormPageState extends State<RegisterFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    super.initState();
    // The cubit state is the source of truth, so the user's data survives
    // going back to this page from the steps.
    final form = context.read<RegisterCubit>().state.form;
    _firstName = TextEditingController(text: form.firstName);
    _lastName = TextEditingController(text: form.lastName);
    _email = TextEditingController(text: form.email);
    _password = TextEditingController(text: form.password);
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    context.read<RegisterCubit>().doEvent(
      SubmitEvent(
        firstName: _firstName.text,
        lastName: _lastName.text,
        email: _email.text,
        password: _password.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      children: [
        // Logo stays fixed at the top.
        Gap(16.h),
        SvgPicture.asset(AppImages.logo, height: 56.h),
        // If the SVG still doesn't render (unsupported <filter>), export the
        // logo as PNG and use: Image.asset(AppImages.logoPng, height: 56.h),

        // Title + card are centered in the remaining space.
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.registerTitle1,
                          style: theme.textTheme.titleMedium,
                        ),
                        Text(
                          l10n.registerTitle2.toUpperCase(),
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: 18.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(12.h),
                  CustomBlurCard(
                    sigma: 16,
                    showWhiteBorders: true,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.register,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontSize: 20.sp,
                            ),
                          ),
                          Gap(12.h),
                          CustomTextFormField(
                            controller: _firstName,
                            hintText: l10n.firstName,
                            prefixIcon: AppIcons.profile,
                            textInputAction: TextInputAction.next,
                            validator: (v) => mapValidationErrorToMessage(
                              AppValidators.firstName(v),
                              l10n,
                            ),
                          ),
                          Gap(8.h),
                          CustomTextFormField(
                            controller: _lastName,
                            hintText: l10n.lastName,
                            prefixIcon: AppIcons.profile,
                            textInputAction: TextInputAction.next,
                            validator: (v) => mapValidationErrorToMessage(
                              AppValidators.lastName(v),
                              l10n,
                            ),
                          ),
                          Gap(8.h),
                          CustomTextFormField(
                            controller: _email,
                            hintText: l10n.email,
                            prefixIcon: AppIcons.mail,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: (v) => mapValidationErrorToMessage(
                              AppValidators.email(v),
                              l10n,
                            ),
                          ),
                          Gap(8.h),
                          CustomTextFormField(
                            controller: _password,
                            hintText: l10n.password,
                            prefixIcon: AppIcons.lock,
                            isPassword: true,
                            textInputAction: TextInputAction.done,
                            validator: (v) => mapValidationErrorToMessage(
                              AppValidators.strongPassword(v),
                              l10n,
                            ),
                          ),
                          Gap(12.h),
                          const SocialLoginRow(),
                          Gap(12.h),
                          CustomButton(
                            label: l10n.register,
                            height: 46.h,
                            onPressed: _submit,
                          ),
                          Gap(8.h),
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 4.w,
                            children: [
                              Text(
                                l10n.alreadyHaveAccount,
                                style: theme.textTheme.titleSmall,
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(
                                  context,
                                ).pushReplacementNamed(AppRoutes.login),
                                child: Text(
                                  l10n.login,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: AppColors.primary,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
