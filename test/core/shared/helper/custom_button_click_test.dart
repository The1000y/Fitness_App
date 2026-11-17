import 'package:fitness_app/core/shared/helper/custom_button_click.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildTestApp(Widget child) {
  return ScreenUtilPlusInit(
    designSize: const Size(375, 812),
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  group('CustomButtonClick', () {
    testWidgets('renders iconWidget and responds to tap', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        _buildTestApp(
          CustomButtonClick(
            onPressed: () => tapped = true,
            iconWidget: const Icon(Icons.play_arrow),
          ),
        ),
      );

      expect(find.byIcon(Icons.play_arrow), findsOneWidget);

      await tester.tap(find.byType(CustomButtonClick));
      expect(tapped, isTrue);
    });
  });
}
