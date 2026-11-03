import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ExerciseListItem extends StatelessWidget {
  const ExerciseListItem({
    super.key,
    required this.exercise,
    required this.onTap,
  });

  final ExerciseEntity exercise;
  final VoidCallback onTap;

  String get _thumbnailUrl {
    final url = exercise.shortYoutubeDemonstrationLink;
    if (url.isEmpty) return '';
    final id = YoutubePlayerController.convertUrlToId(url.trim());
    if (id == null) return '';
    return YoutubePlayerController.getThumbnail(videoId: id);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: AppColors.neutral.shade600,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            _ExerciseThumbnail(thumbnailUrl: _thumbnailUrl),
            Gap(12.w),
            _ExerciseInfo(exercise: exercise),
            Gap(8.w),
            const _PlayButton(),
          ],
        ),
      ),
    );
  }
}

class _ExerciseThumbnail extends StatelessWidget {
  const _ExerciseThumbnail({required this.thumbnailUrl});

  final String thumbnailUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: SizedBox(
        width: 64.w,
        height: 64.w,
        child: thumbnailUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: thumbnailUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const ColoredBox(color: AppColors.surfaceMuted),
                errorWidget: (context, url, error) =>
                    const _ThumbnailPlaceholder(),
              )
            : const _ThumbnailPlaceholder(),
      ),
    );
  }
}

class _ThumbnailPlaceholder extends StatelessWidget {
  const _ThumbnailPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.surfaceMuted,
      child: Center(
        child: Icon(
          Icons.fitness_center,
          color: AppColors.textSecondary,
          size: 24,
        ),
      ),
    );
  }
}

class _ExerciseInfo extends StatelessWidget {
  const _ExerciseInfo({required this.exercise});

  final ExerciseEntity exercise;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exercise.exercise,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(4.h),
          Text(
            exercise.primaryEquipment,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12.sp,
            ),
          ),
          Gap(2.h),
          Text(
            '${exercise.difficultyLevel} • ${exercise.mechanics}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.r,
      height: 36.r,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.play_arrow_rounded,
        color: AppColors.white,
        size: 22.r,
      ),
    );
  }
}
