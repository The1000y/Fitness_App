import 'package:fitness_app/core/shared/custom_blur_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomBlurEffect', () {
    testWidgets('renders child inside BackdropFilter', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomBlurEffect(
              sigma: 15,
              child: Text('Blurred Child'),
            ),
          ),
        ),
      );

      expect(find.text('Blurred Child'), findsOneWidget);
      expect(find.byType(BackdropFilter), findsOneWidget);
    });
  });
}
