import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/config/routing/app_routes.dart';
import 'package:fitness_app/features/auth/domain/entities/register_entity/register_request_entity.dart';
import 'package:fitness_app/features/auth/domain/entities/register_entity/register_response_entity.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_cubit.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_state.dart';
import 'package:fitness_app/features/auth/presentation/register/view/register_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/register_test_helpers.dart';

void main() {
  late RegisterCubit cubit;
  late MockRegisterUseCase useCase;

  setUpAll(() {
    registerFallbackValue(RegisterRequestEntity());
  });

  setUp(() async {
    await getIt.reset();
    useCase = MockRegisterUseCase();
    when(() => useCase(any())).thenAnswer(
      (_) async => Success(RegisterResponeEntity(message: 'Account created')),
    );
    cubit = RegisterCubit(ucase: useCase);
    getIt.registerFactory<RegisterCubit>(() => cubit);
  });

  tearDown(() async {
    await cubit.close();
    await getIt.reset();
  });

  Future<void> pumpRegisterView(WidgetTester tester) {
    return pumpRegisterWidget(
      tester,
      const RegisterView(),
      routes: {
        AppRoutes.login: (_) => const Scaffold(body: Text('Login page')),
      },
    );
  }

  Future<void> submitCredentials(WidgetTester tester) async {
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Ahmed');
    await tester.enterText(fields.at(1), 'Ali');
    await tester.enterText(fields.at(2), 'ahmed@example.com');
    await tester.enterText(fields.at(3), 'Password1!');

    final registerButton = find.widgetWithText(ElevatedButton, 'Register');
    await tester.ensureVisible(registerButton);
    await tester.tap(registerButton);
    await tester.pumpAndSettle();
  }

  testWidgets('completes the registration flow and navigates to login', (
    tester,
  ) async {
    await pumpRegisterView(tester);
    await tester.pumpAndSettle();

    await submitCredentials(tester);
    expect(find.text('TELL US ABOUT YOURSELF!'), findsOneWidget);

    await tester.tap(find.text('Male'));
    await tester.pump();
    await tapNextStep(tester);
    expect(find.text('HOW OLD ARE YOU?'), findsOneWidget);

    await tapNextStep(tester);
    expect(find.text('WHAT IS YOUR WEIGHT?'), findsOneWidget);

    await tapNextStep(tester);
    expect(find.text('WHAT IS YOUR HEIGHT?'), findsOneWidget);

    await tapNextStep(tester);
    expect(find.text('WHAT IS YOUR GOAL?'), findsOneWidget);

    await tester.tap(find.text('Lose weight'));
    await tester.pump();
    await tapNextStep(tester);
    expect(find.text('YOUR REGULAR PHYSICAL ACTIVITY LEVEL?'), findsOneWidget);

    await tapNextStep(tester);

    expect(find.text('Login page'), findsOneWidget);
    expect(find.text('Account created successfully'), findsOneWidget);
    expect(cubit.state.form.step, 5);
    expect(cubit.state.form.firstName, 'Ahmed');
    expect(cubit.state.form.gender, isNotNull);

    final request =
        verify(() => useCase(captureAny())).captured.single
            as RegisterRequestEntity;

    expect(request.firstName, 'Ahmed');
    expect(request.lastName, 'Ali');
    expect(request.email, 'ahmed@example.com');
    expect(request.password, 'Password1!');
    expect(request.rePassword, 'Password1!');
    expect(request.gender, 'male');
    expect(request.goal, 'Lose weight');
    expect(request.activityLevel, 'level1');
  });

  testWidgets('returns to the credentials page from the first step', (
    tester,
  ) async {
    await pumpRegisterView(tester);
    await tester.pumpAndSettle();

    await submitCredentials(tester);
    expect(find.text('TELL US ABOUT YOURSELF!'), findsOneWidget);

    await tester.tap(findBackButton());
    await tester.pumpAndSettle();

    expect(find.text('Hey there'), findsOneWidget);
    expect(find.text('TELL US ABOUT YOURSELF!'), findsNothing);
  });
}
