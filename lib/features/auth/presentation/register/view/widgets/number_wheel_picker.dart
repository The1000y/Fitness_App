import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class NumberWheelPicker extends StatefulWidget {
  const NumberWheelPicker({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
    required this.onChanged,
  });

  final int value;
  final int min;
  final int max;
  final String unit;
  final ValueChanged<int> onChanged;

  @override
  State<NumberWheelPicker> createState() => _NumberWheelPickerState();
}

class _NumberWheelPickerState extends State<NumberWheelPicker> {
  late final FixedExtentScrollController _controller;
  late int _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.value;
    _controller = FixedExtentScrollController(
      initialItem: widget.value - widget.min,
    );
  }

  @override
  void didUpdateWidget(covariant NumberWheelPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value &&
        widget.value != _selected &&
        widget.value >= widget.min &&
        widget.value <= widget.max) {
      _selected = widget.value;
      _controller.jumpToItem(widget.value - widget.min);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  TextStyle? _styleFor(BuildContext context, int distance) {
    final base = Theme.of(context).textTheme.titleLarge;

    return switch (distance) {
      0 => base?.copyWith(fontSize: 40.sp, color: AppColors.primary),
      1 => base?.copyWith(fontSize: 26.sp),
      2 => base?.copyWith(
        fontSize: 20.sp,
        color: AppColors.white.withValues(alpha: 0.7),
      ),
      _ => base?.copyWith(
        fontSize: 14.sp,
        color: AppColors.white.withValues(alpha: 0.4),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.unit,
          style: theme.textTheme.titleSmall?.copyWith(color: AppColors.primary),
        ),
        SizedBox(
          height: 72.h,
          child: RotatedBox(
            quarterTurns: 3,
            child: ListWheelScrollView.useDelegate(
              controller: _controller,
              itemExtent: 64.w,
              diameterRatio: 3,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                final value = widget.min + index;

                setState(() {
                  _selected = value;
                });

                widget.onChanged(value);
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: widget.max - widget.min + 1,
                builder: (context, index) {
                  final value = widget.min + index;
                  final distance = (value - _selected).abs();

                  return RotatedBox(
                    quarterTurns: 1,
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '$value',
                          maxLines: 1,
                          softWrap: false,
                          style: _styleFor(context, distance),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Icon(Icons.arrow_drop_up_rounded, color: AppColors.primary, size: 30.r),
      ],
    );
  }
}
