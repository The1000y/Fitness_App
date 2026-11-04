import 'package:fitness_app/core/shared/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

Widget wrapWithScreenUtil(Widget child) {
  return ScreenUtilPlusInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    child: MaterialApp(home: Scaffold(appBar: child as PreferredSizeWidget)),
  );
}

void main() {
  group('CustomAppBar', () {
    testWidgets('renders title text and preferredSize', (tester) async {
      const appBar = CustomAppBar(title: 'My Profile');

      expect(appBar.preferredSize.height, equals(kToolbarHeight));

      await tester.pumpWidget(wrapWithScreenUtil(appBar));
      await tester.pumpAndSettle();

      expect(find.text('My Profile'), findsOneWidget);
    });

    testWidgets('renders titleWidget when provided', (tester) async {
      await tester.pumpWidget(
        wrapWithScreenUtil(
          const CustomAppBar(titleWidget: Text('Custom Title Widget')),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Custom Title Widget'), findsOneWidget);
    });

    testWidgets('renders actions when provided', (tester) async {
      await tester.pumpWidget(
        wrapWithScreenUtil(
          CustomAppBar(
            title: 'Title',
            actions: [
              IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('calls onBackTap when back button tapped', (tester) async {
      bool backTapped = false;

      await tester.pumpWidget(
        wrapWithScreenUtil(
          CustomAppBar(
            title: 'Back Test',
            showBackButton: true,
            onBackTap: () {
              backTapped = true;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(backTapped, isTrue);
    });

    testWidgets('does not render back button when showBackButton is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithScreenUtil(
          const CustomAppBar(title: 'No Back', showBackButton: false),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(IconButton), findsNothing);
    });
  });
}
