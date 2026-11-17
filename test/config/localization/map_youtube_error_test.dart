import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/config/localization/map_youtube_error.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  group('mapYoutubeError', () {
    test('maps missing video errors to videoNotFound', () {
      expect(
        mapYoutubeError(YoutubeError.videoNotFound, l10n),
        l10n.videoNotFound,
      );
      expect(
        mapYoutubeError(YoutubeError.cannotFindVideo, l10n),
        l10n.videoNotFound,
      );
    });

    test('maps embedding errors to videoPlayerError', () {
      expect(
        mapYoutubeError(YoutubeError.notEmbeddable, l10n),
        l10n.videoPlayerError,
      );
      expect(
        mapYoutubeError(YoutubeError.sameAsNotEmbeddable, l10n),
        l10n.videoPlayerError,
      );
      expect(
        mapYoutubeError(YoutubeError.sameAsNotEmbeddable2, l10n),
        l10n.videoPlayerError,
      );
    });

    test('maps invalid params and html5 errors', () {
      expect(
        mapYoutubeError(YoutubeError.invalidParam, l10n),
        l10n.invalidVideo,
      );
      expect(
        mapYoutubeError(YoutubeError.html5Error, l10n),
        l10n.embeddingDisabled,
      );
    });

    test('falls back for none and unknown errors', () {
      expect(mapYoutubeError(YoutubeError.none, l10n), l10n.failedToLoadVideo);
      expect(
        mapYoutubeError(YoutubeError.unknown, l10n),
        l10n.failedToLoadVideo,
      );
    });
  });
}
