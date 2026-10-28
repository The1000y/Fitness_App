import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/config/localization/validation_error_message_mapper.dart';
import 'package:fitness_app/config/routing/app_routes.dart';
import 'package:fitness_app/config/utils/auth_validators.dart';
import 'package:fitness_app/core/constants/app_icons.dart';
import 'package:fitness_app/core/constants/app_strings.dart';
import 'package:fitness_app/core/shared/base_ui_event_listener.dart';
import 'package:fitness_app/core/shared/custom_button.dart';
import 'package:fitness_app/core/shared/custom_text_form_field.dart';
import 'package:fitness_app/features/auth/presentation/login/manager/login_cubit.dart';
import 'package:fitness_app/features/auth/presentation/login/manager/login_event.dart';
import 'package:fitness_app/features/auth/presentation/login/manager/login_state.dart';
import 'package:fitness_app/features/auth/presentation/login/view/widgets/auth_card.dart';
import 'package:fitness_app/features/auth/presentation/login/view/widgets/auth_footer_link.dart';
import 'package:fitness_app/features/auth/presentation/login/view/widgets/auth_link_text.dart';
import 'package:fitness_app/features/auth/presentation/login/view/widgets/auth_or_divider.dart';
import 'package:fitness_app/features/auth/presentation/login/view/widgets/auth_scaffold.dart';
import 'package:fitness_app/features/auth/presentation/login/view/widgets/social_login_buttons.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    context.read<LoginCubit>().onEvent(
      LoginSubmitted(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => getIt<LoginCubit>(),
      child: BaseUiEventListener<LoginCubit, LoginState, CommonUiEvent>(
        child: AuthScaffold(
          subtitle: AppStrings.loginTitleOne,
          title: AppStrings.loginTitleTwo,
          child: AuthCard(
            title: AppStrings.login,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextFormField(
                    controller: _emailController,
                    hintText: AppStrings.email,
                    prefixIcon: AppIcons.mail,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) => mapValidationErrorToMessage(
                      AppValidators.email(value),
                      l10n,
                    ),
                  ),

                  Gap(16.h),

                  CustomTextFormField(
                    controller: _passwordController,
                    hintText: AppStrings.password,
                    prefixIcon: AppIcons.lock,
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                    validator: (value) => mapValidationErrorToMessage(
                      AppValidators.password(value),
                      l10n,
                    ),
                  ),

                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: AuthLinkText(
                      label: AppStrings.forgotPassword,
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.forgotPassword,
                      ),
                    ),
                  ),

                  Gap(8.h),
                  const AuthOrDivider(),
                  Gap(16.h),

                  // Social login is not implemented yet (buttons disabled).
                  const SocialLoginButtons(),

                  Gap(24.h),

                  BlocSelector<LoginCubit, LoginState, bool>(
                    selector: (state) => state.loginState.isLoading,
                    builder: (context, isLoading) {
                      return CustomButton(
                        label: AppStrings.login,
                        variant: ButtonVariant.filled,
                        isLoading: isLoading,
                        onPressed: () => _submit(context),
                      );
                    },
                  ),

                  Gap(8.h),

                  AuthFooterLink(
                    text: AppStrings.dontHaveAccount,
                    linkLabel: AppStrings.register,
                    onPressed: () => Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.register,
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
