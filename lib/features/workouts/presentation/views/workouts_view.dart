import 'package:fitness_app/config/routing/app_routes.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_images.dart';
import '../../../../core/shared/custom_background_image.dart';

class WorkoutsView extends StatefulWidget {
  const WorkoutsView({super.key});

  @override
  State<WorkoutsView> createState() => _WorkoutsViewState();
}

class _WorkoutsViewState extends State<WorkoutsView> {
 

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundImage(
      backgroundImage: AppImages.layoutBackground,
      child: Scaffold(backgroundColor: Colors.transparent, body: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(onPressed: (){
               Navigator.pushNamed(
          context,
          AppRoutes.exerciseDetails,
          arguments: {
            'primeMoverMuscleId': '69d982ef85f6bfa972bf2248',
            'difficultyLevelId': '69d982ed85f6bfa972bf2216',
            'muscleName': 'Abdominals',
          },
        );
            }, child: Text("ex"))
          ],
        ),
      )),
    );
  }
}
