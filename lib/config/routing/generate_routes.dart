import 'package:fitness_app/config/routing/app_routes.dart';
import 'package:fitness_app/features/auth/presentation/onboarding/views/onboarding_view.dart';
import 'package:fitness_app/features/chat/presentation/views/chat_view.dart';
import 'package:fitness_app/features/home/presentation/views/home_view.dart';
import 'package:fitness_app/features/main/presentation/views/main_layout_view.dart';
import 'package:fitness_app/features/profile/presentation/views/profile_view.dart';
import 'package:fitness_app/features/workouts/presentation/views/workouts_view.dart';
import 'package:fitness_app/test_view.dart';
import 'package:flutter/material.dart';

abstract final class GenerateRoutes {
  static Widget _getHomeTap([dynamic arg]) {
    return const HomeView();
  }

  static Widget _getChatTap([dynamic arg]) {
    return const ChatView();
  }

  static Widget _getWorkoutsTap([dynamic arg]) {
    return const WorkoutsView();
  }

  static Widget _getProfileTap([dynamic arg]) {
    return const ProfileView();
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _pageRoute(const TestView(), settings);

      case AppRoutes.onboarding:
        return _pageRoute(const OnboardingView(), settings);

      // Auth
      case AppRoutes.login:
        return _pageRoute(const _StubScreen('Login'), settings);

      case AppRoutes.register:
        return _pageRoute(const _StubScreen('Register'), settings);

      case AppRoutes.forgotPassword:
        return _pageRoute(const _StubScreen('Forgot Password'), settings);

      case AppRoutes.otpVerification:
        return _pageRoute(const _StubScreen('OTP Verification'), settings);

      case AppRoutes.createPassword:
        return _pageRoute(const _StubScreen('Create Password'), settings);

      case AppRoutes.changePassword:
        return _pageRoute(const _StubScreen('Change Password'), settings);

      // Setup
      case AppRoutes.setupGender:
        return _pageRoute(const _StubScreen('Setup Gender'), settings);

      case AppRoutes.setupAge:
        return _pageRoute(const _StubScreen('Setup Age'), settings);

      case AppRoutes.setupWeight:
        return _pageRoute(const _StubScreen('Setup Weight'), settings);

      case AppRoutes.setupHeight:
        return _pageRoute(const _StubScreen('Setup Height'), settings);

      case AppRoutes.setupGoal:
        return _pageRoute(const _StubScreen('Setup Goal'), settings);

      case AppRoutes.setupActivity:
        return _pageRoute(const _StubScreen('Setup Activity'), settings);

      // Main
      case AppRoutes.main:
        return _pageRoute(
          MainLayoutView(
            tabs: [
              _getHomeTap(settings.arguments),
              _getChatTap(settings.arguments),
              _getWorkoutsTap(settings.arguments),
              _getProfileTap(settings.arguments),
            ],
          ),
          settings,
        );

      case AppRoutes.home:
        return _pageRoute(_getHomeTap(settings.arguments), settings);

      // Workouts
      case AppRoutes.workouts:
        return _pageRoute(_getWorkoutsTap(settings.arguments), settings);

      case AppRoutes.exerciseDetails:
        return _pageRoute(const _StubScreen('Exercise Details'), settings);

      // Food
      case AppRoutes.food:
        return _pageRoute(const _StubScreen('Food'), settings);

      case AppRoutes.foodDetails:
        return _pageRoute(const _StubScreen('Food Details'), settings);

      // Chat
      case AppRoutes.chat:
        return _pageRoute(_getChatTap(settings.arguments), settings);

      case AppRoutes.chatHistory:
        return _pageRoute(const _StubScreen('Chat History'), settings);

      // Profile
      case AppRoutes.profile:
        return _pageRoute(_getProfileTap(settings.arguments), settings);

      case AppRoutes.editProfile:
        return _pageRoute(const _StubScreen('Edit Profile'), settings);

      case AppRoutes.editWeight:
        return _pageRoute(const _StubScreen('Edit Weight'), settings);

      case AppRoutes.editGoal:
        return _pageRoute(const _StubScreen('Edit Goal'), settings);

      case AppRoutes.editActivity:
        return _pageRoute(const _StubScreen('Edit Activity'), settings);

      default:
        return _pageRoute(const _StubScreen('404'), settings);
    }
  }

  static PageRouteBuilder<dynamic> _pageRoute(
    Widget page,
    RouteSettings settings,
  ) {
    return PageRouteBuilder(settings: settings, pageBuilder: (_, _, _) => page);
  }
}

class _StubScreen extends StatelessWidget {
  const _StubScreen(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TestView()),
          ),
          child: Text('Test'),
        ),
      ),
    );
  }
}
