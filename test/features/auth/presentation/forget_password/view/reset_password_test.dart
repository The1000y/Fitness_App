import 'dart:async';
import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/config/routing/app_routes.dart';
import 'package:fitness_app/core/shared/base_ui_event_listener.dart';
import 'package:fitness_app/core/shared/custom_button.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/manager/forget_password_cubit.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/manager/forget_password_event.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/manager/forget_password_state.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/view/reset_password.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockForgetPasswordCubit extends Mock implements ForgetPasswordCubit {}

Widget buildTestScreen({
  required ForgetPasswordCubit cubit,
  Map<String, WidgetBuilder>? routes,
  Locale? locale,
}) {
  return ScreenUtilPlusInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    child: MaterialApp(
      routes: routes ?? {},
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
        child: BaseUiEventListener<ForgetPasswordCubit, ForgetPasswordState, BaseUiEvent>(
          child: const ResetPassword(),
        ),
      ),
    ),
  );
}

void main() {
  late MockForgetPasswordCubit mockCubit;
  late StreamController<BaseUiEvent> uiEventController;
  late StreamController<ForgetPasswordState> stateController;

  setUpAll(() {
    registerFallbackValue(const ResetPasswordEvent('Password123!'));
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

  AppLocalizations getL10n(WidgetTester tester) {
    final element = tester.element(find.byType(ResetPassword));
    return AppLocalizations.of(element)!;
  }

  group('ResetPassword Screen', () {
    testWidgets('renders initial UI elements properly', (tester) async {
      await tester.pumpWidget(buildTestScreen(cubit: mockCubit));
      await tester.pumpAndSettle();
      final l10n = getL10n(tester);

      expect(find.text(l10n.createNewPassword), findsOneWidget);
      expect(find.text(l10n.passwordLengthHint), findsOneWidget);
      expect(find.text(l10n.confirm), findsOneWidget);
      expect(find.byType(CustomButton), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('shows validation error when passwords are empty', (tester) async {
      await tester.pumpWidget(buildTestScreen(cubit: mockCubit));
      await tester.pumpAndSettle();
      final l10n = getL10n(tester);
      await tester.tap(find.text(l10n.confirm));
      await tester.pumpAndSettle();

      expect(find.text(l10n.passwordRequired), findsOneWidget);
      expect(find.text(l10n.confirmPasswordRequired), findsOneWidget);
      verifyNever(() => mockCubit.doEvent(any()));
    });

    testWidgets('shows validation error when confirm password does not match', (tester) async {
      await tester.pumpWidget(buildTestScreen(cubit: mockCubit));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Password123!');
      await tester.enterText(textFields.at(1), 'Different123!');
      final l10n = getL10n(tester);
      await tester.tap(find.text(l10n.confirm));
      await tester.pumpAndSettle();

      expect(find.text(l10n.confirmPasswordMismatch), findsOneWidget);
      verifyNever(() => mockCubit.doEvent(any()));
    });

    testWidgets('triggers ResetPasswordEvent when valid matching passwords are submitted', (tester) async {
      await tester.pumpWidget(buildTestScreen(cubit: mockCubit));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Password123!');
      await tester.enterText(textFields.at(1), 'Password123!');
      final l10n = getL10n(tester);
      await tester.tap(find.text(l10n.confirm));
      await tester.pumpAndSettle();

      verify(
        () => mockCubit.doEvent(
          any(
            that: isA<ResetPasswordEvent>().having(
              (e) => e.newPassword,
              'newPassword',
              'Password123!',
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets('navigates to login on NavigateAndRemoveUntil event', (tester) async {
      bool loginPushed = false;

      await tester.pumpWidget(
        buildTestScreen(
          cubit: mockCubit,
          routes: {
            AppRoutes.login: (context) {
              loginPushed = true;
              return const Scaffold(body: Text('Login Screen'));
            },
          },
        ),
      );
      await tester.pumpAndSettle();

      uiEventController.add(const NavigateAndRemoveUntil(AppRoutes.login));
      await tester.pumpAndSettle();

      expect(loginPushed, isTrue);
      expect(find.text('Login Screen'), findsOneWidget);
    });

    testWidgets('displays loading indicator on button when resetPasswordState is loading', (tester) async {
      when(() => mockCubit.state).thenReturn(
        const ForgetPasswordState(
          resetPasswordState: BaseState<void>(isLoading: true),
        ),
      );

      await tester.pumpWidget(buildTestScreen(cubit: mockCubit));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
