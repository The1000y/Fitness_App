import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Horizontal scrolling row with a 12 gap between items. [height] is unscaled.
class HomeCardsRow extends StatelessWidget {
  const HomeCardsRow({
    super.key,
    required this.height,
    required this.itemCount,
    required this.itemBuilder,
  });

  final double height;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: itemBuilder,
      ),
    );
  }
}