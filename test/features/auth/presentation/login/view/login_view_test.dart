import 'package:fitness_app/config/routing/app_routes.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/core/shared/custom_button.dart';
import 'package:fitness_app/core/shared/custom_text_form_field.dart';
import 'package:fitness_app/features/app/presentation/cubit/auth/app_auth_cubit.dart';
import 'package:fitness_app/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:fitness_app/features/auth/domain/use_cases/login_use_case.dart';
import 'package:fitness_app/features/auth/presentation/login/manager/login_cubit.dart';
import 'package:fitness_app/features/auth/presentation/login/view/login_view.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import '../../../../../helpers/fakes.dart';
import '../../../../../helpers/pump_app.dart';
import '../../../../../helpers/test_data.dart';

void main() {
  late FakeAuthRepo fakeAuthRepo;
  late InMemorySecureStorage storage;
  late AppAuthCubit appAuthCubit;
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  setUp(() {
    storage = InMemorySecureStorage();
    appAuthCubit = AppAuthCubit(storage);
    fakeAuthRepo = FakeAuthRepo();
    getIt.registerFactory<LoginCubit>(
      () => LoginCubit(LoginUseCase(fakeAuthRepo), appAuthCubit),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  Future<void> pumpLogin(
    WidgetTester tester, {
    Locale locale = const Locale('en'),
    Size size = const Size(375, 812),
    Map<String, WidgetBuilder>? routes,
  }) {
    return tester.pumpApp(
      const LoginView(),
      locale: locale,
      size: size,
      routes: {
        AppRoutes.main: (_) => Scaffold(body: Text(l10n.explore)),
        AppRoutes.forgotPassword: (_) =>
            Scaffold(appBar: AppBar(title: const Text('Forgot Password'))),
        AppRoutes.register: (_) =>
            Scaffold(appBar: AppBar(title: const Text('Register'))),
        ...?routes,
      },
    );
  }

  group('LoginView Widget Tests', () {
    testWidgets('renders all UI components correctly', (tester) async {
      await pumpLogin(tester);

      expect(find.text(l10n.loginTitleOne), findsOneWidget);
      expect(find.text(l10n.loginTitleTwo), findsOneWidget);
      expect(find.widgetWithText(CustomButton, l10n.login), findsOneWidget);
      expect(find.byType(CustomTextFormField), findsNWidgets(2));
      expect(find.text(l10n.forgotPassword), findsOneWidget);
      expect(find.text(l10n.or), findsOneWidget);
      expect(find.text(l10n.dontHaveAccount), findsOneWidget);
      expect(find.text(l10n.register), findsOneWidget);
      expect(find.bySemanticsLabel('Facebook'), findsOneWidget);
      expect(find.bySemanticsLabel('Google'), findsOneWidget);
      expect(find.bySemanticsLabel('Apple'), findsOneWidget);
    });

    testWidgets('empty submit shows validation errors and repo is not called', (
      tester,
    ) async {
      await pumpLogin(tester);

      final loginButton = find.widgetWithText(CustomButton, l10n.login);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.text(l10n.emailRequired), findsOneWidget);
      expect(find.text(l10n.passwordRequired), findsOneWidget);
      expect(fakeAuthRepo.callCount, 0);
    });

    testWidgets('invalid email and short password show validation messages', (
      tester,
    ) async {
      await pumpLogin(tester);

      final emailField = find.byType(CustomTextFormField).at(0);
      final passwordField = find.byType(CustomTextFormField).at(1);

      await tester.enterText(emailField, 'invalid-email');
      await tester.enterText(passwordField, '1234567');

      final loginButton = find.widgetWithText(CustomButton, l10n.login);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.text(l10n.emailInvalid), findsOneWidget);
      expect(find.text(l10n.passwordMinLength), findsOneWidget);
      expect(fakeAuthRepo.callCount, 0);
    });

    testWidgets('valid submit calls repo once with typed values', (
      tester,
    ) async {
      final completer = Completer<BaseResponse<LoginEntity>>();
      fakeAuthRepo.completer = completer;
      await pumpLogin(tester);

      final emailField = find.byType(CustomTextFormField).at(0);
      final passwordField = find.byType(CustomTextFormField).at(1);

      await tester.enterText(emailField, TestData.validEmail);
      await tester.enterText(passwordField, TestData.validPassword);

      final loginButton = find.widgetWithText(CustomButton, l10n.login);
      await tester.tap(loginButton);
      await tester.pump(); // trigger loading

      expect(fakeAuthRepo.callCount, 1);
      expect(fakeAuthRepo.lastEmail, TestData.validEmail);
      expect(fakeAuthRepo.lastPassword, TestData.validPassword);

      completer.complete(Success(TestData.loginEntity));
      await tester.pumpAndSettle();
    });

    testWidgets(
      'loading state prevents duplicate tap and handles failure correctly',
      (tester) async {
        final completer = Completer<BaseResponse<LoginEntity>>();
        fakeAuthRepo.completer = completer;

        await pumpLogin(tester);

        final emailField = find.byType(CustomTextFormField).at(0);
        final passwordField = find.byType(CustomTextFormField).at(1);

        await tester.enterText(emailField, TestData.validEmail);
        await tester.enterText(passwordField, TestData.validPassword);

        final loginButton = find.byType(CustomButton);
        await tester.tap(loginButton);
        await tester.pump();

        expect(fakeAuthRepo.callCount, 1);
        expect(
          tester.widget<CustomButton>(find.byType(CustomButton)).isLoading,
          true,
        );

        // Tap again while loading (ignored)
        await tester.tap(loginButton);
        await tester.pump();
        expect(fakeAuthRepo.callCount, 1);

        completer.complete(const Error(InternetConnectionFailure()));
        await tester.pumpAndSettle();

        expect(
          tester.widget<CustomButton>(find.byType(CustomButton)).isLoading,
          false,
        );
        expect(fakeAuthRepo.callCount, 1);
      },
    );

    testWidgets('success navigates to AppRoutes.home', (tester) async {
      fakeAuthRepo.nextResult = Success(TestData.loginEntity);
      await pumpLogin(tester);

      await tester.enterText(
        find.byType(CustomTextFormField).at(0),
        TestData.validEmail,
      );
      await tester.enterText(
        find.byType(CustomTextFormField).at(1),
        TestData.validPassword,
      );

      await tester.tap(find.widgetWithText(CustomButton, l10n.login));
      await tester.pumpAndSettle();

      expect(find.text(l10n.explore), findsOneWidget);
    });

    testWidgets(
      'failure shows SnackBar with InternetConnectionFailure message',
      (tester) async {
        fakeAuthRepo.nextResult = const Error(InternetConnectionFailure());
        await pumpLogin(tester);

        await tester.enterText(
          find.byType(CustomTextFormField).at(0),
          TestData.validEmail,
        );
        await tester.enterText(
          find.byType(CustomTextFormField).at(1),
          TestData.validPassword,
        );

        await tester.tap(find.widgetWithText(CustomButton, l10n.login));
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(SnackBar),
            matching: find.text(l10n.failureInternetConnection),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets('failure shows SnackBar with UnauthorizedFailure message', (
      tester,
    ) async {
      fakeAuthRepo.nextResult = const Error(UnauthorizedFailure());
      await pumpLogin(tester);

      await tester.enterText(
        find.byType(CustomTextFormField).at(0),
        TestData.validEmail,
      );
      await tester.enterText(
        find.byType(CustomTextFormField).at(1),
        TestData.validPassword,
      );

      await tester.tap(find.widgetWithText(CustomButton, l10n.login));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(SnackBar),
          matching: find.text(l10n.failureUnauthorized),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      'failure shows SnackBar with custom server message on BadRequestFailure',
      (tester) async {
        fakeAuthRepo.nextResult = const Error(
          BadRequestFailure(serverMessage: 'Custom server message'),
        );
        await pumpLogin(tester);

        await tester.enterText(
          find.byType(CustomTextFormField).at(0),
          TestData.validEmail,
        );
        await tester.enterText(
          find.byType(CustomTextFormField).at(1),
          TestData.validPassword,
        );

        await tester.tap(find.widgetWithText(CustomButton, l10n.login));
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(SnackBar),
            matching: find.text('Custom server message'),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets('tapping forgot password and register navigates correctly', (
      tester,
    ) async {
      await pumpLogin(tester);

      await tester.tap(find.text(l10n.forgotPassword));
      await tester.pumpAndSettle();
      expect(find.text('Forgot Password'), findsOneWidget);

      // Pop back
      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.tap(find.text(l10n.register));
      await tester.pumpAndSettle();
      expect(find.text('Register'), findsOneWidget);
    });

    testWidgets('password visibility toggle obscures password field only', (
      tester,
    ) async {
      await pumpLogin(tester);

      final emailEditableText = tester.widget<EditableText>(
        find.byType(EditableText).at(0),
      );
      expect(emailEditableText.obscureText, false);

      final passwordEditableText = tester.widget<EditableText>(
        find.byType(EditableText).at(1),
      );
      expect(passwordEditableText.obscureText, true);

      // Tap eye icon to reveal password
      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pump();

      var updatedPasswordText = tester.widget<EditableText>(
        find.byType(EditableText).at(1),
      );
      expect(updatedPasswordText.obscureText, false);
      expect(
        tester
            .widget<EditableText>(find.byType(EditableText).at(0))
            .obscureText,
        false,
      );

      // Tap again to hide password
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();

      updatedPasswordText = tester.widget<EditableText>(
        find.byType(EditableText).at(1),
      );
      expect(updatedPasswordText.obscureText, true);
    });

    testWidgets('layout robustness across sizes and keyboard inset', (
      tester,
    ) async {
      for (final size in [
        const Size(320, 568),
        const Size(360, 640),
        const Size(412, 915),
      ]) {
        await pumpLogin(tester, size: size);
        expect(find.byType(LoginView), findsOneWidget);
      }

      // With keyboard inset
      await pumpLogin(tester);

      // viewInsets are in PHYSICAL pixels, so scale the 300 logical px.
      const keyboardHeight = 300.0;
      tester.view.viewInsets = FakeViewPadding(
        bottom: keyboardHeight * tester.view.devicePixelRatio,
      );
      addTearDown(tester.view.resetViewInsets);
      await tester.pump();

      final loginButton = find.widgetWithText(CustomButton, l10n.login);
      await tester.ensureVisible(loginButton);
      await tester.pump();

      final logicalScreenHeight =
          tester.view.physicalSize.height / tester.view.devicePixelRatio;
      expect(
        tester.getRect(loginButton).bottom,
        lessThanOrEqualTo(logicalScreenHeight - keyboardHeight),
      );
    });

    testWidgets('RTL and LTR layout alignments and directions', (tester) async {
      final englishL10n = await AppLocalizations.delegate.load(
        const Locale('en'),
      );
      final arabicL10n = await AppLocalizations.delegate.load(
        const Locale('ar'),
      );

      await pumpLogin(tester, locale: const Locale('en'));

      final logicalWidth =
          tester.view.physicalSize.width / tester.view.devicePixelRatio;
      final ltrForgotPassword = find.text(englishL10n.forgotPassword);
      expect(ltrForgotPassword, findsOneWidget);
      expect(
        Directionality.of(tester.element(ltrForgotPassword)),
        TextDirection.ltr,
      );
      expect(
        tester.getRect(ltrForgotPassword).center.dx,
        greaterThan(logicalWidth / 2),
      );

      await pumpLogin(tester, locale: const Locale('ar'));

      final rtlForgotPassword = find.text(arabicL10n.forgotPassword);
      expect(rtlForgotPassword, findsOneWidget);
      expect(
        Directionality.of(tester.element(rtlForgotPassword)),
        TextDirection.rtl,
      );
      expect(
        tester.getRect(rtlForgotPassword).center.dx,
        lessThan(logicalWidth / 2),
      );
    });
  });
}
