import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/base_ui_event_listener.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_cubit.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_state.dart';
import 'package:fitness_app/features/profile/presentation/view/widgets/profile_header_widget.dart';
import 'package:fitness_app/features/profile/presentation/view/widgets/profile_menu_section.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BaseUiEventListener<ProfileCubit, ProfileState, CommonUiEvent>(
      child: CustomBackgroundImage(
        backgroundImage: AppImages.layoutBackground,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsetsDirectional.fromSTEB(16.w, 16.h, 16.w, 120.h),
              child: Column(
                children: [
                  Text(
                    l10n.profile,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Gap(24.h),
                  const ProfileHeaderWidget(),
                  Gap(24.h),
                  const ProfileMenuSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
