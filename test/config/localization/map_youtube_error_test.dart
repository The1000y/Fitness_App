import 'package:fitness_app/config/localization/map_youtube_error.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  group('mapYoutubeError', () {
    test('maps videoNotFound and cannotFindVideo to videoNotFound', () {
      expect(mapYoutubeError(YoutubeError.videoNotFound, l10n), l10n.videoNotFound);
      expect(mapYoutubeError(YoutubeError.cannotFindVideo, l10n), l10n.videoNotFound);
    });

    test('maps notEmbeddable errors to videoPlayerError', () {
      expect(mapYoutubeError(YoutubeError.notEmbeddable, l10n), l10n.videoPlayerError);
      expect(mapYoutubeError(YoutubeError.sameAsNotEmbeddable, l10n), l10n.videoPlayerError);
      expect(mapYoutubeError(YoutubeError.sameAsNotEmbeddable2, l10n), l10n.videoPlayerError);
    });

    test('maps invalidParam to invalidVideo', () {
      expect(mapYoutubeError(YoutubeError.invalidParam, l10n), l10n.invalidVideo);
    });

    test('maps html5Error to embeddingDisabled', () {
      expect(mapYoutubeError(YoutubeError.html5Error, l10n), l10n.embeddingDisabled);
    });

    test('maps unknown/default to failedToLoadVideo', () {
      expect(mapYoutubeError(YoutubeError.unknown, l10n), l10n.failedToLoadVideo);
    });
  });
}

