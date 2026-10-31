import 'dart:async';
import 'package:fitness_app/config/localization/map_youtube_error.dart';
import 'package:fitness_app/features/meals/presentation/widgets/video_player_content.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CustomVideoPlayer extends StatefulWidget {
  const CustomVideoPlayer({
    super.key,
    required this.thumbnailImage,
    required this.videoUrl,
    this.overlayContent,
    this.aspectRatio = 4 / 3,
  });

  final String thumbnailImage;
  final String videoUrl;
  final Widget? overlayContent;
  final double? aspectRatio;

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  bool _isLoading = true;
  YoutubeError? _error;
  YoutubePlayerController? _controller;
  StreamSubscription<YoutubePlayerValue>? _subscription;

  void _onPlayPressed() {
    if (_controller != null) return;
    final trimmedUrl = widget.videoUrl.trim();
    final videoId = YoutubePlayerController.convertUrlToId(trimmedUrl);

    if (videoId == null) {
      setState(() => _error = YoutubeError.invalidParam);
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
      _isLoading = true;
      _error = null;
    });
  }

  void _onPlayerValueChanged(YoutubePlayerValue value) {
    if (!mounted) return;
    if (value.hasError) {
      setState(() => _error = value.error);
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
      _isLoading = true;
      _error = null;
    });
  }

  void _onRetry() {
    _onClosed();
    _onPlayPressed();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final errorMessage = _error == null ? null : mapYoutubeError(_error!, l10n);
    return AspectRatio(
      aspectRatio: widget.aspectRatio ?? 16 / 9,
      child: ClipRRect(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
        child: VideoPlayerContent(
          controller: _controller,
          errorMessage: errorMessage,
          isLoading: _isLoading,
          thumbnailImage: widget.thumbnailImage,
          overlayContent: widget.overlayContent,
          onPlayPressed: _onPlayPressed,
          onClosed: _onClosed,
          onRetry: _controller == null ? null : _onRetry,
        ),
      ),
    );
  }
}
