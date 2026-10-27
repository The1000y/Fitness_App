import 'package:fitness_app/core/constants/app_test_keys.dart';
import 'package:fitness_app/features/chat/presentation/views/chat_view.dart';
import 'package:fitness_app/features/home/presentation/views/home_view.dart';
import 'package:fitness_app/features/main/presentation/views/main_layout_view.dart';
import 'package:fitness_app/features/profile/presentation/views/profile_view.dart';
import 'package:fitness_app/features/workouts/presentation/views/workouts_view.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// Helper to build and pump [MainLayoutView] within the app's real runtime environment.
  Future<void> pumpMainLayoutView(
    WidgetTester tester, {
    List<Widget>? tabs,
    TargetPlatform platform = TargetPlatform.android,
  }) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final actualTabs =
        tabs ?? const [HomeView(), ChatView(), WorkoutsView(), ProfileView()];

    await tester.pumpWidget(
      ScreenUtilPlusInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          theme: ThemeData(platform: platform),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: MainLayoutView(tabs: actualTabs),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Helper to get the localized strings from the test context.
  AppLocalizations getL10n(WidgetTester tester) {
    return AppLocalizations.of(tester.element(find.byType(MainLayoutView)))!;
  }

  group('MainLayoutView Rendering and Initial State', () {
    testWidgets(
      'renders floating bottom navigation bar and displays Home tab as initial screen',
      (WidgetTester tester) async {
        await pumpMainLayoutView(tester);
        final l10n = getL10n(tester);

        // Verify bottom navigation bar exists
        expect(
          find.byKey(const Key(AppTestKeys.mainLayoutBottomNav)),
          findsOneWidget,
        );

        // Verify all 4 tabs are present
        expect(
          find.byKey(const Key(AppTestKeys.mainTabExplore)),
          findsOneWidget,
        );
        expect(find.byKey(const Key(AppTestKeys.mainTabCoach)), findsOneWidget);
        expect(
          find.byKey(const Key(AppTestKeys.mainTabWorkouts)),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key(AppTestKeys.mainTabProfile)),
          findsOneWidget,
        );

        // Verify initial IndexedStack state shows HomeView
        final indexedStackFinder = find.byType(IndexedStack);
        expect(indexedStackFinder, findsOneWidget);
        final indexedStack = tester.widget<IndexedStack>(indexedStackFinder);
        expect(indexedStack.index, 0);
        expect(find.byType(HomeView), findsOneWidget);

        // Verify only selected tab (Explore) displays its label
        expect(find.text(l10n.explore), findsOneWidget);
        expect(find.text(l10n.smartCoach), findsNothing);
        expect(find.text(l10n.workouts), findsNothing);
        expect(find.text(l10n.profile), findsNothing);
      },
    );
  });

  group('MainLayoutView Tab Navigation Flows', () {
    testWidgets('switches to Smart Coach tab when coach tab is tapped', (
      WidgetTester tester,
    ) async {
      await pumpMainLayoutView(tester);
      final l10n = getL10n(tester);

      // Tap on Smart Coach tab (index 1)
      await tester.tap(find.byKey(const Key(AppTestKeys.mainTabCoach)));
      await tester.pumpAndSettle();

      // Verify active tab index updated to 1
      final indexedStack = tester.widget<IndexedStack>(
        find.byType(IndexedStack),
      );
      expect(indexedStack.index, 1);
      expect(find.byType(ChatView), findsOneWidget);

      // Verify label visibility updated
      expect(find.text(l10n.smartCoach), findsOneWidget);
      expect(find.text(l10n.explore), findsNothing);
    });

    testWidgets('switches to Workouts tab when workouts tab is tapped', (
      WidgetTester tester,
    ) async {
      await pumpMainLayoutView(tester);
      final l10n = getL10n(tester);

      // Tap on Workouts tab (index 2)
      await tester.tap(find.byKey(const Key(AppTestKeys.mainTabWorkouts)));
      await tester.pumpAndSettle();

      // Verify active tab index updated to 2
      final indexedStack = tester.widget<IndexedStack>(
        find.byType(IndexedStack),
      );
      expect(indexedStack.index, 2);
      expect(find.byType(WorkoutsView), findsOneWidget);

      // Verify label visibility updated
      expect(find.text(l10n.workouts), findsOneWidget);
      expect(find.text(l10n.explore), findsNothing);
    });

    testWidgets('switches to Profile tab when profile tab is tapped', (
      WidgetTester tester,
    ) async {
      await pumpMainLayoutView(tester);
      final l10n = getL10n(tester);

      // Tap on Profile tab (index 3)
      await tester.tap(find.byKey(const Key(AppTestKeys.mainTabProfile)));
      await tester.pumpAndSettle();

      // Verify active tab index updated to 3
      final indexedStack = tester.widget<IndexedStack>(
        find.byType(IndexedStack),
      );
      expect(indexedStack.index, 3);
      expect(find.byType(ProfileView), findsOneWidget);

      // Verify label visibility updated
      expect(find.text(l10n.profile), findsOneWidget);
      expect(find.text(l10n.explore), findsNothing);
    });
  });

  group('MainLayoutView Back Navigation and Close App Dialog Flow', () {
    testWidgets(
      'returns to Home tab when system back is pressed on any non-home tab',
      (WidgetTester tester) async {
        await pumpMainLayoutView(tester);

        // 1. Switch to Workouts tab
        await tester.tap(find.byKey(const Key(AppTestKeys.mainTabWorkouts)));
        await tester.pumpAndSettle();

        expect(tester.widget<IndexedStack>(find.byType(IndexedStack)).index, 2);

        // 2. Simulate system back button
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();

        // 3. Verify user returned to Home tab (index 0) and dialog is not shown
        expect(tester.widget<IndexedStack>(find.byType(IndexedStack)).index, 0);
        expect(find.byType(HomeView), findsOneWidget);
        expect(find.byKey(const Key(AppTestKeys.closeAppDialog)), findsNothing);
      },
    );

    testWidgets(
      'shows close app confirmation dialog when system back is pressed on Home tab',
      (WidgetTester tester) async {
        await pumpMainLayoutView(tester);
        final l10n = getL10n(tester);

        // Ensure we are at Home tab (index 0)
        expect(tester.widget<IndexedStack>(find.byType(IndexedStack)).index, 0);

        // Simulate system back button
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();

        // Verify confirmation dialog is displayed
        expect(
          find.byKey(const Key(AppTestKeys.closeAppDialog)),
          findsOneWidget,
        );
        expect(find.text(l10n.closeAppConfirm), findsOneWidget);
        expect(
          find.byKey(const Key(AppTestKeys.closeAppDialogNoButton)),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key(AppTestKeys.closeAppDialogYesButton)),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'dismisses close app confirmation dialog when NO button is tapped',
      (WidgetTester tester) async {
        await pumpMainLayoutView(tester);

        // Trigger the dialog
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();

        expect(
          find.byKey(const Key(AppTestKeys.closeAppDialog)),
          findsOneWidget,
        );

        // Tap "NO" button
        await tester.tap(
          find.byKey(const Key(AppTestKeys.closeAppDialogNoButton)),
        );
        await tester.pumpAndSettle();

        // Verify dialog is dismissed and user remains on Home tab
        expect(find.byKey(const Key(AppTestKeys.closeAppDialog)), findsNothing);
        expect(tester.widget<IndexedStack>(find.byType(IndexedStack)).index, 0);
      },
    );

    testWidgets(
      'confirms exit and dismisses dialog when Yes button is tapped',
      (WidgetTester tester) async {
        await pumpMainLayoutView(tester);

        // Trigger the dialog
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();

        expect(
          find.byKey(const Key(AppTestKeys.closeAppDialog)),
          findsOneWidget,
        );

        // Tap "Yes" button (triggers SystemNavigator.pop)
        await tester.tap(
          find.byKey(const Key(AppTestKeys.closeAppDialogYesButton)),
        );
        await tester.pumpAndSettle();

        // Verify dialog is closed without exception
        expect(find.byKey(const Key(AppTestKeys.closeAppDialog)), findsNothing);
      },
    );

    testWidgets(
      'does not show close app dialog on non-Android platform (e.g. iOS) when system back is pressed',
      (WidgetTester tester) async {
        await pumpMainLayoutView(tester, platform: TargetPlatform.iOS);

        // Simulate system back button on Home tab
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();

        // Verify confirmation dialog is NOT shown
        expect(find.byKey(const Key(AppTestKeys.closeAppDialog)), findsNothing);
      },
    );
  });
}
