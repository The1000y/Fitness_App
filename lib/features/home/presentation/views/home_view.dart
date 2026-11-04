import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:fitness_app/features/home/presentation/manager/home_cubit.dart';
import 'package:fitness_app/features/home/presentation/manager/home_event.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/home_categories.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/home_food_categories.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/home_header.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/home_muscles_random_section.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/home_popular_training.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/home_upcoming_workouts_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../auth/domain/entities/login_entity/user_entity.dart';
import '../manager/home_state.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>()..onEvent(const HomeStarted()),
      child: CustomBackgroundImage(
        backgroundImage: AppImages.layoutBackground,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.h),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: BlocSelector<HomeCubit, HomeState, UserEntity?>(
                  selector: (state) => state.userState.data,
                  builder: (context, user) => HomeHeader(
                    firstName: user?.firstName ?? '',
                    photoUrl: user?.photo,
                  ),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),
                  const HomeCategories(),
                  SizedBox(height: 24.h),
                  const HomeMusclesRandomSection(),
                  SizedBox(height: 24.h),
                  const HomeUpcomingWorkoutsSection(),
                  SizedBox(height: 24.h),
                  const HomeFoodCategories(),
                  SizedBox(height: 24.h),
                  const HomePopularTraining(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}