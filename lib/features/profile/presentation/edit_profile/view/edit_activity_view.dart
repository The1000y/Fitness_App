import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_option.dart';
import 'package:fitness_app/features/auth/presentation/register/view/widgets/option_tile.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/view/edit_option_scaffold.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class EditActivityView extends StatefulWidget {
  const EditActivityView({super.key, required this.initialLevel});

  final String? initialLevel;

  @override
  State<EditActivityView> createState() => _EditActivityViewState();
}

class _EditActivityViewState extends State<EditActivityView> {
  ActivityLevel? _selected;

  @override
  void initState() {
    super.initState();
    final current = widget.initialLevel?.toLowerCase();
    for (final level in ActivityLevel.values) {
      if (level.apiValue.toLowerCase() == current) {
        _selected = level;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final options = <(ActivityLevel, String)>[
      (ActivityLevel.rookie, l10n.activityRookie),
      (ActivityLevel.beginner, l10n.levelBeginner),
      (ActivityLevel.intermediate, l10n.levelIntermediate),
      (ActivityLevel.advance, l10n.levelAdvanced),
      (ActivityLevel.trueBeast, l10n.activityTrueBeast),
    ];

    return CustomBackgroundImage(
      backgroundImage: AppImages.authBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: EditOptionScaffold(
            title: l10n.activityTitle,
            onDone: () => Navigator.pop(context, _selected),
            child: StatefulBuilder(
              builder: (context, setLocal) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final (level, label) in options)
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: OptionTile(
                        label: label,
                        selected: _selected == level,
                        onTap: () => setLocal(() => _selected = level),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}