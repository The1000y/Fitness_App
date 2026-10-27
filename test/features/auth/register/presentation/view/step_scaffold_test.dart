import 'package:fitness_app/features/auth/presentation/register/manager/register_cubit.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_event.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_option.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_state.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_ui_event.dart';
import 'package:fitness_app/features/auth/presentation/register/view/widgets/step_scaffold.dart';
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

  Future<void> moveToStepTwo() async {
    await cubit.doEvent(const GenderSelectedEvent(Gender.male));
    await cubit.doEvent(const NextStepEvent());
    await cubit.doEvent(const NextStepEvent());
  }

  Future<void> pumpScaffold(WidgetTester tester) {
    return pumpRegisterWidget(
      tester,
      const Scaffold(
        body: StepScaffold(
          step: 2,
          title: 'Step title',
          subtitle: 'Step subtitle',
          child: Text('Step content'),
        ),
      ),
      cubit: cubit,
    );
  }

  testWidgets('renders its title, subtitle, content and progress', (
    tester,
  ) async {
    await moveToStepTwo();
    await pumpScaffold(tester);

    expect(find.text('STEP TITLE'), findsOneWidget);
    expect(find.text('Step subtitle'), findsOneWidget);
    expect(find.text('Step content'), findsOneWidget);
    expect(find.text('3/6'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });

  testWidgets('advances with the next button', (tester) async {
    await moveToStepTwo();
    await pumpScaffold(tester);

    final events = <Object>[];
    final subscription = cubit.uiEventStream.listen(events.add);
    addTearDown(subscription.cancel);

    await tapNextStep(tester);

    expect(cubit.state.form.step, 3);
    expect(events.single, isA<StepChangedUiEvent>());
    expect((events.single as StepChangedUiEvent).step, 3);
  });

  testWidgets('goes back with the back button', (tester) async {
    await moveToStepTwo();
    await pumpScaffold(tester);

    final events = <Object>[];
    final subscription = cubit.uiEventStream.listen(events.add);
    addTearDown(subscription.cancel);

    await tester.tap(find.byType(SvgPicture).first);
    await tester.pump();

    expect(cubit.state.form.step, 1);
    expect(events.single, isA<StepChangedUiEvent>());
    expect((events.single as StepChangedUiEvent).step, 1);
  });
}
