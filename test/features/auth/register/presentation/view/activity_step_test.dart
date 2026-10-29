import 'package:fitness_app/features/auth/presentation/register/manager/register_cubit.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_event.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_option.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_state.dart';
import 'package:fitness_app/features/auth/presentation/register/view/widgets/activity_step.dart';
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

  Future<void> moveToActivityStep() async {
    await cubit.doEvent(const GenderSelectedEvent(Gender.male));
    for (var i = 0; i < 4; i++) {
      await cubit.doEvent(const NextStepEvent());
    }
    await cubit.doEvent(const GoalSelectedEvent(Goal.loseWeight));
    await cubit.doEvent(const NextStepEvent());
  }

  Future<void> pumpActivityStep(WidgetTester tester) {
    return pumpRegisterWidget(
      tester,
      const Scaffold(body: ActivityStep()),
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

  testWidgets('renders every activity level with rookie selected', (
    tester,
  ) async {
    await moveToActivityStep();
    await pumpActivityStep(tester);

    expect(find.text('YOUR REGULAR PHYSICAL ACTIVITY LEVEL?'), findsOneWidget);
    expect(find.text('6/6'), findsOneWidget);
    expect(find.text('Rookie'), findsOneWidget);
    expect(find.text('Beginner'), findsOneWidget);
    expect(find.text('Intermediate'), findsOneWidget);
    expect(find.text('Advanced'), findsOneWidget);
    expect(find.text('True beast'), findsOneWidget);
    expect(optionTile(tester, 'Rookie').selected, isTrue);
    expect(optionTile(tester, 'True beast').selected, isFalse);
  });

  testWidgets('selects a different activity level', (tester) async {
    await moveToActivityStep();
    await pumpActivityStep(tester);

    await tester.tap(find.text('True beast'));
    await tester.pump();

    expect(cubit.state.form.activityLevel, ActivityLevel.trueBeast);
    expect(optionTile(tester, 'True beast').selected, isTrue);
    expect(optionTile(tester, 'Rookie').selected, isFalse);
  });
}
