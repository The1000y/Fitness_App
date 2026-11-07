import 'package:fitness_app/core/shared/helper/image_thumbnail_overlay.dart';
import 'package:fitness_app/core/shared/helper/video_error_view.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerContent extends StatelessWidget {
  const VideoPlayerContent({
    super.key,
    required this.controller,
    required this.errorMessage,
    required this.isLoading,
    required this.thumbnailImage,
    required this.onPlayPressed,
    required this.onClosed,
    this.overlayContent,
    this.onRetry,
  });

  final YoutubePlayerController? controller;
  final String? errorMessage;
  final bool isLoading;
  final String thumbnailImage;
  final Widget? overlayContent;
  final VoidCallback onPlayPressed;
  final VoidCallback onClosed;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final playerController = controller;

    if (errorMessage != null) {
      return VideoErrorView(
        errorMessage: errorMessage!,
        onClose: onClosed,
        onRetry: onRetry,
      );
    }

    if (playerController != null) {
      return Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                YoutubePlayer(controller: playerController),
                if (isLoading)
                  const ColoredBox(
                    color: Colors.black,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          ColoredBox(
            color: AppColors.black,
            child: SizedBox(
              height: 35.h,
              width: double.infinity,
              child: Align(
                alignment: AlignmentDirectional.center,
                child: TextButton.icon(
                  onPressed: onClosed,
                  icon: Icon(
                    Icons.close_rounded,
                    size: 18.r,
                    color: AppColors.primary,
                  ),
                  label: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return ImageThumbnailOverlay(
      onPlayPressed: onPlayPressed,
      widget: overlayContent,
      thumbnailImage: thumbnailImage,
    );
  }
}
