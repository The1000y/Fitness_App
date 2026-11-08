import 'package:fitness_app/core/shared/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

Widget wrapWithScreenUtil(Widget child) {
  return ScreenUtilPlusInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    child: MaterialApp(
      home: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  group('CustomButton', () {
    testWidgets('renders label and triggers onPressed when tapped', (
      tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        wrapWithScreenUtil(
          CustomButton(
            label: 'Submit',
            onPressed: () {
              tapped = true;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Submit'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      await tester.tap(find.byType(CustomButton));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('renders outlined button when variant is outlined', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithScreenUtil(
          CustomButton(
            label: 'Cancel',
            variant: ButtonVariant.outlined,
            onPressed: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets(
      'shows CircularProgressIndicator and disables tap when isLoading is true',
      (tester) async {
        bool tapped = false;

        await tester.pumpWidget(
          wrapWithScreenUtil(
            CustomButton(
              label: 'Loading...',
              isLoading: true,
              onPressed: () {
                tapped = true;
              },
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Loading...'), findsNothing);

        await tester.tap(find.byType(CustomButton));
        await tester.pump();

        expect(tapped, isFalse);
      },
    );

    testWidgets('does not trigger onPressed when enabled is false', (
      tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        wrapWithScreenUtil(
          CustomButton(
            label: 'Disabled',
            enabled: false,
            onPressed: () {
              tapped = true;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(CustomButton));
      await tester.pump();

      expect(tapped, isFalse);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(
        wrapWithScreenUtil(
          CustomButton(
            label: 'With Icon',
            icon: const Icon(Icons.check),
            onPressed: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.text('With Icon'), findsOneWidget);
    });
  });
}
