import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../../../../config/base/base_ui_event.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_images.dart';
import '../../../../../core/shared/base_ui_event_listener.dart';
import '../../../../../core/shared/custom_background_image.dart';
import '../../../../../core/theme/app_colors/app_colors.dart';
import '../../../../../l10n/app_localizations.dart';
import '../manager/edit_profile_cubit.dart';
import '../manager/edit_profile_event.dart';
import '../manager/edit_profile_state.dart';
import 'edit_profile_fields_widget.dart';
import 'edit_profile_form_widget.dart';
import 'edit_profile_header_widget.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _email;

  @override
  void initState() {
    super.initState();
    final profile = context.read<EditProfileCubit>().state.initialProfile;
    _firstName = TextEditingController(text: profile?.firstName ?? '');
    _lastName = TextEditingController(text: profile?.lastName ?? '');
    _email = TextEditingController(text: profile?.email ?? '');
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    super.dispose();
  }

  void _saveAndExit() {
    FocusScope.of(context).unfocus();
    context.read<EditProfileCubit>().doEvent(
      SaveEditProfileEvent(
        firstName: _firstName.text,
        lastName: _lastName.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _saveAndExit();
      },
      child: BaseUiEventListener<
        EditProfileCubit,
        EditProfileState,
        CommonUiEvent
      >(
        child: CustomBackgroundImage(
          backgroundImage: AppImages.layoutBackground,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsetsDirectional.fromSTEB(
                  16.w,
                  16.h,
                  16.w,
                  120.h,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: _BackButton(onTap: _saveAndExit),
                          ),
                          Text(
                            l10n.editProfile,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(24.h),
                    const EditProfileHeaderWidget(),
                    Gap(24.h),
                    EditProfileFormWidget(
                      firstName: _firstName,
                      lastName: _lastName,
                      email: _email,
                    ),
                    Gap(24.h),
                    const EditProfileFieldsWidget(),
                    Gap(24.h),
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

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        shape: const CircleBorder(),
        padding: EdgeInsets.zero,
      ),
      icon: SvgPicture.asset(
        AppIcons.arrowBack,
        height: 14.r,
        width: 14.r,
        colorFilter: const ColorFilter.mode(
          AppColors.textPrimary,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
