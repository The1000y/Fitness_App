import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/features/home/presentation/manager/home_cubit.dart';
import 'package:fitness_app/features/home/presentation/manager/home_event.dart';
import 'package:fitness_app/features/home/presentation/manager/home_state.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_category_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../config/routing/app_routes.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../auth/presentation/login/view/widgets/home_section_header.dart';
import 'home_image_title_card.dart';
import 'home_section_state_view.dart';

class HomeFoodCategories extends StatelessWidget {
  const HomeFoodCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(
          title: l10n.recommendationForYou,
          actionLabel: l10n.seeAll,
            onActionPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.meals,
            ),
        ),
        SizedBox(height: 7.h),
        BlocSelector<HomeCubit, HomeState,
            BaseState<List<MealCategoryEntity>>>(
          selector: (state) => state.mealCategoriesState,
          builder: (context, mealCategories) {
            return HomeSectionStateView<List<MealCategoryEntity>>(
              state: mealCategories,
              height: 104,
              onRetry: () => context.read<HomeCubit>().onEvent(
                const HomeMealCategoriesRetried(),
              ),
              builder: (context, categories) {
                return SizedBox(
                  height: 104.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => SizedBox(width: 12.w),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return HomeImageTitleCard(
                        imageUrl: category.thumbnail,
                        title: category.name,
                        size: 104.w,
                        labelHeight: 30.h,
                        labelPadding: EdgeInsets.symmetric(horizontal: 8.w),
                        onTap: () {
                          // Navigation action
                        },
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}