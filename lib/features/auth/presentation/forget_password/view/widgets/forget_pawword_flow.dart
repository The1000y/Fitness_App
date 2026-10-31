import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/config/routing/app_routes.dart';
import 'package:fitness_app/core/shared/base_ui_event_listener.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/manager/forget_password_cubit.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/manager/forget_password_state.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/view/forget_password.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/view/reset_password.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/view/verify_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordFlow extends StatefulWidget {
  const ForgetPasswordFlow({super.key});

  @override
  State<ForgetPasswordFlow> createState() => _ForgetPasswordFlowState();
}

class _ForgetPasswordFlowState extends State<ForgetPasswordFlow> {
  final _navKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ForgetPasswordCubit>(),
      child: BaseUiEventListener<ForgetPasswordCubit, ForgetPasswordState, BaseUiEvent>(
        navigatorKey: _navKey,
        child: NavigatorPopHandler(
          onPopWithResult: (_) => _navKey.currentState!.maybePop(),
          child: Navigator(
            key: _navKey,
            initialRoute: AppRoutes.forgotPassword,
            onGenerateRoute: _onGenerateRoute,
          ),
        ),
      ),
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    final Widget page = switch (settings.name) {
      AppRoutes.otpVerification => const VerifyOtp(),
      AppRoutes.createPassword => const ResetPassword(),
      _ => const ForgetPassword(),
    };
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }
}