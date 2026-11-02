import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomBackgroundImage', () {
    testWidgets('renders background image and child with overlay', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomBackgroundImage(
              backgroundImage: 'assets/images/robot_chat.png',
              showOverlay: true,
              child: Text('Foreground Content'),
            ),
          ),
        ),
      );

      expect(find.text('Foreground Content'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (w) => w is ColoredBox && w.color == AppColors.overlay,
        ),
        findsOneWidget,
      );
    });

    testWidgets('omits overlay when showOverlay is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomBackgroundImage(
              backgroundImage: 'assets/images/robot_chat.png',
              showOverlay: false,
              child: Text('No Overlay Content'),
            ),
          ),
        ),
      );

      expect(find.text('No Overlay Content'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (w) => w is ColoredBox && w.color == AppColors.overlay,
        ),
        findsNothing,
      );
    });
  });
}
