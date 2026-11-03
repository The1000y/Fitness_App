import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HeroVideoSection extends StatefulWidget {
  const HeroVideoSection({
    super.key,
    required this.exercise,
    required this.muscleName,
  });

  final ExerciseEntity exercise;
  final String muscleName;

  @override
  State<HeroVideoSection> createState() => _HeroVideoSectionState();
}

class _HeroVideoSectionState extends State<HeroVideoSection> {
  bool _isPlaying = false;
  YoutubePlayerController? _controller;

  String? get _videoId {
    final url = widget.exercise.shortYoutubeDemonstrationLink;
    if (url.isEmpty) return null;
    return YoutubePlayerController.convertUrlToId(url.trim());
  }

  String get _thumbnailUrl {
    final id = _videoId;
    if (id == null) return '';
    return YoutubePlayerController.getThumbnail(videoId: id);
  }

  void _startVideo() {
    final id = _videoId;
    if (id == null || _controller != null) return;

    final controller = YoutubePlayerController.fromVideoId(
      videoId: id,
      autoPlay: true,
      params: const YoutubePlayerParams(
        enableCaption: false,
        showVideoAnnotations: false,
        showControls: false,
        mute: true,
        loop: true,
      ),
    );

    setState(() {
      _controller = controller;
      _isPlaying = true;
    });
  }

  void _stopVideo() {
    _controller?.close();
    setState(() {
      _controller = null;
      _isPlaying = false;
    });
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant HeroVideoSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exercise.shortYoutubeDemonstrationLink !=
        widget.exercise.shortYoutubeDemonstrationLink) {
      _controller?.close();
      _controller = null;
      _isPlaying = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isPlaying ? _stopVideo : _startVideo,
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: _isPlaying && _controller != null
                ? YoutubePlayer(controller: _controller!)
                : _buildThumbnail(),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8.h,
            left: 12.w,
            child: _BackButton(onTap: () => Navigator.of(context).pop()),
          ),
          if (!_isPlaying)
            Positioned.fill(
              child: Center(
                child: Container(
                  width: 56.r,
                  height: 56.r,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: AppColors.white,
                    size: 32.r,
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _GradientOverlay(
              muscleName: widget.muscleName,
              isPlaying: _isPlaying,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnail() {
    if (_thumbnailUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: _thumbnailUrl,
        fit: BoxFit.cover,
        color: AppColors.black.withValues(alpha: 0.4),
        colorBlendMode: BlendMode.darken,
        placeholder: (context, url) =>
            const ColoredBox(color: AppColors.surfaceMuted),
        errorWidget: (context, url, error) => _placeholderBox(),
      );
    }
    return _placeholderBox();
  }

  Widget _placeholderBox() {
    return ColoredBox(
      color: AppColors.neutral.shade800,
      child: const Center(
        child: Icon(
          Icons.fitness_center,
          color: AppColors.textSecondary,
          size: 48,
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.r,
        height: 36.r,
        decoration: BoxDecoration(
          color: AppColors.black.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.white,
          size: 18.r,
        ),
      ),
    );
  }
}

class _GradientOverlay extends StatelessWidget {
  const _GradientOverlay({required this.muscleName, required this.isPlaying});

  final String muscleName;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.transparent,
            AppColors.black.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            muscleName,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          Gap(4.h),
          Text(
            'Tap to ${isPlaying ? 'stop' : 'play'} demo',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }
}
