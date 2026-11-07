import 'package:youtube_player_flutter/youtube_player_flutter.dart';

extension YoutubeUrlX on String {
  String get youtubeThumbnail {
    final url = trim();
    if (url.isEmpty) return '';
    final id = YoutubePlayerController.convertUrlToId(url);
    if (id == null) return '';
    return YoutubePlayerController.getThumbnail(videoId: id);
  }
}
