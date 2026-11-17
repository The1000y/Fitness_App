import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/config/routing/app_routes.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/manager/forget_password_cubit.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/view/reset_password.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/view/verify_otp.dart';
import 'package:fitness_app/features/auth/presentation/forget_password/view/widgets/forget_pawword_flow.dart';
import 'package:fitness_app/features/auth/presentation/login/view/login_view.dart';
import 'package:fitness_app/features/auth/presentation/onboarding/views/onboarding_view.dart';
import 'package:fitness_app/features/auth/presentation/register/view/register_view.dart';
import 'package:fitness_app/features/chat/presentation/manager/chat_cubit.dart';
import 'package:fitness_app/features/chat/presentation/manager/chat_event.dart';
import 'package:fitness_app/features/chat/presentation/view/chat_view.dart';
import 'package:fitness_app/features/exercise/domain/entities/exercise_entity.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/args/exercise_details_args.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/manager/exercise_details_cubit.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/manager/exercise_details_event.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/exercise_details_view.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/view/exercise_video_player_view.dart';
import 'package:fitness_app/features/exercise/presentation/workout_categories/view/workout_categories_view.dart';
import 'package:fitness_app/features/chat/presentation/view/message_view.dart';
import 'package:fitness_app/features/chat/presentation/view/widget/prefrence_borading_chat.dart';
import 'package:fitness_app/features/home/presentation/views/home_view.dart';
import 'package:fitness_app/features/main/presentation/views/main_layout_view.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_cubit.dart';
import 'package:fitness_app/features/meals/presentation/manager/meals_event.dart';
import 'package:fitness_app/features/meals/presentation/view/details_food_view.dart';
import 'package:fitness_app/features/meals/presentation/view/meals_view.dart';
import 'package:fitness_app/features/profile/presentation/change_password/manager/change_password_cubit.dart';
import 'package:fitness_app/features/profile/presentation/change_password/view/change_password_view.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/manager/edit_profile_cubit.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/manager/edit_profile_event.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/view/edit_activity_view.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/view/edit_goal_view.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/view/edit_profile_view.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/view/edit_weight_view.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_cubit.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_event.dart';
import 'package:fitness_app/features/profile/presentation/view/profile_view.dart';
import 'package:fitness_app/features/profile/presentation/web_view/args/profile_web_view_args.dart';
import 'package:fitness_app/features/profile/presentation/web_view/view/profile_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract final class GenerateRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _pageRoute(const _StubScreen('Splash Screen'), settings);

      case AppRoutes.onboarding:
        return _pageRoute(const OnboardingView(), settings);

      case AppRoutes.login:
        return _pageRoute(const LoginView(), settings);

      case AppRoutes.register:
        return _pageRoute(const RegisterView(), settings);

      case AppRoutes.forgotPassword:
        return _pageRoute(const ForgetPasswordFlow(), settings);

      case AppRoutes.otpVerification:
        final cubit = (settings.arguments is ForgetPasswordCubit)
            ? (settings.arguments as ForgetPasswordCubit)
            : getIt<ForgetPasswordCubit>();
        return _pageRoute(
          BlocProvider.value(value: cubit, child: const VerifyOtp()),
          settings,
        );

      case AppRoutes.createPassword:
        final cubit = (settings.arguments is ForgetPasswordCubit)
            ? (settings.arguments as ForgetPasswordCubit)
            : getIt<ForgetPasswordCubit>();
        return _pageRoute(
          BlocProvider.value(value: cubit, child: const ResetPassword()),
          settings,
        );

      case AppRoutes.changePassword:
        return _pageRoute(
          BlocProvider(
            create: (_) => getIt<ChangePasswordCubit>(),
            child: const ChangePasswordView(),
          ),
          settings,
        );

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

      case AppRoutes.main:
        return _pageRoute(
          MainLayoutView(
            tabs: [
              HomeView(),
              SizedBox(),
              WorkoutCategoriesView(),
              BlocProvider.value(
                value: getIt<ProfileCubit>()..onEvent(const LoadProfile()),
                child: const ProfileView(),
              ),
            ],
          ),
          settings,
        );

      case AppRoutes.workoutCategories:
        return _pageRoute(const WorkoutCategoriesView(), settings);

      case AppRoutes.exerciseDetails:
        final args = settings.arguments as ExerciseDetailsArgs;
        return _pageRoute(
          BlocProvider(
            create: (_) => getIt<ExerciseDetailsCubit>()
              ..onEvent(
                LoadLevels(
                  primeMoverMuscleId: args.primeMoverMuscleId,
                  difficultyLevelId: args.difficultyLevelId,
                ),
              ),
            child: ExerciseDetailsView(muscleName: args.muscleName),
          ),
          settings,
        );

      case AppRoutes.exerciseVideoPlayer:
        final exercise = settings.arguments as ExerciseEntity;
        return _pageRoute(
          ExerciseVideoPlayerView(exercise: exercise),
          settings,
        );

      case AppRoutes.meals:
        final args = settings.arguments;
        final category = args is String ? args : null;

        return _pageRoute(
          BlocProvider(
            create: (context) =>
                getIt.get<MealsCubit>()
                  ..doEvent(GetMealsCategoriesEvent(category)),
            child: const MealsView(),
          ),
          settings,
        );

      case AppRoutes.mealDetails:
        var mealId = settings.arguments as String;
        return _pageRoute(
          BlocProvider<MealsCubit>(
            create: (context) =>
                getIt<MealsCubit>()..onEvent(GetMealDetailsEvent(mealId)),
            child: DetailsFoodView(mealId: mealId),
          ),
          settings,
        );

      case AppRoutes.chatHistory:
        var route = getIt<PrefrenceBoradingChat>().getBoardingChat;
        return _pageRoute(
          route == true
              ? BlocProvider<ChatCubit>(
                  create: (_) =>
                      getIt<ChatCubit>()
                        ..onEvent(const LoadPreviousChatsEvent()),
                  child: const MessageView(),
                )
              : const ChatView(),
          settings,
        );

      case AppRoutes.chatMessages:
        return _pageRoute(
          BlocProvider<ChatCubit>(
            create: (_) =>
                getIt<ChatCubit>()..onEvent(const LoadPreviousChatsEvent()),
            child: const MessageView(),
          ),
          settings,
        );

      case AppRoutes.editProfile:
        final profileCubit = settings.arguments as ProfileCubit;
        final profile = profileCubit.state.profileState.data;
        if (profile == null) return _pageRoute(const _StubScreen('404'), settings);
        return _pageRoute(
          BlocProvider(
            create: (_) => getIt<EditProfileCubit>()
              ..doEvent(InitEditProfileEvent(profile)),
            child: const EditProfileView(),
          ),
          settings,
        );

      case AppRoutes.editWeight:
        final initialWeight = (settings.arguments as int?) ?? 70;
        return _pageRoute(
          EditWeightView(initialWeight: initialWeight),
          settings,
        );

      case AppRoutes.editGoal:
        final initialGoal = settings.arguments as String?;
        return _pageRoute(
          EditGoalView(initialGoal: initialGoal),
          settings,
        );

      case AppRoutes.editActivity:
        final initialLevel = settings.arguments as String?;
        return _pageRoute(
          EditActivityView(initialLevel: initialLevel),
          settings,
        );

      case AppRoutes.webView:
        final args = settings.arguments as ProfileWebViewArgs;
        return _pageRoute(ProfileWebView(args: args), settings);

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
