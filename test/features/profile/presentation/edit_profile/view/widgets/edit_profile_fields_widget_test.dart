import 'package:fitness_app/features/profile/presentation/edit_profile/manager/edit_profile_cubit.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/manager/edit_profile_event.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/manager/edit_profile_state.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/view/edit_activity_view.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/view/edit_field_tile.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/view/edit_goal_view.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/view/edit_profile_fields_widget.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/view/edit_weight_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../helpers/pump_app.dart';

class MockEditProfileCubit extends Mock implements EditProfileCubit {}

void main() {
  late MockEditProfileCubit cubit;

  setUpAll(() {
    registerFallbackValue(const EditWeightChangedEvent(70.0));
    registerFallbackValue(const GoalChangedEvent('Gain weight'));
    registerFallbackValue(const ActivityLevelChangedEvent('level1'));
  });

  setUp(() {
    cubit = MockEditProfileCubit();
    when(() => cubit.doEvent(any())).thenAnswer((_) async {});
  });

  void stubState(EditProfileState state) {
    when(() => cubit.state).thenReturn(state);
    when(() => cubit.stream).thenAnswer((_) => Stream.value(state));
  }

  Widget buildSubject() {
    return BlocProvider<EditProfileCubit>.value(
      value: cubit,
      child: const Scaffold(
        body: SingleChildScrollView(
          child: EditProfileFieldsWidget(),
        ),
      ),
    );
  }

  group('EditProfileFieldsWidget', () {
    testWidgets('renders all three EditFieldTiles with formatted values', (tester) async {
      stubState(
        const EditProfileState(
          weight: 70.0,
          goal: 'Gain weight',
          activityLevel: 'level1',
        ),
      );

      await tester.pumpApp(buildSubject());

      expect(find.byType(EditFieldTile), findsNWidgets(3));
      expect(find.text('Your weight '), findsOneWidget);
      expect(find.text('70 kg'), findsOneWidget);
      expect(find.text('Your goal '), findsOneWidget);
      expect(find.text('Gain weight'), findsOneWidget);
      expect(find.text('Your activity level '), findsOneWidget);
      expect(find.text('Rookie'), findsOneWidget);
    });

    testWidgets('maps various goal and activityLevel enum values correctly', (tester) async {
      stubState(
        const EditProfileState(
          weight: 65.4,
          goal: 'Gain more flexible',
          activityLevel: 'level5',
        ),
      );

      await tester.pumpApp(buildSubject());

      expect(find.text('65 kg'), findsOneWidget);
      expect(find.text('Gain more flexibility'), findsOneWidget);
      expect(find.text('True beast'), findsOneWidget);
    });

    testWidgets('falls back to raw string when goal or activity is unknown, or empty when null', (tester) async {
      stubState(
        const EditProfileState(
          weight: null,
          goal: 'unmapped_goal',
          activityLevel: null,
        ),
      );

      await tester.pumpApp(buildSubject());

      expect(find.text('0 kg'), findsOneWidget);
      expect(find.text('unmapped_goal'), findsOneWidget);
    });

    testWidgets('tapping weight tile opens EditWeightView and dispatches EditWeightChangedEvent on pop', (tester) async {
      stubState(
        const EditProfileState(
          weight: 75.0,
          goal: 'Gain weight',
          activityLevel: 'level1',
        ),
      );

      await tester.pumpApp(buildSubject(), size: const Size(375, 900));

      final weightTileTap = find.text('(tap to edit)').first;
      await tester.tap(weightTileTap);
      await tester.pumpAndSettle();

      expect(find.byType(EditWeightView), findsOneWidget);

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      verify(
        () => cubit.doEvent(
          any(that: isA<EditWeightChangedEvent>().having((e) => e.weight, 'weight', 75.0)),
        ),
      ).called(1);
    });

    testWidgets('tapping goal tile opens EditGoalView and dispatches GoalChangedEvent on pop', (tester) async {
      stubState(
        const EditProfileState(
          weight: 75.0,
          goal: 'Gain weight',
          activityLevel: 'level1',
        ),
      );

      await tester.pumpApp(buildSubject(), size: const Size(375, 900));

      final goalTileTap = find.text('(tap to edit)').at(1);
      await tester.tap(goalTileTap);
      await tester.pumpAndSettle();

      expect(find.byType(EditGoalView), findsOneWidget);

      await tester.tap(find.text('Lose weight'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      verify(
        () => cubit.doEvent(
          any(that: isA<GoalChangedEvent>().having((e) => e.goal, 'goal', 'Lose weight')),
        ),
      ).called(1);
    });

    testWidgets('tapping activity tile opens EditActivityView and dispatches ActivityLevelChangedEvent on pop', (tester) async {
      stubState(
        const EditProfileState(
          weight: 75.0,
          goal: 'Gain weight',
          activityLevel: 'level1',
        ),
      );

      await tester.pumpApp(buildSubject(), size: const Size(375, 900));

      final activityTileTap = find.text('(tap to edit)').at(2);
      await tester.tap(activityTileTap);
      await tester.pumpAndSettle();

      expect(find.byType(EditActivityView), findsOneWidget);

      await tester.tap(find.text('Beginner'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      verify(
        () => cubit.doEvent(
          any(that: isA<ActivityLevelChangedEvent>().having((e) => e.activityLevel, 'activityLevel', 'level2')),
        ),
      ).called(1);
    });

    testWidgets('dismissing sub-views without a result does not dispatch change events', (tester) async {
      stubState(
        const EditProfileState(
          weight: 75.0,
          goal: 'Gain weight',
          activityLevel: 'level1',
        ),
      );

      await tester.pumpApp(buildSubject(), size: const Size(375, 900));

      final weightTileTap = find.text('(tap to edit)').first;
      await tester.tap(weightTileTap);
      await tester.pumpAndSettle();

      // Dismiss without Done by popping directly
      final navigator = tester.state<NavigatorState>(find.byType(Navigator).last);
      navigator.pop(null);
      await tester.pumpAndSettle();

      verifyNever(() => cubit.doEvent(any(that: isA<EditWeightChangedEvent>())));
    });
  });
}
