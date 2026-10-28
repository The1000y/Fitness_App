import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_colors/app_colors.dart';

class CustomBottomTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const CustomBottomTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final tabs = [
      _BottomTabItem(
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        label: localizations.homeTab,
      ),
      _BottomTabItem(
        icon: Icons.local_fire_department_outlined,
        selectedIcon: Icons.local_fire_department,
        label: localizations.activityTab,
      ),
      _BottomTabItem(
        icon: Icons.fitness_center_outlined,
        selectedIcon: Icons.fitness_center,
        label: localizations.workouts,
      ),
      _BottomTabItem(
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: localizations.profile,
      ),
    ];

    return SafeArea(
      top: false,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(28.r),
        ),
        child: Row(
          children: List.generate(tabs.length, (index) {
            final tab = tabs[index];
            final isSelected = selectedIndex == index;

            return Expanded(
              child: InkWell(
                onTap: () => onTabSelected(index),
                borderRadius: BorderRadius.circular(20.r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.12)
                        : AppColors.transparent,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? tab.selectedIcon : tab.icon,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        size: 24.sp,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        tab.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontSize: 11.sp,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _BottomTabItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _BottomTabItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}
