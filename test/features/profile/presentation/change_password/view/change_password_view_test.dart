import 'dart:async';

import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/profile/domain/entities/params/change_password_param.dart';
import 'package:fitness_app/features/profile/domain/use_cases/profile_change_password_use_case.dart';
import 'package:fitness_app/features/profile/presentation/change_password/manager/change_password_cubit.dart';
import 'package:fitness_app/features/profile/presentation/change_password/view/change_password_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/pump_app.dart';

class MockProfileChangePasswordUseCase extends Mock
    implements ProfileChangePasswordUseCase {}

void main() {
  late MockProfileChangePasswordUseCase useCase;

  const oldPassword = 'Old@1234';
  const newPassword = 'New@1234';

  setUpAll(() {
    registerFallbackValue(
      const ChangePasswordParam(oldPassword: 'a', newPassword: 'b'),
    );
  });

  setUp(() => useCase = MockProfileChangePasswordUseCase());

  /// Opens the screen from a host page so that a successful submit can pop it.
  Future<void> openScreen(WidgetTester tester) async {
    await tester.pumpApp(
      Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => BlocProvider(
                    create: (_) => ChangePasswordCubit(useCase),
                    child: const ChangePasswordView(),
                  ),
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  Future<void> fill(
    WidgetTester tester, {
    String old = oldPassword,
    String next = newPassword,
    String confirm = newPassword,
  }) async {
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), old);
    await tester.enterText(fields.at(1), next);
    await tester.enterText(fields.at(2), confirm);
  }

  Future<void> submit(WidgetTester tester) async {
    final button = find.byType(ElevatedButton);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();
  }

  group('ChangePasswordView', () {
    testWidgets('renders_titleHintThreeFieldsAndDoneButton', (tester) async {
      await openScreen(tester);

      expect(find.text('Create new password'), findsOneWidget);
      expect(find.text("Make sure it's 8 characters or more"), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.text('Old password'), findsOneWidget);
      expect(find.text('New password'), findsOneWidget);
      expect(find.text('Confirm password'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('emptySubmit_showsRequiredErrorsAndSkipsUseCase', (
      tester,
    ) async {
      await openScreen(tester);

      await submit(tester);

      expect(find.text('Password is required'), findsNWidgets(2));
      expect(find.text('Please confirm your password'), findsOneWidget);
      verifyNever(() => useCase(any()));
    });

    testWidgets('weakNewPassword_showsStrongRulesError', (tester) async {
      await openScreen(tester);

      await fill(tester, next: 'weakpass', confirm: 'weakpass');
      await submit(tester);

      expect(
        find.text(
          'Password must include uppercase, lowercase, a number and a '
          'special character',
        ),
        findsOneWidget,
      );
      verifyNever(() => useCase(any()));
    });

    testWidgets('newPasswordSameAsOld_showsDifferentPasswordError', (
      tester,
    ) async {
      await openScreen(tester);

      await fill(tester, next: oldPassword, confirm: oldPassword);
      await submit(tester);

      expect(
        find.text('New password must be different from the old password'),
        findsOneWidget,
      );
      verifyNever(() => useCase(any()));
    });

    testWidgets('confirmMismatch_showsMismatchError', (tester) async {
      await openScreen(tester);

      await fill(tester, confirm: 'Other@1234');
      await submit(tester);

      expect(find.text('Passwords do not match'), findsOneWidget);
      verifyNever(() => useCase(any()));
    });

    testWidgets('eyeIcon_togglesPasswordVisibility', (tester) async {
      await openScreen(tester);

      expect(find.byIcon(Icons.visibility_off_outlined), findsNWidgets(3));

      await tester.tap(find.byIcon(Icons.visibility_off_outlined).first);
      await tester.pump();

      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off_outlined), findsNWidgets(2));
    });

    testWidgets('validSubmit_success_popsScreenAndShowsSnackBar', (
      tester,
    ) async {
      when(
        () => useCase(any()),
      ).thenAnswer((_) async => const Success<void>(null));
      await openScreen(tester);

      await fill(tester);
      await submit(tester);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      verify(
        () => useCase(
          const ChangePasswordParam(
            oldPassword: oldPassword,
            newPassword: newPassword,
          ),
        ),
      ).called(1);
      expect(find.byType(ChangePasswordView), findsNothing);
      expect(find.text('Password changed successfully'), findsOneWidget);
    });

    testWidgets('validSubmit_failure_staysAndShowsServerMessage', (
      tester,
    ) async {
      when(() => useCase(any())).thenAnswer(
        (_) async => const Error<void>(
          BadRequestFailure(serverMessage: 'Incorrect password'),
        ),
      );
      await openScreen(tester);

      await fill(tester);
      await submit(tester);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(ChangePasswordView), findsOneWidget);
      expect(find.text('Incorrect password'), findsOneWidget);
    });

    testWidgets('submitInFlight_showsLoaderAndDisablesButton', (tester) async {
      final completer = Completer<BaseResponse<void>>();
      when(() => useCase(any())).thenAnswer((_) => completer.future);
      await openScreen(tester);

      await fill(tester);
      await submit(tester);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);

      completer.complete(const Error<void>(ServerFailure()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('arabicLocale_rendersLocalizedTitle', (tester) async {
      await tester.pumpApp(
        BlocProvider(
          create: (_) => ChangePasswordCubit(useCase),
          child: const ChangePasswordView(),
        ),
        locale: const Locale('ar'),
      );
      await tester.pumpAndSettle();

      expect(find.text('Create new password'), findsNothing);
      expect(find.byType(TextFormField), findsNWidgets(3));
    });
  });
}
