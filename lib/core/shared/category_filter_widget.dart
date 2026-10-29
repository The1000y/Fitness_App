import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../theme/app_colors/app_colors.dart';

class CategoryTabBar extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final bool isScrollable;

  const CategoryTabBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.isScrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: isScrollable
          ? ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return _buildCategoryItem(context, categories[index]);
              },
            )
          : Row(
              children: categories.map((category) {
                return Expanded(
                  child: _buildCategoryItem(
                    context,
                    category,
                    isExpanded: true,
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildCategoryItem(
    BuildContext context,
    String category, {
    bool isExpanded = false,
  }) {
    final isSelected = category == selectedCategory;

    return Padding(
      padding: EdgeInsets.only(right: isScrollable ? 10.w : 0),
      child: GestureDetector(
        onTap: () => onCategorySelected(category),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isExpanded ? double.infinity : null,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(24.r),
          ),
          alignment: Alignment.center,
          child: Text(
            category,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 15.sp,
            ),
          ),
        ),
      ),
    );
  }
}
