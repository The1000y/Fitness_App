import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class TypingDotsIndicator extends StatefulWidget {
  const TypingDotsIndicator({super.key});

  @override
  State<TypingDotsIndicator> createState() => TypingDotsIndicatorState();
}

class TypingDotsIndicatorState extends State<TypingDotsIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44.w,
      height: 16.h,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (index) {
              final delay = index * 0.2;
              final value = ((_controller.value - delay) % 1.0 + 1.0) % 1.0;
              final bounce = value < 0.5 ? (value * 2) : (2 - value * 2);

              return Transform.translate(
                offset: Offset(0, -4 * bounce),
                child: Container(
                  width: 8.r,
                  height: 8.r,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(
                      alpha: 0.4 + (0.6 * bounce),
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
