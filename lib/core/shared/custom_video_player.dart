import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../theme/app_colors/app_colors.dart';

/// A custom, friendly YouTube video player widget that handles:
/// - Parsing any YouTube URL format (standard, shortened, embed, shorts) or raw video ID
/// - Loading states with auto-generated/custom thumbnail and fitness-themed spinner
/// - Network errors, invalid URLs, embed restrictions, and playback errors with retry functionality
/// - Themed YouTube controls matching the app theme (orange progress bar, white controls)
/// - Seamless fullscreen support and auto-hide controls
/// - Video completion callback ([onFinished])
/// - Controller disposal, dynamic URL updates, and lifecycle management
class CustomVideoPlayer extends StatefulWidget {
  const CustomVideoPlayer({
    super.key,
    required this.urlVideo,

    this.autoPlay = false,
    this.looping = false,
    this.showControls = true,
    this.aspectRatio,
    this.borderRadius,
    this.thumbnailUrl,
    this.title,
    this.onFinished,
    this.mute = false,
  });

  /// The YouTube URL (e.g. watch, youtu.be, shorts, embed) or raw 11-char video ID.
  final String urlVideo;

  /// Whether to automatically start playback once initialized.
  final bool autoPlay;

  /// Whether to loop playback when the video reaches the end.
  final bool looping;

  /// Whether to show playback controls overlay.
  final bool showControls;

  /// Optional override for the aspect ratio. Defaults to 16/9.
  final double? aspectRatio;

  /// Border radius applied to the video container. Defaults to 16.r.
  final BorderRadiusGeometry? borderRadius;

  /// Optional preview thumbnail image shown during loading.
  /// If not provided, YouTube's video thumbnail is automatically loaded.
  final String? thumbnailUrl;

  /// Optional title displayed on the player.
  final String? title;

  /// Callback invoked when playback finishes (if looping is false).
  final VoidCallback? onFinished;

  /// Whether to start playback muted.
  final bool mute;

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  YoutubePlayerController? _controller;
  StreamSubscription<YoutubePlayerValue>? _subscription;

  String? _videoId;
  bool _isReady = false;
  bool _hasStartedPlaying = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void didUpdateWidget(covariant CustomVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.urlVideo != widget.urlVideo) {
      final newVideoId = YoutubePlayerController.convertUrlToId(widget.urlVideo);
      if (newVideoId != null && _controller != null && !_hasError) {
        _videoId = newVideoId;
        _isReady = false;
        _hasStartedPlaying = false;
        if (widget.autoPlay) {
          _controller!.loadVideoById(videoId: newVideoId);
        } else {
          _controller!.cueVideoById(videoId: newVideoId);
        }
      } else {
        _initializePlayer();
      }
    }
  }

  void _initializePlayer() {
    _cleanupController();

    final trimmedUrl = widget.urlVideo.trim();
    if (trimmedUrl.isEmpty) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Video URL is empty.';
        _isReady = false;
        _hasStartedPlaying = false;
      });
      return;
    }

    final videoId = YoutubePlayerController.convertUrlToId(trimmedUrl);
    if (videoId == null || videoId.isEmpty) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Invalid YouTube video URL.';
        _isReady = false;
        _hasStartedPlaying = false;
      });
      return;
    }

    _videoId = videoId;
    _hasError = false;
    _errorMessage = '';
    _isReady = false;
    _hasStartedPlaying = false;

    try {
      final controller = YoutubePlayerController(
        params: YoutubePlayerParams(
          showControls: widget.showControls,
          showFullscreenButton: true,
          mute: widget.mute,
          loop: widget.looping,
          enableCaption: false,
          showVideoAnnotations: false,
        ),
        onWebResourceError: (error) {
          if (mounted) {
            setState(() {
              _hasError = true;
              _errorMessage =
                  'Network error. Please check your internet connection.';
            });
          }
        },
      );

      if (widget.autoPlay) {
        controller.loadVideoById(videoId: videoId);
      } else {
        controller.cueVideoById(videoId: videoId);
      }

      _controller = controller;

      _subscription = controller.stream.listen((value) {
        if (!mounted) return;
        if (value.hasError) {
          setState(() {
            _hasError = true;
            _errorMessage = _mapYoutubeError(value.error);
          });
          return;
        }

        if (!_isReady &&
            (value.playerState == PlayerState.playing ||
                value.playerState == PlayerState.paused ||
                value.playerState == PlayerState.buffering ||
                value.playerState == PlayerState.cued)) {
          setState(() {
            _isReady = true;
          });
        }

        if (!_hasStartedPlaying && value.playerState == PlayerState.playing) {
          setState(() {
            _hasStartedPlaying = true;
          });
        }

        if (value.playerState == PlayerState.ended) {
          widget.onFinished?.call();
        }
      });
    } catch (_) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to initialize YouTube player.';
      });
    }
  }

  String _mapYoutubeError(YoutubeError error) {
    switch (error) {
      case YoutubeError.videoNotFound:
      case YoutubeError.cannotFindVideo:
        return 'This video was not found or is private.';
      case YoutubeError.notEmbeddable:
      case YoutubeError.sameAsNotEmbeddable:
      case YoutubeError.sameAsNotEmbeddable2:
        return 'The owner has disabled embedding for this video.';
      case YoutubeError.invalidParam:
        return 'Invalid YouTube video parameter or ID.';
      case YoutubeError.html5Error:
        return 'HTML5 player error while loading video.';
      default:
        return 'Failed to load video. Please check your connection.';
    }
  }

  void _cleanupController() {
    _subscription?.cancel();
    _subscription = null;
    _controller?.close();
    _controller = null;
  }

  @override
  void dispose() {
    _cleanupController();
    super.dispose();
  }

  String _getThumbnailUrl() {
    final customThumbnail = widget.thumbnailUrl?.trim();
    if (customThumbnail != null && customThumbnail.isNotEmpty) {
      return customThumbnail;
    }
    final videoId = _videoId?.trim();
    if (videoId != null && videoId.isNotEmpty) {
      return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius =
        widget.borderRadius ?? BorderRadius.circular(16.r);
    final effectiveAspectRatio = widget.aspectRatio ?? (16 / 9);

    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: AspectRatio(
        aspectRatio: effectiveAspectRatio,
        child: Container(
          color: AppColors.neutral[900] ?? const Color(0xFF0A0A0A),
          child: _buildBody(effectiveAspectRatio),
        ),
      ),
    );
  }

  Widget _buildBody(double aspectRatio) {
    if (_hasError) {
      return _buildErrorView();
    }

    if (_controller == null) {
      return _buildThumbnailOverlay();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            extensions: [
              YoutubePlayerTheme(
                progressBarActiveColor: AppColors.primary,
                progressBarBufferedColor:
                    AppColors.primary.withValues(alpha: 0.4),
                progressBarBackgroundColor:
                    AppColors.white.withValues(alpha: 0.25),
                controlsColor: AppColors.white,
                titleStyle: TextStyle(
                  color: AppColors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
                timerStyle: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          // الثامنيل بس لحد ما المستخدم يدوس play
          child: YoutubePlayer(
            controller: _controller!,
            aspectRatio: aspectRatio,
            backgroundColor:
                AppColors.neutral[900] ?? const Color(0xFF0A0A0A),
            autoFullScreen: true,
            enableFullScreenOnVerticalDrag: true,
          ),
        ),

        // Display thumbnail until the user starts playback for the first time
        if (!_hasStartedPlaying)
          Positioned.fill(
            child: IgnorePointer(
              child: _buildThumbnailOverlay(),
            ),
          ),
      ],
    );
  }

  Widget _buildThumbnailOverlay() {
    final thumbnail = _getThumbnailUrl();

    return Stack(
      fit: StackFit.expand,
      children: [
        if (thumbnail.isNotEmpty)
          CachedNetworkImage(
            imageUrl: thumbnail,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                Container(color: AppColors.neutral[900]),
            errorWidget: (context, url, error) =>
                Container(color: AppColors.neutral[900]),
          ),
        if (!_isReady) ...[
          Container(
            color: thumbnail.isNotEmpty
                ? AppColors.scrim
                : (AppColors.neutral[900] ?? const Color(0xFF0A0A0A)),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 32.r,
                  height: 32.r,
                  child: const CircularProgressIndicator(
                    strokeWidth: 3,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Loading YouTube video...',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildErrorView() {
    return Container(
      color: AppColors.neutral[900] ?? const Color(0xFF0A0A0A),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.videocam_off_rounded,
                color: AppColors.primary,
                size: 32.r,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              _errorMessage.isNotEmpty
                  ? _errorMessage
                  : 'Unable to play YouTube video',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Check the video link or connection and try again',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11.sp,
              ),
            ),
            SizedBox(height: 14.h),
            ElevatedButton.icon(
              onPressed: () {
                setState(_initializePlayer);
              },
              icon: Icon(Icons.refresh_rounded, size: 18.r),
              label: Text(
                'Retry',
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


