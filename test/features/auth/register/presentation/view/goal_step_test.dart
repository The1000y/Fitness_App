import 'package:fitness_app/features/auth/presentation/register/manager/register_cubit.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_event.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_option.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_state.dart';
import 'package:fitness_app/features/auth/presentation/register/view/widgets/goal_step.dart';
import 'package:fitness_app/features/auth/presentation/register/view/widgets/option_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/register_test_helpers.dart';

void main() {
  late RegisterCubit cubit;

  setUp(() {
    cubit = RegisterCubit(ucase: stubRegisterUseCase());
    addTearDown(cubit.close);
  });

  Future<void> moveToGoalStep() async {
    await cubit.doEvent(const GenderSelectedEvent(Gender.male));
    for (var i = 0; i < 4; i++) {
      await cubit.doEvent(const NextStepEvent());
    }
  }

  Future<void> pumpGoalStep(WidgetTester tester) {
    return pumpRegisterWidget(
      tester,
      const Scaffold(body: GoalStep()),
      cubit: cubit,
    );
  }

  OptionTile optionTile(WidgetTester tester, String label) {
    return tester.widget<OptionTile>(
      find.byWidgetPredicate(
        (widget) => widget is OptionTile && widget.label == label,
      ),
    );
  }

  ElevatedButton nextButton(WidgetTester tester) {
    return tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Next'),
    );
  }

  testWidgets('renders every goal and disables next until one is selected', (
    tester,
  ) async {
    await moveToGoalStep();
    await pumpGoalStep(tester);

    expect(find.text('WHAT IS YOUR GOAL?'), findsOneWidget);
    expect(find.text('5/6'), findsOneWidget);
    expect(find.text('Gain weight'), findsOneWidget);
    expect(find.text('Lose weight'), findsOneWidget);
    expect(find.text('Get fitter'), findsOneWidget);
    expect(find.text('Gain more flexibility'), findsOneWidget);
    expect(find.text('Learn the basics'), findsOneWidget);
    expect(nextButton(tester).onPressed, isNull);
  });

  testWidgets('selects a goal and enables the next button', (tester) async {
    await moveToGoalStep();
    await pumpGoalStep(tester);

    await tester.tap(find.text('Lose weight'));
    await tester.pump();

    expect(cubit.state.form.goal, Goal.loseWeight);
    expect(optionTile(tester, 'Lose weight').selected, isTrue);
    expect(optionTile(tester, 'Gain weight').selected, isFalse);
    expect(nextButton(tester).onPressed, isNotNull);
  });

  testWidgets('advances to the activity step after selecting a goal', (
    tester,
  ) async {
    await moveToGoalStep();
    await pumpGoalStep(tester);

    await tester.tap(find.text('Get fitter'));
    await tester.pump();
    await tapNextStep(tester);

    expect(cubit.state.form.step, 5);
    expect(cubit.state.form.goal, Goal.getFitter);
  });
}
