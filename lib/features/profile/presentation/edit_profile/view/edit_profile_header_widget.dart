import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/manager/edit_profile_cubit.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/manager/edit_profile_event.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/manager/edit_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

class EditProfileHeaderWidget extends StatelessWidget {
  const EditProfileHeaderWidget({super.key});

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

  Widget _buildAvatarImage({
    required String? pickedPath,
    required String? remotePhotoUrl,
  }) {
    if (pickedPath != null && pickedPath.isNotEmpty) {
      return Image.file(
        File(pickedPath),
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _avatarFallback(),
      );
    }

    if (remotePhotoUrl != null && remotePhotoUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: remotePhotoUrl,
        fit: BoxFit.cover,
        placeholder: (_, _) => _avatarFallback(),
        errorWidget: (_, _, _) => _avatarFallback(),
      );
    }

    return _avatarFallback();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      buildWhen: (previous, current) =>
          previous.initialProfile != current.initialProfile ||
          previous.pickedPhotoPath != current.pickedPhotoPath,
      builder: (context, state) {
        final profile = state.initialProfile;
        final photo = profile?.photo;

        return Column(
          children: [
            Stack(
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
                    child: _buildAvatarImage(
                      pickedPath: state.pickedPhotoPath,
                      remotePhotoUrl: photo,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      context
                          .read<EditProfileCubit>()
                          .doEvent(const PickPhotoEvent());
                    },
                    child: Container(
                      width: 32.r,
                      height: 32.r,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.neutral.shade800,
                          width: 2.r,
                        ),
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 16.r,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Gap(12.h),
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
