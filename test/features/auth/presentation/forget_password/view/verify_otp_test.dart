import 'dart:async';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/core/shared/custom_button.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/manager/forget_password_cubit.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/manager/forget_password_event.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/manager/forget_password_state.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/view/verify_otp.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinput/pinput.dart';

class MockForgetPasswordCubit extends Mock implements ForgetPasswordCubit {}

Widget buildTestScreen({required ForgetPasswordCubit cubit, Locale? locale}) {
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
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<ForgetPasswordCubit>.value(
        value: cubit,
        child: const VerifyOtp(),
      ),
    ),
  );
}

void main() {
  late MockForgetPasswordCubit mockCubit;
  late StreamController<BaseUiEvent> uiEventController;
  late StreamController<ForgetPasswordState> stateController;

  setUpAll(() {
    registerFallbackValue(const VerifyOtpEvent('0000'));
  });

  setUp(() {
    mockCubit = MockForgetPasswordCubit();
    uiEventController = StreamController<BaseUiEvent>.broadcast();
    stateController = StreamController<ForgetPasswordState>.broadcast();

    when(
      () => mockCubit.uiEventStream,
    ).thenAnswer((_) => uiEventController.stream);
    when(() => mockCubit.stream).thenAnswer((_) => stateController.stream);
    when(() => mockCubit.state).thenReturn(const ForgetPasswordState());
    when(() => mockCubit.doEvent(any())).thenAnswer((_) async {});
  });

  tearDown(() {
    uiEventController.close();
    stateController.close();
  });
  AppLocalizations getl10n(WidgetTester tester) {
    final element = tester.element(find.byType((VerifyOtp)));
    return AppLocalizations.of(element)!;
  }

  group('VerifyOtp Screen', () {
    testWidgets('renders initial UI elements properly', (tester) async {
      await tester.pumpWidget(buildTestScreen(cubit: mockCubit));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final l10n = getl10n(tester);

      expect(find.text(l10n.otpCode), findsOneWidget);
      expect(find.text(l10n.enterYourOtp), findsOneWidget);
      expect(find.text(l10n.confirm), findsOneWidget);
      expect(find.text(l10n.didntReceiveCode), findsOneWidget);
      expect(find.text(l10n.resendCode), findsOneWidget);
      expect(find.byType(Pinput), findsOneWidget);
      expect(find.byType(CustomButton), findsOneWidget);
    });

    testWidgets('shows validation error when confirming with empty OTP', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestScreen(cubit: mockCubit));
      await tester.pump();
      final l10n = getl10n(tester);
      await tester.tap(find.text(l10n.confirm));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text(l10n.otpRequired), findsOneWidget);
      verifyNever(() => mockCubit.doEvent(any()));
    });

    testWidgets(
      'shows validation error when confirming with incomplete OTP (<4 digits)',
      (tester) async {
        await tester.pumpWidget(buildTestScreen(cubit: mockCubit));
        await tester.pump();

        await tester.enterText(find.byType(Pinput), '12');
        await tester.pump();
        final l10n = getl10n(tester);
        await tester.tap(find.text(l10n.confirm));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text(l10n.otpIncomplete), findsOneWidget);
        verifyNever(() => mockCubit.doEvent(any()));
      },
    );

    testWidgets(
      'triggers VerifyOtpEvent when valid 4-digit code is submitted',
      (tester) async {
        await tester.pumpWidget(buildTestScreen(cubit: mockCubit));
        await tester.pump();

        await tester.enterText(find.byType(Pinput), '1234');
        await tester.pump();
        final l10n = getl10n(tester);
        await tester.tap(find.text(l10n.confirm));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        verify(
          () => mockCubit.doEvent(
            any(
              that: isA<VerifyOtpEvent>().having((e) => e.code, 'code', '1234'),
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'displays loading indicator on button when verifyOtpState is loading',
      (tester) async {
        when(() => mockCubit.state).thenReturn(
          const ForgetPasswordState(
            verifyOtpState: BaseState<void>(isLoading: true),
          ),
        );

        await tester.pumpWidget(buildTestScreen(cubit: mockCubit));
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.pump(const Duration(milliseconds: 400));
      },
    );
  });
}
