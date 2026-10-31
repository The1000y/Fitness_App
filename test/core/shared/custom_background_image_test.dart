import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomBackgroundImage', () {
    testWidgets('renders child and overlay when showOverlay is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomBackgroundImage(
              backgroundImage: AppImages.authBackground,
              showOverlay: true,
              child: const Text('Child Content'),
            ),
          ),
        ),
      );

      expect(find.text('Child Content'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) => widget is ColoredBox && widget.color == AppColors.overlay,
        ),
        findsOneWidget,
      );
    });

    testWidgets('does not render overlay when showOverlay is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomBackgroundImage(
              backgroundImage: AppImages.authBackground,
              showOverlay: false,
              child: const Text('No Overlay Child'),
            ),
          ),
        ),
      );

      expect(find.text('No Overlay Child'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) => widget is ColoredBox && widget.color == AppColors.overlay,
        ),
        findsNothing,
      );
    });
  });
}
