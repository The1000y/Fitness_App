import 'package:fitness_app/config/base/base_state.dart';
import 'package:fitness_app/config/routing/app_routes.dart';
import 'package:fitness_app/features/home/presentation/manager/home_cubit.dart';
import 'package:fitness_app/features/home/presentation/manager/home_event.dart';
import 'package:fitness_app/features/home/presentation/manager/home_state.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/common/home_cards_row.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/common/home_image_card.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/common/home_section_title.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/common/home_state_view.dart';
import 'package:fitness_app/features/home/presentation/views/widgets/shimmer/home_image_cards_shimmer.dart';
import 'package:fitness_app/features/meals/domain/entities/meal_category_entity.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class HomeFoodCategories extends StatelessWidget {
  const HomeFoodCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionTitle(
          title: l10n.recommendationForYou,
          actionLabel: l10n.seeAll,
          onAction: () => Navigator.pushNamed(context, AppRoutes.meals),
        ),
        SizedBox(height: 7.h),
        BlocSelector<HomeCubit, HomeState, BaseState<List<MealCategoryEntity>>>(
          selector: (state) => state.mealCategoriesState,
          builder: (context, state) => HomeStateView<List<MealCategoryEntity>>(
            state: state,
            height: 104,
            loading: const HomeImageCardsShimmer(size: 104),
            onRetry: () => context.read<HomeCubit>().onEvent(
              const HomeMealCategoriesRetried(),
            ),
            builder: (context, categories) => HomeCardsRow(
              height: 104,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return HomeImageCard(
                  imageUrl: category.thumbnail,
                  title: category.name,
                  size: 104,
                  labelPadding: 8,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.meals,
                    arguments: category.name,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
