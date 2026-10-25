import 'package:fitness_app/config/routing/app_routes.dart';
import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/constants/app_test_keys.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:fitness_app/core/shared/custom_blur_card.dart';
import 'package:fitness_app/features/auth/presentation/onboarding/views/onboarding_view.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:fitness_app/l10n/app_localizations_en.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() {
  final l10n = AppLocalizationsEn();

  Future<void> pumpOnboardingView(WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ScreenUtilPlusInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const OnboardingView(),
          routes: {
            AppRoutes.login: (context) =>
                const Scaffold(body: Text('Login Screen')),
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  void expectOnboardingPage({
    required int pageIndex,
    required String expectedTitle,
    required String expectedImage,
    required bool expectSkipButton,
    required bool expectBackButton,
  }) {
    expect(find.text(expectedTitle), findsOneWidget);
    expect(find.text(l10n.onboardingDescription), findsOneWidget);

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is AnimatedSmoothIndicator &&
            widget.count == 3 &&
            widget.activeIndex == pageIndex,
      ),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName == expectedImage,
      ),
      findsOneWidget,
    );

    expect(
      find.byKey(const Key(AppTestKeys.onboardingNextButton)),
      findsOneWidget,
    );

    if (expectSkipButton) {
      expect(
        find.byKey(const Key(AppTestKeys.onboardingSkipButton)),
        findsOneWidget,
      );
    } else {
      expect(
        find.byKey(const Key(AppTestKeys.onboardingSkipButton)),
        findsNothing,
      );
    }

    if (expectBackButton) {
      expect(
        find.byKey(const Key(AppTestKeys.onboardingBackButton)),
        findsOneWidget,
      );
    } else {
      expect(
        find.byKey(const Key(AppTestKeys.onboardingBackButton)),
        findsNothing,
      );
    }
  }

  group('OnboardingView Rendering and Static Shell', () {
    testWidgets('renders background image, blur card, and PageView shell', (
      WidgetTester tester,
    ) async {
      await pumpOnboardingView(tester);

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is CustomBackgroundImage &&
              widget.backgroundImage == AppImages.onboardingBackground,
        ),
        findsOneWidget,
      );
      expect(find.byType(CustomBlurCard), findsOneWidget);
      expect(
        find.byKey(const Key(AppTestKeys.onboardingPageView)),
        findsOneWidget,
      );
    });

    testWidgets(
      'renders first page with skip and next buttons, without back button',
      (WidgetTester tester) async {
        await pumpOnboardingView(tester);

        expectOnboardingPage(
          pageIndex: 0,
          expectedTitle: l10n.onboardingTitle1,
          expectedImage: AppImages.avatar(31),
          expectSkipButton: true,
          expectBackButton: false,
        );
      },
    );
  });

  group('OnboardingView Navigation Flows', () {
    testWidgets(
      'navigates forward through all pages sequentially using Next button',
      (WidgetTester tester) async {
        await pumpOnboardingView(tester);

        expectOnboardingPage(
          pageIndex: 0,
          expectedTitle: l10n.onboardingTitle1,
          expectedImage: AppImages.avatar(31),
          expectSkipButton: true,
          expectBackButton: false,
        );

        await tester.tap(
          find.byKey(const Key(AppTestKeys.onboardingNextButton)),
        );
        await tester.pumpAndSettle();

        expectOnboardingPage(
          pageIndex: 1,
          expectedTitle: l10n.onboardingTitle2,
          expectedImage: AppImages.avatar(30),
          expectSkipButton: true,
          expectBackButton: true,
        );

        await tester.tap(
          find.byKey(const Key(AppTestKeys.onboardingNextButton)),
        );
        await tester.pumpAndSettle();

        expectOnboardingPage(
          pageIndex: 2,
          expectedTitle: l10n.onboardingTitle3,
          expectedImage: AppImages.avatar(29),
          expectSkipButton: false,
          expectBackButton: true,
        );

        await tester.tap(
          find.byKey(const Key(AppTestKeys.onboardingNextButton)),
        );
        await tester.pumpAndSettle();

        expect(find.text('Login Screen'), findsOneWidget);
        expect(find.byType(OnboardingView), findsNothing);
      },
    );

    testWidgets('navigates back to previous page using Back button', (
      WidgetTester tester,
    ) async {
      await pumpOnboardingView(tester);

      await tester.tap(find.byKey(const Key(AppTestKeys.onboardingNextButton)));
      await tester.pumpAndSettle();

      expectOnboardingPage(
        pageIndex: 1,
        expectedTitle: l10n.onboardingTitle2,
        expectedImage: AppImages.avatar(30),
        expectSkipButton: true,
        expectBackButton: true,
      );

      await tester.tap(find.byKey(const Key(AppTestKeys.onboardingBackButton)));
      await tester.pumpAndSettle();

      expectOnboardingPage(
        pageIndex: 0,
        expectedTitle: l10n.onboardingTitle1,
        expectedImage: AppImages.avatar(31),
        expectSkipButton: true,
        expectBackButton: false,
      );
    });

    testWidgets(
      'jumps directly to final page and hides Skip button when Skip is tapped',
      (WidgetTester tester) async {
        await pumpOnboardingView(tester);

        expect(find.text(l10n.onboardingTitle1), findsOneWidget);

        await tester.tap(
          find.byKey(const Key(AppTestKeys.onboardingSkipButton)),
        );
        await tester.pumpAndSettle();

        expectOnboardingPage(
          pageIndex: 2,
          expectedTitle: l10n.onboardingTitle3,
          expectedImage: AppImages.avatar(29),
          expectSkipButton: false,
          expectBackButton: true,
        );
      },
    );

    testWidgets('swiping PageView updates page content and active indicator', (
      WidgetTester tester,
    ) async {
      await pumpOnboardingView(tester);

      await tester.flingFrom(
        const Offset(187.5, 200),
        const Offset(-300, 0),
        1000,
      );
      await tester.pumpAndSettle();

      expectOnboardingPage(
        pageIndex: 1,
        expectedTitle: l10n.onboardingTitle2,
        expectedImage: AppImages.avatar(30),
        expectSkipButton: true,
        expectBackButton: true,
      );

      await tester.flingFrom(
        const Offset(187.5, 200),
        const Offset(300, 0),
        1000,
      );
      await tester.pumpAndSettle();

      expectOnboardingPage(
        pageIndex: 0,
        expectedTitle: l10n.onboardingTitle1,
        expectedImage: AppImages.avatar(31),
        expectSkipButton: true,
        expectBackButton: false,
      );
    });
  });
}
