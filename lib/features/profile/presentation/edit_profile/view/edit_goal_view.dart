import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_option.dart';
import 'package:fitness_app/features/auth/presentation/register/view/widgets/option_tile.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/view/edit_option_scaffold.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class EditGoalView extends StatefulWidget {
  const EditGoalView({super.key, required this.initialGoal});

  final String? initialGoal;

  @override
  State<EditGoalView> createState() => _EditGoalViewState();
}

class _EditGoalViewState extends State<EditGoalView> {
  Goal? _selected;

  @override
  void initState() {
    super.initState();
    final current = widget.initialGoal?.toLowerCase();
    for (final goal in Goal.values) {
      if (goal.apiValue.toLowerCase() == current) {
        _selected = goal;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final options = <(Goal, String)>[
      (Goal.gainWeight, l10n.goalGainWeight),
      (Goal.loseWeight, l10n.goalLoseWeight),
      (Goal.getFitter, l10n.goalGetFitter),
      (Goal.gainFlexibility, l10n.goalGainFlexibility),
      (Goal.learnBasics, l10n.goalLearnBasics),
    ];

    return CustomBackgroundImage(
      backgroundImage: AppImages.authBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: EditOptionScaffold(
            title: l10n.goalTitle,
            subtitle: l10n.personalizedPlanHint,
            onDone: () => Navigator.pop(context, _selected),
            child: StatefulBuilder(
              builder: (context, setLocal) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final (goal, label) in options)
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: OptionTile(
                        label: label,
                        selected: _selected == goal,
                        onTap: () => setLocal(() => _selected = goal),
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