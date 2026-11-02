import 'package:fitness_app/core/shared/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildTestApp(Widget child) {
  return ScreenUtilPlusInit(
    designSize: const Size(375, 812),
    child: MaterialApp(home: Scaffold(appBar: child as PreferredSizeWidget)),
  );
}

void main() {
  group('CustomAppBar', () {
    testWidgets('renders title text and actions', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          const CustomAppBar(
            title: 'Profile Settings',
            showBackButton: false,
            actions: [
              Icon(Icons.more_vert),
            ],
          ),
        ),
      );

      expect(find.text('Profile Settings'), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('renders titleWidget when provided instead of title', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          const CustomAppBar(
            titleWidget: Text('Custom Title Widget'),
            showBackButton: false,
          ),
        ),
      );

      expect(find.text('Custom Title Widget'), findsOneWidget);
    });

    testWidgets('hides back button when showBackButton is false', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          const CustomAppBar(
            title: 'No Back Button',
            showBackButton: false,
          ),
        ),
      );

      expect(find.byType(IconButton), findsNothing);
    });

    testWidgets('fires onBackTap when back button is tapped', (tester) async {
      var backTapped = false;

      await tester.pumpWidget(
        _buildTestApp(
          CustomAppBar(
            title: 'Back Test',
            showBackButton: true,
            onBackTap: () => backTapped = true,
          ),
        ),
      );

      final backButton = find.byType(IconButton);
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      expect(backTapped, isTrue);
    });
  });
}

