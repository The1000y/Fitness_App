import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:fitness_app/features/auth/presentation/register/view/widgets/number_wheel_picker.dart';
import 'package:fitness_app/features/profile/presentation/edit_profile/view/edit_option_scaffold.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class EditWeightView extends StatefulWidget {
  const EditWeightView({super.key, required this.initialWeight});

  final int initialWeight;

  @override
  State<EditWeightView> createState() => _EditWeightViewState();
}

class _EditWeightViewState extends State<EditWeightView> {
  late int _weight;

  @override
  void initState() {
    super.initState();
    _weight = widget.initialWeight;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CustomBackgroundImage(
      backgroundImage: AppImages.authBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: EditOptionScaffold(
            title: l10n.weightTitle,
            subtitle: l10n.personalizedPlanHint,
            onDone: () => Navigator.pop(context, _weight),
            child: NumberWheelPicker(
              value: _weight,
              min: 30,
              max: 250,
              unit: l10n.kgUnit,
              onChanged: (v) => _weight = v,
            ),
          ),
        ),
      ),
    );
  }
}