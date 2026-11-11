import 'dart:async';
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/features/app/presentation/cubit/auth/app_auth_cubit.dart';
import 'package:fitness_app/features/app/presentation/cubit/auth/app_auth_state.dart';
import 'package:fitness_app/features/app/presentation/cubit/auth/app_auth_ui_event.dart';
import 'package:fitness_app/features/app/presentation/cubit/locale/app_locale_cubit.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/manager/forget_password_cubit.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/manager/forget_password_state.dart';
import 'package:fitness_app/features/auth/presentation/onboarding/views/onboarding_view.dart';
import 'package:fitness_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAppAuthCubit extends Mock implements AppAuthCubit {}

class MockForgetPasswordCubit extends Mock implements ForgetPasswordCubit {}

class MockAppLocaleCubit extends Mock implements AppLocaleCubit {}

void main() {
  late MockAppAuthCubit mockAppAuthCubit;
  late MockForgetPasswordCubit mockForgetPasswordCubit;
  late MockAppLocaleCubit mockAppLocaleCubit;
  late StreamController<AppAuthUiEvent> authUiEventController;
  late StreamController<BaseUiEvent> forgetPasswordUiEventController;
  late StreamController<ForgetPasswordState> forgetPasswordStateController;

  setUp(() {
    mockAppAuthCubit = MockAppAuthCubit();
    mockForgetPasswordCubit = MockForgetPasswordCubit();
    mockAppLocaleCubit = MockAppLocaleCubit();
    authUiEventController = StreamController<AppAuthUiEvent>.broadcast();
    forgetPasswordUiEventController = StreamController<BaseUiEvent>.broadcast();
    forgetPasswordStateController =
        StreamController<ForgetPasswordState>.broadcast();

    when(() => mockAppAuthCubit.state).thenReturn(const AppAuthState());
    when(() => mockAppAuthCubit.stream).thenAnswer((_) => const Stream.empty());
    when(
      () => mockAppAuthCubit.uiEventStream,
    ).thenAnswer((_) => authUiEventController.stream);
    when(() => mockAppAuthCubit.close()).thenAnswer((_) async {});

    when(
      () => mockForgetPasswordCubit.state,
    ).thenReturn(const ForgetPasswordState());
    when(
      () => mockForgetPasswordCubit.stream,
    ).thenAnswer((_) => forgetPasswordStateController.stream);
    when(
      () => mockForgetPasswordCubit.uiEventStream,
    ).thenAnswer((_) => forgetPasswordUiEventController.stream);
    when(() => mockForgetPasswordCubit.close()).thenAnswer((_) async {});

    when(() => mockAppLocaleCubit.state).thenReturn(const Locale('en'));
    when(
      () => mockAppLocaleCubit.stream,
    ).thenAnswer((_) => const Stream.empty());
    when(() => mockAppLocaleCubit.load()).thenAnswer((_) async {});

    if (getIt.isRegistered<AppAuthCubit>()) {
      getIt.unregister<AppAuthCubit>();
    }
    getIt.registerSingleton<AppAuthCubit>(mockAppAuthCubit);

    if (getIt.isRegistered<ForgetPasswordCubit>()) {
      getIt.unregister<ForgetPasswordCubit>();
    }
    getIt.registerSingleton<ForgetPasswordCubit>(mockForgetPasswordCubit);

    if (getIt.isRegistered<AppLocaleCubit>()) {
      getIt.unregister<AppLocaleCubit>();
    }
    getIt.registerSingleton<AppLocaleCubit>(mockAppLocaleCubit);
  });

  tearDown(() {
    authUiEventController.close();
    forgetPasswordUiEventController.close();
    forgetPasswordStateController.close();
    if (getIt.isRegistered<AppAuthCubit>()) {
      getIt.unregister<AppAuthCubit>();
    }
    if (getIt.isRegistered<ForgetPasswordCubit>()) {
      getIt.unregister<ForgetPasswordCubit>();
    }
    if (getIt.isRegistered<AppLocaleCubit>()) {
      getIt.unregister<AppLocaleCubit>();
    }
  });

  group('FitnessApp', () {
    testWidgets('pumps successfully and displays initial onboarding route', (
      tester,
    ) async {
      await tester.pumpWidget(const FitnessApp());
      await tester.pumpAndSettle();

      expect(find.byType(FitnessApp), findsOneWidget);
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(OnboardingView), findsOneWidget);
    });
  });
}
