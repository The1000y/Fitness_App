import 'package:fitness_app/config/routing/app_routes.dart';
import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:flutter/material.dart';

class WorkoutsView extends StatelessWidget {
  const WorkoutsView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundImage(
      backgroundImage: AppImages.layoutBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // TEMP: test button, remove after the muscle cards are built
        body: Center(
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.exerciseDetails,
              arguments: {
                'primeMoverMuscleId': '69d982ef85f6bfa972bf2248',
                'muscleName': 'Chest',
              },
            ),
            child: const Text('Exercise Details'),
          ),
        ),
      ),
    );
  }
}
