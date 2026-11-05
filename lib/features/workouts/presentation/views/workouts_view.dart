import 'package:fitness_app/config/routing/app_routes.dart';
import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:fitness_app/features/exercise/presentation/exercise_details/args/exercise_details_args.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class WorkoutsView extends StatelessWidget {
  const WorkoutsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return CustomBackgroundImage(
      backgroundImage: AppImages.layoutBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.exerciseDetails,
              arguments: ExerciseDetailsArgs(
                primeMoverMuscleId: '69d982ef85f6bfa972bf2248',
                muscleName: l10n.chest,
              ),
            ),
            child: Text(l10n.exerciseDetailsTitle),
          ),
        ),
      ),
    );
  }
}
