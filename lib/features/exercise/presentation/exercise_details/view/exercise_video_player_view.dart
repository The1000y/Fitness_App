import 'package:fitness_app/core/extensions/youtube_url_extension.dart';
import 'package:fitness_app/core/shared/custom_video_player.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

class ExerciseVideoPlayerView extends StatelessWidget {
  const ExerciseVideoPlayerView({super.key, required this.exercise});

  final ExerciseEntity exercise;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final inDepthUrl = exercise.inDepthYoutubeExplanationLink;
    final shortDemoUrl = exercise.shortYoutubeDemonstrationLink;
    final videoUrl = inDepthUrl != null && inDepthUrl.isNotEmpty
        ? inDepthUrl
        : shortDemoUrl;
    final hasShortDemo = shortDemoUrl.isNotEmpty && shortDemoUrl != videoUrl;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.white,
          ),
        ),
        title: Text(
          exercise.exercise,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomVideoPlayer(
              videoUrl: videoUrl,
              thumbnailImage: shortDemoUrl.youtubeThumbnail,
              aspectRatio: 16 / 9,
            ),
            Gap(20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.exercise,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Gap(12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      _InfoChip(
                        icon: Icons.fitness_center,
                        label: exercise.primaryEquipment,
                      ),
                      _InfoChip(
                        icon: Icons.speed,
                        label: exercise.difficultyLevel,
                      ),
                      _InfoChip(
                        icon: Icons.category_outlined,
                        label: exercise.mechanics,
                      ),
                    ],
                  ),
                  Gap(20.h),
                  _SectionTitle(title: l10n.targetMuscles),
                  Gap(8.h),
                  _DetailRow(
                    label: l10n.primeMover,
                    value: exercise.primeMoverMuscle,
                  ),
                  if (exercise.secondaryMuscle != null)
                    _DetailRow(
                      label: l10n.secondaryMuscle,
                      value: exercise.secondaryMuscle!,
                    ),
                  if (exercise.tertiaryMuscle != null)
                    _DetailRow(
                      label: l10n.tertiaryMuscle,
                      value: exercise.tertiaryMuscle!,
                    ),
                  Gap(16.h),
                  _SectionTitle(title: l10n.exerciseDetailsTitle),
                  Gap(8.h),
                  _DetailRow(
                    label: l10n.bodyRegion,
                    value: exercise.bodyRegion,
                  ),
                  _DetailRow(
                    label: l10n.targetGroup,
                    value: exercise.targetMuscleGroup,
                  ),
                  Gap(24.h),
                  if (hasShortDemo) ...[
                    _SectionTitle(title: l10n.shortDemo),
                    Gap(8.h),
                    CustomVideoPlayer(
                      videoUrl: shortDemoUrl,
                      thumbnailImage: shortDemoUrl.youtubeThumbnail,
                      aspectRatio: 16 / 9,
                    ),
                    Gap(24.h),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.neutral.shade600,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 16.r),
          Gap(6.w),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.primary,
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
