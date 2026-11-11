import 'package:fitness_app/core/shared/video_player_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/core/shared/custom_video_player.dart';
import 'package:fitness_app/core/shared/helper/custom_button_click.dart';
import 'package:fitness_app/core/shared/helper/image_thumbnail_overlay.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import '../../helpers/pump_app.dart';

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  group('CustomVideoPlayer', () {
    testWidgets('renders the thumbnail overlay before playback', (
      tester,
    ) async {
      await tester.pumpApp(
        const CustomVideoPlayer(videoUrl: '', thumbnailImage: ''),
      );

      expect(find.byType(ImageThumbnailOverlay), findsOneWidget);
      expect(find.byType(VideoPlayerContent), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
    });

    testWidgets('shows an invalid video error for an empty url', (
      tester,
    ) async {
      await tester.pumpApp(
        const CustomVideoPlayer(videoUrl: '', thumbnailImage: ''),
      );

      await tester.tap(find.byType(CustomButtonClick));
      await tester.pump();

      expect(find.text(l10n.invalidVideo), findsOneWidget);
      expect(find.byIcon(Icons.videocam_off_rounded), findsOneWidget);
      expect(find.text(l10n.retry), findsNothing);
      expect(find.text(l10n.back), findsOneWidget);
    });

    testWidgets('closing the error returns to the thumbnail', (tester) async {
      await tester.pumpApp(
        const CustomVideoPlayer(videoUrl: '', thumbnailImage: ''),
      );

      await tester.tap(find.byType(CustomButtonClick));
      await tester.pump();
      expect(find.text(l10n.invalidVideo), findsOneWidget);

      await tester.tap(find.text(l10n.back));
      await tester.pump();

      expect(find.text(l10n.invalidVideo), findsNothing);
      expect(find.byType(ImageThumbnailOverlay), findsOneWidget);
    });

    testWidgets('renders the provided overlay content', (tester) async {
      await tester.pumpApp(
        const CustomVideoPlayer(
          videoUrl: '',
          thumbnailImage: '',
          overlayContent: Text('meal overlay'),
        ),
      );

      expect(find.text('meal overlay'), findsOneWidget);
    });
  });
}
