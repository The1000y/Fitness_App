import 'dart:async';

import 'package:fitness_app/config/routing/app_routes.dart';
import 'package:fitness_app/features/app/presentation/cubit/locale/app_locale_cubit.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_cubit.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_event.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_state.dart';
import 'package:fitness_app/features/profile/presentation/view/widgets/profile_menu_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/profile_fakes.dart';
import '../../../../../helpers/pump_app.dart';

void main() {
  late MockProfileCubit profileCubit;
  late MockAppLocaleCubit localeCubit;

  setUp(() {
    profileCubit = MockProfileCubit();
    localeCubit = MockAppLocaleCubit();

    when(() => profileCubit.state).thenReturn(const ProfileState());
    when(
      () => profileCubit.stream,
    ).thenAnswer((_) => const Stream<ProfileState>.empty());
    when(() => localeCubit.state).thenReturn(const Locale('en'));
    when(
      () => localeCubit.stream,
    ).thenAnswer((_) => const Stream<Locale>.empty());
    when(() => localeCubit.toggle()).thenAnswer((_) async {});
  });

  Future<void> pumpMenu(WidgetTester tester) {
    return tester.pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<ProfileCubit>.value(value: profileCubit),
          BlocProvider<AppLocaleCubit>.value(value: localeCubit),
        ],
        child: const Scaffold(
          body: SingleChildScrollView(child: ProfileMenuSection()),
        ),
      ),
      routes: {
        AppRoutes.editProfile: (_) =>
            const Scaffold(body: Text('Edit profile screen')),
        AppRoutes.changePassword: (_) =>
            const Scaffold(body: Text('Change password screen')),
      },
    );
  }

  group('ProfileMenuSection', () {
    testWidgets('renders all profile menu entries and language state', (
      tester,
    ) async {
      await pumpMenu(tester);
      await tester.pumpAndSettle();

      expect(find.text('Edit profile'), findsOneWidget);
      expect(find.text('Change password'), findsOneWidget);
      expect(find.text('Security'), findsOneWidget);
      expect(find.text('Privacy policy'), findsOneWidget);
      expect(find.text('Help'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
      expect(find.textContaining('Select language'), findsOneWidget);
      expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
    });

    testWidgets('navigates to change password', (tester) async {
      await pumpMenu(tester);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Change password'));
      await tester.pumpAndSettle();

      expect(find.text('Change password screen'), findsOneWidget);
    });

    testWidgets('navigates to edit profile', (tester) async {
      await pumpMenu(tester);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Edit profile'));
      await tester.pumpAndSettle();

      expect(find.text('Edit profile screen'), findsOneWidget);
    });

    testWidgets('toggles the locale from the switch', (tester) async {
      await pumpMenu(tester);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Switch));
      await tester.pump();

      verify(() => localeCubit.toggle()).called(1);
    });

    testWidgets('asks for confirmation and cancels logout', (tester) async {
      when(
        () => profileCubit.onEvent(const LogoutRequested()),
      ).thenReturn(null);
      await pumpMenu(tester);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();

      expect(find.text('Are you sure you want to log out?'), findsOneWidget);

      await tester.tap(find.text('No'));
      await tester.pumpAndSettle();

      expect(find.text('Are you sure you want to log out?'), findsNothing);
      verifyNever(() => profileCubit.onEvent(const LogoutRequested()));
    });

    testWidgets('confirms logout and dispatches the event', (tester) async {
      when(
        () => profileCubit.onEvent(const LogoutRequested()),
      ).thenReturn(null);
      await pumpMenu(tester);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();

      verify(() => profileCubit.onEvent(const LogoutRequested())).called(1);
    });

    testWidgets('shows a loader and disables logout while signing out', (
      tester,
    ) async {
      when(
        () => profileCubit.state,
      ).thenReturn(const ProfileState(isLoggingOut: true));

      await pumpMenu(tester);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.tap(find.text('Logout'));
      await tester.pump();

      expect(find.text('Are you sure you want to log out?'), findsNothing);
      verifyNever(() => profileCubit.onEvent(const LogoutRequested()));
    });
  });
}
