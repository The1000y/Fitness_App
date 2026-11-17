import 'package:fitness_app/config/routing/app_routes.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/chat/domain/entities/catalog_entities.dart';
import 'package:fitness_app/features/chat/presentation/view/widget/coach_recommendation_card.dart';
import 'package:fitness_app/features/chat/presentation/view/widget/typing_dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class CustomChatMessage extends StatelessWidget {
  const CustomChatMessage({
    super.key,
    required this.text,
    required this.isSender,
    required this.senderAvatar,
    required this.receiverAvatar,
    this.exercises = const [],
    this.meals = const [],
    this.isTyping = false,
  });

  final String text;
  final bool isSender;
  final ImageProvider senderAvatar;
  final ImageProvider receiverAvatar;
  final List<ExerciseEntity> exercises;
  final List<MealEntity> meals;
  final bool isTyping;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    final avatar = Container(
      margin: EdgeInsets.only(
        left: isSender ? 0 : 12.w,
        right: isSender ? 12.w : 0,
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 20.r,
        backgroundColor: AppColors.neutral[700],
        backgroundImage: isSender ? senderAvatar : receiverAvatar,
      ),
    );

    final bubble = Flexible(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6.h),
        padding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: isTyping ? 14.h : 12.h,
        ),
        decoration: BoxDecoration(
          color: isSender
              ? AppColors.accent.withValues(alpha: 0.75)
              : AppColors.neutral[600]?.withValues(alpha: 0.92),
          border: Border.all(
            color: isSender
                ? AppColors.primary.withValues(alpha: 0.4)
                : AppColors.borderSubtle,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isSender ? 18.r : 4.r),
            topRight: Radius.circular(isSender ? 4.r : 18.r),
            bottomLeft: Radius.circular(18.r),
            bottomRight: Radius.circular(18.r),
          ),
        ),
        child: isTyping
            ? const TypingDotsIndicator()
            : SelectableText(
                text,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.45,
                  fontSize: 14.sp,
                ),
              ),
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        crossAxisAlignment: isSender
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isSender
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isSender) avatar,
              SizedBox(width: 8.w),
              bubble,
              SizedBox(width: 8.w),
              if (isSender) avatar,
            ],
          ),

          // ── كروت التمارين الأفقية (تظهر تحت رد البوت فقط) ──
          if (!isSender && exercises.isNotEmpty) ...[
            SizedBox(height: 8.h),
            SizedBox(
              height: 138.h,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 52.w),
                scrollDirection: Axis.horizontal,
                itemCount: exercises.length,
                separatorBuilder: (_, _) => SizedBox(width: 10.w),
                itemBuilder: (context, index) {
                  final ex = exercises[index];
                  final displayTitle =
                      (isAr && ex.nameAr != null && ex.nameAr!.isNotEmpty)
                      ? ex.nameAr!
                      : ex.exercise;

                  return CoachRecommendationCard(
                    title: displayTitle,
                    subtitle: '${ex.targetMuscleGroup} • ${ex.difficultyLevel}',
                    badgeText: ex.primaryEquipment.isNotEmpty
                        ? ex.primaryEquipment
                        : 'Workout',
                    icon: Icons.fitness_center_rounded,
                    onTap: () {
                      Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.exerciseVideoPlayer, arguments: ex);
                    },
                  );
                },
              ),
            ),
          ],

          // ── كروت الوجبات الأفقية (تظهر تحت رد البوت فقط) ──
          if (!isSender && meals.isNotEmpty) ...[
            SizedBox(height: 8.h),
            SizedBox(
              height: 150.h,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 52.w),
                scrollDirection: Axis.horizontal,
                itemCount: meals.length,
                separatorBuilder: (_, _) => SizedBox(width: 10.w),
                itemBuilder: (context, index) {
                  final meal = meals[index];
                  final displayTitle =
                      (isAr && meal.nameAr != null && meal.nameAr!.isNotEmpty)
                      ? meal.nameAr!
                      : meal.name;
                  final proteinText = meal.proteinG != null
                      ? '${meal.proteinG!.toInt()}g Protein'
                      : (meal.category ?? 'Healthy Meal');
                  final kcalText = meal.kcal != null
                      ? '${meal.kcal!.toInt()} kcal'
                      : (meal.area ?? '');

                  return CoachRecommendationCard(
                    title: displayTitle,
                    subtitle: [
                      proteinText,
                      if (kcalText.isNotEmpty) kcalText,
                    ].join(' • '),
                    badgeText: meal.category ?? 'Nutrition',
                    imageUrl: meal.thumbnail,
                    icon: Icons.restaurant_menu_rounded,
                    onTap: () {
                      Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.mealDetails, arguments: meal.id);
                    },
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
