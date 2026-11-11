import 'package:fitness_app/config/routing/app_routes.dart';
import 'package:fitness_app/core/constants/app_icons.dart';
import 'package:fitness_app/core/constants/app_strings.dart';
import 'package:fitness_app/core/shared/confirmation_dialog.dart';
import 'package:fitness_app/core/shared/custom_blur_card.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/app/presentation/cubit/locale/app_locale_cubit.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_cubit.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_event.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_state.dart';
import 'package:fitness_app/features/profile/presentation/view/widgets/profile_menu_item.dart';
import 'package:fitness_app/features/profile/presentation/web_view/args/profile_web_view_args.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    void openWebView(String title, String url) {
      Navigator.pushNamed(
        context,
        AppRoutes.webView,
        arguments: ProfileWebViewArgs(title: title, url: url),
      );
    }

    return CustomBlurCard(
      borderRadius: BorderRadius.circular(20.r),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          ProfileMenuItem(
            icon: AppIcons.profile,
            title: l10n.editProfile,
            onTap: () async {
              final cubit = context.read<ProfileCubit>();
              await Navigator.pushNamed(context, AppRoutes.editProfile);
              cubit.onEvent(const LoadProfile());
            },
          ),
          Divider(
            height: 1.h,
            thickness: 1,
            color: AppColors.white.withValues(alpha: 0.08),
          ),
          ProfileMenuItem(
            icon: AppIcons.change,
            title: l10n.changePassword,
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.changePassword),
          ),
          Divider(
            height: 1.h,
            thickness: 1,
            color: AppColors.white.withValues(alpha: 0.08),
          ),
          BlocBuilder<AppLocaleCubit, Locale>(
            builder: (context, locale) {
              final localeL10n = AppLocalizations.of(context)!;
              final localeCubit = context.read<AppLocaleCubit>();

              return ProfileMenuItem(
                icon: AppIcons.language,
                titleWidget: Text.rich(
                  TextSpan(
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(text: '${localeL10n.selectLanguage} ('),
                      TextSpan(
                        text: localeL10n.currentLanguageName,
                        style: const TextStyle(color: AppColors.primary),
                      ),
                      const TextSpan(text: ')'),
                    ],
                  ),
                ),
                trailing: Switch(
                  value: locale.languageCode == 'en',
                  activeTrackColor: AppColors.primary,
                  activeThumbColor: AppColors.white,
                  onChanged: (_) => localeCubit.toggle(),
                ),
                onTap: localeCubit.toggle,
              );
            },
          ),
          Divider(
            height: 1.h,
            thickness: 1,
            color: AppColors.white.withValues(alpha: 0.08),
          ),
          ProfileMenuItem(
            icon: AppIcons.lockSetting,
            title: l10n.security,
            onTap: () => openWebView(l10n.security, AppStrings.securityUrl),
          ),
          Divider(
            height: 1.h,
            thickness: 1,
            color: AppColors.white.withValues(alpha: 0.08),
          ),
          ProfileMenuItem(
            icon: AppIcons.securityWarning,
            title: l10n.privacyPolicy,
            onTap: () =>
                openWebView(l10n.privacyPolicy, AppStrings.privacyPolicyUrl),
          ),
          Divider(
            height: 1.h,
            thickness: 1,
            color: AppColors.white.withValues(alpha: 0.08),
          ),
          ProfileMenuItem(
            icon: AppIcons.help,
            title: l10n.help,
            onTap: () => openWebView(l10n.help, AppStrings.helpUrl),
          ),
          Divider(
            height: 1.h,
            thickness: 1,
            color: AppColors.white.withValues(alpha: 0.08),
          ),
          BlocSelector<ProfileCubit, ProfileState, bool>(
            selector: (state) => state.isLoggingOut,
            builder: (context, isLoggingOut) {
              final cubit = context.read<ProfileCubit>();

              return ProfileMenuItem(
                icon: AppIcons.logout,
                title: l10n.logout,
                titleColor: AppColors.primary,
                trailing: isLoggingOut
                    ? SizedBox(
                        width: 18.r,
                        height: 18.r,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      )
                    : null,
                onTap: isLoggingOut
                    ? null
                    : () async {
                        final confirmed = await showConfirmationDialog(
                          context,
                          message: l10n.logoutConfirm,
                        );
                        if (confirmed) {
                          cubit.onEvent(const LogoutRequested());
                        }
                      },
              );
            },
          ),
        ],
      ),
    );
  }
}
