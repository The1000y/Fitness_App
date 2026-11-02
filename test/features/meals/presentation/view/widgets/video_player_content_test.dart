import 'package:fitness_app/core/shared/helper/image_thumbnail_overlay.dart';
import 'package:fitness_app/core/shared/helper/video_error_view.dart';
import 'package:fitness_app/features/meals/presentation/view/widgets/video_player_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../../helpers/pump_app.dart';

void main() {
  group('VideoPlayerContent', () {
    testWidgets('renders VideoErrorView when errorMessage is not null', (tester) async {
      var retryCalled = false;
      var closeCalled = false;

      await tester.pumpApp(
        Scaffold(
          body: VideoPlayerContent(
            controller: null,
            errorMessage: 'Network error occurred',
            isLoading: false,
            thumbnailImage: 'https://example.com/thumb.jpg',
            onPlayPressed: () {},
            onClosed: () => closeCalled = true,
            onRetry: () => retryCalled = true,
          ),
        ),
      );

      expect(find.byType(VideoErrorView), findsOneWidget);
      expect(find.text('Network error occurred'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      expect(retryCalled, isTrue);

      await tester.tap(find.text('Back'));
      expect(closeCalled, isTrue);
    });

    testWidgets('renders ImageThumbnailOverlay with overlayContent when controller is null', (tester) async {
      var playPressed = false;

      await tester.pumpApp(
        Scaffold(
          body: VideoPlayerContent(
            controller: null,
            errorMessage: null,
            isLoading: false,
            thumbnailImage: 'https://example.com/thumb.jpg',
            overlayContent: const Text('Overlay Title'),
            onPlayPressed: () => playPressed = true,
            onClosed: () {},
          ),
        ),
      );

      expect(find.byType(ImageThumbnailOverlay), findsOneWidget);
      expect(find.text('Overlay Title'), findsOneWidget);

      final playButton = find.byIcon(Icons.play_arrow_rounded);
      expect(playButton, findsOneWidget);
      await tester.tap(playButton);
      expect(playPressed, isTrue);
    });
  });
}
