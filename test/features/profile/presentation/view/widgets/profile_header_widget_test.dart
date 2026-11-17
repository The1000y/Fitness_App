import 'dart:async';

import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_cubit.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_event.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_state.dart';
import 'package:fitness_app/features/profile/presentation/view/widgets/profile_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/profile_fakes.dart';
import '../../../../../helpers/pump_app.dart';

void main() {
  late MockProfileCubit cubit;

  setUp(() {
    cubit = MockProfileCubit();
  });

  void stubState(ProfileState state) {
    when(() => cubit.state).thenReturn(state);
    when(
      () => cubit.stream,
    ).thenAnswer((_) => const Stream<ProfileState>.empty());
  }

  Future<void> pumpHeader(WidgetTester tester) {
    return tester.pumpApp(
      BlocProvider<ProfileCubit>.value(
        value: cubit,
        child: const Scaffold(body: Center(child: ProfileHeaderWidget())),
      ),
    );
  }

  group('ProfileHeaderWidget', () {
    testWidgets('shows a loader while the profile is loading', (tester) async {
      stubState(
        const ProfileState(
          profileState: BaseState<ProfileEntity>(isLoading: true),
        ),
      );

      await pumpHeader(tester);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Ada Lovelace'), findsNothing);
    });

    testWidgets('shows the user name and avatar fallback on success', (
      tester,
    ) async {
      stubState(
        const ProfileState(
          profileState: BaseState<ProfileEntity>(data: testProfile),
        ),
      );

      await pumpHeader(tester);
      await tester.pumpAndSettle();

      expect(find.text('Ada Lovelace'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows retry and reloads when loading failed', (tester) async {
      const failure = ServerFailure();
      stubState(
        const ProfileState(
          profileState: BaseState<ProfileEntity>(errorMessage: failure),
        ),
      );
      when(() => cubit.onEvent(const LoadProfile())).thenReturn(null);

      await pumpHeader(tester);
      await tester.pumpAndSettle();

      expect(find.text('Retry'), findsOneWidget);

      await tester.tap(find.text('Retry'));

      verify(() => cubit.onEvent(const LoadProfile())).called(1);
    });
  });
}
