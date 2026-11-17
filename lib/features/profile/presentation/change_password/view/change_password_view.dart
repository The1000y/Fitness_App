import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/base_ui_event_listener.dart';
import 'package:fitness_app/core/shared/custom_app_bar.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:fitness_app/features/profile/presentation/change_password/manager/change_password_cubit.dart';
import 'package:fitness_app/features/profile/presentation/change_password/manager/change_password_state.dart';
import 'package:fitness_app/features/profile/presentation/change_password/view/widgets/change_password_form.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

/// Change-password screen. Expects a [ChangePasswordCubit] to be provided by
/// an ancestor `BlocProvider`.
class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BaseUiEventListener<
      ChangePasswordCubit,
      ChangePasswordState,
      BaseUiEvent
    >(
      child: CustomBackgroundImage(
        backgroundImage: AppImages.authBackground,
        fit: BoxFit.cover,
        child: Scaffold(
          appBar: const CustomAppBar(),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsetsDirectional.all(16.r),
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
                  Gap(48.h),
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
                  const ChangePasswordForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
