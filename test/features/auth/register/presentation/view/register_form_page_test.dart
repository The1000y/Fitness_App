import 'package:fitness_app/config/routing/app_routes.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_cubit.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_state.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_ui_event.dart';
import 'package:fitness_app/features/auth/presentation/register/view/register_form_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/register_test_helpers.dart';

void main() {
  late RegisterCubit cubit;

  setUp(() {
    cubit = RegisterCubit(ucase: stubRegisterUseCase());
    addTearDown(cubit.close);
  });

  Future<void> pumpForm(
    WidgetTester tester, {
    Map<String, WidgetBuilder> routes = const {},
  }) {
    return pumpRegisterWidget(
      tester,
      const Scaffold(body: RegisterFormPage()),
      cubit: cubit,
      routes: routes,
    );
  }

  testWidgets('renders the registration form', (tester) async {
    await pumpForm(tester);

    expect(find.text('Hey there'), findsOneWidget);
    expect(find.text('CREATE AN ACCOUNT'), findsOneWidget);
    expect(find.text('Register'), findsNWidgets(2));
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.text('First name'), findsOneWidget);
    expect(find.text('Last name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Already have an account?'), findsOneWidget);
  });

  testWidgets('shows a required error for every empty field', (tester) async {
    await pumpForm(tester);

    final registerButton = find.widgetWithText(ElevatedButton, 'Register');
    await tester.ensureVisible(registerButton);
    await tester.tap(registerButton);
    await tester.pump();

    expect(find.text('First name is required'), findsOneWidget);
    expect(find.text('Last name is required'), findsOneWidget);
    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('shows format errors for invalid values', (tester) async {
    await pumpForm(tester);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Ahmed1');
    await tester.enterText(fields.at(1), 'Ali1');
    await tester.enterText(fields.at(2), 'not-an-email');
    await tester.enterText(fields.at(3), 'weakpassword');

    final registerButton = find.widgetWithText(ElevatedButton, 'Register');
    await tester.ensureVisible(registerButton);
    await tester.tap(registerButton);
    await tester.pump();

    expect(find.text('First name must contain letters only'), findsOneWidget);
    expect(find.text('Last name must contain letters only'), findsOneWidget);
    expect(find.text('Please enter a valid email'), findsOneWidget);
    expect(
      find.text(
        'Password must include uppercase, lowercase, a number and a special character',
      ),
      findsOneWidget,
    );
  });

  testWidgets('stores valid credentials and emits the first step event', (
    tester,
  ) async {
    await pumpForm(tester);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Ahmed');
    await tester.enterText(fields.at(1), 'Ali');
    await tester.enterText(fields.at(2), 'ahmed@example.com');
    await tester.enterText(fields.at(3), 'Password1!');

    final events = <Object>[];
    final subscription = cubit.uiEventStream.listen(events.add);
    addTearDown(subscription.cancel);

    final registerButton = find.widgetWithText(ElevatedButton, 'Register');
    await tester.ensureVisible(registerButton);
    await tester.tap(registerButton);
    await tester.pumpAndSettle();

    expect(cubit.state.form.firstName, 'Ahmed');
    expect(cubit.state.form.lastName, 'Ali');
    expect(cubit.state.form.email, 'ahmed@example.com');
    expect(cubit.state.form.password, 'Password1!');
    expect(events.single, isA<AcceptFirstUiEvent>());
  });

  testWidgets('toggles password visibility', (tester) async {
    await pumpForm(tester);

    final obscured = find.byWidgetPredicate(
      (widget) => widget is EditableText && widget.obscureText,
    );
    expect(obscured, findsOneWidget);

    await tester.tap(find.byType(IconButton));
    await tester.pump();

    expect(obscured, findsNothing);
  });

  testWidgets('navigates to login from the existing account link', (
    tester,
  ) async {
    await pumpForm(
      tester,
      routes: {
        AppRoutes.login: (_) => const Scaffold(body: Text('Login page')),
      },
    );

    final loginLink = find.text('Login');
    await tester.ensureVisible(loginLink);
    await tester.tap(loginLink);
    await tester.pumpAndSettle();

    expect(find.text('Login page'), findsOneWidget);
  });
}
