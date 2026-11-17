import 'package:fitness_app/core/constants/app_icons.dart';
import 'package:fitness_app/core/shared/custom_text_form_field.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

class EditProfileFormWidget extends StatelessWidget {
  const EditProfileFormWidget({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController email;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        CustomTextFormField(
          controller: firstName,
          hintText: l10n.firstName,
          prefixIcon: AppIcons.profile,
          textInputAction: TextInputAction.next,
        ),
        Gap(8.h),
        CustomTextFormField(
          controller: lastName,
          hintText: l10n.lastName,
          prefixIcon: AppIcons.profile,
          textInputAction: TextInputAction.next,
        ),
        Gap(8.h),
        CustomTextFormField(
          controller: email,
          hintText: l10n.email,
          prefixIcon: AppIcons.mail,
          readOnly: true,
        ),
      ],
    );
  }
}