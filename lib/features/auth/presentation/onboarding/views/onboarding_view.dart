import 'dart:developer';

import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/constants/app_strings.dart';
import 'package:fitness_app/core/constants/app_test_keys.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:fitness_app/core/shared/custom_blur_card.dart';
import 'package:fitness_app/core/shared/custom_button.dart';
import 'package:fitness_app/features/auth/domain/entities/onboarding/onboarding_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../core/theme/app_colors/app_colors.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late PageController _pageController;
  int currentPage = 0;
  final List<OnboardingEntity> _pages = [
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

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CustomBackgroundImage(
      backgroundImage: AppImages.onboardingBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(
              width: 375.w,
              top: 64,
              height: 516.h,
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _pageController,
                key: Key(AppTestKeys.onboardingPageView),
                itemCount: _pages.length,
                onPageChanged: (pageNumber) {
                  setState(() => currentPage = pageNumber);
                },
                itemBuilder: (context, index) {
                  return Image.asset(
                        _pages[index].image,
                        key: ValueKey(_pages[index].image),
                        fit: BoxFit.contain,
                      )
                      .animate(key: ValueKey(index))
                      .fadeIn(duration: 500.ms, curve: Curves.easeOut)
                      .scale(
                        begin: const Offset(0.88, 0.88),
                        end: const Offset(1.0, 1.0),
                        duration: 600.ms,
                        curve: Curves.easeOutBack,
                      )
                      .slideY(
                        begin: 0.08,
                        end: 0,
                        duration: 600.ms,
                        curve: Curves.easeOut,
                      );
                },
              ),
            ),

            Positioned(
              top: 40,
              right: 16,
              child: (currentPage != _pages.length - 1)
                  ? TextButton(
                      key: Key(AppTestKeys.onboardingSkipButton),
                      onPressed: () => _goToPage(_pages.length - 1),
                      child: Text(
                        AppStrings.skip,
                        style: textTheme.titleSmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: CustomBlurCard(
                showWhiteBorders: true,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  topLeft: Radius.circular(50),
                ),
                child: Column(
                  children: [
                    Text(
                          _pages[currentPage].title,
                          key: ValueKey(currentPage),
                          textAlign: TextAlign.center,
                          style: textTheme.headlineLarge,
                        )
                        .animate(key: ValueKey(currentPage))
                        .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                        .scale(
                          begin: const Offset(0.85, 0.85),
                          end: const Offset(1, 1),
                          duration: 600.ms,
                          curve: Curves.easeOutBack,
                        ),

                    const SizedBox(height: 12),

                    Text(
                          _pages[currentPage].description,
                          key: ValueKey("desc_$currentPage"),
                          textAlign: TextAlign.center,
                          style: textTheme.titleMedium?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.3,
                          ),
                        )
                        .animate(key: ValueKey("desc_$currentPage"))
                        .fadeIn(
                          duration: 700.ms,
                          delay: 150.ms,
                          curve: Curves.easeOut,
                        )
                        .slideY(
                          begin: 0.15,
                          end: 0,
                          duration: 700.ms,
                          delay: 150.ms,
                          curve: Curves.easeOut,
                        ),

                    const Gap(24),

                    AnimatedSmoothIndicator(
                      count: 3,
                      effect: ExpandingDotsEffect(
                        dotColor: AppColors.white,
                        activeDotColor: AppColors.primary,
                        dotHeight: 8,
                        dotWidth: 8,
                      ),
                      activeIndex: currentPage,
                    ),

                    const Gap(24),

                    currentPage == 0
                        ? CustomButton(
                            label: AppStrings.next,
                            key: Key(AppTestKeys.onboardingNextButton),
                            variant: ButtonVariant.filled,
                            onPressed: () => _goToPage(1),
                          )
                        : Row(
                            children: [
                              CustomButton(
                                key: Key(AppTestKeys.onboardingNextButton),
                                label: AppStrings.next,
                                width: 100.w,
                                variant: ButtonVariant.filled,
                                onPressed: () {
                                  if (currentPage == _pages.length - 1) {
                                    log('Go to Login Page');
                                  } else {
                                    _goToPage(currentPage + 1);
                                  }
                                },
                              ),

                              const Spacer(),

                              CustomButton(
                                label: AppStrings.back,
                                key: Key(AppTestKeys.onboardingBackButton),
                                variant: ButtonVariant.outlined,
                                width: 100.w,
                                onPressed: () => _goToPage(currentPage - 1),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
