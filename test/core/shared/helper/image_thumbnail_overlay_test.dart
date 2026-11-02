import 'package:fitness_app/core/shared/helper/custom_button_click.dart';
import 'package:fitness_app/core/shared/helper/image_thumbnail_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildTestApp(Widget child) {
  return ScreenUtilPlusInit(
    designSize: const Size(375, 812),
    child: MaterialApp(
      home: Scaffold(
        body: SizedBox(width: 375, height: 250, child: child),
      ),
    ),
  );
}

void main() {
  group('ImageThumbnailOverlay', () {
    testWidgets('renders overlay widget and handles play button tap', (tester) async {
      var playTapped = false;

      await tester.pumpWidget(
        _buildTestApp(
          ImageThumbnailOverlay(
            thumbnailImage: 'https://example.com/thumbnail.jpg',
            onPlayPressed: () => playTapped = true,
            widget: const Text('Overlay Title'),
          ),
        ),
      );

      expect(find.text('Overlay Title'), findsOneWidget);
      expect(find.byType(CustomButtonClick), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);

      await tester.tap(find.byType(CustomButtonClick));
      expect(playTapped, isTrue);
    });
  });
}

