import 'package:fitness_app/core/extensions/youtube_url_extension.dart';
import 'package:fitness_app/core/shared/custom_video_player.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/widgets/exercise_hero_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class ExerciseVideoHeaderDelegate extends SliverPersistentHeaderDelegate {
  const ExerciseVideoHeaderDelegate({
    required this.exercise,
    required this.muscleName,
    required this.autoPlay,
    required this.playRequestId,
    required this.maxHeight,
    required this.minHeight,
  });

  final ExerciseEntity exercise;
  final String muscleName;
  final bool autoPlay;
  final int playRequestId;
  final double maxHeight;
  final double minHeight;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = (shrinkOffset / (maxHeight - minHeight))
        .clamp(0.0, 1.0)
        .toDouble();

    return Stack(
      fit: StackFit.expand,
      children: [
        CustomVideoPlayer(
          key: ValueKey('${exercise.id}-$playRequestId'),
          videoUrl: exercise.shortYoutubeDemonstrationLink,
          thumbnailImage:
              exercise.shortYoutubeDemonstrationLink.youtubeThumbnail,
          overlayContent: Opacity(
            opacity: 1 - progress,
            child: ExerciseHeroInfo(muscleName: muscleName),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 8.h,
          left: 12.w,
          child: const BackButton(color: AppColors.white),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant ExerciseVideoHeaderDelegate oldDelegate) {
    return oldDelegate.exercise.id != exercise.id ||
        oldDelegate.autoPlay != autoPlay ||
        oldDelegate.playRequestId != playRequestId ||
        oldDelegate.maxHeight != maxHeight ||
        oldDelegate.minHeight != minHeight;
  }
}
