import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/config/routing/app_routes.dart';
import 'package:fitness_app/config/routing/generate_routes.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/manager/forget_password_cubit.dart';
import 'package:fitness_app/features/profile/presentation/web_view/args/profile_web_view_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockForgetPasswordCubit extends Mock implements ForgetPasswordCubit {}

void main() {
  late MockForgetPasswordCubit mockCubit;

  setUp(() {
    mockCubit = MockForgetPasswordCubit();
    if (getIt.isRegistered<ForgetPasswordCubit>()) {
      getIt.unregister<ForgetPasswordCubit>();
    }
    getIt.registerSingleton<ForgetPasswordCubit>(mockCubit);
  });

  tearDown(() {
    if (getIt.isRegistered<ForgetPasswordCubit>()) {
      getIt.unregister<ForgetPasswordCubit>();
    }
  });

  group('GenerateRoutes', () {
    test('generates route for splash', () {
      final route = GenerateRoutes.generateRoute(
        const RouteSettings(name: AppRoutes.splash),
      );
      expect(route, isA<PageRouteBuilder>());
    });

    test('generates route for onboarding', () {
      final route = GenerateRoutes.generateRoute(
        const RouteSettings(name: AppRoutes.onboarding),
      );
      expect(route, isA<PageRouteBuilder>());
    });

    test('generates route for login', () {
      final route = GenerateRoutes.generateRoute(
        const RouteSettings(name: AppRoutes.login),
      );
      expect(route, isA<PageRouteBuilder>());
    });

    test('generates route for forgotPassword', () {
      final route = GenerateRoutes.generateRoute(
        const RouteSettings(name: AppRoutes.forgotPassword),
      );
      expect(route, isA<PageRouteBuilder>());
    });

    test('generates route for otpVerification with cubit in arguments', () {
      final route = GenerateRoutes.generateRoute(
        RouteSettings(name: AppRoutes.otpVerification, arguments: mockCubit),
      );
      expect(route, isA<PageRouteBuilder>());
    });

    test('generates route for createPassword with cubit in arguments', () {
      final route = GenerateRoutes.generateRoute(
        RouteSettings(name: AppRoutes.createPassword, arguments: mockCubit),
      );
      expect(route, isA<PageRouteBuilder>());
    });

    test('generates route for webView with typed arguments', () {
      const args = ProfileWebViewArgs(
        title: 'Security',
        url: 'https://example.com/security',
      );
      final route = GenerateRoutes.generateRoute(
        const RouteSettings(name: AppRoutes.webView, arguments: args),
      );

      expect(route, isA<PageRouteBuilder>());
      expect(route.settings.name, AppRoutes.webView);
    });

    test('generates default 404 route for unknown route name', () {
      final route = GenerateRoutes.generateRoute(
        const RouteSettings(name: '/unknown-route'),
      );
      expect(route, isA<PageRouteBuilder>());
    });
  });
}
