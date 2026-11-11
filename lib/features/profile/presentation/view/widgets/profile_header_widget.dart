import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_cubit.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_event.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_state.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

class ProfileHeaderWidget extends StatelessWidget {
  const ProfileHeaderWidget({super.key});

  Widget _avatarFallback() {
    return ColoredBox(
      color: AppColors.surface,
      child: Center(
        child: Icon(
          Icons.person,
          size: 52.r,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) =>
          previous.profileState != current.profileState,
      builder: (context, state) {
        final profileState = state.profileState;
        final profile = profileState.data;
        final photo = profile?.photo ?? '';

        return Column(
          children: [
            Container(
              width: 104.r,
              height: 104.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary,
                  width: 3.r,
                ),
              ),
              child: ClipOval(
                child: photo.isEmpty
                    ? _avatarFallback()
                    : CachedNetworkImage(
                        imageUrl: photo,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => _avatarFallback(),
                        errorWidget: (_, _, _) => _avatarFallback(),
                      ),
              ),
            ),
            Gap(12.h),
            if (profileState.isLoading)
              SizedBox(
                width: 18.r,
                height: 18.r,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              )
            else if (profileState.errorMessage != null)
              TextButton(
                onPressed: () =>
                    context.read<ProfileCubit>().onEvent(const LoadProfile()),
                child: Text(l10n.retry),
              )
            else
              Text(
                profile?.fullName ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        );
      },
    );
  }
}
