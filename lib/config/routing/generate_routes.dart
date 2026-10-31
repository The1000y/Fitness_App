import 'package:fitness_app/config/routing/app_routes.dart';
import 'package:fitness_app/features/auth/presentation/onboarding/views/onboarding_view.dart';
import 'package:fitness_app/features/auth/presentation/register/view/register_view.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/view/widgets/forget_pawword_flow.dart';
import 'package:fitness_app/features/chat/presentation/views/chat_view.dart';
import 'package:fitness_app/features/home/presentation/views/home_view.dart';
import 'package:fitness_app/features/main/presentation/views/main_layout_view.dart';
import 'package:fitness_app/features/profile/presentation/views/profile_view.dart';
import 'package:fitness_app/features/workouts/presentation/views/workouts_view.dart';
import 'package:flutter/material.dart';

abstract final class GenerateRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _pageRoute(const _StubScreen('Splash Screen'), settings);

      case AppRoutes.onboarding:
        return _pageRoute(const OnboardingView(), settings);

      // Auth
      case AppRoutes.login:
        return _pageRoute(const _StubScreen('Login'), settings);

      case AppRoutes.register:
        return _pageRoute(const RegisterView(), settings);

      case AppRoutes.forgotPassword:
        return _pageRoute(const ForgetPasswordFlow(), settings);

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
            tabs: [HomeView(), ChatView(), WorkoutsView(), ProfileView()],
          ),
          settings,
        );

      case AppRoutes.exerciseDetails:
        return _pageRoute(const _StubScreen('Exercise Details'), settings);

      // Food
      case AppRoutes.food:
        return _pageRoute(const _StubScreen('Food'), settings);

      case AppRoutes.foodDetails:
        return _pageRoute(const _StubScreen('Food Details'), settings);

      case AppRoutes.chatHistory:
        return _pageRoute(const _StubScreen('Chat History'), settings);

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
            MaterialPageRoute(builder: (context) => const _StubScreen('Next')),
          ),
          child: Text('Test'),
        ),
      ),
    );
  }
}
