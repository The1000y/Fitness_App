import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class VideoErrorView extends StatelessWidget {
  const VideoErrorView({
    super.key,
    required this.onClose,
    this.onRetry,
    required this.errorMessage,
  });

  final VoidCallback onClose;
  final VoidCallback? onRetry;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context)!;
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.videocam_off_rounded, color: AppColors.primary),
            const SizedBox(height: 8),
            //  Text(l10n.unableToPlayVideo),
            Text(errorMessage),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onRetry != null)
                  TextButton(onPressed: onRetry, child: Text(l10n.retry)),
                TextButton(onPressed: onClose, child: Text(l10n.back)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
