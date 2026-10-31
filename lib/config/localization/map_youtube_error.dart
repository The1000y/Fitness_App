  import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

String mapYoutubeError(YoutubeError error , AppLocalizations l10n,)  {
    switch (error) {
      case YoutubeError.videoNotFound:
      case YoutubeError.cannotFindVideo:
        return l10n.videoNotFound;
      case YoutubeError.notEmbeddable:
      case YoutubeError.sameAsNotEmbeddable:
      case YoutubeError.sameAsNotEmbeddable2:
        return l10n.videoPlayerError;
      case YoutubeError.invalidParam:
        return l10n.invalidVideo;
      case YoutubeError.html5Error:
        return l10n.embeddingDisabled;
      default:
        return l10n.failedToLoadVideo;
    }
  }
