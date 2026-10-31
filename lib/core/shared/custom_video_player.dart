import 'dart:async';
import 'package:fitness_app/config/localization/map_youtube_error.dart';
// import 'package:fitness_app/core/shared/helper/custom_button_click.dart';
import 'package:fitness_app/core/shared/helper/image_thumbnail_overlay.dart';
import 'package:fitness_app/core/shared/helper/video_error_view.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CustomVideoPlayer extends StatefulWidget {
  const CustomVideoPlayer({
    super.key,
    required this.thumbnailImage,
    required this.videoUrl,
    this.mealInfoOverlay,
    this.aspectRatio = 4 / 3,
  });

  final String thumbnailImage;
  final String videoUrl;
  final Widget? mealInfoOverlay;
  final double? aspectRatio;

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  bool _isPlay = false;
  bool _isLoading = true;
  String? _errorMessage;
  YoutubePlayerController? _controller;
  StreamSubscription<YoutubePlayerValue>? _subscription;

  void _onPlayPressed() {
    if (_controller != null) return;
    final l10n = AppLocalizations.of(context)!;
    final trimmedUrl = widget.videoUrl.trim();
    final videoId = YoutubePlayerController.convertUrlToId(trimmedUrl);

    if (videoId == null) {
      setState(() => _errorMessage = l10n.invalidVideo);
      return;
    }

    final controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        enableCaption: false,
        showVideoAnnotations: false,
      ),
    );
    _subscription = controller.stream.listen(_onPlayerValueChanged);

    setState(() {
      _controller = controller;
      _isPlay = true;
      _isLoading = true;
      _errorMessage = null;
    });
  }

  void _onPlayerValueChanged(YoutubePlayerValue value) {
    if (!mounted) return;
    if (value.hasError) {
      final l10n = AppLocalizations.of(context)!;
      setState(() => _errorMessage = mapYoutubeError(value.error, l10n));
      return;
    }
    final isReady =
        value.playerState == PlayerState.playing ||
        value.playerState == PlayerState.paused ||
        value.playerState == PlayerState.buffering;
    if (_isLoading && isReady) {
      setState(() => _isLoading = false);
    }
  }

  void _onClosed() {
    _subscription?.cancel();
    _subscription = null;
    _controller?.close();
    setState(() {
      _controller = null;
      _isPlay = false;
      _isLoading = true;
      _errorMessage = null;
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.aspectRatio ?? 16 / 9,
      child: ClipRRect(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    var theme = Theme.of(context);
    if (_errorMessage != null) {
      return VideoErrorView(
        errorMessage: _errorMessage!,
        onClose: _onClosed,
        onRetry: _controller == null
            ? null
            : () {
                _onClosed();
                _onPlayPressed();
              },
      );
    }
    if (_isPlay) {
      return Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                YoutubePlayer(controller: _controller!),
                if (_isLoading)
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
         !_isLoading? ColoredBox(
            color: AppColors.black,
            child: SizedBox(
              height: 35.h,
              width: double.infinity,
              child: Align(
                alignment: AlignmentDirectional.center,
                child: TextButton.icon(
                  onPressed: _onClosed,
                  icon: Icon(
                    Icons.close_rounded,
                    size: 18.r,
                    color: AppColors.primary,
                  ),
                  label: Text(AppLocalizations.of(context)!.cancel,
                    style:theme.textTheme.bodyMedium!.copyWith(
                      color: AppColors.primary
                    )
                  ),
                ),
              ),
            ),
          ): const SizedBox.shrink(),
        ],
      );
    }
    return ImageThumbnailOverlay(
      onPlayPressed: _onPlayPressed,
      widget: widget.mealInfoOverlay,
      thumbnailImage: widget.thumbnailImage,
    );
  }
}
