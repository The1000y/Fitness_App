import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/core/constants/app_strings.dart';
import 'package:fitness_app/core/shared/custom_button.dart';
import 'package:fitness_app/core/shared/custom_text_form_field.dart';
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
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  setUp(() {
    fakeAuthRepo = FakeAuthRepo();
    if (getIt.isRegistered<LoginCubit>()) {
      getIt.reset();
    }
    getIt.registerFactory<LoginCubit>(() => LoginCubit(LoginUseCase(fakeAuthRepo)));
  });

  tearDown(() {
    getIt.reset();
  });

  group('LoginView Widget Tests', () {
    testWidgets('renders all UI components correctly', (tester) async {
      await tester.pumpApp(const LoginView());

      expect(find.text(AppStrings.loginTitleOne), findsOneWidget);
      expect(find.text(AppStrings.loginTitleTwo), findsOneWidget);
      expect(find.widgetWithText(CustomButton, AppStrings.login), findsOneWidget);
      expect(find.byType(CustomTextFormField), findsNWidgets(2));
      expect(find.text(AppStrings.forgotPassword), findsOneWidget);
      expect(find.text(AppStrings.or), findsOneWidget);
      expect(find.text(AppStrings.dontHaveAccount), findsOneWidget);
      expect(find.text(AppStrings.register), findsOneWidget);
      expect(find.bySemanticsLabel('Facebook'), findsOneWidget);
      expect(find.bySemanticsLabel('Google'), findsOneWidget);
      expect(find.bySemanticsLabel('Apple'), findsOneWidget);
    });

    testWidgets('empty submit shows validation errors and repo is not called', (tester) async {
      await tester.pumpApp(const LoginView());

      final loginButton = find.widgetWithText(CustomButton, AppStrings.login);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.text(l10n.emailRequired), findsOneWidget);
      expect(find.text(l10n.passwordRequired), findsOneWidget);
      expect(fakeAuthRepo.callCount, 0);
    });

    testWidgets('invalid email and short password show validation messages', (tester) async {
      await tester.pumpApp(const LoginView());

      final emailField = find.byType(CustomTextFormField).at(0);
      final passwordField = find.byType(CustomTextFormField).at(1);

      await tester.enterText(emailField, 'invalid-email');
      await tester.enterText(passwordField, '1234567');

      final loginButton = find.widgetWithText(CustomButton, AppStrings.login);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.text(l10n.emailInvalid), findsOneWidget);
      expect(find.text(l10n.passwordMinLength), findsOneWidget);
      expect(fakeAuthRepo.callCount, 0);
    });

    testWidgets('valid submit calls repo once with typed values', (tester) async {
      fakeAuthRepo.nextResult = Success(TestData.loginEntity);
      await tester.pumpApp(const LoginView());

      final emailField = find.byType(CustomTextFormField).at(0);
      final passwordField = find.byType(CustomTextFormField).at(1);

      await tester.enterText(emailField, TestData.validEmail);
      await tester.enterText(passwordField, TestData.validPassword);

      final loginButton = find.widgetWithText(CustomButton, AppStrings.login);
      await tester.tap(loginButton);
      await tester.pump(); // trigger loading

      expect(fakeAuthRepo.callCount, 1);
      expect(fakeAuthRepo.lastEmail, TestData.validEmail);
      expect(fakeAuthRepo.lastPassword, TestData.validPassword);
    });

    testWidgets('loading state prevents duplicate tap', (tester) async {
      final completer = Completer<BaseResponse<LoginEntity>>();
      fakeAuthRepo.completer = completer;

      await tester.pumpApp(const LoginView());

      final emailField = find.byType(CustomTextFormField).at(0);
      final passwordField = find.byType(CustomTextFormField).at(1);

      await tester.enterText(emailField, TestData.validEmail);
      await tester.enterText(passwordField, TestData.validPassword);

      final loginButton = find.byType(CustomButton);
      await tester.tap(loginButton);
      await tester.pump();

      expect(fakeAuthRepo.callCount, 1);

      // Tap again while loading
      await tester.tap(loginButton);
      await tester.pump();

      expect(fakeAuthRepo.callCount, 1); // ignored

      completer.complete(Success(TestData.loginEntity));
      await tester.pumpAndSettle();
    });

    testWidgets('success navigates to AppRoutes.home', (tester) async {
      fakeAuthRepo.nextResult = Success(TestData.loginEntity);
      await tester.pumpApp(const LoginView());

      await tester.enterText(find.byType(CustomTextFormField).at(0), TestData.validEmail);
      await tester.enterText(find.byType(CustomTextFormField).at(1), TestData.validPassword);

      await tester.tap(find.widgetWithText(CustomButton, AppStrings.login));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('failure shows SnackBar with mapped failure message', (tester) async {
      fakeAuthRepo.nextResult = const Error(InternetConnectionFailure());
      await tester.pumpApp(const LoginView());

      await tester.enterText(find.byType(CustomTextFormField).at(0), TestData.validEmail);
      await tester.enterText(find.byType(CustomTextFormField).at(1), TestData.validPassword);

      await tester.tap(find.widgetWithText(CustomButton, AppStrings.login));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('tapping forgot password and register navigates correctly', (tester) async {
      await tester.pumpApp(const LoginView());

      await tester.tap(find.text(AppStrings.forgotPassword));
      await tester.pumpAndSettle();
      expect(find.text('Forgot Password'), findsOneWidget);

      // Pop back
      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.register));
      await tester.pumpAndSettle();
      expect(find.text('Register'), findsOneWidget);
    });

    testWidgets('password visibility toggle obscures password field only', (tester) async {
      await tester.pumpApp(const LoginView());

      final editableTextFinder = find.byType(EditableText).at(1);

      EditableText editableText = tester.widget(editableTextFinder);
      expect(editableText.obscureText, true);

      // Tap eye icon suffix button
      final eyeIcon = find.byType(IconButton);
      if (eyeIcon.evaluate().isNotEmpty) {
        await tester.tap(eyeIcon.first);
        await tester.pump();
        editableText = tester.widget(find.byType(EditableText).at(1));
        expect(editableText.obscureText, false);
      }
    });

    testWidgets('layout robustness across sizes and keyboard inset', (tester) async {
      for (final size in [
        const Size(320, 568),
        const Size(360, 640),
        const Size(412, 915),
      ]) {
        await tester.pumpApp(const LoginView(), size: size);
        expect(find.byType(LoginView), findsOneWidget);
      }

      // With keyboard inset
      await tester.pumpApp(const LoginView());
      tester.view.viewInsets = FakeViewPadding(bottom: 300, top: 0, left: 0, right: 0);
      await tester.pump();
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -200));
      await tester.pump();
      expect(find.widgetWithText(CustomButton, AppStrings.login), findsOneWidget);
      tester.view.viewInsets = FakeViewPadding.zero;
    });

    testWidgets('RTL layout renders without exception', (tester) async {
      await tester.pumpApp(const LoginView(), locale: const Locale('ar'));
      expect(find.byType(LoginView), findsOneWidget);
    });
  });
}
