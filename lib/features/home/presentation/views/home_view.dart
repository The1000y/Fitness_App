import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/home/presentation/manager/home_cubit.dart';
import 'package:fitness_app/features/home/presentation/manager/home_event.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/sections/home_categories.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/sections/home_food_categories.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/sections/home_popular_training.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/sections/home_random_muscles.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/sections/home_upcoming_workouts.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_cubit.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_event.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_state.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<HomeCubit>()..onEvent(const HomeStarted()),
        ),
        BlocProvider.value(
          value: getIt<ProfileCubit>()..onEvent(const LoadProfile()),
        ),
      ],
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
                child: BlocSelector<ProfileCubit, ProfileState, ProfileEntity?>(
                  selector: (state) => state.profileState.data,
                  builder: (context, profile) => _Header(
                    firstName: profile?.firstName ?? '',
                    photoUrl: profile?.photo,
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
                  const HomeRandomMuscles(),
                  SizedBox(height: 24.h),
                  const HomeUpcomingWorkouts(),
                  SizedBox(height: 24.h),
                  const HomeFoodCategories(),
                  SizedBox(height: 24.h),
                  const HomePopularTraining(),
                  SizedBox(height: 130.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.firstName, this.photoUrl});

  final String firstName;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final placeholder = Container(
      color: Colors.white24,
      alignment: Alignment.center,
      child: Icon(Icons.person, size: 22.r, color: AppColors.textPrimary),
    );

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.homeGreeting(firstName),
                style: textTheme.bodyMedium?.copyWith(
                  fontFamily: 'Baloo Thambi 2',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                l10n.homeSubtitle,
                style: textTheme.bodyLarge?.copyWith(
                  fontFamily: 'Baloo Thambi 2',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        ClipOval(
          child: SizedBox(
            width: 36.r,
            height: 36.r,
            child: photoUrl != null && photoUrl!.isNotEmpty
                ? Image.network(
              photoUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => placeholder,
            )
                : placeholder,
          ),
        ),
      ],
    );
  }
}