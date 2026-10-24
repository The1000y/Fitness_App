import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/constants/app_strings.dart';
import 'package:fitness_app/features/auth/domain/entities/onboarding/onboarding_entity.dart';

abstract final class AppDummiesData {
  static final List<OnboardingEntity> onboardingPages = [
    OnboardingEntity(
      image: AppImages.avatar(31),
      title: AppStrings.onboarding1Title,
      description: AppStrings.onboardingDescription,
    ),
    OnboardingEntity(
      image: AppImages.avatar(30),
      title: AppStrings.onboarding2Title,
      description: AppStrings.onboardingDescription,
    ),
    OnboardingEntity(
      image: AppImages.avatar(29),
      title: AppStrings.onboarding3Title,
      description: AppStrings.onboardingDescription,
    ),
  ];
}
