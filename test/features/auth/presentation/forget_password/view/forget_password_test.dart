import 'dart:async';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/core/shared/custom_button.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/manager/forget_password_cubit.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/manager/forget_password_event.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/manager/forget_password_state.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/view/forget_password.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:fitness_app/l10n/app_localizations_en.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockForgetPasswordCubit extends Mock implements ForgetPasswordCubit {}

Widget buildTestScreen({
  required ForgetPasswordCubit cubit,
}) {
  return ScreenUtilPlusInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<ForgetPasswordCubit>.value(
        value: cubit,
        child: const ForgetPassword(),
      ),
    ),
  );
}

void main() {
  late MockForgetPasswordCubit mockCubit;
  late StreamController<BaseUiEvent> uiEventController;
  late StreamController<ForgetPasswordState> stateController;
  final l10n = AppLocalizationsEn();

  setUpAll(() {
    registerFallbackValue(const SendCodeEvent('fallback@example.com'));
  });

  setUp(() {
    mockCubit = MockForgetPasswordCubit();
    uiEventController = StreamController<BaseUiEvent>.broadcast();
    stateController = StreamController<ForgetPasswordState>.broadcast();

    when(() => mockCubit.uiEventStream).thenAnswer((_) => uiEventController.stream);
    when(() => mockCubit.stream).thenAnswer((_) => stateController.stream);
    when(() => mockCubit.state).thenReturn(const ForgetPasswordState());
    when(() => mockCubit.doEvent(any())).thenAnswer((_) async {});
  });

  tearDown(() {
    uiEventController.close();
    stateController.close();
  });

  group('ForgetPassword Screen', () {
    testWidgets('renders initial UI elements properly', (tester) async {
      await tester.pumpWidget(buildTestScreen(cubit: mockCubit));
      await tester.pumpAndSettle();

      expect(find.text(l10n.forgotPassword), findsOneWidget);
      expect(find.text(l10n.enterYourEmail), findsOneWidget);
      expect(find.text(l10n.sendOtp), findsOneWidget);
      expect(find.byType(CustomButton), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('shows validation error when tapping Send OTP with empty email', (tester) async {
      await tester.pumpWidget(buildTestScreen(cubit: mockCubit));
      await tester.pumpAndSettle();

      await tester.tap(find.text(l10n.sendOtp));
      await tester.pumpAndSettle();

      expect(find.text(l10n.emailRequired), findsOneWidget);
      verifyNever(() => mockCubit.doEvent(any()));
    });

    testWidgets('shows validation error when email format is invalid', (tester) async {
      await tester.pumpWidget(buildTestScreen(cubit: mockCubit));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'invalid_email');
      await tester.tap(find.text(l10n.sendOtp));
      await tester.pumpAndSettle();

      expect(find.text(l10n.emailInvalid), findsOneWidget);
      verifyNever(() => mockCubit.doEvent(any()));
    });

    testWidgets('triggers SendCodeEvent when valid email is submitted', (tester) async {
      await tester.pumpWidget(buildTestScreen(cubit: mockCubit));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'user@example.com');
      await tester.tap(find.text(l10n.sendOtp));
      await tester.pumpAndSettle();

      verify(
        () => mockCubit.doEvent(
          any(that: isA<SendCodeEvent>().having((e) => e.email, 'email', 'user@example.com')),
        ),
      ).called(1);
    });

    testWidgets('displays loading indicator on button when forgetPasswordState is loading', (tester) async {
      when(() => mockCubit.state).thenReturn(
        const ForgetPasswordState(
          forgetPasswordState: BaseState<void>(isLoading: true),
        ),
      );

      await tester.pumpWidget(buildTestScreen(cubit: mockCubit));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
