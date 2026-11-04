import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../core/theme/app_colors/app_colors.dart';
import '../../../../../l10n/app_localizations.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.firstName,
    this.photoUrl,
  });

  final String firstName;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.homeGreeting(firstName),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: 'Baloo Thambi 2',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                l10n.homeSubtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontFamily: 'Baloo Thambi 2',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        ClipOval(
          child: SizedBox(
            width: 36.r,
            height: 36.r,
            child: photoUrl != null && photoUrl!.isNotEmpty
                ? Image.network(
              photoUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildPlaceholder(),
            )
                : _buildPlaceholder(),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.white24,
      alignment: Alignment.center,
      child: Icon(
        Icons.person,
        size: 22.r,
        color: AppColors.textPrimary,
      ),
    );
  }
}