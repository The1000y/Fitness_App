import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/core/shared/helper/custom_button_click.dart';
import 'package:fitness_app/core/shared/helper/image_thumbnail_overlay.dart';
import 'package:fitness_app/core/shared/helper/video_error_view.dart';
import 'package:fitness_app/features/meals/presentation/widgets/video_player_content.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  group('VideoPlayerContent', () {
    testWidgets('shows the thumbnail overlay when idle', (tester) async {
      var plays = 0;

      await tester.pumpApp(
        Scaffold(
          body: VideoPlayerContent(
            controller: null,
            errorMessage: null,
            isLoading: true,
            thumbnailImage: '',
            onPlayPressed: () => plays++,
            onClosed: () {},
          ),
        ),
      );

      expect(find.byType(ImageThumbnailOverlay), findsOneWidget);
      expect(find.byType(VideoErrorView), findsNothing);

      await tester.tap(find.byType(CustomButtonClick));
      await tester.pump();

      expect(plays, 1);
    });

    testWidgets('renders the overlay content when idle', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: VideoPlayerContent(
            controller: null,
            errorMessage: null,
            isLoading: false,
            thumbnailImage: '',
            overlayContent: const Text('overlay'),
            onPlayPressed: () {},
            onClosed: () {},
          ),
        ),
      );

      expect(find.text('overlay'), findsOneWidget);
    });

    testWidgets('shows the error view with retry and close actions', (
      tester,
    ) async {
      var closes = 0;
      var retries = 0;

      await tester.pumpApp(
        Scaffold(
          body: VideoPlayerContent(
            controller: null,
            errorMessage: 'Unable to play',
            isLoading: false,
            thumbnailImage: '',
            onPlayPressed: () {},
            onClosed: () => closes++,
            onRetry: () => retries++,
          ),
        ),
      );

      expect(find.byType(VideoErrorView), findsOneWidget);
      expect(find.text('Unable to play'), findsOneWidget);

      await tester.tap(find.text(l10n.retry));
      await tester.pump();
      expect(retries, 1);

      await tester.tap(find.text(l10n.back));
      await tester.pump();
      expect(closes, 1);
    });

    testWidgets('hides retry when no retry callback is provided', (
      tester,
    ) async {
      await tester.pumpApp(
        Scaffold(
          body: VideoPlayerContent(
            controller: null,
            errorMessage: 'Unable to play',
            isLoading: false,
            thumbnailImage: '',
            onPlayPressed: () {},
            onClosed: () {},
          ),
        ),
      );

      expect(find.text(l10n.retry), findsNothing);
      expect(find.text(l10n.back), findsOneWidget);
    });
  });
}
