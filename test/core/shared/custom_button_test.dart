import 'package:fitness_app/core/shared/custom_button.dart';
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
  group('CustomButton', () {
    testWidgets('renders label and fires onPressed when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        _buildTestApp(
          CustomButton(
            label: 'Submit',
            onPressed: () => tapped = true,
          ),
        ),
      );

      expect(find.text('Submit'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      await tester.tap(find.text('Submit'));
      expect(tapped, isTrue);
    });

    testWidgets('renders outlined button when variant is outlined', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          CustomButton(
            label: 'Cancel',
            variant: ButtonVariant.outlined,
            onPressed: () {},
          ),
        ),
      );

      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          CustomButton(
            label: 'With Icon',
            icon: const Icon(Icons.star),
            onPressed: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('With Icon'), findsOneWidget);
    });

    testWidgets('shows CircularProgressIndicator and ignores taps when isLoading is true', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        _buildTestApp(
          CustomButton(
            label: 'Loading',
            isLoading: true,
            onPressed: () => tapped = true,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading'), findsNothing);

      await tester.tap(find.byType(CustomButton));
      expect(tapped, isFalse);
    });

    testWidgets('ignores taps when enabled is false', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        _buildTestApp(
          CustomButton(
            label: 'Disabled',
            enabled: false,
            onPressed: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.text('Disabled'));
      expect(tapped, isFalse);
    });
  });
}

