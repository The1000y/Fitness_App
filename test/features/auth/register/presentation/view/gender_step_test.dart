import 'package:fitness_app/features/auth/presentation/register/manager/register_cubit.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_option.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_state.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_ui_event.dart';
import 'package:fitness_app/features/auth/presentation/register/view/widgets/gender_option.dart';
import 'package:fitness_app/features/auth/presentation/register/view/widgets/gender_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/register_test_helpers.dart';

void main() {
  late RegisterCubit cubit;

  setUp(() {
    cubit = RegisterCubit(ucase: stubRegisterUseCase());
    addTearDown(cubit.close);
  });

  Future<void> pumpGenderStep(WidgetTester tester) {
    return pumpRegisterWidget(
      tester,
      const Scaffold(body: GenderStep()),
      cubit: cubit,
    );
  }

  GenderOption genderOption(WidgetTester tester, String label) {
    return tester.widget<GenderOption>(
      find.byWidgetPredicate(
        (widget) => widget is GenderOption && widget.label == label,
      ),
    );
  }

  ElevatedButton nextButton(WidgetTester tester) {
    return tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Next'),
    );
  }

  testWidgets('renders both gender choices and the first step progress', (
    tester,
  ) async {
    await pumpGenderStep(tester);

    expect(find.text('TELL US ABOUT YOURSELF!'), findsOneWidget);
    expect(find.text('We need to know your gender'), findsOneWidget);
    expect(find.text('1/6'), findsOneWidget);
    expect(find.text('Male'), findsOneWidget);
    expect(find.text('Female'), findsOneWidget);
    expect(genderOption(tester, 'Male').selected, isFalse);
    expect(genderOption(tester, 'Female').selected, isFalse);
    expect(nextButton(tester).onPressed, isNull);
  });

  testWidgets('selects a gender and enables the next button', (tester) async {
    await pumpGenderStep(tester);

    await tester.tap(find.text('Male'));
    await tester.pump();

    expect(cubit.state.form.gender, Gender.male);
    expect(genderOption(tester, 'Male').selected, isTrue);
    expect(genderOption(tester, 'Female').selected, isFalse);
    expect(nextButton(tester).onPressed, isNotNull);
  });

  testWidgets('advances to the next step from the gender step', (tester) async {
    await pumpGenderStep(tester);

    await tester.tap(find.text('Male'));
    await tester.pump();

    final events = <Object>[];
    final subscription = cubit.uiEventStream.listen(events.add);
    addTearDown(subscription.cancel);

    await tapNextStep(tester);

    expect(cubit.state.form.step, 1);
    expect(events.single, isA<StepChangedUiEvent>());
    expect((events.single as StepChangedUiEvent).step, 1);
  });

  testWidgets('returns to credentials from the back button', (tester) async {
    await pumpGenderStep(tester);

    final events = <Object>[];
    final subscription = cubit.uiEventStream.listen(events.add);
    addTearDown(subscription.cancel);

    await tester.tap(find.byType(SvgPicture).first);
    await tester.pump();

    expect(events.single, isA<BackToCredentialsUiEvent>());
    expect(cubit.state.form.step, 0);
  });
}
